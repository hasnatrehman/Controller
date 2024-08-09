Shader "Lux URP/Terrain/Mesh Terrain" {
	Properties {
		[HeaderHelpLuxURP_URL(v7hplahjb13)] [Header(Surface Options)] [Space(8)] [ToggleOff(_RECEIVE_SHADOWS_OFF)] _ReceiveShadows ("Receive Shadows", Float) = 1
		[Header(Surface Inputs)] [Space(8)] [Toggle(_NORMALMAP)] _ApplyNormal ("Enable Normal Maps", Float) = 1
		[Toggle(_TOPDOWNPROJECTION)] _ApplyTopDownProjection ("Enable Top Down Projection", Float) = 0
		_TopDownTiling ("     Tiling in World Space", Float) = 1
		[Space(5)] [NoScaleOffset] _DetailA0 ("Detail 0  Albedo (RGB) Smoothness (A)", 2D) = "gray" {}
		[NoScaleOffset] _Normal0 ("     Normal 0", 2D) = "bump" {}
		[NoScaleOffset] _DetailA1 ("Detail 1  Albedo (RGB) Smoothness (A)", 2D) = "gray" {}
		[NoScaleOffset] _Normal1 ("     Normal 1", 2D) = "bump" {}
		[NoScaleOffset] _DetailA2 ("Detail 2  Albedo (RGB) Smoothness (A)", 2D) = "gray" {}
		[NoScaleOffset] _Normal2 ("     Normal 2", 2D) = "bump" {}
		[NoScaleOffset] _DetailA3 ("Detail 3  Albedo (RGB) Smoothness (A)", 2D) = "gray" {}
		[NoScaleOffset] _Normal3 ("     Normal 3", 2D) = "bump" {}
		[Space(5)] [Toggle(_USEVERTEXCOLORS)] _VertexColors ("Use Vertex Colors", Float) = 0
		[NoScaleOffset] _SplatMap ("Splat Map (RGB)", 2D) = "red" {}
		[Space(5)] [LuxURPVectorTwoDrawer] _SplatTiling ("Detail Tiling (UV)", Vector) = (1,1,0,0)
		_Specular ("Specular", Vector) = (0.2,0.2,0.2,0)
		_Occlusion ("Occlusion", Range(-5, 2)) = 0
		[Header(Advanced)] [Space(8)] [ToggleOff] _SpecularHighlights ("Enable Specular Highlights", Float) = 1
		[ToggleOff] _EnvironmentReflections ("Environment Reflections", Float) = 1
	}
	//DummyShaderTextExporter
	SubShader{
		Tags { "RenderType" = "Opaque" }
		LOD 200
		CGPROGRAM
#pragma surface surf Standard
#pragma target 3.0

		struct Input
		{
			float2 uv_MainTex;
		};

		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			o.Albedo = 1;
		}
		ENDCG
	}
	Fallback "Hidden/InternalErrorShader"
}