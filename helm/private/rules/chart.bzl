"helm_chart rule"

load("@io_bazel_rules_docker//container:providers.bzl", "ImageInfo")

_DOC = "Defines a helm chart."

_ATTRS = {
    "srcs": attr.label_list(
        doc = "Files to package into a chart; must contain a Chart.yaml file.",
        allow_files = True,
    ),
    "app_version": attr.string(
        doc = "Set the appVersion on the chart to this version.",
    ),
    "version": attr.string(
        doc = "Set the version on the chart to this semver version.",
    ),
    "image_digest_vars": attr.label_keyed_string_dict(
        doc = """Map of container image labels to a template keys, to extract digest from.
```image_digest_vars = {

    ":image": "{img_digest}",

}```
        """,
        providers = [ImageInfo],
    ),
    "values_json": attr.string(
        doc = """Values in json format.
        Typical use-case is to pass dynamic values to a helm chart:
```values_json = json.encode({

    "image": {

        "tag": "latest@{img_digest}",

    },

})
```
        """,
    ),
    "values_files": attr.label_list(
        doc = "Specify values in a YAML file (can specify multiple).",
        allow_files = [".yml", ".yaml"],
    ),
    "deps": attr.label_list(
        doc = "Chart dependencies; must much the ones defined in a Chart.yaml file.",
        allow_files = [".tgz"],
    ),
    "_windows_constraint": attr.label(
        default = Label("@platforms//os:windows"),
    ),
    "_helper_cli": attr.label(
        default = Label("//helm/private/rules:helper"),
        cfg = "host",
        executable = True,
        allow_files = True,
    ),
}

def _impl(ctx):
    user_values_file = _build_user_values_file(ctx)

    merged_values_file = _merge_values(ctx, user_values_file)

    srcs = _copy_chart(ctx, merged_values_file)
    out_dir = _package(ctx, srcs, user_values_file)
    chart_archive = _copy_tgz(ctx, out_dir)
    return [
        DefaultInfo(files = depset([chart_archive])),
    ]

def _build_user_values_file(ctx):
    values_json = ctx.attr.values_json
    if not values_json:
        return None

    image_digest_files = []
    image_digest_path_vars = {}
    for target, var in ctx.attr.image_digest_vars.items():
        digest_file = target[ImageInfo].container_parts["digest"]
        image_digest_files.append(digest_file)
        image_digest_path_vars[var] = digest_file.path

    out_json = ctx.actions.declare_file(ctx.label.name + "-user-values.json")

    ctx.actions.write(
        output = out_json,
        content = values_json,
    )

    out_yaml = ctx.actions.declare_file(ctx.label.name + "-user-values.yaml")

    args = ctx.actions.args()
    args.add("build-values")
    args.add("-input", out_json.path)
    args.add("-output", out_yaml.path)
    for var, path in image_digest_path_vars.items():
        args.add("-digest", var + ":" + path)

    ctx.actions.run(
        inputs = image_digest_files + [out_json],
        outputs = [out_yaml],
        arguments = [args],
        progress_message = "Building user values file: " + out_yaml.short_path,
        executable = ctx.executable._helper_cli,
    )
    return out_yaml

def _package(ctx, srcs, user_values_file):
    chart_yaml = _root_file("Chart.yaml", srcs)
    if chart_yaml == None:
        fail("Chart.yaml file is not found in srcs")

    chart_path = chart_yaml.dirname

    out = ctx.actions.declare_directory(ctx.label.name + "-helm-chart-out")

    args = []
    args += ["package"]
    args += [chart_path]
    args += ["--destination", out.path]
    if ctx.attr.version:
        args += ["--version", ctx.attr.version]
    if ctx.attr.app_version:
        args += ["--app-version", ctx.attr.app_version]

    if ctx.target_platform_has_constraint(ctx.attr._windows_constraint[platform_common.ConstraintValueInfo]):
        ctx.actions.run(
            inputs = srcs,
            outputs = [out],
            arguments = [ctx.actions.args().add_all(args)],
            progress_message = "Packaging chart " + out.short_path,
            tools = ctx.toolchains["@slamdev_rules_helm//helm:toolchain_type"].default.files,
            executable = ctx.var["HELM_BIN"],
        )
    else:
        command = [ctx.var["HELM_BIN"]] + args
        ctx.actions.run_shell(
            inputs = srcs,
            outputs = [out],
            tools = ctx.toolchains["@slamdev_rules_helm//helm:toolchain_type"].default.files,
            progress_message = "Packaging chart " + out.short_path,
            # removes 'symbolic' warning from helm output
            command = " ".join(command) + " 2> >(grep -v symbolic) >/dev/null",
        )

    return out

