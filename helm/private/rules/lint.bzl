"helm_lint_test rule"

_DOC = "Defines a helm lint execution."

_ATTRS = {
    "chart": attr.label(
        doc = "The label of the chart to install.",
        allow_single_file = [".tgz"],
        mandatory = True,
    ),
    "strict": attr.bool(
        doc = "Fail on lint warnings.",
    ),
    "namespace": attr.string(
        doc = "Namespace scope for this reques.",
    ),
}

def _impl(ctx):
    cmd = [ctx.var["HELM_BIN"]]
    cmd += ["lint"]
    cmd += [ctx.file.chart.short_path]
    if ctx.attr.strict:
        cmd += ["--strict"]
    if ctx.attr.namespace:
        cmd += ["--namespace", ctx.attr.namespace]

    executable = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.write(output = executable, content = " ".join(cmd))
    runfiles = ctx.runfiles(files = ctx.toolchains["@slamdev_rules_helm//helm:toolchain_type"].default.files.to_list() + [ctx.file.chart])
    return [
        DefaultInfo(
            executable = executable,
            runfiles = runfiles,
        ),
    ]

lint_test = rule(
    doc = _DOC,
    implementation = _impl,
    attrs = _ATTRS,
    provides = [DefaultInfo],
    test = True,
    toolchains = ["@slamdev_rules_helm//helm:toolchain_type"],
)
