"# Helm Rules"

load("//helm/private/rules:chart.bzl", "chart")
load("//helm/private/rules:install.bzl", "install")
load("//helm/private/rules:template.bzl", "template")
load("//helm/private/rules:lint.bzl", "lint_test")
load("//helm/private/rules:import.bzl", _import = "helm_import")

helm_chart = chart
helm_install = install
helm_template = template
helm_lint_test = lint_test
helm_import = _import
