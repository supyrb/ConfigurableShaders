// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ConfigurableTransparentUnlit.shader" company="Supyrb">
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
Shader "Configurable/Unlit/Transparent"
{
	Properties
	{
		[HDR] _Color("Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		[SimpleToggle] _UseVertexColor("Vertex color", Float) = 1.0
		
		[HeaderHelpURL(Rendering, https, github.com supyrb ConfigurableShaders wiki Rendering)]
		[Tooltip(Changes the depth value. Negative values are closer to the camera)] _Offset("Offset", Float) = 0.0
		[Enum(UnityEngine.Rendering.CullMode)] _Culling ("Cull Mode", Int) = 2
		[Enum(Off,0,On,1)] _ZWrite("ZWrite", Int) = 0
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
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendSrc ("Blend mode Source", Int) = 5
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendDst ("Blend mode Destination", Int) = 10
	}
	
	CGINCLUDE
	#include "UnityCG.cginc"
	
	half4 _Color;
	half _UseVertexColor;
	sampler2D _MainTex;
	float4 _MainTex_ST;
	
	struct appdata_t {
		float4 vertex : POSITION;
		float2 texcoord : TEXCOORD0;
		half4 color: COLOR;
		UNITY_VERTEX_INPUT_INSTANCE_ID
	};
	
	struct v2f
	{
		float4 vertex : SV_POSITION;
		float2 texcoord : TEXCOORD0;
		half4 color: COLOR;
		#ifdef SOFTPARTICLES_ON
		float4 projPos : TEXCOORD1;
		#endif
	};
	
	v2f vert (appdata_t v)
	{
		v2f o;
		UNITY_SETUP_INSTANCE_ID(v);
		UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
		o.color = lerp(_Color, v.color * _Color, _UseVertexColor);
		#ifdef SOFTPARTICLES_ON
		o.projPos = ComputeScreenPos (o.vertex);
		COMPUTE_EYEDEPTH(o.projPos.z);
		#endif
		return o;
	}
	
	half4 frag (v2f i) : SV_Target
	{
		#ifdef SOFTPARTICLES_ON
		float sceneZ = LinearEyeDepth (SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)));
		float partZ = i.projPos.z;
		float fade = saturate (_InvFade * (sceneZ-partZ));
		i.color.a *= fade;
		#endif
		
		half4 col = tex2D(_MainTex, i.texcoord) * i.color;
		return col;
	}	
	ENDCG
		
	SubShader
	{
		Tags { "Queue" = "Transparent" "RenderType" = "Transparent"}
		
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
			#pragma multi_compile_instancing
			ENDCG
		}
	}
}