
[[Enum(UnityEngine.Rendering.CullMode)]](https://docs.unity3d.com/ScriptReference/Rendering.CullMode.html)
```
public enum CullMode
{
	Off = 0,
	Front = 1,
	Back = 2
}
```

[[Enum(UnityEngine.Rendering.StencilOp)]](https://docs.unity3d.com/ScriptReference/Rendering.StencilOp.html)
```
public enum StencilOp
{
	Keep = 0,
	Zero = 1,
	Replace = 2,
	IncrementSaturate = 3,
	DecrementSaturate = 4,
	Invert = 5,
	IncrementWrap = 6,
	DecrementWrap = 7
}
```

[[Enum(UnityEngine.Rendering.CompareFunction)]](https://docs.unity3d.com/ScriptReference/Rendering.CompareFunction.html)
```
public enum CompareFunction
{
	Disabled = 0,
	Never = 1,
	Less = 2,
	Equal = 3,
	LessEqual = 4,
	Greater = 5,
	NotEqual = 6,
	GreaterEqual = 7,
	Always = 8
}
```

[[Enum(UnityEngine.Rendering.BlendMode)]](https://docs.unity3d.com/ScriptReference/Rendering.BlendMode.html)
```
public enum BlendMode
{
  Zero = 0,
  One = 1,
  DstColor = 2,
  SrcColor = 3,
  OneMinusDstColor = 4,
  SrcAlpha = 5,
  OneMinusSrcColor = 6,
  DstAlpha = 7,
  OneMinusDstAlpha = 8,
  SrcAlphaSaturate = 9,
  OneMinusSrcAlpha = 10
}
```

[[Enum(UnityEngine.Rendering.RenderQueue)]](https://docs.unity3d.com/ScriptReference/Rendering.RenderQueue.html)
```
public enum RenderQueue
{
  Background = 1000,
  Geometry = 2000,
  AlphaTest = 2450,
  GeometryLast = 2500,
  Transparent = 3000,
  Overlay = 4000
}
```

[[Enum(UnityEngine.Rendering.BlendOp)]](https://docs.unity3d.com/ScriptReference/Rendering.BlendOp.html) *(Mostly DX11.1 only)*
```
public enum BlendOp
{
	Add = 0,
	Subtract = 1,
	ReverseSubtract = 2,
	Min = 3,
	Max = 4,
	LogicalClear = 5,
	LogicalSet = 6,
	LogicalCopy = 7,
	LogicalCopyInverted = 8,
	LogicalNoop = 9,
	LogicalInvert = 10,
	LogicalAnd = 11,
	LogicalNand = 12,
	LogicalOr = 13,
	LogicalNor = 14,
	LogicalXor = 15,
	LogicalEquivalence = 16,
	LogicalAndReverse = 17,
	LogicalAndInverted = 18,
	LogicalOrReverse = 19,
	LogicalOrInverted = 20,
	Multiply = 21,
	Screen = 22,
	Overlay = 23,
	Darken = 24,
	Lighten = 25,
	ColorDodge = 26,
	ColorBurn = 27,
	HardLight = 28,
	SoftLight = 29,
	Difference = 30,
	Exclusion = 31,
	HSLHue = 32,
	HSLSaturation = 33,
	HSLColor = 34,
	HSLLuminosity = 35
}
```