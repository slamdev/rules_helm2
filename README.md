# Bazel rules for helm

## Installation

Include this in your WORKSPACE file:

```starlark
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "slamdev_rules_helm",
    url = "https://github.com/slamdev/rules_helm/releases/download/0.0.0/slamdev_rules_helm-v0.0.0.tar.gz",
    sha256 = "",
)

load("@slamdev_rules_helm//helm:deps.bzl", "helm_register_toolchains", "rules_helm_dependencies")

rules_helm_dependencies()

helm_register_toolchains(
    name = "helm3_7_1",
    helm_version = "3.7.1",
)
```

> note, in the above, replace the version and sha256 with the one indicated
> in the release notes for rules_helm.
