load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies", "go_repository")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")

def rules_helm_go_dependencies():
    """Pull in external Go packages needed by Go binaries in this repo.

    Pull in all dependencies needed to build the Go binaries in this
    repository. This function assumes the repositories imported by the macro
    'rules_helm_dependencies' in //helm:repositories.bzl have been imported
    already.
    """
    go_rules_dependencies()
    if native.existing_rules().get("go_sdk"):
        go_register_toolchains()
    else:
        go_register_toolchains(version = "1.17.2")
    gazelle_dependencies()
    maybe(
        go_repository,
        name = "sigs_k8s_io_yaml",
        importpath = "sigs.k8s.io/yaml",
        sum = "h1:a2VclLzOGrwOHDiV8EfBGhvjHvP46CtW5j6POvhYGGo=",
        version = "v1.3.0",
    )
