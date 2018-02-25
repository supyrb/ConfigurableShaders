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
//   https://github.com/supyrb/ConfigurableShaders/wiki/Rendering
// </documentation>
// --------------------------------------------------------------------------------------------------------------------
Shader "ConfigurableShaders/Rendering"
{
	Properties
	{		
		[HDR] _Color("Color", Color) = (1,1,1,1)
		
		[Header(Rendering)]
		[Enum(UnityEngine.Rendering.CullMode)] _Culling ("Culling", Int) = 2
		[Enum(Off,0,On,1)] _ZWrite("ZWrite", Int) = 1
		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", Int) = 4
		[Enum(None,0,Alpha,1,Red,8,Green,4,Blue,2,RGB,14,RGBA,15)] _ColorMask("Writing Color Mask", Int) = 15
	}
	
	CGINCLUDE
	#include "UnityCG.cginc"
	
	fixed4 _Color;
	
	struct v2f
	{
		float4 vertex : SV_POSITION;
	};
	
	v2f vert (float4 vertex : POSITION)
	{
		v2f o;
		o.vertex = UnityObjectToClipPos(vertex);
		return o;
	}
	
	fixed4 frag (v2f i) : SV_Target
	{
		return _Color;
	}
	
	ENDCG
		
	SubShader
	{
		Tags { "RenderType"="Opaque" "Queue" = "Geometry" }
		LOD 100
		Cull [_Culling]
		Offset [_Offset], [_Offset]
		ZWrite [_ZWrite]
		ZTest [_ZTest]
		ColorMask [_ColorMask]

		Pass
		{
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			ENDCG
		}
	}
	Fallback "VertexLit"
}