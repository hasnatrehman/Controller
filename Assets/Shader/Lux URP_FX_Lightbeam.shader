Shader "Lux URP/FX/Lightbeam" {
	Properties {
		[HeaderHelpLuxURP_URL(m12h3vad3enc)] [Header(Surface Options)] [Space(8)] [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", Float) = 4
		[Enum(UnityEngine.Rendering.CullMode)] _Cull ("Culling", Float) = 2
		[Toggle(ORTHO_SUPPORT)] _OrthoSpport ("Enable Orthographic Support", Float) = 0
		[Header(Surface Inputs)] [Space(8)] [HDR] _Color ("Color", Vector) = (1,1,1,1)
		[NoScaleOffset] _MainTex ("Fall Off (G)", 2D) = "white" {}
		[NoScaleOffset] _SpotTex ("Spot Mask (G)", 2D) = "white" {}
		_ConeWidth ("Cone Width", Range(1, 10)) = 8
		_SpotFade ("Spot Mask Intensity", Range(0.51, 1)) = 0.6
		[Header(Detail Noise)] [Space(8)] [Toggle(_MASKMAP)] _SpecGlossEnabled ("Enable detail noise", Float) = 0
		_DetailTex ("     Detail Noise (G)", 2D) = "white" {}
		_DetailStrength ("     Strength", Range(0, 1)) = 1
		_DetailScrollSpeed ("     Scroll Speed 1:(XY) 2:(ZW)", Vector) = (0,0,0,0)
		[Header(Scene Fade)] [Space(8)] _near ("     Near", Float) = 0
		_far ("     Soft Edge Factor", Float) = 2
		[Header(Camera Fade)] [Space(8)] [LuxURPCameraFadeDrawer] _CameraFadeDistances ("Camera Fade Distances", Vector) = (0.3,1,0.3,1)
		[Space(5)] _LimitLength ("Limit Length", Float) = 50
	}
	//DummyShaderTextExporter
	SubShader{
		Tags { "RenderType"="Opaque" }
		LOD 200
		CGPROGRAM
#pragma surface surf Standard
#pragma target 3.0

		sampler2D _MainTex;
		fixed4 _Color;
		struct Input
		{
			float2 uv_MainTex;
		};
		
		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	Fallback "Hidden/InternalErrorShader"
}