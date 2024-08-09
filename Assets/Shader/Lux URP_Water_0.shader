Shader "Lux URP/Water" {
	Properties {
		[HeaderHelpLuxURP_URL(pwa0yoxc3z5m)] [Header(Surface Options)] [Space(8)] [Enum(Off,0,On,1)] _ZWrite ("ZWrite", Float) = 1
		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", Float) = 4
		[Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("Dest BlendMode", Float) = 0
		[ToggleOff(_RECEIVE_SHADOWS_OFF)] _ReceiveShadows ("Receive Shadows", Float) = 1
		[Toggle(ORTHO_SUPPORT)] _OrthoSpport ("Enable Orthographic Support", Float) = 0
		[Header(Surface Inputs)] [Space(8)] _BumpMap ("Water Normal Map", 2D) = "bump" {}
		_BumpScale ("Normal Scale", Float) = 1
		[LuxURPVectorTwoDrawer] _Speed ("Speed (UV)", Vector) = (0.1,0,0,0)
		[LuxURPVectorFourDrawer] _SecondaryTilingSpeedRefractBump ("Secondary Bump", Vector) = (2,2.3,0.1,1)
		[LuxURPHelpDrawer] _Help ("Tiling (X) Speed (Y) Refraction (Z) Bump Scale (W)", Float) = 1
		[Space(5)] _Smoothness ("Smoothness", Range(0, 1)) = 0.5
		_Occulusion ("Occulusion", Range(0, 1)) = 1
		_ReflectionIntensity ("ReflectionIntensity", Range(-100, 100)) = 0
		_SpecColor ("Specular", Vector) = (0.2,0.2,0.2,1)
		[Space(5)] _EdgeBlend ("Edge Blending", Range(0.1, 10)) = 2
		[Space(5)] [Toggle(_REFRACTION)] _EnableRefraction ("Enable Refraction", Float) = 1
		_Refraction ("     Refraction", Range(0, 1)) = 0.25
		_ReflectionBumpScale ("Reflection Bump Scale", Range(0.1, 1)) = 0.3
		[Header(Underwater Fog)] [Space(8)] _Color ("Fog Color", Vector) = (0.2,0.8,0.9,1)
		_Density ("Density", Float) = 1
		[Header(Foam)] [Space(8)] [Toggle(_FOAM)] _Foam ("Enable Foam", Float) = 1
		[NoScaleOffset] _FoamMap ("Foam Albedo (RGB) Mask (A)", 2D) = "bump" {}
		_FoamTiling ("Foam Tiling", Float) = 2
		[LuxURPVectorTwoDrawer] _FoamSpeed ("Foam Speed (UV)", Vector) = (0.1,0,0,0)
		_FoamScale ("Foam Scale", Float) = 4
		_FoamSoftIntersectionFactor ("Foam Edge Blending", Range(0.1, 3)) = 0.5
		_FoamSlopStrength ("Foam Slope Strength", Range(0, 1)) = 0.85
		_FoamSmoothness ("Foam Smoothness", Range(0, 1)) = 0.3
		[Header(Advanced)] [Space(8)] [ToggleOff] _SpecularHighlights ("Enable Specular Highlights", Float) = 1
		[ToggleOff] _EnvironmentReflections ("Environment Reflections", Float) = 1
		[HideInInspector] _Alpha ("Dummy", Float) = 1
		[HideInInspector] _FresnelPower ("Dummy", Float) = 1
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
}