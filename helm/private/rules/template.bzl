"helm_template rule"

_DOC = "Defines a helm template execution."

_ATTRS = {
    "chart": attr.label(
        doc = "The label of the chart to render.",
        allow_single_file = [".tgz"],
        mandatory = True,
    ),
    "release_name": attr.string(
        doc = "Release name used by helm.",
        mandatory = True,
    ),
    "disable_openapi_validation": attr.bool(
        doc = "If set, the install process will not validate rendered templates against the Kubernetes OpenAPI Schema.",
    ),
    "namespace": attr.string(
        doc = "Namespace scope for this reques.",
    ),
    "api_versions": attr.string(
        doc = "Kubernetes api versions used for Capabilities.APIVersions.",
    ),
    "include_crds": attr.bool(
        doc = "Include CRDs in the templated output.",
    ),
    "is_upgrade": attr.bool(
        doc = "Set .Release.IsUpgrade instead of .Release.IsInstall.",
    ),
    "kube_version": attr.string(
        doc = "Kubernetes version used for Capabilities.KubeVersion.",
    ),
    "validate": attr.bool(
        doc = "Validate your manifests against the Kubernetes cluster you are currently pointing at.",
    ),
}

def _impl(ctx):
    out = _template(ctx)

    executable = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.write(
        executable,
        "cat " + out.short_path,
        is_executable = True,
    )

    return DefaultInfo(
        files = depset([out]),
        executable = executable,
        runfiles = ctx.runfiles([out]),
    )

def _template(ctx):
    out = ctx.actions.declare_file(ctx.label.name + ".yaml")

    command = [ctx.var["HELM_BIN"]]
    command += ["template"]
    command += [ctx.attr.release_name]
    command += [ctx.file.chart.path]
    if ctx.attr.api_versions:
        command += ["--api-versions", ctx.attr.api_versions]
    if ctx.attr.disable_openapi_validation:
        command += ["--disable-openapi-validation"]
    if ctx.attr.include_crds:
        command += ["--include-crds"]
    if ctx.attr.is_upgrade:
        command += ["--is-upgrade"]
    if ctx.attr.kube_version:
        command += ["--kube-version", ctx.attr.kube_version]
    if ctx.attr.validate:
        command += ["--validate"]
    if ctx.attr.namespace:
        command += ["--namespace", ctx.attr.namespace]

    ctx.actions.run_shell(
        inputs = [ctx.file.chart],
        outputs = [out],
        arguments = [out.path],
        tools = ctx.toolchains["@slamdev_rules_helm//helm:toolchain_type"].default.files,
        progress_message = "Rendering chart " + out.short_path,
        command = " ".join(command) + " > $1",
    )

    return out

template = rule(
    doc = _DOC,
    implementation = _impl,
    attrs = _ATTRS,
    provides = [DefaultInfo],
    executable = True,
    toolchains = ["@slamdev_rules_helm//helm:toolchain_type"],
)
