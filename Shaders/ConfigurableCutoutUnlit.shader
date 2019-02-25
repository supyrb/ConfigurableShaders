// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ConfigurableCutoutUnlit.shader" company="Supyrb">
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
//   https://github.com/supyrb/ConfigurableShaders/wiki/Stencil
// </documentation>
// --------------------------------------------------------------------------------------------------------------------
Shader "Configurable/Unlit/Cutout"
{
	Properties
	{
		[HDR] _Color("Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
		
		[Header(Rendering)]
		[Tooltip(Changes the depth value. Negative values are closer to the camera)] _Offset("Offset", Float) = 0.0
		[Enum(UnityEngine.Rendering.CullMode)] _Culling ("Cull Mode", Int) = 2
		[Enum(Off,0,On,1)] _ZWrite("ZWrite", Int) = 1
		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", Int) = 4
		[Enum(None,0,Alpha,1,Red,8,Green,4,Blue,2,RGB,14,RGBA,15)] _ColorMask("Color Mask", Int) = 14
		
		[Header(Stencil)]
		[EightBit] _Stencil ("Stencil ID", Int) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)] _StencilComp ("Stencil Comparison", Int) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilOp ("Stencil Operation", Int) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilFail ("Stencil Fail", Int) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilZFail ("Stencil ZFail", Int) = 0
		[EightBit] _ReadMask ("ReadMask", Int) = 255
		[EightBit] _WriteMask ("WriteMask", Int) = 255
		
		[Header(Blending)]
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendSrc ("Blend mode Source", Int) = 5
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendDst ("Blend mode Destination", Int) = 10
	}
	
	CGINCLUDE
	#include "UnityCG.cginc"
	
	fixed4 _Color;
	sampler2D _MainTex;
	float4 _MainTex_ST;
	fixed _Cutoff;
	
	struct v2f
	{
		float4 vertex : SV_POSITION;
		float2 texcoord : TEXCOORD0;
	};
	
	struct appdata_t {
		float4 vertex : POSITION;
		float2 texcoord : TEXCOORD0;
		UNITY_VERTEX_INPUT_INSTANCE_ID
	};
	
	v2f vert (appdata_t v)
	{
		v2f o;
		UNITY_SETUP_INSTANCE_ID(v);
		UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
		return o;
	}
	
	fixed4 frag (v2f i) : SV_Target
	{
		fixed4 image = tex2D(_MainTex, i.texcoord);
		clip(image.a - _Cutoff);
		return image * _Color;
	}
	
	struct v2fShadow 
	{
		float4 vertex : SV_POSITION;
		float2 texcoord : TEXCOORD0;
		UNITY_VERTEX_OUTPUT_STEREO
	};

	v2fShadow vertShadow( appdata_base v )
	{
		v2fShadow o;
		UNITY_SETUP_INSTANCE_ID(v);
		UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
		return o;
	}

	float4 fragShadow( v2fShadow i ) : SV_Target
	{
		fixed4 image = tex2D(_MainTex, i.texcoord);
		clip(image.a - _Cutoff);
		SHADOW_CASTER_FRAGMENT(i)
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

		Pass
		{
			Tags {"Queue"="AlphaTest" "RenderType"="TransparentCutout"}
			LOD 200
			Cull [_Culling]
			Offset [_Offset], [_Offset]
			ZWrite [_ZWrite]
			ZTest [_ZTest]
			ColorMask [_ColorMask]
			Blend [_BlendSrc] [_BlendDst]
			
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing // allow instanced shadow pass for most of the shaders
			ENDCG
		}
		
		// Pass to render object as a shadow caster
		Pass
		{
			Name "ShadowCaster"
			Tags { "LightMode" = "ShadowCaster" }
			LOD 80
			Cull [_Culling]
			Offset [_Offset], [_Offset]
			ZWrite [_ZWrite]
			ZTest [_ZTest]
			
			CGPROGRAM
			#pragma vertex vertShadow
			#pragma fragment fragShadow
			#pragma target 2.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile_instancing // allow instanced shadow pass for most of the shaders
			ENDCG
		}
	}
}