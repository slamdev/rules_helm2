package main

import (
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	"sigs.k8s.io/yaml"
	"strings"
)

type digestVarsFlag map[string]string
type filesFlag []string

var input string
var output string
var digestVars digestVarsFlag
var files filesFlag
var cmd string

func init() {
	buildValuesFlag := flag.NewFlagSet("build-values", flag.ContinueOnError)
	buildValuesFlag.StringVar(&input, "input", "", "")
	buildValuesFlag.StringVar(&output, "output", "", "")
	buildValuesFlag.Var(&digestVars, "digest", "")

	mergeYamlsFlag := flag.NewFlagSet("merge-yamls", flag.ContinueOnError)
	mergeYamlsFlag.StringVar(&output, "output", "", "")
	mergeYamlsFlag.Var(&files, "file", "")

	switch os.Args[1] {
	case buildValuesFlag.Name():
		cmd = buildValuesFlag.Name()
		if err := buildValuesFlag.Parse(os.Args[2:]); err != nil {
			panic(err)
		}
	case mergeYamlsFlag.Name():
		cmd = mergeYamlsFlag.Name()
		if err := mergeYamlsFlag.Parse(os.Args[2:]); err != nil {
			panic(err)
		}
	default:
		panic("unknown subcommand")
	}
}

func main() {
	switch cmd {
	case "build-values":
		if err := buildValues(); err != nil {
			panic(err)
		}
	case "merge-yamls":
		if err := mergeYamls(); err != nil {
			panic(err)
		}
	}
}

func mergeYamls() error {
	base := map[string]interface{}{}
	for _, f := range files {
		b, err := ioutil.ReadFile(f)
		if err != nil {
			return fmt.Errorf("failed to read input file %s; %w", f, err)
		}
		currentMap := map[string]interface{}{}
		if err := yaml.Unmarshal(b, &currentMap); err != nil {
			return fmt.Errorf("failed to parse %s; %w", f, err)
		}
		base = mergeMaps(base, currentMap)
	}
	valuesYaml, err := yaml.Marshal(base)
	if err != nil {
		return fmt.Errorf("failed to marshal yaml; %w", err)
	}
	if err := ioutil.WriteFile(output, valuesYaml, 0644); err != nil {
		return fmt.Errorf("failed to write yaml file %s; %w", output, err)
	}
	return nil
}

func mergeMaps(a, b map[string]interface{}) map[string]interface{} {
	out := make(map[string]interface{}, len(a))
	for k, v := range a {
		out[k] = v
	}
	for k, v := range b {
		if v, ok := v.(map[string]interface{}); ok {
			if bv, ok := out[k]; ok {
				if bv, ok := bv.(map[string]interface{}); ok {
					out[k] = mergeMaps(bv, v)
					continue
				}
			}
		}
		out[k] = v
	}
	return out
}

func buildValues() error {
	b, err := ioutil.ReadFile(input)
	if err != nil {
		return fmt.Errorf("failed to read input file %s; %w", input, err)
	}
	valuesJson := string(b)
	for k, v := range digestVars {
		db, err := ioutil.ReadFile(v)
		if err != nil {
			return fmt.Errorf("failed to read digest file %s; %w", v, err)
		}
		digest := string(db)
		valuesJson = strings.ReplaceAll(valuesJson, k, digest)
	}
	valuesYaml, err := yaml.JSONToYAML([]byte(valuesJson))
	if err != nil {
		return fmt.Errorf("convert values json to yaml; %w", err)
	}
	if err := ioutil.WriteFile(output, valuesYaml, 0644); err != nil {
		return fmt.Errorf("failed to write yaml file %s; %w", output, err)
	}
	return nil
}

func (i *digestVarsFlag) String() string {
	return ""
}

func (i *digestVarsFlag) Set(value string) error {
	if *i == nil {
		*i = make(map[string]string)
	}
	parts := strings.Split(value, ":")
	(*i)[parts[0]] = parts[1]
	return nil
}

func (i *filesFlag) String() string {
	return ""
}

func (i *filesFlag) Set(value string) error {
	*i = append(*i, value)
	return nil
}
