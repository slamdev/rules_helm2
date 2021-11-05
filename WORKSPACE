# Declare the local Bazel workspace.
# This is *not* included in the published distribution.
workspace(
    # If your ruleset is "official"
    # (i.e. is in the bazelbuild GitHub org)
    # then this should just be named "rules_helm"
    # see https://docs.bazel.build/versions/main/skylark/deploying.html#workspace
    name = "slamdev_rules_helm",
)

load(":internal_deps.bzl", "rules_helm_internal_deps")

# Fetch deps needed only locally for development
rules_helm_internal_deps()

load("//helm:repositories.bzl", "helm_register_toolchains", "rules_helm_dependencies")

# Fetch our "runtime" dependencies which users need as well
rules_helm_dependencies()

helm_register_toolchains(
    name = "helm1_14",
    helm_version = "1.14.2",
)

############################################
# Gazelle, for generating bzl_library targets
load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")
load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")

go_rules_dependencies()

go_register_toolchains(version = "1.17.2")

gazelle_dependencies()
