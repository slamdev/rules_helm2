# Declare the local Bazel workspace.
# This is *not* included in the published distribution.
workspace(
    name = "slamdev_rules_helm",
)

load(":internal_deps.bzl", "rules_helm_internal_deps")

# Fetch deps needed only locally for development
rules_helm_internal_deps()

load("//helm:repositories.bzl", "helm_register_toolchains", "rules_helm_dependencies")

# Fetch our "runtime" dependencies which users need as well
rules_helm_dependencies()

load("//helm:go_deps.bzl", "rules_helm_go_dependencies")

rules_helm_go_dependencies()

helm_register_toolchains(
    name = "helm3_7_1",
    helm_version = "3.7.1",
)

load("//helm:defs.bzl", "helm_import")

helm_import(
    name = "redis",
    chart_name = "redis",
    repository = "https://charts.bitnami.com/bitnami",
    sha256 = "39a9bbb760b1b992f744d06c6cb5c9db9103204a1348f31e76f9201ddeb2b604",
    version = "16.12.2",
)

load("@io_bazel_rules_docker//repositories:repositories.bzl", container_repositories = "repositories")

container_repositories()

load("@io_bazel_rules_docker//go:image.bzl", _go_image_repos = "repositories")

_go_image_repos()
