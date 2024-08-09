Shader "Shader Graphs/LampEmissive" {
	Properties {
		[NoScaleOffset] Texture2D_e48d2ddc9588461bb5bb61be251cd6f5 ("Texture2D", 2D) = "white" {}
		Vector1_354afe3042b84df09182cb85a8d56c7c ("DayEmissive", Float) = 0
		Vector1_edf9b56e176b40f396b253ab515e93a6 ("NightEmissive", Float) = 0
		Color_9beef2cc725c4ccdb8bc8a5425a5a921 ("Color", Vector) = (0,0,0,0)
		[HideInInspector] [NoScaleOffset] unity_Lightmaps ("unity_Lightmaps", 2DArray) = "" {}
		[HideInInspector] [NoScaleOffset] unity_LightmapsInd ("unity_LightmapsInd", 2DArray) = "" {}
		[HideInInspector] [NoScaleOffset] unity_ShadowMasks ("unity_ShadowMasks", 2DArray) = "" {}
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
	Fallback "Hidden/Shader Graph/FallbackError"
	//CustomEditor "ShaderGraph.PBRMasterGUI"
}