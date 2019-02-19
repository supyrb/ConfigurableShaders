// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ConfigurableStandard.shader" company="Supyrb">
//   Copyright (c) 2019 Supyrb. All rights reserved.
// </copyright>
// <repository>
//   https://github.com/supyrb/ConfigurableShaders
// </repository>
// <author>
//   Johannes Deml
//   send@johannesdeml.com
// </author>
// <documentation>
//   https://github.com/supyrb/ConfigurableShaders/wiki
// </documentation>
// --------------------------------------------------------------------------------------------------------------------

Shader "Configurable/Standard" 
{
	Properties 
	{
		[HDR] _Color("Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		
		[Gamma] _Metallic("Metallic", Range(0, 1)) = 0
		_Glossiness("Smoothness", Range(0, 1)) = 0.5
		
		[Header(Rendering)]
		_Offset("Offset", float) = 0
		[Enum(UnityEngine.Rendering.CullMode)] _Culling ("Cull Mode", Int) = 2
		[Enum(Off,0,On,1)] _ZWrite("ZWrite", Int) = 1
		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", Int) = 4
		[Enum(None,0,Alpha,1,Red,8,Green,4,Blue,2,RGB,14,RGBA,15)] _ColorMask("Color Mask", Int) = 15
		
		[Header(Stencil)]
		_Stencil ("Stencil ID [0;255]", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)] _StencilComp ("Stencil Comparison", Int) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilOp ("Stencil Operation", Int) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilFail ("Stencil Fail", Int) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilZFail ("Stencil ZFail", Int) = 0
		// Readmask and Writemask are hidden by default, remove [HideInInspector] if you need them
		[HideInInspector] _ReadMask ("ReadMask [0;255]", Int) = 255
		[HideInInspector] _WriteMask ("WriteMask [0;255]", Int) = 255
		
		[Header(Blending)]
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendSrc ("Blend mode Source", Int) = 5
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendDst ("Blend mode Destination", Int) = 10
	}
	
	CGINCLUDE

	
	sampler2D _MainTex;
	half4 _Color;
	half _Glossiness;
	half _Metallic;

	struct Input 
	{
		float2 uv_MainTex;
	};

	void surf (Input IN, inout SurfaceOutputStandard o) 
	{
		half4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
		o.Albedo = c.rgb;
		o.Alpha = c.a;
		o.Metallic = _Metallic;
        o.Smoothness = _Glossiness;
	}
	ENDCG
	
	SubShader 
	{
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

		Tags { "RenderType"="Opaque" "Queue" = "Geometry" }
        LOD 100
        Cull [_Culling]
        Offset [_Offset], [_Offset]
        ZWrite [_ZWrite]
        ZTest [_ZTest]
        ColorMask [_ColorMask]
        Blend [_BlendSrc] [_BlendDst]

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows addshadow
		#pragma target 3.0
		ENDCG
	}
	FallBack "Diffuse"
}
