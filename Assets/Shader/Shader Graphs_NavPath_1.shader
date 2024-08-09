Shader "Shader Graphs/NavPath" {
	Properties {
		Color_4e969abf2af54fff95382dfa55cdd042 ("Color", Vector) = (0,0,0,0)
		Vector1_67ad2c54d987414e9dea62a1754a672e ("Opacity", Range(0, 1)) = 0.8
		Vector1_dff9fc19043a4d3f93d6fdb53789561d ("Rotation", Float) = 0
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
}