def _file_len(file):
    str = file.short_path
    return len(str)

def _root_file(name, files):
    found = []
    for f in files:
        if f.basename == name:
            found.append(f)
    found = sorted(found, key = _file_len)
    if len(found) == 0:
        return None
    return found[0]

def _merge_values(ctx, user_values_file):
    default_values_file = _root_file("values.yaml", ctx.files.srcs)

    out_yaml = ctx.actions.declare_file(ctx.label.name + "-merged-values.yaml")

    inputs = []
    args = ctx.actions.args()
    args.add("merge-yamls")
    args.add("-output", out_yaml.path)
    if default_values_file:
        args.add("-file", default_values_file.path)
        inputs.append(default_values_file)

    for f in ctx.files.values_files:
        args.add("-file", f.path)
        inputs.append(f)

    if user_values_file:
        args.add("-file", user_values_file.path)
        inputs.append(user_values_file)

    ctx.actions.run(
        inputs = inputs,
        outputs = [out_yaml],
        arguments = [args],
        progress_message = "Merging yamls",
        executable = ctx.executable._helper_cli,
    )

    return out_yaml

def _copy_chart(ctx, merged_values_file):
    values_file = _root_file("values.yaml", ctx.files.srcs)

    outs = []
    for f in ctx.files.srcs:
        src = f
        if f == values_file and merged_values_file:
            src = merged_values_file
        copy = ctx.actions.declare_file(ctx.label.name + "/" + f.path)
        outs.append(copy)
        if ctx.target_platform_has_constraint(ctx.attr._windows_constraint[platform_common.ConstraintValueInfo]):
            command = "copy $1 $2"
            args = [src.path.replace("/", "\\"), copy.path.replace("/", "\\")]
        else:
            command = "cp -f $1 $2"
            args = [src.path, copy.path]
        ctx.actions.run_shell(
            tools = [src],
            outputs = [copy],
            command = command,
            arguments = args,
            progress_message = "Copying %s file to %s " % (src.short_path, copy.short_path),
        )

    chart_yaml = _root_file("Chart.yaml", ctx.files.srcs)
    if chart_yaml == None:
        fail("Chart.yaml file is not found in srcs")
    chart_path = ctx.label.name + "/" + chart_yaml.dirname

    for f in ctx.files.deps:
        src = f
        copy = ctx.actions.declare_file(chart_path + "/charts/" + f.basename)
        outs.append(copy)
        if ctx.target_platform_has_constraint(ctx.attr._windows_constraint[platform_common.ConstraintValueInfo]):
            command = "copy $1 $2"
            args = [src.path.replace("/", "\\"), copy.path.replace("/", "\\")]
        else:
            command = "cp -f $1 $2"
            args = [src.path, copy.path]
        ctx.actions.run_shell(
            tools = [src],
            outputs = [copy],
            command = command,
            arguments = args,
            progress_message = "Copying %s file to %s " % (src.short_path, copy.short_path),
        )
    return outs

def _copy_tgz(ctx, src):
    dest = ctx.actions.declare_file(ctx.label.name + ".tgz")

    src_path = src.path + "/*.tgz"
    dest_path = dest.path

    if ctx.target_platform_has_constraint(ctx.attr._windows_constraint[platform_common.ConstraintValueInfo]):
        command = "copy $1 $2"
        args = [src_path.replace("/", "\\"), dest_path.replace("/", "\\")]
    else:
        command = "cp -f $1 $2"
        args = [src_path, dest_path]

    ctx.actions.run_shell(
        tools = [src],
        outputs = [dest],
        command = command,
        arguments = args,
        progress_message = "Copying %s to %s " % (src.short_path, dest.short_path),
    )

    return dest

chart = rule(
    doc = _DOC,
    implementation = _impl,
    attrs = _ATTRS,
    provides = [DefaultInfo],
    toolchains = ["@slamdev_rules_helm//helm:toolchain_type"],
)
