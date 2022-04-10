<!-- Generated with Stardoc: http://skydoc.bazel.build -->

# Helm Rules

<a id="#helm_chart"></a>

## helm_chart

<pre>
helm_chart(<a href="#helm_chart-name">name</a>, <a href="#helm_chart-app_version">app_version</a>, <a href="#helm_chart-deps">deps</a>, <a href="#helm_chart-image_digest_vars">image_digest_vars</a>, <a href="#helm_chart-srcs">srcs</a>, <a href="#helm_chart-values_files">values_files</a>, <a href="#helm_chart-values_json">values_json</a>, <a href="#helm_chart-version">version</a>)
</pre>

Defines a helm chart.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="helm_chart-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="helm_chart-app_version"></a>app_version |  Set the appVersion on the chart to this version.   | String | optional | "" |
| <a id="helm_chart-deps"></a>deps |  Chart dependencies; must much the ones defined in a Chart.yaml file.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="helm_chart-image_digest_vars"></a>image_digest_vars |  Map of container image labels to a template keys, to extract digest from. <pre><code>image_digest_vars = {<br><br>    ":image": "{img_digest}",<br><br>}</code></pre>   | <a href="https://bazel.build/docs/skylark/lib/dict.html">Dictionary: Label -> String</a> | optional | {} |
| <a id="helm_chart-srcs"></a>srcs |  Files to package into a chart; must contain a Chart.yaml file.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="helm_chart-values_files"></a>values_files |  Specify values in a YAML file (can specify multiple).   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="helm_chart-values_json"></a>values_json |  Values in json format.         Typical use-case is to pass dynamic values to a helm chart: <pre><code>values_json = json.encode({<br><br>    "image": {<br><br>        "tag": "latest@{img_digest}",<br><br>    },<br><br>}) </code></pre>   | String | optional | "" |
| <a id="helm_chart-version"></a>version |  Set the version on the chart to this semver version.   | String | optional | "" |


<a id="#helm_import"></a>

## helm_import

<pre>
helm_import(<a href="#helm_import-name">name</a>, <a href="#helm_import-chart_name">chart_name</a>, <a href="#helm_import-repo_mapping">repo_mapping</a>, <a href="#helm_import-repository">repository</a>, <a href="#helm_import-sha256">sha256</a>, <a href="#helm_import-version">version</a>)
</pre>

