Shader "Shader Graphs/BlobShadowGraph" {
	Properties {
		[HDR] _BlobColor ("Color", Vector) = (0,0,0,0)
		_BlobIntensity ("Intensity", Float) = 0
		_BlobPower ("Power (Sharpness)", Float) = 0
		_CubeToSphereBlend ("Cube To Sphere Blend", Range(0, 1)) = 0
		_RoundedCubeBias ("Rounded Cube Bias", Range(0, 3)) = 2.5
		_RoundedCubePower ("Rounded Cube Power", Range(0, 5)) = 3.5
		[HideInInspector] [NoScaleOffset] unity_Lightmaps ("unity_Lightmaps", 2DArray) = "" {}
		[HideInInspector] [NoScaleOffset] unity_LightmapsInd ("unity_LightmapsInd", 2DArray) = "" {}
		[HideInInspector] [NoScaleOffset] unity_ShadowMasks ("unity_ShadowMasks", 2DArray) = "" {}
		[Toggle] SHADOW_SHAPE_BLENDING ("Shadow Shape Blending", Float) = 0
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