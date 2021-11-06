"helm_import rule"

_DOC = "Defines an imported helm chart."

_ATTRS = {
    "chart_name": attr.string(
        doc = "Chart name to import.",
        mandatory = True,
    ),
    "repository": attr.string(
        doc = "Chart repository url where to locate the requested chart.",
        mandatory = True,
    ),
    "version": attr.string(
        doc = "Specify a version constraint for the chart version to use.",
        mandatory = True,
    ),
    "sha256": attr.string(
        doc = "The expected SHA-256 hash of the chart imported.",
    ),
}

def _impl(repository_ctx):
    file_name = "{}-{}.tgz".format(
        repository_ctx.attr.chart_name,
        repository_ctx.attr.version,
    )
    repository_ctx.download(
        output = file_name,
        url = "{}/{}".format(
            repository_ctx.attr.repository,
            file_name,
        ),
        sha256 = repository_ctx.attr.sha256,
    )
    repository_ctx.file("BUILD.bazel", content = """
package(default_visibility = ["//visibility:public"])
filegroup(
    name = "chart",
    srcs = glob(["{}"]),
)
    """.format(file_name))

helm_import = repository_rule(
    doc = _DOC,
    implementation = _impl,
    attrs = _ATTRS,
)
