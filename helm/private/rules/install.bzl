"helm_install rule"

load("@io_bazel_rules_docker//container:providers.bzl", "PushInfo")

_DOC = "Defines a helm install execution."

_ATTRS = {
    "chart": attr.label(
        doc = "The label of the chart to install.",
        allow_single_file = [".tgz"],
        mandatory = True,
    ),
    "images": attr.label_list(
        doc = "List of container_push labels to run before installing a chart.",
        providers = [PushInfo, DefaultInfo],
    ),
    "release_name": attr.string(
        doc = "Release name used by helm.",
        mandatory = True,
    ),
    "atomic": attr.bool(
        doc = "The installation process deletes\\rollbacks the installation on failure.",
    ),
    "cleanup_on_fail": attr.bool(
        doc = "Allow deletion of new resources created in this upgrade when upgrade fails.",
    ),
    "create_namespace": attr.bool(
        doc = "Create the release namespace if not present.",
    ),
    "description": attr.string(
        doc = "Add a custom description.",
    ),
    "disable_openapi_validation": attr.bool(
        doc = "If set, the install process will not validate rendered templates against the Kubernetes OpenAPI Schema.",
    ),
    "dry_run": attr.bool(
        doc = "Simulate an install\\upgrade.",
    ),
    "force": attr.bool(
        doc = "Force resource updates through a replacement strategy.",
    ),
    "no_hooks": attr.bool(
        doc = "Prevent hooks from running during install\\upgrade",
    ),
    "namespace": attr.string(
        doc = "Namespace scope for this reques.",
    ),
}

def _impl(ctx):
    runfiles = []
    commands = []

    for image in ctx.attr.images:
        commands.append(image[DefaultInfo].files_to_run.executable.short_path)
        runfiles += image[DefaultInfo].files.to_list()
        runfiles += image[DefaultInfo].default_runfiles.files.to_list()

    runfiles += ctx.toolchains["@slamdev_rules_helm//helm:toolchain_type"].default.files.to_list()
    runfiles.append(ctx.file.chart)
    commands.append(_build_helm_command(ctx))

    script_content = " && ".join(commands)

    executable = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.write(
        executable,
        script_content,
        is_executable = True,
    )

    return DefaultInfo(
        executable = executable,
        runfiles = ctx.runfiles(runfiles),
    )

def _build_helm_command(ctx):
    args = [ctx.var["HELM_BIN"]]
    args.append("upgrade")
    args.append(ctx.attr.release_name)
    args.append(ctx.file.chart.short_path)
    args.append("--install")
    if ctx.attr.atomic:
        args.append("--atomic")
    if ctx.attr.cleanup_on_fail:
        args.append("--cleanup-on-fail")
    if ctx.attr.create_namespace:
        args.append("--create-namespace")
    if ctx.attr.description:
        args.extend(["--description", ctx.attr.description])
    if ctx.attr.disable_openapi_validation:
        args.append("--disable-openapi-validation")
    if ctx.attr.dry_run:
        args.append("--dry-run")
    if ctx.attr.force:
        args.append("--force")
    if ctx.attr.no_hooks:
        args.append("--no-hooks")
    if ctx.attr.namespace:
        args.extend(["--namespace", ctx.attr.namespace])
    return " ".join(args)

install = rule(
    doc = _DOC,
    implementation = _impl,
    attrs = _ATTRS,
    provides = [DefaultInfo],
    executable = True,
    toolchains = ["@slamdev_rules_helm//helm:toolchain_type"],
)