Defines an imported helm chart.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="helm_import-name"></a>name |  A unique name for this repository.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="helm_import-chart_name"></a>chart_name |  Chart name to import.   | String | required |  |
| <a id="helm_import-repo_mapping"></a>repo_mapping |  A dictionary from local repository name to global repository name. This allows controls over workspace dependency resolution for dependencies of this repository.&lt;p&gt;For example, an entry <code>"@foo": "@bar"</code> declares that, for any time this repository depends on <code>@foo</code> (such as a dependency on <code>@foo//some:target</code>, it should actually resolve that dependency within globally-declared <code>@bar</code> (<code>@bar//some:target</code>).   | <a href="https://bazel.build/docs/skylark/lib/dict.html">Dictionary: String -> String</a> | required |  |
| <a id="helm_import-repository"></a>repository |  Chart repository url where to locate the requested chart.   | String | required |  |
| <a id="helm_import-sha256"></a>sha256 |  The expected SHA-256 hash of the chart imported.   | String | optional | "" |
| <a id="helm_import-version"></a>version |  Specify a version constraint for the chart version to use.   | String | required |  |


<a id="#helm_install"></a>

## helm_install

<pre>
helm_install(<a href="#helm_install-name">name</a>, <a href="#helm_install-atomic">atomic</a>, <a href="#helm_install-chart">chart</a>, <a href="#helm_install-cleanup_on_fail">cleanup_on_fail</a>, <a href="#helm_install-create_namespace">create_namespace</a>, <a href="#helm_install-description">description</a>,
             <a href="#helm_install-disable_openapi_validation">disable_openapi_validation</a>, <a href="#helm_install-dry_run">dry_run</a>, <a href="#helm_install-force">force</a>, <a href="#helm_install-images">images</a>, <a href="#helm_install-namespace">namespace</a>, <a href="#helm_install-no_hooks">no_hooks</a>, <a href="#helm_install-release_name">release_name</a>,
             <a href="#helm_install-template_output">template_output</a>)
</pre>

Defines a helm install execution.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="helm_install-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="helm_install-atomic"></a>atomic |  The installation process deletes\rollbacks the installation on failure.   | Boolean | optional | False |
| <a id="helm_install-chart"></a>chart |  The label of the chart to install.   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required |  |
| <a id="helm_install-cleanup_on_fail"></a>cleanup_on_fail |  Allow deletion of new resources created in this upgrade when upgrade fails.   | Boolean | optional | False |
| <a id="helm_install-create_namespace"></a>create_namespace |  Create the release namespace if not present.   | Boolean | optional | False |
| <a id="helm_install-description"></a>description |  Add a custom description.   | String | optional | "" |
| <a id="helm_install-disable_openapi_validation"></a>disable_openapi_validation |  If set, the install process will not validate rendered templates against the Kubernetes OpenAPI Schema.   | Boolean | optional | False |
| <a id="helm_install-dry_run"></a>dry_run |  Simulate an install\upgrade.   | Boolean | optional | False |
| <a id="helm_install-force"></a>force |  Force resource updates through a replacement strategy.   | Boolean | optional | False |
| <a id="helm_install-images"></a>images |  List of container_push labels to run before installing a chart.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="helm_install-namespace"></a>namespace |  Namespace scope for this reques.   | String | optional | "" |
| <a id="helm_install-no_hooks"></a>no_hooks |  Prevent hooks from running during install\upgrade   | Boolean | optional | False |
| <a id="helm_install-release_name"></a>release_name |  Release name used by helm.   | String | required |  |
| <a id="helm_install-template_output"></a>template_output |  Filename to dump the rendered chart   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional |  |


<a id="#helm_lint_test"></a>

## helm_lint_test

<pre>
helm_lint_test(<a href="#helm_lint_test-name">name</a>, <a href="#helm_lint_test-chart">chart</a>, <a href="#helm_lint_test-namespace">namespace</a>, <a href="#helm_lint_test-strict">strict</a>)
</pre>

Defines a helm lint execution.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="helm_lint_test-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="helm_lint_test-chart"></a>chart |  The label of the chart to install.   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required |  |
| <a id="helm_lint_test-namespace"></a>namespace |  Namespace scope for this reques.   | String | optional | "" |
| <a id="helm_lint_test-strict"></a>strict |  Fail on lint warnings.   | Boolean | optional | False |


<a id="#helm_template"></a>

## helm_template

<pre>
helm_template(<a href="#helm_template-name">name</a>, <a href="#helm_template-api_versions">api_versions</a>, <a href="#helm_template-chart">chart</a>, <a href="#helm_template-disable_openapi_validation">disable_openapi_validation</a>, <a href="#helm_template-include_crds">include_crds</a>, <a href="#helm_template-is_upgrade">is_upgrade</a>,
              <a href="#helm_template-kube_version">kube_version</a>, <a href="#helm_template-namespace">namespace</a>, <a href="#helm_template-no_hooks">no_hooks</a>, <a href="#helm_template-release_name">release_name</a>, <a href="#helm_template-validate">validate</a>)
</pre>

Defines a helm template execution.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="helm_template-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="helm_template-api_versions"></a>api_versions |  Kubernetes api versions used for Capabilities.APIVersions.   | String | optional | "" |
| <a id="helm_template-chart"></a>chart |  The label of the chart to render.   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required |  |
| <a id="helm_template-disable_openapi_validation"></a>disable_openapi_validation |  If set, the install process will not validate rendered templates against the Kubernetes OpenAPI Schema.   | Boolean | optional | False |
| <a id="helm_template-include_crds"></a>include_crds |  Include CRDs in the templated output.   | Boolean | optional | False |
| <a id="helm_template-is_upgrade"></a>is_upgrade |  Set .Release.IsUpgrade instead of .Release.IsInstall.   | Boolean | optional | False |
| <a id="helm_template-kube_version"></a>kube_version |  Kubernetes version used for Capabilities.KubeVersion.   | String | optional | "" |
| <a id="helm_template-namespace"></a>namespace |  Namespace scope for this reques.   | String | optional | "" |
| <a id="helm_template-no_hooks"></a>no_hooks |  Prevent hooks from running during install.   | Boolean | optional | False |
| <a id="helm_template-release_name"></a>release_name |  Release name used by helm.   | String | required |  |
| <a id="helm_template-validate"></a>validate |  Validate your manifests against the Kubernetes cluster you are currently pointing at.   | Boolean | optional | False |


