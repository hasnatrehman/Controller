Shader "Shader Graphs/Hologram" {
	Properties {
		Color_19C6C157 ("Base Color", Vector) = (0.4438857,0.7075472,0.4713053,0)
		[NoScaleOffset] Texture2D_48882336 ("Hologram Texture", 2D) = "white" {}
		Vector2_6925FF1E ("Hologram Texture Tiling", Vector) = (1,3,0,0)
		Vector1_6DC2C68C ("Scroll Speed", Float) = 0.1
		[HDR] Color_E448CF9F ("Fresnel Color", Vector) = (1.498039,0.5411765,0,0)
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