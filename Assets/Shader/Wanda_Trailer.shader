Shader "Wanda/Trailer" {
	Properties {
		[NoScaleOffset] _BaseMap ("Diffuse", 2D) = "white" {}
		[ToggleUI] _HasColor ("HasColor", Float) = 1
		_Color ("Color", Vector) = (1,1,1,0)
		_Smothness ("Smoothness", Range(0, 1)) = 0.5
		[NoScaleOffset] _Specular ("Specular", 2D) = "white" {}
		[NoScaleOffset] _ColorMask ("ColorMask", 2D) = "white" {}
		[NoScaleOffset] _Dirt ("Dirt", 2D) = "white" {}
		[HideInInspector] [NoScaleOffset] unity_Lightmaps ("unity_Lightmaps", 2DArray) = "" {}
		[HideInInspector] [NoScaleOffset] unity_LightmapsInd ("unity_LightmapsInd", 2DArray) = "" {}
		[HideInInspector] [NoScaleOffset] unity_ShadowMasks ("unity_ShadowMasks", 2DArray) = "" {}
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
	Fallback "Hidden/Shader Graph/FallbackError"
	//CustomEditor "ShaderGraph.PBRMasterGUI"
}