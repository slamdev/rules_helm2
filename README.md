# Template for Bazel rules

Copy this template to create a Bazel ruleset.

Features:

- follows the official style guide at https://docs.bazel.build/versions/main/skylark/deploying.html
- includes Bazel formatting as a pre-commit hook (using [buildifier])
- includes typical toolchain setup
- CI configured with GitHub Actions
- Release on GitHub Actions when pushing a tag

See https://docs.bazel.build/versions/main/skylark/deploying.html#readme

[buildifier]: https://github.com/bazelbuild/buildtools/tree/master/buildifier#readme

Ready to get started? Copy this repo, then

1. search for "slamdev_rules_helm" and replace with the name you'll use for your workspace
1. search for "helm" and replace with the language/tool your rules are for
1. rename directory "helm" similarly
1. run `pre-commit install` to get lints (see CONTRIBUTING.md)
1. if you don't need to fetch platform-dependent tools, then remove anything toolchain-related.
1. delete this section of the README (everything up to the SNIP).

---- SNIP ----

# Bazel rules for helm

## Installation

Include this in your WORKSPACE file:

```starlark
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
http_archive(
    name = "slamdev_rules_helm",
    url = "https://github.com/myorg/rules_helm/releases/download/0.0.0/rules_helm-0.0.0.tar.gz",
    sha256 = "",
)

load("@slamdev_rules_helm//helm:repositories.bzl", "helm_rules_dependencies")

# This fetches the rules_helm dependencies, which are:
# - bazel_skylib
# If you want to have a different version of some dependency,
# you should fetch it *before* calling this.
# Alternatively, you can skip calling this function, so long as you've
# already fetched these dependencies.
rules_helm_dependencies()
```

> note, in the above, replace the version and sha256 with the one indicated
> in the release notes for rules_helm
> In the future, our release automation should take care of this.
