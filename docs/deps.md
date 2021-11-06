<!-- Generated with Stardoc: http://skydoc.bazel.build -->



<a id="#helm_register_toolchains"></a>

## helm_register_toolchains

<pre>
helm_register_toolchains(<a href="#helm_register_toolchains-name">name</a>, <a href="#helm_register_toolchains-kwargs">kwargs</a>)
</pre>

Convenience macro for users which does typical setup.

- create a repository for each built-in platform like "helm_linux_amd64" -
  this repository is lazily fetched when helm is needed for that platform.
- TODO: create a convenience repository for the host platform like "helm_host"
- create a repository exposing toolchains for each platform like "helm_platforms"
- register a toolchain pointing at each platform
Users can avoid this macro and do these steps themselves, if they want more control.


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="helm_register_toolchains-name"></a>name |  base name for all created repos, like "helm3_7_1"   |  none |
| <a id="helm_register_toolchains-kwargs"></a>kwargs |  passed to each helm_repositories call   |  none |


<a id="#rules_helm_dependencies"></a>

## rules_helm_dependencies

<pre>
rules_helm_dependencies()
</pre>

Macro for users to download and configure repo dependencies.



