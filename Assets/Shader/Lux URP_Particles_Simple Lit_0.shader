Shader "Lux URP/Particles/Simple Lit" {
	Properties {
		[HeaderHelpLuxURP_URL(hgrc26wf1x5s)] [Header(Surface Options)] [Space(8)] [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", Float) = 4
		[Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull", Float) = 2
		[Enum(Off,0,On,1)] [HideInInspector] _ZWrite ("ZWrite", Float) = 0
		[Space(5)] [Enum(Alpha,0,Premultiply,1,Additive,2,Multiply,3)] _Blend ("Blending Mode", Float) = 0
		[Enum(Multiply,0,Additive,1,Subtractive,2,Overlay,3,Color,4,Difference,5)] _ColorMode ("Color Mode", Float) = 0
		[Space(5)] [ToggleOff(_RECEIVE_SHADOWS_OFF)] _ReceiveShadows ("Receive Shadows", Float) = 0
		[Toggle(_ADDITIONALLIGHT_SHADOWS)] _AdditionalLightShadows ("Additional Light Shadows", Float) = 1
		[Toggle(_PERVERTEX_SHADOWS)] _PerVertexShadows ("     Per Vertex Shadows", Float) = 0
		_SampleOffset ("     Sample Offset", Range(0, 2)) = 0.1
		[Header(Surface Inputs)] [Space(8)] _BaseColor ("Base Color", Vector) = (1,1,1,1)
		_BaseMap ("Base Map", 2D) = "white" {}
		[Space(5)] [ToggleOff] _SpecularHighlights ("Specular Highlights", Float) = 1
		[Toggle] _EnableSpecGloss ("     Enable Spec Gloss Map", Float) = 0
		[NoScaleOffset] _SpecGlossMap ("          Spec Gloss Map", 2D) = "white" {}
		_SpecColor ("          Specular (RGB) Smoothness(A)", Vector) = (1,1,1,0.5)
		[Space(5)] [Toggle(_NORMALMAP)] _ApplyNormal ("Enable Normal Map", Float) = 0
		[NoScaleOffset] _BumpMap ("     Normal Map", 2D) = "bump" {}
		[Space(5)] [Toggle(_EMISSION)] _EnableEmission ("Enable Emission", Float) = 0
		[NoScaleOffset] _EmissionMap ("     Emission Map", 2D) = "white" {}
		[HDR] _EmissionColor ("     Color", Vector) = (1,1,1,1)
		[Space(5)] [Toggle(_TRANSMISSION)] _EnableTransmission ("Enable Transmission", Float) = 0
		_Transmission ("     Transmission", Range(0, 1)) = 0.5
		_TransmissionDistortion ("     Distortion", Range(0.01, 0.5)) = 0.01
		[HideInInspector] _BlendOp ("__blendop", Float) = 0
		[Header(Particle Options)] [Space(8)] [Toggle(_FLIPBOOKBLENDING_ON)] _FlipbookBlending ("Enable Flipbook Blending", Float) = 0
		[Space(5)] [Toggle(_DISTORTION_ON)] _DistortionEnabled ("Enable Distortion", Float) = 0
		_DistortionStrength ("     Strength", Float) = 1
		_DistortionBlend ("     Blend", Range(0, 1)) = 0.5
		[HideInInspector] _DistortionStrengthScaled ("     Distortion Strength Scaled", Float) = 0.1
		[Space(5)] [Toggle(_SOFTPARTICLES_ON)] _SoftParticlesEnabled ("Enable Soft Particles", Float) = 0
		[LuxURPVectorTwoDrawer] _SoftParticleFadeParams ("     Near (X) Far (Y)", Vector) = (0,1,0,0)
		[Space(5)] [Toggle(_FADING_ON)] _CameraFadingEnabled ("Enable Camera Fading", Float) = 0
		[LuxURPVectorTwoDrawer] _CameraFadeParamsRaw ("     Near (X) Far (Y)", Vector) = (1,2,0,0)
		[HideInInspector] _CameraFadeParams ("     Near (X) Far (Y)", Vector) = (1,1,0,0)
		[HideInInspector] _Surface ("__surface", Float) = 0
		[HideInInspector] _AlphaClip ("__clip", Float) = 0
		[Enum(UnityEngine.Rendering.BlendMode)] [HideInInspector] _SrcBlend ("__src", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] [HideInInspector] _DstBlend ("__dst", Float) = 0
		[HideInInspector] _BaseColorAddSubDiff ("_ColorMode", Vector) = (0,0,0,0)
		[HideInInspector] _QueueOffset ("Queue offset", Float) = 0
		[HideInInspector] _FlipbookMode ("flipbook", Float) = 0
		[HideInInspector] _Glossiness ("gloss", Float) = 0
		[HideInInspector] _Mode ("mode", Float) = 0
		[HideInInspector] _Color ("color", Vector) = (1,1,1,1)
		[HideInInspector] _MainTex ("Albedo", 2D) = "white" {}
		[HideInInspector] _Color ("Color", Vector) = (1,1,1,1)
		[HideInInspector] _Cutoff ("Alpha Cutoff", Range(0, 1)) = 0
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
	Fallback "Lightweight Render Pipeline/Particles/Unlit"
	//CustomEditor "LuxURPParticlesCustomShaderGUI"
}