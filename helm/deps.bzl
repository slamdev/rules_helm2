"# Helm Dependencies"

load("@slamdev_rules_helm//helm:repositories.bzl", _helm_register_toolchains = "helm_register_toolchains", _rules_helm_dependencies = "rules_helm_dependencies")
load("@slamdev_rules_helm//helm:go_deps.bzl", "rules_helm_go_dependencies")

helm_register_toolchains = _helm_register_toolchains

def rules_helm_dependencies():
    """Macro for users to download and configure repo dependencies."""
    _rules_helm_dependencies()
    rules_helm_go_dependencies()
