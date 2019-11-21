# Configurable Unity Shaders

![Configurable stencil shader inspector screenshot](../../wiki/images/cutoutExample.gif)

Don't repeat yourself by writing the same shaders over and over again with little variation. You can expose a lot of different shader settings through attributes!
Configurable Shaders does three main things:

1. Provide unlit and lit Shaders for Opaque, Cutout and Transparent RenderTypes with a lot of configuration.
2. Provide new useful Material Property Drawers and Debug Shaders
3. Document the hidden features of shaders, that are not that apparent from the Unity Docs.

[Unity Thread](https://forum.unity.com/threads/painless-stencil-shader-with-enums.518966)

## Installation

### Simple Download
[Latest Unity Packages](../../releases/latest)

### Unity Package Manager (UPM)

> You will need to have git installed and set in your system PATH.

Find `Packages/manifest.json` in your project and add the following:
```json
{
  "dependencies": {
    "com.supyrb.configurableshaders": "https://github.com/supyrb/ConfigurableShaders.git#0.6.3",
    "...": "..."
  }
}
```


## Wiki ([Home](../../wiki))
* [Rendering](../../wiki/Rendering)
* [Stencil](../../wiki/Stencil)
* [Blending](../../wiki/Blending)
* [BlendModes](../../wiki/BlendModes)
* [Material PropertyDrawers](../../wiki/PropertyDrawers)
* [DebugShaders](../../wiki/DebugShaders)

## Additional Support Notes

* This Project is for Builtin Shaders, and not meant for usage in the Universal RenderPipeline (URP) or the High Definition Render Pipeline (HDRP)
* Alpha 2 Coverage is supported in the Unlit Cutout Shader ([More Information](https://github.com/supyrb/ConfigurableShaders/issues/9))
* Easily Recreate [Diablo BlendAdd](https://www.youtube.com/watch?v=YPy2hytwDLM&feature=youtu.be&t=1217) by setting Blend to One OneMinusSrcAlpha ([More Information](https://github.com/supyrb/ConfigurableShaders/wiki/BlendModes))
* Custom [Material PropertyDrawers](../../wiki/PropertyDrawers)
* Single Pass Stereo Rendering for VR
* Shadows are also configred with the settings of the shader (which is great!)

## Examples

Name | Example
--- | ---
Overview Scene | ![Overview Scene Screenshot](https://repository-images.githubusercontent.com/122844243/ea508d80-ee9b-11e9-8c62-e88efcc1d60f)
World Normal Shader | ![WorldNormalShader](../../wiki/images/DebugShaders/WorldNormalDemo.gif)
Depth01 Shader | ![Depth01Shader](../../wiki/images/DebugShaders/Depth01Demo.gif)
Standard Material Properties | ![Depth01Shader](../../wiki/images/ConfigurableStandardMaterial.png)

## Contribute
We would ❤love to hear from you.
* If you find a problem, either create a PR or file an issue
* To get in touch [send us a tweet]((https://twitter.com/supyrb))
* Play our game [marbloid](https://itunes.apple.com/us/app/marbloid/id1207773612)


## Helping Hands & Contributors
* [@Supyrb](https://twitter.com/supyrb) (Owner)
* [@DemlJohannes](https://twitter.com/DemlJohannes)
* [@bgolus](https://twitter.com/bgolus)

## License
* MIT - see [LICENSE](./LICENSE.md)
* Stanford Bunny from https://graphics.stanford.edu/data/3Dscanrep/
