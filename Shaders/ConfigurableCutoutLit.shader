// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ConfigurableCutoutLit.shader" company="Supyrb">
//   Copyright (c) 2019 Supyrb. All rights reserved.
// </copyright>
// <repository>
//   https://github.com/supyrb/ConfigurableShaders
// </repository>
// <author>
//   Johannes Deml
//   public@deml.io
// </author>
// <documentation>
//   https://github.com/supyrb/ConfigurableShaders/wiki
// </documentation>
// --------------------------------------------------------------------------------------------------------------------

Shader "Configurable/Lit/Cutout" 
{
	Properties 
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
		
		[Gamma] _Metallic("Metallic", Range(0.0, 1.0)) = 0
		_Glossiness("Smoothness", Range(0.0, 1.0)) = 0.5
		[HDR] _EmissionColor("Emission Color", Color) = (0,0,0,1)
		[SimpleToggle] _UseVertexColor("Vertex color", Float) = 1.0
		
		[HeaderHelpURL(Rendering, https, github.com supyrb ConfigurableShaders wiki Rendering)]
		[Tooltip(Changes the depth value. Negative values are closer to the camera)] _Offset("Offset", Float) = 0.0
		[Enum(UnityEngine.Rendering.CullMode)] _Culling ("Cull Mode", Int) = 2
		[Enum(Off,0,On,1)] _ZWrite("ZWrite", Int) = 1
		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", Int) = 4
		[Enum(None,0,Alpha,1,Red,8,Green,4,Blue,2,RGB,14,RGBA,15)] _ColorMask("Color Mask", Int) = 14
		
		[HeaderHelpURL(Stencil, https, github.com supyrb ConfigurableShaders wiki Stencil)]
		[EightBit] _Stencil ("Stencil ID", Int) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)] _StencilComp ("Stencil Comparison", Int) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilOp ("Stencil Operation", Int) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilFail ("Stencil Fail", Int) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilZFail ("Stencil ZFail", Int) = 0
		[EightBit] _ReadMask ("ReadMask", Int) = 255
		[EightBit] _WriteMask ("WriteMask", Int) = 255
		
		[HeaderHelpURL(Blending, https, github.com supyrb ConfigurableShaders wiki Blending)]
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendSrc ("Blend mode Source", Int) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendDst ("Blend mode Destination", Int) = 0
	}
	
	CGINCLUDE

	
	sampler2D _MainTex;
	half4 _Color;
	half4 _EmissionColor;
	half _UseVertexColor;
	half _Glossiness;
	half _Metallic;

	struct Input 
	{
		float2 uv_MainTex;
		float4 color : COLOR;
	};

	void surf (Input IN, inout SurfaceOutputStandard o) 
	{
		half4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
		c = lerp(c, c * IN.color, _UseVertexColor);
		o.Albedo = c.rgb;
		o.Alpha = c.a;
		o.Metallic = _Metallic;
        o.Smoothness = _Glossiness;
		o.Emission = _EmissionColor;
	}
	ENDCG
	
	SubShader 
	{
		Tags { "RenderType"="TransparentCutout" "Queue" = "AlphaTest" }
        LOD 300
        Cull [_Culling]
        Offset [_Offset], [_Offset]
        ZWrite [_ZWrite]
        ZTest [_ZTest]
        ColorMask [_ColorMask]
        Blend [_BlendSrc] [_BlendDst]
		
		Stencil
		{
			Ref [_Stencil]
			ReadMask [_ReadMask]
			WriteMask [_WriteMask]
			Comp [_StencilComp]
			Pass [_StencilOp] 
			Fail [_StencilFail]
			ZFail [_StencilZFail]
		}

		CGPROGRAM
		#pragma surface surf Standard alphatest:_Cutoff fullforwardshadows addshadow keepalpha
		#pragma target 3.0
		ENDCG
	}
	FallBack "Diffuse"
}
