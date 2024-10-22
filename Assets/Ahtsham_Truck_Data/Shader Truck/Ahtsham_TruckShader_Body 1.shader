Shader "Shader Graphs/Ahtsham_TruckShader_Body 1"
{
    Properties
    {
        _Color("Color", Color) = (1, 1, 1, 0)
        [NoScaleOffset]_Base("Base", 2D) = "white" {}
        _Fresnel("Fresnel", Range(0, 3)) = 0
        [NoScaleOffset]_Specular("Specular", 2D) = "white" {}
        [NoScaleOffset]_Mask("Mask", 2D) = "white" {}
        [NoScaleOffset]_Metallic("Metallic", 2D) = "white" {}
        _Smoothness("Smoothness", Range(0, 1)) = 0
        [NoScaleOffset]_Cubemap("Cubemap", CUBE) = "" {}
        [NoScaleOffset]_Dirt("Dirt", 2D) = "white" {}
        _LOD("LOD", Range(0, 1)) = 0
        [HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector]_QueueControl("_QueueControl", Float) = -1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Opaque"
            "UniversalMaterialType" = "Lit"
            "Queue"="Geometry"
            "DisableBatching"="False"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalLitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }
        
        // Render State
        Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
        #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _LIGHT_LAYERS
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile_fragment _ _LIGHT_COOKIES
        #pragma multi_compile _ _FORWARD_PLUS
        #pragma multi_compile _ EVALUATE_SH_MIXED EVALUATE_SH_VERTEX
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        #define _FOG_FRAGMENT 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 TangentSpaceNormal;
             float3 WorldSpaceViewDirection;
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV : INTERP0;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP2;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord : INTERP3;
            #endif
             float4 tangentWS : INTERP4;
             float4 texCoord0 : INTERP5;
             float4 fogFactorAndVertexLight : INTERP6;
             float3 positionWS : INTERP7;
             float3 normalWS : INTERP8;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Base_TexelSize;
        float4 _Mask_TexelSize;
        float _Fresnel;
        float4 _Color;
        float4 _Metallic_TexelSize;
        float4 _Specular_TexelSize;
        float4 _Dirt_TexelSize;
        float _Smoothness;
        float _LOD;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Base);
        SAMPLER(sampler_Base);
        TEXTURE2D(_Mask);
        SAMPLER(sampler_Mask);
        TEXTURE2D(_Metallic);
        SAMPLER(sampler_Metallic);
        TEXTURECUBE(_Cubemap);
        SAMPLER(sampler_Cubemap);
        TEXTURE2D(_Specular);
        SAMPLER(sampler_Specular);
        TEXTURE2D(_Dirt);
        SAMPLER(sampler_Dirt);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_ChannelMask_RedGreenBlueAlpha_float (float In, out float Out)
        {
            Out = In;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
        {
            Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_28c3cd6e7bdd49caaa67cc2e6af0c22d_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base);
            float4 _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_28c3cd6e7bdd49caaa67cc2e6af0c22d_Out_0_Texture2D.tex, _Property_28c3cd6e7bdd49caaa67cc2e6af0c22d_Out_0_Texture2D.samplerstate, _Property_28c3cd6e7bdd49caaa67cc2e6af0c22d_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_R_4_Float = _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_RGBA_0_Vector4.r;
            float _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_G_5_Float = _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_RGBA_0_Vector4.g;
            float _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_B_6_Float = _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_RGBA_0_Vector4.b;
            float _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_A_7_Float = _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_RGBA_0_Vector4.a;
            float4 _Property_1a4a66ddb7314a7db44891e2e4154e53_Out_0_Vector4 = _Color;
            UnityTexture2D _Property_d29e9efea0ff4249908d92d1051dd915_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Mask);
            float4 _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d29e9efea0ff4249908d92d1051dd915_Out_0_Texture2D.tex, _Property_d29e9efea0ff4249908d92d1051dd915_Out_0_Texture2D.samplerstate, _Property_d29e9efea0ff4249908d92d1051dd915_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_R_4_Float = _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_RGBA_0_Vector4.r;
            float _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_G_5_Float = _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_RGBA_0_Vector4.g;
            float _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_B_6_Float = _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_RGBA_0_Vector4.b;
            float _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_A_7_Float = _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_RGBA_0_Vector4.a;
            float _ChannelMask_93b1dc178259488d92396896b0888715_Out_1_Float;
            Unity_ChannelMask_RedGreenBlueAlpha_float (_SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_R_4_Float, _ChannelMask_93b1dc178259488d92396896b0888715_Out_1_Float);
            float4 _Lerp_df5aa3bbccea487db44607d2fa6aea17_Out_3_Vector4;
            Unity_Lerp_float4(_SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_RGBA_0_Vector4, _Property_1a4a66ddb7314a7db44891e2e4154e53_Out_0_Vector4, (_ChannelMask_93b1dc178259488d92396896b0888715_Out_1_Float.xxxx), _Lerp_df5aa3bbccea487db44607d2fa6aea17_Out_3_Vector4);
            UnityTexture2D _Property_f9296df1b28549b0b747f18d0984f541_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Dirt);
            float4 _SampleTexture2D_75da8cdac346499f953172c2706ddd05_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_f9296df1b28549b0b747f18d0984f541_Out_0_Texture2D.tex, _Property_f9296df1b28549b0b747f18d0984f541_Out_0_Texture2D.samplerstate, _Property_f9296df1b28549b0b747f18d0984f541_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_75da8cdac346499f953172c2706ddd05_R_4_Float = _SampleTexture2D_75da8cdac346499f953172c2706ddd05_RGBA_0_Vector4.r;
            float _SampleTexture2D_75da8cdac346499f953172c2706ddd05_G_5_Float = _SampleTexture2D_75da8cdac346499f953172c2706ddd05_RGBA_0_Vector4.g;
            float _SampleTexture2D_75da8cdac346499f953172c2706ddd05_B_6_Float = _SampleTexture2D_75da8cdac346499f953172c2706ddd05_RGBA_0_Vector4.b;
            float _SampleTexture2D_75da8cdac346499f953172c2706ddd05_A_7_Float = _SampleTexture2D_75da8cdac346499f953172c2706ddd05_RGBA_0_Vector4.a;
            float _Property_6f362c2b5d8b42f8b51d7cd8c9e0c5e4_Out_0_Float = _LOD;
            float _Multiply_95b7844b07b54bee8ce34f223873e058_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_75da8cdac346499f953172c2706ddd05_A_7_Float, _Property_6f362c2b5d8b42f8b51d7cd8c9e0c5e4_Out_0_Float, _Multiply_95b7844b07b54bee8ce34f223873e058_Out_2_Float);
            float4 _Lerp_68cd9d96e1a24a49a02355bd48e2f613_Out_3_Vector4;
            Unity_Lerp_float4(_Lerp_df5aa3bbccea487db44607d2fa6aea17_Out_3_Vector4, _SampleTexture2D_75da8cdac346499f953172c2706ddd05_RGBA_0_Vector4, (_Multiply_95b7844b07b54bee8ce34f223873e058_Out_2_Float.xxxx), _Lerp_68cd9d96e1a24a49a02355bd48e2f613_Out_3_Vector4);
            float _FresnelEffect_5989a23e047d4b88b7dd8856ad805eef_Out_3_Float;
            Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, 1, _FresnelEffect_5989a23e047d4b88b7dd8856ad805eef_Out_3_Float);
            float _Property_ca1ba1c8550f41ebb50ffb4ee3b39399_Out_0_Float = _Fresnel;
            float _Multiply_3e84c19f71084e0fa7f8deb3e19a71a5_Out_2_Float;
            Unity_Multiply_float_float(_FresnelEffect_5989a23e047d4b88b7dd8856ad805eef_Out_3_Float, _Property_ca1ba1c8550f41ebb50ffb4ee3b39399_Out_0_Float, _Multiply_3e84c19f71084e0fa7f8deb3e19a71a5_Out_2_Float);
            UnityTextureCube _Property_373c5e134b6e4018af52a7f784303650_Out_0_Cubemap = UnityBuildTextureCubeStruct(_Cubemap);
            float4 _SampleCubemap_98f5c7b9ec01448aa2f03f105732c1f8_Out_0_Vector4 = SAMPLE_TEXTURECUBE_LOD(_Property_373c5e134b6e4018af52a7f784303650_Out_0_Cubemap.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, IN.WorldSpaceViewDirection, 0);
            UnityTexture2D _Property_ec58c8b27ed64551b81e1f8539d175df_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Mask);
            float4 _SampleTexture2D_f22ff145dce64761a34d169e64c6fca3_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_ec58c8b27ed64551b81e1f8539d175df_Out_0_Texture2D.tex, _Property_ec58c8b27ed64551b81e1f8539d175df_Out_0_Texture2D.samplerstate, _Property_ec58c8b27ed64551b81e1f8539d175df_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_f22ff145dce64761a34d169e64c6fca3_R_4_Float = _SampleTexture2D_f22ff145dce64761a34d169e64c6fca3_RGBA_0_Vector4.r;
            float _SampleTexture2D_f22ff145dce64761a34d169e64c6fca3_G_5_Float = _SampleTexture2D_f22ff145dce64761a34d169e64c6fca3_RGBA_0_Vector4.g;
            float _SampleTexture2D_f22ff145dce64761a34d169e64c6fca3_B_6_Float = _SampleTexture2D_f22ff145dce64761a34d169e64c6fca3_RGBA_0_Vector4.b;
            float _SampleTexture2D_f22ff145dce64761a34d169e64c6fca3_A_7_Float = _SampleTexture2D_f22ff145dce64761a34d169e64c6fca3_RGBA_0_Vector4.a;
            float _Float_3db560db412d41f59c869999afc8ce70_Out_0_Float = 0;
            float _Subtract_a418342d766c4098a8501665125fbe40_Out_2_Float;
            Unity_Subtract_float(_SampleTexture2D_f22ff145dce64761a34d169e64c6fca3_R_4_Float, _Float_3db560db412d41f59c869999afc8ce70_Out_0_Float, _Subtract_a418342d766c4098a8501665125fbe40_Out_2_Float);
            float _Clamp_f07138c57dfe4b8a8b87a935155fd790_Out_3_Float;
            Unity_Clamp_float(_Subtract_a418342d766c4098a8501665125fbe40_Out_2_Float, 0, 1, _Clamp_f07138c57dfe4b8a8b87a935155fd790_Out_3_Float);
            float4 _Multiply_54f2142f1a2a446c80d5257dd05810cb_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleCubemap_98f5c7b9ec01448aa2f03f105732c1f8_Out_0_Vector4, (_Clamp_f07138c57dfe4b8a8b87a935155fd790_Out_3_Float.xxxx), _Multiply_54f2142f1a2a446c80d5257dd05810cb_Out_2_Vector4);
            float4 _Multiply_7322d935dd03414dba0d824b45dda546_Out_2_Vector4;
            Unity_Multiply_float4_float4((_Multiply_3e84c19f71084e0fa7f8deb3e19a71a5_Out_2_Float.xxxx), _Multiply_54f2142f1a2a446c80d5257dd05810cb_Out_2_Vector4, _Multiply_7322d935dd03414dba0d824b45dda546_Out_2_Vector4);
            UnityTexture2D _Property_72ef1a68bc3845839170a2cb14890eb7_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Metallic);
            float4 _SampleTexture2D_fb4864449111453987026bf621eda8b1_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_72ef1a68bc3845839170a2cb14890eb7_Out_0_Texture2D.tex, _Property_72ef1a68bc3845839170a2cb14890eb7_Out_0_Texture2D.samplerstate, _Property_72ef1a68bc3845839170a2cb14890eb7_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_fb4864449111453987026bf621eda8b1_R_4_Float = _SampleTexture2D_fb4864449111453987026bf621eda8b1_RGBA_0_Vector4.r;
            float _SampleTexture2D_fb4864449111453987026bf621eda8b1_G_5_Float = _SampleTexture2D_fb4864449111453987026bf621eda8b1_RGBA_0_Vector4.g;
            float _SampleTexture2D_fb4864449111453987026bf621eda8b1_B_6_Float = _SampleTexture2D_fb4864449111453987026bf621eda8b1_RGBA_0_Vector4.b;
            float _SampleTexture2D_fb4864449111453987026bf621eda8b1_A_7_Float = _SampleTexture2D_fb4864449111453987026bf621eda8b1_RGBA_0_Vector4.a;
            UnityTexture2D _Property_dd464c3c1cf54c6db9bb0c7d72f9903e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Specular);
            float4 _SampleTexture2D_269f375e9bf14e33aaf6fea5ec88738b_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_dd464c3c1cf54c6db9bb0c7d72f9903e_Out_0_Texture2D.tex, _Property_dd464c3c1cf54c6db9bb0c7d72f9903e_Out_0_Texture2D.samplerstate, _Property_dd464c3c1cf54c6db9bb0c7d72f9903e_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_269f375e9bf14e33aaf6fea5ec88738b_R_4_Float = _SampleTexture2D_269f375e9bf14e33aaf6fea5ec88738b_RGBA_0_Vector4.r;
            float _SampleTexture2D_269f375e9bf14e33aaf6fea5ec88738b_G_5_Float = _SampleTexture2D_269f375e9bf14e33aaf6fea5ec88738b_RGBA_0_Vector4.g;
            float _SampleTexture2D_269f375e9bf14e33aaf6fea5ec88738b_B_6_Float = _SampleTexture2D_269f375e9bf14e33aaf6fea5ec88738b_RGBA_0_Vector4.b;
            float _SampleTexture2D_269f375e9bf14e33aaf6fea5ec88738b_A_7_Float = _SampleTexture2D_269f375e9bf14e33aaf6fea5ec88738b_RGBA_0_Vector4.a;
            UnityTexture2D _Property_37db059d88dd4b70bc86c0706a19a53c_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Mask);
            float4 _SampleTexture2D_56b17b9176a04c05ab48e52126a2502c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_37db059d88dd4b70bc86c0706a19a53c_Out_0_Texture2D.tex, _Property_37db059d88dd4b70bc86c0706a19a53c_Out_0_Texture2D.samplerstate, _Property_37db059d88dd4b70bc86c0706a19a53c_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_56b17b9176a04c05ab48e52126a2502c_R_4_Float = _SampleTexture2D_56b17b9176a04c05ab48e52126a2502c_RGBA_0_Vector4.r;
            float _SampleTexture2D_56b17b9176a04c05ab48e52126a2502c_G_5_Float = _SampleTexture2D_56b17b9176a04c05ab48e52126a2502c_RGBA_0_Vector4.g;
            float _SampleTexture2D_56b17b9176a04c05ab48e52126a2502c_B_6_Float = _SampleTexture2D_56b17b9176a04c05ab48e52126a2502c_RGBA_0_Vector4.b;
            float _SampleTexture2D_56b17b9176a04c05ab48e52126a2502c_A_7_Float = _SampleTexture2D_56b17b9176a04c05ab48e52126a2502c_RGBA_0_Vector4.a;
            float _ChannelMask_4d7ee1a97ad14c949ba2d2a8acc03174_Out_1_Float;
            Unity_ChannelMask_RedGreenBlueAlpha_float (_SampleTexture2D_56b17b9176a04c05ab48e52126a2502c_R_4_Float, _ChannelMask_4d7ee1a97ad14c949ba2d2a8acc03174_Out_1_Float);
            float4 _Lerp_ffddf489f87641f0a989475b5d5c69a3_Out_3_Vector4;
            Unity_Lerp_float4(_SampleTexture2D_fb4864449111453987026bf621eda8b1_RGBA_0_Vector4, _SampleTexture2D_269f375e9bf14e33aaf6fea5ec88738b_RGBA_0_Vector4, (_ChannelMask_4d7ee1a97ad14c949ba2d2a8acc03174_Out_1_Float.xxxx), _Lerp_ffddf489f87641f0a989475b5d5c69a3_Out_3_Vector4);
            UnityTexture2D _Property_e89c3b70222e42b18107727deca1926c_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base);
            float4 _SampleTexture2D_17c079a6c4984d9c85e44fa759dc15ce_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_e89c3b70222e42b18107727deca1926c_Out_0_Texture2D.tex, _Property_e89c3b70222e42b18107727deca1926c_Out_0_Texture2D.samplerstate, _Property_e89c3b70222e42b18107727deca1926c_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_17c079a6c4984d9c85e44fa759dc15ce_R_4_Float = _SampleTexture2D_17c079a6c4984d9c85e44fa759dc15ce_RGBA_0_Vector4.r;
            float _SampleTexture2D_17c079a6c4984d9c85e44fa759dc15ce_G_5_Float = _SampleTexture2D_17c079a6c4984d9c85e44fa759dc15ce_RGBA_0_Vector4.g;
            float _SampleTexture2D_17c079a6c4984d9c85e44fa759dc15ce_B_6_Float = _SampleTexture2D_17c079a6c4984d9c85e44fa759dc15ce_RGBA_0_Vector4.b;
            float _SampleTexture2D_17c079a6c4984d9c85e44fa759dc15ce_A_7_Float = _SampleTexture2D_17c079a6c4984d9c85e44fa759dc15ce_RGBA_0_Vector4.a;
            float _Property_34681fb069ad48508734e6d476a8fc9e_Out_0_Float = _Smoothness;
            UnityTexture2D _Property_56128e922feb4567ad8580b5a265ac39_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Mask);
            float4 _SampleTexture2D_8230b955e7504292aac52356957dc41f_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_56128e922feb4567ad8580b5a265ac39_Out_0_Texture2D.tex, _Property_56128e922feb4567ad8580b5a265ac39_Out_0_Texture2D.samplerstate, _Property_56128e922feb4567ad8580b5a265ac39_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_8230b955e7504292aac52356957dc41f_R_4_Float = _SampleTexture2D_8230b955e7504292aac52356957dc41f_RGBA_0_Vector4.r;
            float _SampleTexture2D_8230b955e7504292aac52356957dc41f_G_5_Float = _SampleTexture2D_8230b955e7504292aac52356957dc41f_RGBA_0_Vector4.g;
            float _SampleTexture2D_8230b955e7504292aac52356957dc41f_B_6_Float = _SampleTexture2D_8230b955e7504292aac52356957dc41f_RGBA_0_Vector4.b;
            float _SampleTexture2D_8230b955e7504292aac52356957dc41f_A_7_Float = _SampleTexture2D_8230b955e7504292aac52356957dc41f_RGBA_0_Vector4.a;
            float _ChannelMask_89a1d7e505674b6a8c0f3fb5fa3e315e_Out_1_Float;
            Unity_ChannelMask_RedGreenBlueAlpha_float (_SampleTexture2D_8230b955e7504292aac52356957dc41f_R_4_Float, _ChannelMask_89a1d7e505674b6a8c0f3fb5fa3e315e_Out_1_Float);
            float4 _Lerp_255342fa31564996a99da4fa83bfce55_Out_3_Vector4;
            Unity_Lerp_float4(_SampleTexture2D_17c079a6c4984d9c85e44fa759dc15ce_RGBA_0_Vector4, (_Property_34681fb069ad48508734e6d476a8fc9e_Out_0_Float.xxxx), (_ChannelMask_89a1d7e505674b6a8c0f3fb5fa3e315e_Out_1_Float.xxxx), _Lerp_255342fa31564996a99da4fa83bfce55_Out_3_Vector4);
            surface.BaseColor = (_Lerp_68cd9d96e1a24a49a02355bd48e2f613_Out_3_Vector4.xyz);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Emission = (_Multiply_7322d935dd03414dba0d824b45dda546_Out_2_Vector4.xyz);
            surface.Metallic = (_Lerp_ffddf489f87641f0a989475b5d5c69a3_Out_3_Vector4).x;
            surface.Smoothness = (_Lerp_255342fa31564996a99da4fa83bfce55_Out_3_Vector4).x;
            surface.Occlusion = 1;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "GBuffer"
            Tags
            {
                "LightMode" = "UniversalGBuffer"
            }
        
        // Render State
        Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
        #pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_GBUFFER
        #define _FOG_FRAGMENT 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 TangentSpaceNormal;
             float3 WorldSpaceViewDirection;
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV : INTERP0;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP2;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord : INTERP3;
            #endif
             float4 tangentWS : INTERP4;
             float4 texCoord0 : INTERP5;
             float4 fogFactorAndVertexLight : INTERP6;
             float3 positionWS : INTERP7;
             float3 normalWS : INTERP8;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Base_TexelSize;
        float4 _Mask_TexelSize;
        float _Fresnel;
        float4 _Color;
        float4 _Metallic_TexelSize;
        float4 _Specular_TexelSize;
        float4 _Dirt_TexelSize;
        float _Smoothness;
        float _LOD;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Base);
        SAMPLER(sampler_Base);
        TEXTURE2D(_Mask);
        SAMPLER(sampler_Mask);
        TEXTURE2D(_Metallic);
        SAMPLER(sampler_Metallic);
        TEXTURECUBE(_Cubemap);
        SAMPLER(sampler_Cubemap);
        TEXTURE2D(_Specular);
        SAMPLER(sampler_Specular);
        TEXTURE2D(_Dirt);
        SAMPLER(sampler_Dirt);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_ChannelMask_RedGreenBlueAlpha_float (float In, out float Out)
        {
            Out = In;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
        {
            Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_28c3cd6e7bdd49caaa67cc2e6af0c22d_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base);
            float4 _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_28c3cd6e7bdd49caaa67cc2e6af0c22d_Out_0_Texture2D.tex, _Property_28c3cd6e7bdd49caaa67cc2e6af0c22d_Out_0_Texture2D.samplerstate, _Property_28c3cd6e7bdd49caaa67cc2e6af0c22d_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_R_4_Float = _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_RGBA_0_Vector4.r;
            float _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_G_5_Float = _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_RGBA_0_Vector4.g;
            float _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_B_6_Float = _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_RGBA_0_Vector4.b;
            float _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_A_7_Float = _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_RGBA_0_Vector4.a;
            float4 _Property_1a4a66ddb7314a7db44891e2e4154e53_Out_0_Vector4 = _Color;
            UnityTexture2D _Property_d29e9efea0ff4249908d92d1051dd915_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Mask);
            float4 _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d29e9efea0ff4249908d92d1051dd915_Out_0_Texture2D.tex, _Property_d29e9efea0ff4249908d92d1051dd915_Out_0_Texture2D.samplerstate, _Property_d29e9efea0ff4249908d92d1051dd915_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_R_4_Float = _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_RGBA_0_Vector4.r;
            float _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_G_5_Float = _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_RGBA_0_Vector4.g;
            float _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_B_6_Float = _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_RGBA_0_Vector4.b;
            float _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_A_7_Float = _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_RGBA_0_Vector4.a;
            float _ChannelMask_93b1dc178259488d92396896b0888715_Out_1_Float;
            Unity_ChannelMask_RedGreenBlueAlpha_float (_SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_R_4_Float, _ChannelMask_93b1dc178259488d92396896b0888715_Out_1_Float);
            float4 _Lerp_df5aa3bbccea487db44607d2fa6aea17_Out_3_Vector4;
            Unity_Lerp_float4(_SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_RGBA_0_Vector4, _Property_1a4a66ddb7314a7db44891e2e4154e53_Out_0_Vector4, (_ChannelMask_93b1dc178259488d92396896b0888715_Out_1_Float.xxxx), _Lerp_df5aa3bbccea487db44607d2fa6aea17_Out_3_Vector4);
            UnityTexture2D _Property_f9296df1b28549b0b747f18d0984f541_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Dirt);
            float4 _SampleTexture2D_75da8cdac346499f953172c2706ddd05_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_f9296df1b28549b0b747f18d0984f541_Out_0_Texture2D.tex, _Property_f9296df1b28549b0b747f18d0984f541_Out_0_Texture2D.samplerstate, _Property_f9296df1b28549b0b747f18d0984f541_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_75da8cdac346499f953172c2706ddd05_R_4_Float = _SampleTexture2D_75da8cdac346499f953172c2706ddd05_RGBA_0_Vector4.r;
            float _SampleTexture2D_75da8cdac346499f953172c2706ddd05_G_5_Float = _SampleTexture2D_75da8cdac346499f953172c2706ddd05_RGBA_0_Vector4.g;
            float _SampleTexture2D_75da8cdac346499f953172c2706ddd05_B_6_Float = _SampleTexture2D_75da8cdac346499f953172c2706ddd05_RGBA_0_Vector4.b;
            float _SampleTexture2D_75da8cdac346499f953172c2706ddd05_A_7_Float = _SampleTexture2D_75da8cdac346499f953172c2706ddd05_RGBA_0_Vector4.a;
            float _Property_6f362c2b5d8b42f8b51d7cd8c9e0c5e4_Out_0_Float = _LOD;
            float _Multiply_95b7844b07b54bee8ce34f223873e058_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_75da8cdac346499f953172c2706ddd05_A_7_Float, _Property_6f362c2b5d8b42f8b51d7cd8c9e0c5e4_Out_0_Float, _Multiply_95b7844b07b54bee8ce34f223873e058_Out_2_Float);
            float4 _Lerp_68cd9d96e1a24a49a02355bd48e2f613_Out_3_Vector4;
            Unity_Lerp_float4(_Lerp_df5aa3bbccea487db44607d2fa6aea17_Out_3_Vector4, _SampleTexture2D_75da8cdac346499f953172c2706ddd05_RGBA_0_Vector4, (_Multiply_95b7844b07b54bee8ce34f223873e058_Out_2_Float.xxxx), _Lerp_68cd9d96e1a24a49a02355bd48e2f613_Out_3_Vector4);
            float _FresnelEffect_5989a23e047d4b88b7dd8856ad805eef_Out_3_Float;
            Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, 1, _FresnelEffect_5989a23e047d4b88b7dd8856ad805eef_Out_3_Float);
            float _Property_ca1ba1c8550f41ebb50ffb4ee3b39399_Out_0_Float = _Fresnel;
            float _Multiply_3e84c19f71084e0fa7f8deb3e19a71a5_Out_2_Float;
            Unity_Multiply_float_float(_FresnelEffect_5989a23e047d4b88b7dd8856ad805eef_Out_3_Float, _Property_ca1ba1c8550f41ebb50ffb4ee3b39399_Out_0_Float, _Multiply_3e84c19f71084e0fa7f8deb3e19a71a5_Out_2_Float);
            UnityTextureCube _Property_373c5e134b6e4018af52a7f784303650_Out_0_Cubemap = UnityBuildTextureCubeStruct(_Cubemap);
            float4 _SampleCubemap_98f5c7b9ec01448aa2f03f105732c1f8_Out_0_Vector4 = SAMPLE_TEXTURECUBE_LOD(_Property_373c5e134b6e4018af52a7f784303650_Out_0_Cubemap.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, IN.WorldSpaceViewDirection, 0);
            UnityTexture2D _Property_ec58c8b27ed64551b81e1f8539d175df_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Mask);
            float4 _SampleTexture2D_f22ff145dce64761a34d169e64c6fca3_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_ec58c8b27ed64551b81e1f8539d175df_Out_0_Texture2D.tex, _Property_ec58c8b27ed64551b81e1f8539d175df_Out_0_Texture2D.samplerstate, _Property_ec58c8b27ed64551b81e1f8539d175df_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_f22ff145dce64761a34d169e64c6fca3_R_4_Float = _SampleTexture2D_f22ff145dce64761a34d169e64c6fca3_RGBA_0_Vector4.r;
            float _SampleTexture2D_f22ff145dce64761a34d169e64c6fca3_G_5_Float = _SampleTexture2D_f22ff145dce64761a34d169e64c6fca3_RGBA_0_Vector4.g;
            float _SampleTexture2D_f22ff145dce64761a34d169e64c6fca3_B_6_Float = _SampleTexture2D_f22ff145dce64761a34d169e64c6fca3_RGBA_0_Vector4.b;
            float _SampleTexture2D_f22ff145dce64761a34d169e64c6fca3_A_7_Float = _SampleTexture2D_f22ff145dce64761a34d169e64c6fca3_RGBA_0_Vector4.a;
            float _Float_3db560db412d41f59c869999afc8ce70_Out_0_Float = 0;
            float _Subtract_a418342d766c4098a8501665125fbe40_Out_2_Float;
            Unity_Subtract_float(_SampleTexture2D_f22ff145dce64761a34d169e64c6fca3_R_4_Float, _Float_3db560db412d41f59c869999afc8ce70_Out_0_Float, _Subtract_a418342d766c4098a8501665125fbe40_Out_2_Float);
            float _Clamp_f07138c57dfe4b8a8b87a935155fd790_Out_3_Float;
            Unity_Clamp_float(_Subtract_a418342d766c4098a8501665125fbe40_Out_2_Float, 0, 1, _Clamp_f07138c57dfe4b8a8b87a935155fd790_Out_3_Float);
            float4 _Multiply_54f2142f1a2a446c80d5257dd05810cb_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleCubemap_98f5c7b9ec01448aa2f03f105732c1f8_Out_0_Vector4, (_Clamp_f07138c57dfe4b8a8b87a935155fd790_Out_3_Float.xxxx), _Multiply_54f2142f1a2a446c80d5257dd05810cb_Out_2_Vector4);
            float4 _Multiply_7322d935dd03414dba0d824b45dda546_Out_2_Vector4;
            Unity_Multiply_float4_float4((_Multiply_3e84c19f71084e0fa7f8deb3e19a71a5_Out_2_Float.xxxx), _Multiply_54f2142f1a2a446c80d5257dd05810cb_Out_2_Vector4, _Multiply_7322d935dd03414dba0d824b45dda546_Out_2_Vector4);
            UnityTexture2D _Property_72ef1a68bc3845839170a2cb14890eb7_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Metallic);
            float4 _SampleTexture2D_fb4864449111453987026bf621eda8b1_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_72ef1a68bc3845839170a2cb14890eb7_Out_0_Texture2D.tex, _Property_72ef1a68bc3845839170a2cb14890eb7_Out_0_Texture2D.samplerstate, _Property_72ef1a68bc3845839170a2cb14890eb7_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_fb4864449111453987026bf621eda8b1_R_4_Float = _SampleTexture2D_fb4864449111453987026bf621eda8b1_RGBA_0_Vector4.r;
            float _SampleTexture2D_fb4864449111453987026bf621eda8b1_G_5_Float = _SampleTexture2D_fb4864449111453987026bf621eda8b1_RGBA_0_Vector4.g;
            float _SampleTexture2D_fb4864449111453987026bf621eda8b1_B_6_Float = _SampleTexture2D_fb4864449111453987026bf621eda8b1_RGBA_0_Vector4.b;
            float _SampleTexture2D_fb4864449111453987026bf621eda8b1_A_7_Float = _SampleTexture2D_fb4864449111453987026bf621eda8b1_RGBA_0_Vector4.a;
            UnityTexture2D _Property_dd464c3c1cf54c6db9bb0c7d72f9903e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Specular);
            float4 _SampleTexture2D_269f375e9bf14e33aaf6fea5ec88738b_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_dd464c3c1cf54c6db9bb0c7d72f9903e_Out_0_Texture2D.tex, _Property_dd464c3c1cf54c6db9bb0c7d72f9903e_Out_0_Texture2D.samplerstate, _Property_dd464c3c1cf54c6db9bb0c7d72f9903e_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_269f375e9bf14e33aaf6fea5ec88738b_R_4_Float = _SampleTexture2D_269f375e9bf14e33aaf6fea5ec88738b_RGBA_0_Vector4.r;
            float _SampleTexture2D_269f375e9bf14e33aaf6fea5ec88738b_G_5_Float = _SampleTexture2D_269f375e9bf14e33aaf6fea5ec88738b_RGBA_0_Vector4.g;
            float _SampleTexture2D_269f375e9bf14e33aaf6fea5ec88738b_B_6_Float = _SampleTexture2D_269f375e9bf14e33aaf6fea5ec88738b_RGBA_0_Vector4.b;
            float _SampleTexture2D_269f375e9bf14e33aaf6fea5ec88738b_A_7_Float = _SampleTexture2D_269f375e9bf14e33aaf6fea5ec88738b_RGBA_0_Vector4.a;
            UnityTexture2D _Property_37db059d88dd4b70bc86c0706a19a53c_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Mask);
            float4 _SampleTexture2D_56b17b9176a04c05ab48e52126a2502c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_37db059d88dd4b70bc86c0706a19a53c_Out_0_Texture2D.tex, _Property_37db059d88dd4b70bc86c0706a19a53c_Out_0_Texture2D.samplerstate, _Property_37db059d88dd4b70bc86c0706a19a53c_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_56b17b9176a04c05ab48e52126a2502c_R_4_Float = _SampleTexture2D_56b17b9176a04c05ab48e52126a2502c_RGBA_0_Vector4.r;
            float _SampleTexture2D_56b17b9176a04c05ab48e52126a2502c_G_5_Float = _SampleTexture2D_56b17b9176a04c05ab48e52126a2502c_RGBA_0_Vector4.g;
            float _SampleTexture2D_56b17b9176a04c05ab48e52126a2502c_B_6_Float = _SampleTexture2D_56b17b9176a04c05ab48e52126a2502c_RGBA_0_Vector4.b;
            float _SampleTexture2D_56b17b9176a04c05ab48e52126a2502c_A_7_Float = _SampleTexture2D_56b17b9176a04c05ab48e52126a2502c_RGBA_0_Vector4.a;
            float _ChannelMask_4d7ee1a97ad14c949ba2d2a8acc03174_Out_1_Float;
            Unity_ChannelMask_RedGreenBlueAlpha_float (_SampleTexture2D_56b17b9176a04c05ab48e52126a2502c_R_4_Float, _ChannelMask_4d7ee1a97ad14c949ba2d2a8acc03174_Out_1_Float);
            float4 _Lerp_ffddf489f87641f0a989475b5d5c69a3_Out_3_Vector4;
            Unity_Lerp_float4(_SampleTexture2D_fb4864449111453987026bf621eda8b1_RGBA_0_Vector4, _SampleTexture2D_269f375e9bf14e33aaf6fea5ec88738b_RGBA_0_Vector4, (_ChannelMask_4d7ee1a97ad14c949ba2d2a8acc03174_Out_1_Float.xxxx), _Lerp_ffddf489f87641f0a989475b5d5c69a3_Out_3_Vector4);
            UnityTexture2D _Property_e89c3b70222e42b18107727deca1926c_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base);
            float4 _SampleTexture2D_17c079a6c4984d9c85e44fa759dc15ce_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_e89c3b70222e42b18107727deca1926c_Out_0_Texture2D.tex, _Property_e89c3b70222e42b18107727deca1926c_Out_0_Texture2D.samplerstate, _Property_e89c3b70222e42b18107727deca1926c_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_17c079a6c4984d9c85e44fa759dc15ce_R_4_Float = _SampleTexture2D_17c079a6c4984d9c85e44fa759dc15ce_RGBA_0_Vector4.r;
            float _SampleTexture2D_17c079a6c4984d9c85e44fa759dc15ce_G_5_Float = _SampleTexture2D_17c079a6c4984d9c85e44fa759dc15ce_RGBA_0_Vector4.g;
            float _SampleTexture2D_17c079a6c4984d9c85e44fa759dc15ce_B_6_Float = _SampleTexture2D_17c079a6c4984d9c85e44fa759dc15ce_RGBA_0_Vector4.b;
            float _SampleTexture2D_17c079a6c4984d9c85e44fa759dc15ce_A_7_Float = _SampleTexture2D_17c079a6c4984d9c85e44fa759dc15ce_RGBA_0_Vector4.a;
            float _Property_34681fb069ad48508734e6d476a8fc9e_Out_0_Float = _Smoothness;
            UnityTexture2D _Property_56128e922feb4567ad8580b5a265ac39_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Mask);
            float4 _SampleTexture2D_8230b955e7504292aac52356957dc41f_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_56128e922feb4567ad8580b5a265ac39_Out_0_Texture2D.tex, _Property_56128e922feb4567ad8580b5a265ac39_Out_0_Texture2D.samplerstate, _Property_56128e922feb4567ad8580b5a265ac39_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_8230b955e7504292aac52356957dc41f_R_4_Float = _SampleTexture2D_8230b955e7504292aac52356957dc41f_RGBA_0_Vector4.r;
            float _SampleTexture2D_8230b955e7504292aac52356957dc41f_G_5_Float = _SampleTexture2D_8230b955e7504292aac52356957dc41f_RGBA_0_Vector4.g;
            float _SampleTexture2D_8230b955e7504292aac52356957dc41f_B_6_Float = _SampleTexture2D_8230b955e7504292aac52356957dc41f_RGBA_0_Vector4.b;
            float _SampleTexture2D_8230b955e7504292aac52356957dc41f_A_7_Float = _SampleTexture2D_8230b955e7504292aac52356957dc41f_RGBA_0_Vector4.a;
            float _ChannelMask_89a1d7e505674b6a8c0f3fb5fa3e315e_Out_1_Float;
            Unity_ChannelMask_RedGreenBlueAlpha_float (_SampleTexture2D_8230b955e7504292aac52356957dc41f_R_4_Float, _ChannelMask_89a1d7e505674b6a8c0f3fb5fa3e315e_Out_1_Float);
            float4 _Lerp_255342fa31564996a99da4fa83bfce55_Out_3_Vector4;
            Unity_Lerp_float4(_SampleTexture2D_17c079a6c4984d9c85e44fa759dc15ce_RGBA_0_Vector4, (_Property_34681fb069ad48508734e6d476a8fc9e_Out_0_Float.xxxx), (_ChannelMask_89a1d7e505674b6a8c0f3fb5fa3e315e_Out_1_Float.xxxx), _Lerp_255342fa31564996a99da4fa83bfce55_Out_3_Vector4);
            surface.BaseColor = (_Lerp_68cd9d96e1a24a49a02355bd48e2f613_Out_3_Vector4.xyz);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Emission = (_Multiply_7322d935dd03414dba0d824b45dda546_Out_2_Vector4.xyz);
            surface.Metallic = (_Lerp_ffddf489f87641f0a989475b5d5c69a3_Out_3_Vector4).x;
            surface.Smoothness = (_Lerp_255342fa31564996a99da4fa83bfce55_Out_3_Vector4).x;
            surface.Occlusion = 1;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define VARYINGS_NEED_NORMAL_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Base_TexelSize;
        float4 _Mask_TexelSize;
        float _Fresnel;
        float4 _Color;
        float4 _Metallic_TexelSize;
        float4 _Specular_TexelSize;
        float4 _Dirt_TexelSize;
        float _Smoothness;
        float _LOD;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Base);
        SAMPLER(sampler_Base);
        TEXTURE2D(_Mask);
        SAMPLER(sampler_Mask);
        TEXTURE2D(_Metallic);
        SAMPLER(sampler_Metallic);
        TEXTURECUBE(_Cubemap);
        SAMPLER(sampler_Cubemap);
        TEXTURE2D(_Specular);
        SAMPLER(sampler_Specular);
        TEXTURE2D(_Dirt);
        SAMPLER(sampler_Dirt);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        // GraphFunctions: <None>
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthOnly"
            Tags
            {
                "LightMode" = "DepthOnly"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        ColorMask R
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Base_TexelSize;
        float4 _Mask_TexelSize;
        float _Fresnel;
        float4 _Color;
        float4 _Metallic_TexelSize;
        float4 _Specular_TexelSize;
        float4 _Dirt_TexelSize;
        float _Smoothness;
        float _LOD;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Base);
        SAMPLER(sampler_Base);
        TEXTURE2D(_Mask);
        SAMPLER(sampler_Mask);
        TEXTURE2D(_Metallic);
        SAMPLER(sampler_Metallic);
        TEXTURECUBE(_Cubemap);
        SAMPLER(sampler_Cubemap);
        TEXTURE2D(_Specular);
        SAMPLER(sampler_Specular);
        TEXTURE2D(_Dirt);
        SAMPLER(sampler_Dirt);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        // GraphFunctions: <None>
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormals"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALS
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 tangentWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 tangentWS : INTERP0;
             float3 normalWS : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.tangentWS = input.tangentWS.xyzw;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Base_TexelSize;
        float4 _Mask_TexelSize;
        float _Fresnel;
        float4 _Color;
        float4 _Metallic_TexelSize;
        float4 _Specular_TexelSize;
        float4 _Dirt_TexelSize;
        float _Smoothness;
        float _LOD;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Base);
        SAMPLER(sampler_Base);
        TEXTURE2D(_Mask);
        SAMPLER(sampler_Mask);
        TEXTURE2D(_Metallic);
        SAMPLER(sampler_Metallic);
        TEXTURECUBE(_Cubemap);
        SAMPLER(sampler_Cubemap);
        TEXTURE2D(_Specular);
        SAMPLER(sampler_Specular);
        TEXTURE2D(_Dirt);
        SAMPLER(sampler_Dirt);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        // GraphFunctions: <None>
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 NormalTS;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            surface.NormalTS = IN.TangentSpaceNormal;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Meta"
            Tags
            {
                "LightMode" = "Meta"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature _ EDITOR_VISUALIZATION
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD1
        #define VARYINGS_NEED_TEXCOORD2
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_META
        #define _FOG_FRAGMENT 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 texCoord0;
             float4 texCoord1;
             float4 texCoord2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 WorldSpaceViewDirection;
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 texCoord1 : INTERP1;
             float4 texCoord2 : INTERP2;
             float3 positionWS : INTERP3;
             float3 normalWS : INTERP4;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord1.xyzw = input.texCoord1;
            output.texCoord2.xyzw = input.texCoord2;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord1 = input.texCoord1.xyzw;
            output.texCoord2 = input.texCoord2.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Base_TexelSize;
        float4 _Mask_TexelSize;
        float _Fresnel;
        float4 _Color;
        float4 _Metallic_TexelSize;
        float4 _Specular_TexelSize;
        float4 _Dirt_TexelSize;
        float _Smoothness;
        float _LOD;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Base);
        SAMPLER(sampler_Base);
        TEXTURE2D(_Mask);
        SAMPLER(sampler_Mask);
        TEXTURE2D(_Metallic);
        SAMPLER(sampler_Metallic);
        TEXTURECUBE(_Cubemap);
        SAMPLER(sampler_Cubemap);
        TEXTURE2D(_Specular);
        SAMPLER(sampler_Specular);
        TEXTURE2D(_Dirt);
        SAMPLER(sampler_Dirt);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_ChannelMask_RedGreenBlueAlpha_float (float In, out float Out)
        {
            Out = In;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
        {
            Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 Emission;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_28c3cd6e7bdd49caaa67cc2e6af0c22d_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base);
            float4 _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_28c3cd6e7bdd49caaa67cc2e6af0c22d_Out_0_Texture2D.tex, _Property_28c3cd6e7bdd49caaa67cc2e6af0c22d_Out_0_Texture2D.samplerstate, _Property_28c3cd6e7bdd49caaa67cc2e6af0c22d_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_R_4_Float = _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_RGBA_0_Vector4.r;
            float _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_G_5_Float = _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_RGBA_0_Vector4.g;
            float _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_B_6_Float = _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_RGBA_0_Vector4.b;
            float _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_A_7_Float = _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_RGBA_0_Vector4.a;
            float4 _Property_1a4a66ddb7314a7db44891e2e4154e53_Out_0_Vector4 = _Color;
            UnityTexture2D _Property_d29e9efea0ff4249908d92d1051dd915_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Mask);
            float4 _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d29e9efea0ff4249908d92d1051dd915_Out_0_Texture2D.tex, _Property_d29e9efea0ff4249908d92d1051dd915_Out_0_Texture2D.samplerstate, _Property_d29e9efea0ff4249908d92d1051dd915_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_R_4_Float = _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_RGBA_0_Vector4.r;
            float _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_G_5_Float = _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_RGBA_0_Vector4.g;
            float _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_B_6_Float = _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_RGBA_0_Vector4.b;
            float _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_A_7_Float = _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_RGBA_0_Vector4.a;
            float _ChannelMask_93b1dc178259488d92396896b0888715_Out_1_Float;
            Unity_ChannelMask_RedGreenBlueAlpha_float (_SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_R_4_Float, _ChannelMask_93b1dc178259488d92396896b0888715_Out_1_Float);
            float4 _Lerp_df5aa3bbccea487db44607d2fa6aea17_Out_3_Vector4;
            Unity_Lerp_float4(_SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_RGBA_0_Vector4, _Property_1a4a66ddb7314a7db44891e2e4154e53_Out_0_Vector4, (_ChannelMask_93b1dc178259488d92396896b0888715_Out_1_Float.xxxx), _Lerp_df5aa3bbccea487db44607d2fa6aea17_Out_3_Vector4);
            UnityTexture2D _Property_f9296df1b28549b0b747f18d0984f541_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Dirt);
            float4 _SampleTexture2D_75da8cdac346499f953172c2706ddd05_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_f9296df1b28549b0b747f18d0984f541_Out_0_Texture2D.tex, _Property_f9296df1b28549b0b747f18d0984f541_Out_0_Texture2D.samplerstate, _Property_f9296df1b28549b0b747f18d0984f541_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_75da8cdac346499f953172c2706ddd05_R_4_Float = _SampleTexture2D_75da8cdac346499f953172c2706ddd05_RGBA_0_Vector4.r;
            float _SampleTexture2D_75da8cdac346499f953172c2706ddd05_G_5_Float = _SampleTexture2D_75da8cdac346499f953172c2706ddd05_RGBA_0_Vector4.g;
            float _SampleTexture2D_75da8cdac346499f953172c2706ddd05_B_6_Float = _SampleTexture2D_75da8cdac346499f953172c2706ddd05_RGBA_0_Vector4.b;
            float _SampleTexture2D_75da8cdac346499f953172c2706ddd05_A_7_Float = _SampleTexture2D_75da8cdac346499f953172c2706ddd05_RGBA_0_Vector4.a;
            float _Property_6f362c2b5d8b42f8b51d7cd8c9e0c5e4_Out_0_Float = _LOD;
            float _Multiply_95b7844b07b54bee8ce34f223873e058_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_75da8cdac346499f953172c2706ddd05_A_7_Float, _Property_6f362c2b5d8b42f8b51d7cd8c9e0c5e4_Out_0_Float, _Multiply_95b7844b07b54bee8ce34f223873e058_Out_2_Float);
            float4 _Lerp_68cd9d96e1a24a49a02355bd48e2f613_Out_3_Vector4;
            Unity_Lerp_float4(_Lerp_df5aa3bbccea487db44607d2fa6aea17_Out_3_Vector4, _SampleTexture2D_75da8cdac346499f953172c2706ddd05_RGBA_0_Vector4, (_Multiply_95b7844b07b54bee8ce34f223873e058_Out_2_Float.xxxx), _Lerp_68cd9d96e1a24a49a02355bd48e2f613_Out_3_Vector4);
            float _FresnelEffect_5989a23e047d4b88b7dd8856ad805eef_Out_3_Float;
            Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, 1, _FresnelEffect_5989a23e047d4b88b7dd8856ad805eef_Out_3_Float);
            float _Property_ca1ba1c8550f41ebb50ffb4ee3b39399_Out_0_Float = _Fresnel;
            float _Multiply_3e84c19f71084e0fa7f8deb3e19a71a5_Out_2_Float;
            Unity_Multiply_float_float(_FresnelEffect_5989a23e047d4b88b7dd8856ad805eef_Out_3_Float, _Property_ca1ba1c8550f41ebb50ffb4ee3b39399_Out_0_Float, _Multiply_3e84c19f71084e0fa7f8deb3e19a71a5_Out_2_Float);
            UnityTextureCube _Property_373c5e134b6e4018af52a7f784303650_Out_0_Cubemap = UnityBuildTextureCubeStruct(_Cubemap);
            float4 _SampleCubemap_98f5c7b9ec01448aa2f03f105732c1f8_Out_0_Vector4 = SAMPLE_TEXTURECUBE_LOD(_Property_373c5e134b6e4018af52a7f784303650_Out_0_Cubemap.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, IN.WorldSpaceViewDirection, 0);
            UnityTexture2D _Property_ec58c8b27ed64551b81e1f8539d175df_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Mask);
            float4 _SampleTexture2D_f22ff145dce64761a34d169e64c6fca3_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_ec58c8b27ed64551b81e1f8539d175df_Out_0_Texture2D.tex, _Property_ec58c8b27ed64551b81e1f8539d175df_Out_0_Texture2D.samplerstate, _Property_ec58c8b27ed64551b81e1f8539d175df_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_f22ff145dce64761a34d169e64c6fca3_R_4_Float = _SampleTexture2D_f22ff145dce64761a34d169e64c6fca3_RGBA_0_Vector4.r;
            float _SampleTexture2D_f22ff145dce64761a34d169e64c6fca3_G_5_Float = _SampleTexture2D_f22ff145dce64761a34d169e64c6fca3_RGBA_0_Vector4.g;
            float _SampleTexture2D_f22ff145dce64761a34d169e64c6fca3_B_6_Float = _SampleTexture2D_f22ff145dce64761a34d169e64c6fca3_RGBA_0_Vector4.b;
            float _SampleTexture2D_f22ff145dce64761a34d169e64c6fca3_A_7_Float = _SampleTexture2D_f22ff145dce64761a34d169e64c6fca3_RGBA_0_Vector4.a;
            float _Float_3db560db412d41f59c869999afc8ce70_Out_0_Float = 0;
            float _Subtract_a418342d766c4098a8501665125fbe40_Out_2_Float;
            Unity_Subtract_float(_SampleTexture2D_f22ff145dce64761a34d169e64c6fca3_R_4_Float, _Float_3db560db412d41f59c869999afc8ce70_Out_0_Float, _Subtract_a418342d766c4098a8501665125fbe40_Out_2_Float);
            float _Clamp_f07138c57dfe4b8a8b87a935155fd790_Out_3_Float;
            Unity_Clamp_float(_Subtract_a418342d766c4098a8501665125fbe40_Out_2_Float, 0, 1, _Clamp_f07138c57dfe4b8a8b87a935155fd790_Out_3_Float);
            float4 _Multiply_54f2142f1a2a446c80d5257dd05810cb_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleCubemap_98f5c7b9ec01448aa2f03f105732c1f8_Out_0_Vector4, (_Clamp_f07138c57dfe4b8a8b87a935155fd790_Out_3_Float.xxxx), _Multiply_54f2142f1a2a446c80d5257dd05810cb_Out_2_Vector4);
            float4 _Multiply_7322d935dd03414dba0d824b45dda546_Out_2_Vector4;
            Unity_Multiply_float4_float4((_Multiply_3e84c19f71084e0fa7f8deb3e19a71a5_Out_2_Float.xxxx), _Multiply_54f2142f1a2a446c80d5257dd05810cb_Out_2_Vector4, _Multiply_7322d935dd03414dba0d824b45dda546_Out_2_Vector4);
            surface.BaseColor = (_Lerp_68cd9d96e1a24a49a02355bd48e2f613_Out_3_Vector4.xyz);
            surface.Emission = (_Multiply_7322d935dd03414dba0d824b45dda546_Out_2_Vector4.xyz);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Base_TexelSize;
        float4 _Mask_TexelSize;
        float _Fresnel;
        float4 _Color;
        float4 _Metallic_TexelSize;
        float4 _Specular_TexelSize;
        float4 _Dirt_TexelSize;
        float _Smoothness;
        float _LOD;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Base);
        SAMPLER(sampler_Base);
        TEXTURE2D(_Mask);
        SAMPLER(sampler_Mask);
        TEXTURE2D(_Metallic);
        SAMPLER(sampler_Metallic);
        TEXTURECUBE(_Cubemap);
        SAMPLER(sampler_Cubemap);
        TEXTURE2D(_Specular);
        SAMPLER(sampler_Specular);
        TEXTURE2D(_Dirt);
        SAMPLER(sampler_Dirt);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        // GraphFunctions: <None>
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull Back
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Base_TexelSize;
        float4 _Mask_TexelSize;
        float _Fresnel;
        float4 _Color;
        float4 _Metallic_TexelSize;
        float4 _Specular_TexelSize;
        float4 _Dirt_TexelSize;
        float _Smoothness;
        float _LOD;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Base);
        SAMPLER(sampler_Base);
        TEXTURE2D(_Mask);
        SAMPLER(sampler_Mask);
        TEXTURE2D(_Metallic);
        SAMPLER(sampler_Metallic);
        TEXTURECUBE(_Cubemap);
        SAMPLER(sampler_Cubemap);
        TEXTURE2D(_Specular);
        SAMPLER(sampler_Specular);
        TEXTURE2D(_Dirt);
        SAMPLER(sampler_Dirt);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        // GraphFunctions: <None>
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            // Name: <None>
            Tags
            {
                "LightMode" = "Universal2D"
            }
        
        // Render State
        Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_2D
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Base_TexelSize;
        float4 _Mask_TexelSize;
        float _Fresnel;
        float4 _Color;
        float4 _Metallic_TexelSize;
        float4 _Specular_TexelSize;
        float4 _Dirt_TexelSize;
        float _Smoothness;
        float _LOD;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Base);
        SAMPLER(sampler_Base);
        TEXTURE2D(_Mask);
        SAMPLER(sampler_Mask);
        TEXTURE2D(_Metallic);
        SAMPLER(sampler_Metallic);
        TEXTURECUBE(_Cubemap);
        SAMPLER(sampler_Cubemap);
        TEXTURE2D(_Specular);
        SAMPLER(sampler_Specular);
        TEXTURE2D(_Dirt);
        SAMPLER(sampler_Dirt);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_ChannelMask_RedGreenBlueAlpha_float (float In, out float Out)
        {
            Out = In;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_28c3cd6e7bdd49caaa67cc2e6af0c22d_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base);
            float4 _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_28c3cd6e7bdd49caaa67cc2e6af0c22d_Out_0_Texture2D.tex, _Property_28c3cd6e7bdd49caaa67cc2e6af0c22d_Out_0_Texture2D.samplerstate, _Property_28c3cd6e7bdd49caaa67cc2e6af0c22d_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_R_4_Float = _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_RGBA_0_Vector4.r;
            float _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_G_5_Float = _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_RGBA_0_Vector4.g;
            float _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_B_6_Float = _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_RGBA_0_Vector4.b;
            float _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_A_7_Float = _SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_RGBA_0_Vector4.a;
            float4 _Property_1a4a66ddb7314a7db44891e2e4154e53_Out_0_Vector4 = _Color;
            UnityTexture2D _Property_d29e9efea0ff4249908d92d1051dd915_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Mask);
            float4 _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d29e9efea0ff4249908d92d1051dd915_Out_0_Texture2D.tex, _Property_d29e9efea0ff4249908d92d1051dd915_Out_0_Texture2D.samplerstate, _Property_d29e9efea0ff4249908d92d1051dd915_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_R_4_Float = _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_RGBA_0_Vector4.r;
            float _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_G_5_Float = _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_RGBA_0_Vector4.g;
            float _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_B_6_Float = _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_RGBA_0_Vector4.b;
            float _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_A_7_Float = _SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_RGBA_0_Vector4.a;
            float _ChannelMask_93b1dc178259488d92396896b0888715_Out_1_Float;
            Unity_ChannelMask_RedGreenBlueAlpha_float (_SampleTexture2D_01bd9c53c5774cee829b5a6bfb65cd39_R_4_Float, _ChannelMask_93b1dc178259488d92396896b0888715_Out_1_Float);
            float4 _Lerp_df5aa3bbccea487db44607d2fa6aea17_Out_3_Vector4;
            Unity_Lerp_float4(_SampleTexture2D_518da29224264cb68fd7bf8bd1e36a05_RGBA_0_Vector4, _Property_1a4a66ddb7314a7db44891e2e4154e53_Out_0_Vector4, (_ChannelMask_93b1dc178259488d92396896b0888715_Out_1_Float.xxxx), _Lerp_df5aa3bbccea487db44607d2fa6aea17_Out_3_Vector4);
            UnityTexture2D _Property_f9296df1b28549b0b747f18d0984f541_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Dirt);
            float4 _SampleTexture2D_75da8cdac346499f953172c2706ddd05_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_f9296df1b28549b0b747f18d0984f541_Out_0_Texture2D.tex, _Property_f9296df1b28549b0b747f18d0984f541_Out_0_Texture2D.samplerstate, _Property_f9296df1b28549b0b747f18d0984f541_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_75da8cdac346499f953172c2706ddd05_R_4_Float = _SampleTexture2D_75da8cdac346499f953172c2706ddd05_RGBA_0_Vector4.r;
            float _SampleTexture2D_75da8cdac346499f953172c2706ddd05_G_5_Float = _SampleTexture2D_75da8cdac346499f953172c2706ddd05_RGBA_0_Vector4.g;
            float _SampleTexture2D_75da8cdac346499f953172c2706ddd05_B_6_Float = _SampleTexture2D_75da8cdac346499f953172c2706ddd05_RGBA_0_Vector4.b;
            float _SampleTexture2D_75da8cdac346499f953172c2706ddd05_A_7_Float = _SampleTexture2D_75da8cdac346499f953172c2706ddd05_RGBA_0_Vector4.a;
            float _Property_6f362c2b5d8b42f8b51d7cd8c9e0c5e4_Out_0_Float = _LOD;
            float _Multiply_95b7844b07b54bee8ce34f223873e058_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_75da8cdac346499f953172c2706ddd05_A_7_Float, _Property_6f362c2b5d8b42f8b51d7cd8c9e0c5e4_Out_0_Float, _Multiply_95b7844b07b54bee8ce34f223873e058_Out_2_Float);
            float4 _Lerp_68cd9d96e1a24a49a02355bd48e2f613_Out_3_Vector4;
            Unity_Lerp_float4(_Lerp_df5aa3bbccea487db44607d2fa6aea17_Out_3_Vector4, _SampleTexture2D_75da8cdac346499f953172c2706ddd05_RGBA_0_Vector4, (_Multiply_95b7844b07b54bee8ce34f223873e058_Out_2_Float.xxxx), _Lerp_68cd9d96e1a24a49a02355bd48e2f613_Out_3_Vector4);
            surface.BaseColor = (_Lerp_68cd9d96e1a24a49a02355bd48e2f613_Out_3_Vector4.xyz);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    CustomEditorForRenderPipeline "UnityEditor.ShaderGraphLitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
    FallBack "Hidden/Shader Graph/FallbackError"
}