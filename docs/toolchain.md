<!-- Generated with Stardoc: http://skydoc.bazel.build -->

This module implements the language-specific toolchain rule.


<a id="#helm_toolchain"></a>

## helm_toolchain

<pre>
helm_toolchain(<a href="#helm_toolchain-name">name</a>, <a href="#helm_toolchain-target_tool">target_tool</a>, <a href="#helm_toolchain-target_tool_path">target_tool_path</a>)
</pre>

Defines a helm compiler/runtime toolchain.

For usage see https://docs.bazel.build/versions/main/toolchains.html#defining-toolchains.


**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="helm_toolchain-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="helm_toolchain-target_tool"></a>target_tool |  A hermetically downloaded executable target for the target platform.   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| <a id="helm_toolchain-target_tool_path"></a>target_tool_path |  Path to an existing executable for the target platform.   | String | optional | "" |


<a id="#HelmInfo"></a>

## HelmInfo

<pre>
HelmInfo(<a href="#HelmInfo-target_tool_path">target_tool_path</a>, <a href="#HelmInfo-tool_files">tool_files</a>)
</pre>

Information about how to invoke the tool executable.

**FIELDS**


| Name  | Description |
| :------------- | :------------- |
| <a id="HelmInfo-target_tool_path"></a>target_tool_path |  Path to the tool executable for the target platform.    |
| <a id="HelmInfo-tool_files"></a>tool_files |  Files required in runfiles to make the tool executable available.<br><br>May be empty if the target_tool_path points to a locally installed tool binary.    |


