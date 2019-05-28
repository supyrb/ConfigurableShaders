// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ConfigurableRendering.shader" company="Supyrb">
//   Copyright (c) 2018 Supyrb. All rights reserved.
// </copyright>
// <repository>
//   https://github.com/supyrb/ConfigurableShaders
// </repository>
// <author>
//   Johannes Deml
//   send@johannesdeml.com
// </author>
// <documentation>
//   Wiki: https://github.com/supyrb/ConfigurableShaders/wiki/Blending
//   Blending examples: https://wiki.popcornfx.com/index.php/Particle_tutorial_smoke#Setting_up_the_billboard_renderer
// </documentation>
// --------------------------------------------------------------------------------------------------------------------

Shader "Configurable/UI"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		[SimpleToggle] _UseVertexColor("Vertex color", Float) = 1.0
		
		[HeaderHelpURL(Rendering, https, github.com supyrb ConfigurableShaders wiki Rendering)]
		[Enum(None,0,Alpha,1,Red,8,Green,4,Blue,2,RGB,14,RGBA,15)]_ColorMask ("Color Mask", Float) = 15 
		[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 1
		
		[HeaderHelpURL(Blending, https, github.com supyrb ConfigurableShaders wiki Blending)]
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendSrc ("Blend mode Source", Int) = 5
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendDst ("Blend mode Destination", Int) = 10
		
		[HeaderHelpURL(Stencil, https, github.com supyrb ConfigurableShaders wiki Stencil)]
		[EightBit] _Stencil ("Stencil ID", Int) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)] _StencilComp ("Stencil Comparison", Int) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilOp ("Stencil Operation", Int) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilFail ("Stencil Fail", Int) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilZFail ("Stencil ZFail", Int) = 0
		[EightBit] _ReadMask ("ReadMask", Int) = 255
		[EightBit] _WriteMask ("WriteMask", Int) = 255
	}

	CGINCLUDE
	#include "UnityCG.cginc"
	#include "UnityUI.cginc"
	
	half4 _Color;
	half _UseVertexColor;
	fixed4 _TextureSampleAdd;
	float4 _ClipRect;
	
	struct appdata_t
	{
		float4 vertex	: POSITION;
		float4 color	: COLOR;
		float2 texcoord : TEXCOORD0;
		UNITY_VERTEX_INPUT_INSTANCE_ID
	};

	struct v2f
	{
		float4 vertex	: SV_POSITION;
		half4 color	: COLOR;
		float2 texcoord	 : TEXCOORD0;
		float4 worldPosition : TEXCOORD1;
		UNITY_VERTEX_OUTPUT_STEREO
	};
 

	v2f vert(appdata_t IN)
	{
		v2f OUT;
		UNITY_SETUP_INSTANCE_ID(IN);
		UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
		OUT.worldPosition = IN.vertex;
		OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

		OUT.texcoord = IN.texcoord;
	 
		OUT.color = lerp(_Color, IN.color * _Color, _UseVertexColor);
		return OUT;
	}

	sampler2D _MainTex;

	half4 frag(v2f IN) : SV_Target
	{
		half4 color = (tex2D(_MainTex, IN.texcoord) + _TextureSampleAdd) * IN.color;
	 
		color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
	 
		#ifdef UNITY_UI_ALPHACLIP
		clip (color.a - 0.001);
		#endif

		return color;
	}
	ENDCG
	
	SubShader
	{
		Tags
		{ 
			"Queue"="Transparent" 
			"IgnoreProjector"="True" 
			"RenderType"="Transparent" 
			"PreviewType"="Plane"
			"CanUseSpriteAtlas"="True"
		}
		
		Stencil
		{
			Ref [_Stencil]
			Comp [_StencilComp]
			Pass [_StencilOp]
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
		}
 
		Cull Off
		Lighting Off
		ZWrite Off
		ZTest [unity_GUIZTestMode]
		Blend [_BlendSrc] [_BlendDst]
		ColorMask [_ColorMask]
		
		Pass
		{
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile __ UNITY_UI_ALPHACLIP
			ENDCG
		}
	}
}