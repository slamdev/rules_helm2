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

def _find_chart_url(repository_ctx, repo_file, chart_file):
    repo_def = repository_ctx.read(repo_file)
    lines = repo_def.splitlines()
    for l in lines:
        l = l.lstrip(" ")
        if l.startswith("-") and l.endswith(chart_file):
            url = l.lstrip("-").lstrip(" ")
            if url == chart_file:
                return "{}/{}".format(repository_ctx.attr.repository, url)
            if url.startswith("http") and url.endswith("/{}".format(chart_file)):
                return url
    print(repo_def)
    fail("cannot find {} in {}".format(chart_file, repo_file))

def _impl(repository_ctx):
    repo_yaml = "index.yaml"

    repository_ctx.download(
        output = repo_yaml,
        url = "{}/{}".format(
            repository_ctx.attr.repository,
            repo_yaml,
        ),
    )
    file_name = "{}-{}.tgz".format(
        repository_ctx.attr.chart_name,
        repository_ctx.attr.version,
    )

    chart_url = _find_chart_url(repository_ctx, repo_yaml, file_name)

    repository_ctx.download(
        output = file_name,
        url = chart_url,
        sha256 = repository_ctx.attr.sha256,
    )
    repository_ctx.extract(
        archive = file_name,
    )
    repository_ctx.file("BUILD.bazel", content = """
package(default_visibility = ["//visibility:public"])
filegroup(
    name = "chart",
    srcs = ["{}"],
)
filegroup(
    name = "srcs",
    srcs = glob(["{}/**"]),
)
    """.format(file_name, repository_ctx.attr.chart_name))

helm_import = repository_rule(
    doc = _DOC,
    implementation = _impl,
    attrs = _ATTRS,
)
