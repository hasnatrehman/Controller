Shader "Wanda/RoadTransition" {
	Properties {
		[NoScaleOffset] _Diffuse ("Diffuse", 2D) = "white" {}
		_Wetness ("Wetness", Range(0, 1)) = 0
		[NoScaleOffset] _Maps ("Maps", 2D) = "white" {}
		_PlanarReflection ("PlanarReflection", Range(0, 2)) = 1
		_RoadOcclusion ("Occlusion", Range(0, 5)) = 1
		[NoScaleOffset] _RainMaps ("RainMaps", 2D) = "white" {}
		_Puddles ("Puddles", Range(0, 2)) = 1
		_PuddleDifference ("PuddleDifference", Range(0, 2)) = 1.8
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