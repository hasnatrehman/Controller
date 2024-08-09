Shader "Lux URP/Projection/Decal Unlit" {
	Properties {
		[HeaderHelpLuxURP_URL(skzrp97i0tvt)] [Header(Surface Options)] [Space(8)] [Toggle(ORTHO_SUPPORT)] _OrthoSpport ("Enable Orthographic Support", Float) = 0
		[Toggle(HQ_SAMPLING)] _HQSampling ("Enable HQ Sampling", Float) = 0
		[Header(Surface Inputs)] [Space(8)] [HDR] _Color ("Color", Vector) = (1,1,1,1)
		[NoScaleOffset] _BaseMap ("Albedo (RGB) Alpha (A)", 2D) = "white" {}
		[Header(Distance Fading)] [Space(8)] [LuxURPDistanceFadeDrawer] _DistanceFade ("Distance Fade Params", Vector) = (2500,0.001,0,0)
		[Header(Stencil)] [Space(8)] [IntRange] _StencilRef ("Stencil Reference", Range(0, 255)) = 0
		[IntRange] _ReadMask ("     Read Mask", Range(0, 255)) = 255
		[IntRange] _WriteMask ("     Write Mask", Range(0, 255)) = 255
		[Enum(UnityEngine.Rendering.CompareFunction)] _StencilCompare ("Stencil Comparison", Float) = 6
		[Header(Advanced)] [Space(8)] [Toggle(_APPLYFOG)] _ApplyFog ("Enable Fog", Float) = 0
	}
	//DummyShaderTextExporter
	SubShader{
		Tags { "RenderType"="Opaque" }
		LOD 200
		CGPROGRAM
#pragma surface surf Standard
#pragma target 3.0

		fixed4 _Color;
		struct Input
		{
			float2 uv_MainTex;
		};
		
		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			o.Albedo = _Color.rgb;
			o.Alpha = _Color.a;
		}
		ENDCG
	}
	Fallback "Hidden/InternalErrorShader"
	//CustomEditor "LuxURPUniversalCustomShaderGUI"
}