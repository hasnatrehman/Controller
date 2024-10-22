Shader "Shader Graphs/Ahtsham_Lit_LB BL"
{
    Properties
    {
        [NoScaleOffset]_Base("Base", 2D) = "white" {}
        [NoScaleOffset]_Metallic("Metallic", 2D) = "white" {}
        [NoScaleOffset]_Break_Emi("Break (Emi)", 2D) = "white" {}
        [ToggleUI]_BR("BR", Float) = 0
        [NoScaleOffset]_BeamHigh_Emi("BeamHigh (Emi)", 2D) = "white" {}
        [ToggleUI]_BH("BH", Float) = 0
        [NoScaleOffset]_BeamLow_Emi("BeamLow (Emi)", 2D) = "white" {}
        [ToggleUI]_BL("BL", Float) = 0
        [NoScaleOffset]_IndicatorLeft_Emi("IndicatorLeft (Emi)", 2D) = "white" {}
        [ToggleUI]_IL("IL", Float) = 0
        [NoScaleOffset]_IndicatorRight_Emi("IndicatorRight (Emi)", 2D) = "white" {}
        [ToggleUI]_IR("IR", Float) = 0
        [NoScaleOffset]_Reverse_Emi("Reverse (Emi)", 2D) = "white" {}
        [ToggleUI]_REV("REV", Float) = 0
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
             float3 TangentSpaceNormal;
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
        float4 _Metallic_TexelSize;
        float _BH;
        float4 _Break_Emi_TexelSize;
        float4 _BeamLow_Emi_TexelSize;
        float _BL;
        float4 _IndicatorLeft_Emi_TexelSize;
        float _IR;
        float _IL;
        float4 _IndicatorRight_Emi_TexelSize;
        float _REV;
        float4 _Reverse_Emi_TexelSize;
        float4 _BeamHigh_Emi_TexelSize;
        float _BR;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Base);
        SAMPLER(sampler_Base);
        TEXTURE2D(_Metallic);
        SAMPLER(sampler_Metallic);
        TEXTURE2D(_Break_Emi);
        SAMPLER(sampler_Break_Emi);
        TEXTURE2D(_BeamLow_Emi);
        SAMPLER(sampler_BeamLow_Emi);
        TEXTURE2D(_IndicatorLeft_Emi);
        SAMPLER(sampler_IndicatorLeft_Emi);
        TEXTURE2D(_IndicatorRight_Emi);
        SAMPLER(sampler_IndicatorRight_Emi);
        TEXTURE2D(_Reverse_Emi);
        SAMPLER(sampler_Reverse_Emi);
        TEXTURE2D(_BeamHigh_Emi);
        SAMPLER(sampler_BeamHigh_Emi);
        
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
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
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
            UnityTexture2D _Property_2798ac98d19c42c5899b3175f80c6a56_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base);
            float4 _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_2798ac98d19c42c5899b3175f80c6a56_Out_0_Texture2D.tex, _Property_2798ac98d19c42c5899b3175f80c6a56_Out_0_Texture2D.samplerstate, _Property_2798ac98d19c42c5899b3175f80c6a56_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_R_4_Float = _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_RGBA_0_Vector4.r;
            float _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_G_5_Float = _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_RGBA_0_Vector4.g;
            float _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_B_6_Float = _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_RGBA_0_Vector4.b;
            float _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_A_7_Float = _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_RGBA_0_Vector4.a;
            UnityTexture2D _Property_9e18aed5617c40d38e5d61a182a32af3_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Break_Emi);
            float4 _SampleTexture2D_d352588b583e46fea8d62dd0ea936e78_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_9e18aed5617c40d38e5d61a182a32af3_Out_0_Texture2D.tex, _Property_9e18aed5617c40d38e5d61a182a32af3_Out_0_Texture2D.samplerstate, _Property_9e18aed5617c40d38e5d61a182a32af3_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_d352588b583e46fea8d62dd0ea936e78_R_4_Float = _SampleTexture2D_d352588b583e46fea8d62dd0ea936e78_RGBA_0_Vector4.r;
            float _SampleTexture2D_d352588b583e46fea8d62dd0ea936e78_G_5_Float = _SampleTexture2D_d352588b583e46fea8d62dd0ea936e78_RGBA_0_Vector4.g;
            float _SampleTexture2D_d352588b583e46fea8d62dd0ea936e78_B_6_Float = _SampleTexture2D_d352588b583e46fea8d62dd0ea936e78_RGBA_0_Vector4.b;
            float _SampleTexture2D_d352588b583e46fea8d62dd0ea936e78_A_7_Float = _SampleTexture2D_d352588b583e46fea8d62dd0ea936e78_RGBA_0_Vector4.a;
            float _Property_5d49a99a6f5841a1bc724ef2185ee269_Out_0_Boolean = _BR;
            float4 _Multiply_d549fb0c6e5d410cbad5908e8d8a1262_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_d352588b583e46fea8d62dd0ea936e78_RGBA_0_Vector4, (((float) _Property_5d49a99a6f5841a1bc724ef2185ee269_Out_0_Boolean).xxxx), _Multiply_d549fb0c6e5d410cbad5908e8d8a1262_Out_2_Vector4);
            UnityTexture2D _Property_14efad17c2904d73a0e5fafc6082561c_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BeamHigh_Emi);
            float4 _SampleTexture2D_8e402452ef594350a7d467f89300b17d_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_14efad17c2904d73a0e5fafc6082561c_Out_0_Texture2D.tex, _Property_14efad17c2904d73a0e5fafc6082561c_Out_0_Texture2D.samplerstate, _Property_14efad17c2904d73a0e5fafc6082561c_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_8e402452ef594350a7d467f89300b17d_R_4_Float = _SampleTexture2D_8e402452ef594350a7d467f89300b17d_RGBA_0_Vector4.r;
            float _SampleTexture2D_8e402452ef594350a7d467f89300b17d_G_5_Float = _SampleTexture2D_8e402452ef594350a7d467f89300b17d_RGBA_0_Vector4.g;
            float _SampleTexture2D_8e402452ef594350a7d467f89300b17d_B_6_Float = _SampleTexture2D_8e402452ef594350a7d467f89300b17d_RGBA_0_Vector4.b;
            float _SampleTexture2D_8e402452ef594350a7d467f89300b17d_A_7_Float = _SampleTexture2D_8e402452ef594350a7d467f89300b17d_RGBA_0_Vector4.a;
            float _Property_ba21194f9f0c448e9b5e236885880883_Out_0_Boolean = _BH;
            float4 _Multiply_48c6868bbd044c388a64fbd622f3e697_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_8e402452ef594350a7d467f89300b17d_RGBA_0_Vector4, (((float) _Property_ba21194f9f0c448e9b5e236885880883_Out_0_Boolean).xxxx), _Multiply_48c6868bbd044c388a64fbd622f3e697_Out_2_Vector4);
            float4 _Add_34c8346a6659446ebaf860a6cba3b7db_Out_2_Vector4;
            Unity_Add_float4(_Multiply_d549fb0c6e5d410cbad5908e8d8a1262_Out_2_Vector4, _Multiply_48c6868bbd044c388a64fbd622f3e697_Out_2_Vector4, _Add_34c8346a6659446ebaf860a6cba3b7db_Out_2_Vector4);
            UnityTexture2D _Property_e3c6f1d0922448b49b1aad8cb71b48c7_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BeamLow_Emi);
            float4 _SampleTexture2D_788e52d72b3f4f67bf3d22ea6bed1deb_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_e3c6f1d0922448b49b1aad8cb71b48c7_Out_0_Texture2D.tex, _Property_e3c6f1d0922448b49b1aad8cb71b48c7_Out_0_Texture2D.samplerstate, _Property_e3c6f1d0922448b49b1aad8cb71b48c7_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_788e52d72b3f4f67bf3d22ea6bed1deb_R_4_Float = _SampleTexture2D_788e52d72b3f4f67bf3d22ea6bed1deb_RGBA_0_Vector4.r;
            float _SampleTexture2D_788e52d72b3f4f67bf3d22ea6bed1deb_G_5_Float = _SampleTexture2D_788e52d72b3f4f67bf3d22ea6bed1deb_RGBA_0_Vector4.g;
            float _SampleTexture2D_788e52d72b3f4f67bf3d22ea6bed1deb_B_6_Float = _SampleTexture2D_788e52d72b3f4f67bf3d22ea6bed1deb_RGBA_0_Vector4.b;
            float _SampleTexture2D_788e52d72b3f4f67bf3d22ea6bed1deb_A_7_Float = _SampleTexture2D_788e52d72b3f4f67bf3d22ea6bed1deb_RGBA_0_Vector4.a;
            float _Property_e71de6f31aff460d8af325edec89b4d8_Out_0_Boolean = _BL;
            float4 _Multiply_86d7daad2d724d46a4aa26bd7e3b431b_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_788e52d72b3f4f67bf3d22ea6bed1deb_RGBA_0_Vector4, (((float) _Property_e71de6f31aff460d8af325edec89b4d8_Out_0_Boolean).xxxx), _Multiply_86d7daad2d724d46a4aa26bd7e3b431b_Out_2_Vector4);
            UnityTexture2D _Property_1986682f6c894519ace892145bccb678_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_IndicatorLeft_Emi);
            float4 _SampleTexture2D_080f715ff2954a038ad2eb004033c622_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_1986682f6c894519ace892145bccb678_Out_0_Texture2D.tex, _Property_1986682f6c894519ace892145bccb678_Out_0_Texture2D.samplerstate, _Property_1986682f6c894519ace892145bccb678_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_080f715ff2954a038ad2eb004033c622_R_4_Float = _SampleTexture2D_080f715ff2954a038ad2eb004033c622_RGBA_0_Vector4.r;
            float _SampleTexture2D_080f715ff2954a038ad2eb004033c622_G_5_Float = _SampleTexture2D_080f715ff2954a038ad2eb004033c622_RGBA_0_Vector4.g;
            float _SampleTexture2D_080f715ff2954a038ad2eb004033c622_B_6_Float = _SampleTexture2D_080f715ff2954a038ad2eb004033c622_RGBA_0_Vector4.b;
            float _SampleTexture2D_080f715ff2954a038ad2eb004033c622_A_7_Float = _SampleTexture2D_080f715ff2954a038ad2eb004033c622_RGBA_0_Vector4.a;
            float _Property_d810ea65138a4a1db5b33c768bd2e16e_Out_0_Boolean = _IL;
            float4 _Multiply_d6f12e9147294bffbe2a69a1b2fedbea_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_080f715ff2954a038ad2eb004033c622_RGBA_0_Vector4, (((float) _Property_d810ea65138a4a1db5b33c768bd2e16e_Out_0_Boolean).xxxx), _Multiply_d6f12e9147294bffbe2a69a1b2fedbea_Out_2_Vector4);
            float4 _Add_5b04689a8c2e4f4784439edb2d55bb1d_Out_2_Vector4;
            Unity_Add_float4(_Multiply_86d7daad2d724d46a4aa26bd7e3b431b_Out_2_Vector4, _Multiply_d6f12e9147294bffbe2a69a1b2fedbea_Out_2_Vector4, _Add_5b04689a8c2e4f4784439edb2d55bb1d_Out_2_Vector4);
            float4 _Add_7885016d549b4ec1956c048a65b86b84_Out_2_Vector4;
            Unity_Add_float4(_Add_34c8346a6659446ebaf860a6cba3b7db_Out_2_Vector4, _Add_5b04689a8c2e4f4784439edb2d55bb1d_Out_2_Vector4, _Add_7885016d549b4ec1956c048a65b86b84_Out_2_Vector4);
            UnityTexture2D _Property_4c2777612c45484dbf5970ee15fc1c27_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_IndicatorRight_Emi);
            float4 _SampleTexture2D_9c4b62721b7641f7ba4b3ebd42f53ed9_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_4c2777612c45484dbf5970ee15fc1c27_Out_0_Texture2D.tex, _Property_4c2777612c45484dbf5970ee15fc1c27_Out_0_Texture2D.samplerstate, _Property_4c2777612c45484dbf5970ee15fc1c27_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_9c4b62721b7641f7ba4b3ebd42f53ed9_R_4_Float = _SampleTexture2D_9c4b62721b7641f7ba4b3ebd42f53ed9_RGBA_0_Vector4.r;
            float _SampleTexture2D_9c4b62721b7641f7ba4b3ebd42f53ed9_G_5_Float = _SampleTexture2D_9c4b62721b7641f7ba4b3ebd42f53ed9_RGBA_0_Vector4.g;
            float _SampleTexture2D_9c4b62721b7641f7ba4b3ebd42f53ed9_B_6_Float = _SampleTexture2D_9c4b62721b7641f7ba4b3ebd42f53ed9_RGBA_0_Vector4.b;
            float _SampleTexture2D_9c4b62721b7641f7ba4b3ebd42f53ed9_A_7_Float = _SampleTexture2D_9c4b62721b7641f7ba4b3ebd42f53ed9_RGBA_0_Vector4.a;
            float _Property_e7f0c65c0bc04e0e9d632011ec198912_Out_0_Boolean = _IR;
            float4 _Multiply_8db9c699bf7c48169ec9ca5d5970e213_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_9c4b62721b7641f7ba4b3ebd42f53ed9_RGBA_0_Vector4, (((float) _Property_e7f0c65c0bc04e0e9d632011ec198912_Out_0_Boolean).xxxx), _Multiply_8db9c699bf7c48169ec9ca5d5970e213_Out_2_Vector4);
            UnityTexture2D _Property_c663960e066446399630485727185cdb_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Reverse_Emi);
            float4 _SampleTexture2D_3cb08f5f0d9f43e2b26e0d0dc5dbb1d0_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_c663960e066446399630485727185cdb_Out_0_Texture2D.tex, _Property_c663960e066446399630485727185cdb_Out_0_Texture2D.samplerstate, _Property_c663960e066446399630485727185cdb_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_3cb08f5f0d9f43e2b26e0d0dc5dbb1d0_R_4_Float = _SampleTexture2D_3cb08f5f0d9f43e2b26e0d0dc5dbb1d0_RGBA_0_Vector4.r;
            float _SampleTexture2D_3cb08f5f0d9f43e2b26e0d0dc5dbb1d0_G_5_Float = _SampleTexture2D_3cb08f5f0d9f43e2b26e0d0dc5dbb1d0_RGBA_0_Vector4.g;
            float _SampleTexture2D_3cb08f5f0d9f43e2b26e0d0dc5dbb1d0_B_6_Float = _SampleTexture2D_3cb08f5f0d9f43e2b26e0d0dc5dbb1d0_RGBA_0_Vector4.b;
            float _SampleTexture2D_3cb08f5f0d9f43e2b26e0d0dc5dbb1d0_A_7_Float = _SampleTexture2D_3cb08f5f0d9f43e2b26e0d0dc5dbb1d0_RGBA_0_Vector4.a;
            float _Property_3f79a615983f4b57abac960145641ee5_Out_0_Boolean = _REV;
            float4 _Multiply_ee601476b53a4345959083c075d56bad_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_3cb08f5f0d9f43e2b26e0d0dc5dbb1d0_RGBA_0_Vector4, (((float) _Property_3f79a615983f4b57abac960145641ee5_Out_0_Boolean).xxxx), _Multiply_ee601476b53a4345959083c075d56bad_Out_2_Vector4);
            float4 _Add_5da25797012a4573b9295f462a9e99e0_Out_2_Vector4;
            Unity_Add_float4(_Multiply_8db9c699bf7c48169ec9ca5d5970e213_Out_2_Vector4, _Multiply_ee601476b53a4345959083c075d56bad_Out_2_Vector4, _Add_5da25797012a4573b9295f462a9e99e0_Out_2_Vector4);
            float4 _Add_a47c008b6c174c32a2fe25117c67b858_Out_2_Vector4;
            Unity_Add_float4(_Add_5da25797012a4573b9295f462a9e99e0_Out_2_Vector4, float4(0, 0, 0, 0), _Add_a47c008b6c174c32a2fe25117c67b858_Out_2_Vector4);
            float4 _Add_7b729037ba5d4763818ac5ce7c552c5e_Out_2_Vector4;
            Unity_Add_float4(_Add_7885016d549b4ec1956c048a65b86b84_Out_2_Vector4, _Add_a47c008b6c174c32a2fe25117c67b858_Out_2_Vector4, _Add_7b729037ba5d4763818ac5ce7c552c5e_Out_2_Vector4);
            UnityTexture2D _Property_ea5d3446ea6b416aa763744813415f54_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Metallic);
            float4 _SampleTexture2D_cd62480f4ed4495e8a325ad1766b2c5d_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_ea5d3446ea6b416aa763744813415f54_Out_0_Texture2D.tex, _Property_ea5d3446ea6b416aa763744813415f54_Out_0_Texture2D.samplerstate, _Property_ea5d3446ea6b416aa763744813415f54_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_cd62480f4ed4495e8a325ad1766b2c5d_R_4_Float = _SampleTexture2D_cd62480f4ed4495e8a325ad1766b2c5d_RGBA_0_Vector4.r;
            float _SampleTexture2D_cd62480f4ed4495e8a325ad1766b2c5d_G_5_Float = _SampleTexture2D_cd62480f4ed4495e8a325ad1766b2c5d_RGBA_0_Vector4.g;
            float _SampleTexture2D_cd62480f4ed4495e8a325ad1766b2c5d_B_6_Float = _SampleTexture2D_cd62480f4ed4495e8a325ad1766b2c5d_RGBA_0_Vector4.b;
            float _SampleTexture2D_cd62480f4ed4495e8a325ad1766b2c5d_A_7_Float = _SampleTexture2D_cd62480f4ed4495e8a325ad1766b2c5d_RGBA_0_Vector4.a;
            surface.BaseColor = (_SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_RGBA_0_Vector4.xyz);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Emission = (_Add_7b729037ba5d4763818ac5ce7c552c5e_Out_2_Vector4.xyz);
            surface.Metallic = (_SampleTexture2D_cd62480f4ed4495e8a325ad1766b2c5d_RGBA_0_Vector4).x;
            surface.Smoothness = 0.5;
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
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
        
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
             float3 TangentSpaceNormal;
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
        float4 _Metallic_TexelSize;
        float _BH;
        float4 _Break_Emi_TexelSize;
        float4 _BeamLow_Emi_TexelSize;
        float _BL;
        float4 _IndicatorLeft_Emi_TexelSize;
        float _IR;
        float _IL;
        float4 _IndicatorRight_Emi_TexelSize;
        float _REV;
        float4 _Reverse_Emi_TexelSize;
        float4 _BeamHigh_Emi_TexelSize;
        float _BR;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Base);
        SAMPLER(sampler_Base);
        TEXTURE2D(_Metallic);
        SAMPLER(sampler_Metallic);
        TEXTURE2D(_Break_Emi);
        SAMPLER(sampler_Break_Emi);
        TEXTURE2D(_BeamLow_Emi);
        SAMPLER(sampler_BeamLow_Emi);
        TEXTURE2D(_IndicatorLeft_Emi);
        SAMPLER(sampler_IndicatorLeft_Emi);
        TEXTURE2D(_IndicatorRight_Emi);
        SAMPLER(sampler_IndicatorRight_Emi);
        TEXTURE2D(_Reverse_Emi);
        SAMPLER(sampler_Reverse_Emi);
        TEXTURE2D(_BeamHigh_Emi);
        SAMPLER(sampler_BeamHigh_Emi);
        
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
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
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
            UnityTexture2D _Property_2798ac98d19c42c5899b3175f80c6a56_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base);
            float4 _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_2798ac98d19c42c5899b3175f80c6a56_Out_0_Texture2D.tex, _Property_2798ac98d19c42c5899b3175f80c6a56_Out_0_Texture2D.samplerstate, _Property_2798ac98d19c42c5899b3175f80c6a56_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_R_4_Float = _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_RGBA_0_Vector4.r;
            float _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_G_5_Float = _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_RGBA_0_Vector4.g;
            float _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_B_6_Float = _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_RGBA_0_Vector4.b;
            float _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_A_7_Float = _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_RGBA_0_Vector4.a;
            UnityTexture2D _Property_9e18aed5617c40d38e5d61a182a32af3_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Break_Emi);
            float4 _SampleTexture2D_d352588b583e46fea8d62dd0ea936e78_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_9e18aed5617c40d38e5d61a182a32af3_Out_0_Texture2D.tex, _Property_9e18aed5617c40d38e5d61a182a32af3_Out_0_Texture2D.samplerstate, _Property_9e18aed5617c40d38e5d61a182a32af3_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_d352588b583e46fea8d62dd0ea936e78_R_4_Float = _SampleTexture2D_d352588b583e46fea8d62dd0ea936e78_RGBA_0_Vector4.r;
            float _SampleTexture2D_d352588b583e46fea8d62dd0ea936e78_G_5_Float = _SampleTexture2D_d352588b583e46fea8d62dd0ea936e78_RGBA_0_Vector4.g;
            float _SampleTexture2D_d352588b583e46fea8d62dd0ea936e78_B_6_Float = _SampleTexture2D_d352588b583e46fea8d62dd0ea936e78_RGBA_0_Vector4.b;
            float _SampleTexture2D_d352588b583e46fea8d62dd0ea936e78_A_7_Float = _SampleTexture2D_d352588b583e46fea8d62dd0ea936e78_RGBA_0_Vector4.a;
            float _Property_5d49a99a6f5841a1bc724ef2185ee269_Out_0_Boolean = _BR;
            float4 _Multiply_d549fb0c6e5d410cbad5908e8d8a1262_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_d352588b583e46fea8d62dd0ea936e78_RGBA_0_Vector4, (((float) _Property_5d49a99a6f5841a1bc724ef2185ee269_Out_0_Boolean).xxxx), _Multiply_d549fb0c6e5d410cbad5908e8d8a1262_Out_2_Vector4);
            UnityTexture2D _Property_14efad17c2904d73a0e5fafc6082561c_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BeamHigh_Emi);
            float4 _SampleTexture2D_8e402452ef594350a7d467f89300b17d_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_14efad17c2904d73a0e5fafc6082561c_Out_0_Texture2D.tex, _Property_14efad17c2904d73a0e5fafc6082561c_Out_0_Texture2D.samplerstate, _Property_14efad17c2904d73a0e5fafc6082561c_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_8e402452ef594350a7d467f89300b17d_R_4_Float = _SampleTexture2D_8e402452ef594350a7d467f89300b17d_RGBA_0_Vector4.r;
            float _SampleTexture2D_8e402452ef594350a7d467f89300b17d_G_5_Float = _SampleTexture2D_8e402452ef594350a7d467f89300b17d_RGBA_0_Vector4.g;
            float _SampleTexture2D_8e402452ef594350a7d467f89300b17d_B_6_Float = _SampleTexture2D_8e402452ef594350a7d467f89300b17d_RGBA_0_Vector4.b;
            float _SampleTexture2D_8e402452ef594350a7d467f89300b17d_A_7_Float = _SampleTexture2D_8e402452ef594350a7d467f89300b17d_RGBA_0_Vector4.a;
            float _Property_ba21194f9f0c448e9b5e236885880883_Out_0_Boolean = _BH;
            float4 _Multiply_48c6868bbd044c388a64fbd622f3e697_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_8e402452ef594350a7d467f89300b17d_RGBA_0_Vector4, (((float) _Property_ba21194f9f0c448e9b5e236885880883_Out_0_Boolean).xxxx), _Multiply_48c6868bbd044c388a64fbd622f3e697_Out_2_Vector4);
            float4 _Add_34c8346a6659446ebaf860a6cba3b7db_Out_2_Vector4;
            Unity_Add_float4(_Multiply_d549fb0c6e5d410cbad5908e8d8a1262_Out_2_Vector4, _Multiply_48c6868bbd044c388a64fbd622f3e697_Out_2_Vector4, _Add_34c8346a6659446ebaf860a6cba3b7db_Out_2_Vector4);
            UnityTexture2D _Property_e3c6f1d0922448b49b1aad8cb71b48c7_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BeamLow_Emi);
            float4 _SampleTexture2D_788e52d72b3f4f67bf3d22ea6bed1deb_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_e3c6f1d0922448b49b1aad8cb71b48c7_Out_0_Texture2D.tex, _Property_e3c6f1d0922448b49b1aad8cb71b48c7_Out_0_Texture2D.samplerstate, _Property_e3c6f1d0922448b49b1aad8cb71b48c7_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_788e52d72b3f4f67bf3d22ea6bed1deb_R_4_Float = _SampleTexture2D_788e52d72b3f4f67bf3d22ea6bed1deb_RGBA_0_Vector4.r;
            float _SampleTexture2D_788e52d72b3f4f67bf3d22ea6bed1deb_G_5_Float = _SampleTexture2D_788e52d72b3f4f67bf3d22ea6bed1deb_RGBA_0_Vector4.g;
            float _SampleTexture2D_788e52d72b3f4f67bf3d22ea6bed1deb_B_6_Float = _SampleTexture2D_788e52d72b3f4f67bf3d22ea6bed1deb_RGBA_0_Vector4.b;
            float _SampleTexture2D_788e52d72b3f4f67bf3d22ea6bed1deb_A_7_Float = _SampleTexture2D_788e52d72b3f4f67bf3d22ea6bed1deb_RGBA_0_Vector4.a;
            float _Property_e71de6f31aff460d8af325edec89b4d8_Out_0_Boolean = _BL;
            float4 _Multiply_86d7daad2d724d46a4aa26bd7e3b431b_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_788e52d72b3f4f67bf3d22ea6bed1deb_RGBA_0_Vector4, (((float) _Property_e71de6f31aff460d8af325edec89b4d8_Out_0_Boolean).xxxx), _Multiply_86d7daad2d724d46a4aa26bd7e3b431b_Out_2_Vector4);
            UnityTexture2D _Property_1986682f6c894519ace892145bccb678_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_IndicatorLeft_Emi);
            float4 _SampleTexture2D_080f715ff2954a038ad2eb004033c622_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_1986682f6c894519ace892145bccb678_Out_0_Texture2D.tex, _Property_1986682f6c894519ace892145bccb678_Out_0_Texture2D.samplerstate, _Property_1986682f6c894519ace892145bccb678_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_080f715ff2954a038ad2eb004033c622_R_4_Float = _SampleTexture2D_080f715ff2954a038ad2eb004033c622_RGBA_0_Vector4.r;
            float _SampleTexture2D_080f715ff2954a038ad2eb004033c622_G_5_Float = _SampleTexture2D_080f715ff2954a038ad2eb004033c622_RGBA_0_Vector4.g;
            float _SampleTexture2D_080f715ff2954a038ad2eb004033c622_B_6_Float = _SampleTexture2D_080f715ff2954a038ad2eb004033c622_RGBA_0_Vector4.b;
            float _SampleTexture2D_080f715ff2954a038ad2eb004033c622_A_7_Float = _SampleTexture2D_080f715ff2954a038ad2eb004033c622_RGBA_0_Vector4.a;
            float _Property_d810ea65138a4a1db5b33c768bd2e16e_Out_0_Boolean = _IL;
            float4 _Multiply_d6f12e9147294bffbe2a69a1b2fedbea_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_080f715ff2954a038ad2eb004033c622_RGBA_0_Vector4, (((float) _Property_d810ea65138a4a1db5b33c768bd2e16e_Out_0_Boolean).xxxx), _Multiply_d6f12e9147294bffbe2a69a1b2fedbea_Out_2_Vector4);
            float4 _Add_5b04689a8c2e4f4784439edb2d55bb1d_Out_2_Vector4;
            Unity_Add_float4(_Multiply_86d7daad2d724d46a4aa26bd7e3b431b_Out_2_Vector4, _Multiply_d6f12e9147294bffbe2a69a1b2fedbea_Out_2_Vector4, _Add_5b04689a8c2e4f4784439edb2d55bb1d_Out_2_Vector4);
            float4 _Add_7885016d549b4ec1956c048a65b86b84_Out_2_Vector4;
            Unity_Add_float4(_Add_34c8346a6659446ebaf860a6cba3b7db_Out_2_Vector4, _Add_5b04689a8c2e4f4784439edb2d55bb1d_Out_2_Vector4, _Add_7885016d549b4ec1956c048a65b86b84_Out_2_Vector4);
            UnityTexture2D _Property_4c2777612c45484dbf5970ee15fc1c27_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_IndicatorRight_Emi);
            float4 _SampleTexture2D_9c4b62721b7641f7ba4b3ebd42f53ed9_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_4c2777612c45484dbf5970ee15fc1c27_Out_0_Texture2D.tex, _Property_4c2777612c45484dbf5970ee15fc1c27_Out_0_Texture2D.samplerstate, _Property_4c2777612c45484dbf5970ee15fc1c27_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_9c4b62721b7641f7ba4b3ebd42f53ed9_R_4_Float = _SampleTexture2D_9c4b62721b7641f7ba4b3ebd42f53ed9_RGBA_0_Vector4.r;
            float _SampleTexture2D_9c4b62721b7641f7ba4b3ebd42f53ed9_G_5_Float = _SampleTexture2D_9c4b62721b7641f7ba4b3ebd42f53ed9_RGBA_0_Vector4.g;
            float _SampleTexture2D_9c4b62721b7641f7ba4b3ebd42f53ed9_B_6_Float = _SampleTexture2D_9c4b62721b7641f7ba4b3ebd42f53ed9_RGBA_0_Vector4.b;
            float _SampleTexture2D_9c4b62721b7641f7ba4b3ebd42f53ed9_A_7_Float = _SampleTexture2D_9c4b62721b7641f7ba4b3ebd42f53ed9_RGBA_0_Vector4.a;
            float _Property_e7f0c65c0bc04e0e9d632011ec198912_Out_0_Boolean = _IR;
            float4 _Multiply_8db9c699bf7c48169ec9ca5d5970e213_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_9c4b62721b7641f7ba4b3ebd42f53ed9_RGBA_0_Vector4, (((float) _Property_e7f0c65c0bc04e0e9d632011ec198912_Out_0_Boolean).xxxx), _Multiply_8db9c699bf7c48169ec9ca5d5970e213_Out_2_Vector4);
            UnityTexture2D _Property_c663960e066446399630485727185cdb_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Reverse_Emi);
            float4 _SampleTexture2D_3cb08f5f0d9f43e2b26e0d0dc5dbb1d0_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_c663960e066446399630485727185cdb_Out_0_Texture2D.tex, _Property_c663960e066446399630485727185cdb_Out_0_Texture2D.samplerstate, _Property_c663960e066446399630485727185cdb_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_3cb08f5f0d9f43e2b26e0d0dc5dbb1d0_R_4_Float = _SampleTexture2D_3cb08f5f0d9f43e2b26e0d0dc5dbb1d0_RGBA_0_Vector4.r;
            float _SampleTexture2D_3cb08f5f0d9f43e2b26e0d0dc5dbb1d0_G_5_Float = _SampleTexture2D_3cb08f5f0d9f43e2b26e0d0dc5dbb1d0_RGBA_0_Vector4.g;
            float _SampleTexture2D_3cb08f5f0d9f43e2b26e0d0dc5dbb1d0_B_6_Float = _SampleTexture2D_3cb08f5f0d9f43e2b26e0d0dc5dbb1d0_RGBA_0_Vector4.b;
            float _SampleTexture2D_3cb08f5f0d9f43e2b26e0d0dc5dbb1d0_A_7_Float = _SampleTexture2D_3cb08f5f0d9f43e2b26e0d0dc5dbb1d0_RGBA_0_Vector4.a;
            float _Property_3f79a615983f4b57abac960145641ee5_Out_0_Boolean = _REV;
            float4 _Multiply_ee601476b53a4345959083c075d56bad_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_3cb08f5f0d9f43e2b26e0d0dc5dbb1d0_RGBA_0_Vector4, (((float) _Property_3f79a615983f4b57abac960145641ee5_Out_0_Boolean).xxxx), _Multiply_ee601476b53a4345959083c075d56bad_Out_2_Vector4);
            float4 _Add_5da25797012a4573b9295f462a9e99e0_Out_2_Vector4;
            Unity_Add_float4(_Multiply_8db9c699bf7c48169ec9ca5d5970e213_Out_2_Vector4, _Multiply_ee601476b53a4345959083c075d56bad_Out_2_Vector4, _Add_5da25797012a4573b9295f462a9e99e0_Out_2_Vector4);
            float4 _Add_a47c008b6c174c32a2fe25117c67b858_Out_2_Vector4;
            Unity_Add_float4(_Add_5da25797012a4573b9295f462a9e99e0_Out_2_Vector4, float4(0, 0, 0, 0), _Add_a47c008b6c174c32a2fe25117c67b858_Out_2_Vector4);
            float4 _Add_7b729037ba5d4763818ac5ce7c552c5e_Out_2_Vector4;
            Unity_Add_float4(_Add_7885016d549b4ec1956c048a65b86b84_Out_2_Vector4, _Add_a47c008b6c174c32a2fe25117c67b858_Out_2_Vector4, _Add_7b729037ba5d4763818ac5ce7c552c5e_Out_2_Vector4);
            UnityTexture2D _Property_ea5d3446ea6b416aa763744813415f54_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Metallic);
            float4 _SampleTexture2D_cd62480f4ed4495e8a325ad1766b2c5d_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_ea5d3446ea6b416aa763744813415f54_Out_0_Texture2D.tex, _Property_ea5d3446ea6b416aa763744813415f54_Out_0_Texture2D.samplerstate, _Property_ea5d3446ea6b416aa763744813415f54_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_cd62480f4ed4495e8a325ad1766b2c5d_R_4_Float = _SampleTexture2D_cd62480f4ed4495e8a325ad1766b2c5d_RGBA_0_Vector4.r;
            float _SampleTexture2D_cd62480f4ed4495e8a325ad1766b2c5d_G_5_Float = _SampleTexture2D_cd62480f4ed4495e8a325ad1766b2c5d_RGBA_0_Vector4.g;
            float _SampleTexture2D_cd62480f4ed4495e8a325ad1766b2c5d_B_6_Float = _SampleTexture2D_cd62480f4ed4495e8a325ad1766b2c5d_RGBA_0_Vector4.b;
            float _SampleTexture2D_cd62480f4ed4495e8a325ad1766b2c5d_A_7_Float = _SampleTexture2D_cd62480f4ed4495e8a325ad1766b2c5d_RGBA_0_Vector4.a;
            surface.BaseColor = (_SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_RGBA_0_Vector4.xyz);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Emission = (_Add_7b729037ba5d4763818ac5ce7c552c5e_Out_2_Vector4.xyz);
            surface.Metallic = (_SampleTexture2D_cd62480f4ed4495e8a325ad1766b2c5d_RGBA_0_Vector4).x;
            surface.Smoothness = 0.5;
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
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
        
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
        float4 _Metallic_TexelSize;
        float _BH;
        float4 _Break_Emi_TexelSize;
        float4 _BeamLow_Emi_TexelSize;
        float _BL;
        float4 _IndicatorLeft_Emi_TexelSize;
        float _IR;
        float _IL;
        float4 _IndicatorRight_Emi_TexelSize;
        float _REV;
        float4 _Reverse_Emi_TexelSize;
        float4 _BeamHigh_Emi_TexelSize;
        float _BR;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Base);
        SAMPLER(sampler_Base);
        TEXTURE2D(_Metallic);
        SAMPLER(sampler_Metallic);
        TEXTURE2D(_Break_Emi);
        SAMPLER(sampler_Break_Emi);
        TEXTURE2D(_BeamLow_Emi);
        SAMPLER(sampler_BeamLow_Emi);
        TEXTURE2D(_IndicatorLeft_Emi);
        SAMPLER(sampler_IndicatorLeft_Emi);
        TEXTURE2D(_IndicatorRight_Emi);
        SAMPLER(sampler_IndicatorRight_Emi);
        TEXTURE2D(_Reverse_Emi);
        SAMPLER(sampler_Reverse_Emi);
        TEXTURE2D(_BeamHigh_Emi);
        SAMPLER(sampler_BeamHigh_Emi);
        
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
        float4 _Metallic_TexelSize;
        float _BH;
        float4 _Break_Emi_TexelSize;
        float4 _BeamLow_Emi_TexelSize;
        float _BL;
        float4 _IndicatorLeft_Emi_TexelSize;
        float _IR;
        float _IL;
        float4 _IndicatorRight_Emi_TexelSize;
        float _REV;
        float4 _Reverse_Emi_TexelSize;
        float4 _BeamHigh_Emi_TexelSize;
        float _BR;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Base);
        SAMPLER(sampler_Base);
        TEXTURE2D(_Metallic);
        SAMPLER(sampler_Metallic);
        TEXTURE2D(_Break_Emi);
        SAMPLER(sampler_Break_Emi);
        TEXTURE2D(_BeamLow_Emi);
        SAMPLER(sampler_BeamLow_Emi);
        TEXTURE2D(_IndicatorLeft_Emi);
        SAMPLER(sampler_IndicatorLeft_Emi);
        TEXTURE2D(_IndicatorRight_Emi);
        SAMPLER(sampler_IndicatorRight_Emi);
        TEXTURE2D(_Reverse_Emi);
        SAMPLER(sampler_Reverse_Emi);
        TEXTURE2D(_BeamHigh_Emi);
        SAMPLER(sampler_BeamHigh_Emi);
        
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
        float4 _Metallic_TexelSize;
        float _BH;
        float4 _Break_Emi_TexelSize;
        float4 _BeamLow_Emi_TexelSize;
        float _BL;
        float4 _IndicatorLeft_Emi_TexelSize;
        float _IR;
        float _IL;
        float4 _IndicatorRight_Emi_TexelSize;
        float _REV;
        float4 _Reverse_Emi_TexelSize;
        float4 _BeamHigh_Emi_TexelSize;
        float _BR;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Base);
        SAMPLER(sampler_Base);
        TEXTURE2D(_Metallic);
        SAMPLER(sampler_Metallic);
        TEXTURE2D(_Break_Emi);
        SAMPLER(sampler_Break_Emi);
        TEXTURE2D(_BeamLow_Emi);
        SAMPLER(sampler_BeamLow_Emi);
        TEXTURE2D(_IndicatorLeft_Emi);
        SAMPLER(sampler_IndicatorLeft_Emi);
        TEXTURE2D(_IndicatorRight_Emi);
        SAMPLER(sampler_IndicatorRight_Emi);
        TEXTURE2D(_Reverse_Emi);
        SAMPLER(sampler_Reverse_Emi);
        TEXTURE2D(_BeamHigh_Emi);
        SAMPLER(sampler_BeamHigh_Emi);
        
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
        float4 _Metallic_TexelSize;
        float _BH;
        float4 _Break_Emi_TexelSize;
        float4 _BeamLow_Emi_TexelSize;
        float _BL;
        float4 _IndicatorLeft_Emi_TexelSize;
        float _IR;
        float _IL;
        float4 _IndicatorRight_Emi_TexelSize;
        float _REV;
        float4 _Reverse_Emi_TexelSize;
        float4 _BeamHigh_Emi_TexelSize;
        float _BR;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Base);
        SAMPLER(sampler_Base);
        TEXTURE2D(_Metallic);
        SAMPLER(sampler_Metallic);
        TEXTURE2D(_Break_Emi);
        SAMPLER(sampler_Break_Emi);
        TEXTURE2D(_BeamLow_Emi);
        SAMPLER(sampler_BeamLow_Emi);
        TEXTURE2D(_IndicatorLeft_Emi);
        SAMPLER(sampler_IndicatorLeft_Emi);
        TEXTURE2D(_IndicatorRight_Emi);
        SAMPLER(sampler_IndicatorRight_Emi);
        TEXTURE2D(_Reverse_Emi);
        SAMPLER(sampler_Reverse_Emi);
        TEXTURE2D(_BeamHigh_Emi);
        SAMPLER(sampler_BeamHigh_Emi);
        
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
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
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
            UnityTexture2D _Property_2798ac98d19c42c5899b3175f80c6a56_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base);
            float4 _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_2798ac98d19c42c5899b3175f80c6a56_Out_0_Texture2D.tex, _Property_2798ac98d19c42c5899b3175f80c6a56_Out_0_Texture2D.samplerstate, _Property_2798ac98d19c42c5899b3175f80c6a56_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_R_4_Float = _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_RGBA_0_Vector4.r;
            float _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_G_5_Float = _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_RGBA_0_Vector4.g;
            float _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_B_6_Float = _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_RGBA_0_Vector4.b;
            float _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_A_7_Float = _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_RGBA_0_Vector4.a;
            UnityTexture2D _Property_9e18aed5617c40d38e5d61a182a32af3_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Break_Emi);
            float4 _SampleTexture2D_d352588b583e46fea8d62dd0ea936e78_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_9e18aed5617c40d38e5d61a182a32af3_Out_0_Texture2D.tex, _Property_9e18aed5617c40d38e5d61a182a32af3_Out_0_Texture2D.samplerstate, _Property_9e18aed5617c40d38e5d61a182a32af3_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_d352588b583e46fea8d62dd0ea936e78_R_4_Float = _SampleTexture2D_d352588b583e46fea8d62dd0ea936e78_RGBA_0_Vector4.r;
            float _SampleTexture2D_d352588b583e46fea8d62dd0ea936e78_G_5_Float = _SampleTexture2D_d352588b583e46fea8d62dd0ea936e78_RGBA_0_Vector4.g;
            float _SampleTexture2D_d352588b583e46fea8d62dd0ea936e78_B_6_Float = _SampleTexture2D_d352588b583e46fea8d62dd0ea936e78_RGBA_0_Vector4.b;
            float _SampleTexture2D_d352588b583e46fea8d62dd0ea936e78_A_7_Float = _SampleTexture2D_d352588b583e46fea8d62dd0ea936e78_RGBA_0_Vector4.a;
            float _Property_5d49a99a6f5841a1bc724ef2185ee269_Out_0_Boolean = _BR;
            float4 _Multiply_d549fb0c6e5d410cbad5908e8d8a1262_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_d352588b583e46fea8d62dd0ea936e78_RGBA_0_Vector4, (((float) _Property_5d49a99a6f5841a1bc724ef2185ee269_Out_0_Boolean).xxxx), _Multiply_d549fb0c6e5d410cbad5908e8d8a1262_Out_2_Vector4);
            UnityTexture2D _Property_14efad17c2904d73a0e5fafc6082561c_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BeamHigh_Emi);
            float4 _SampleTexture2D_8e402452ef594350a7d467f89300b17d_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_14efad17c2904d73a0e5fafc6082561c_Out_0_Texture2D.tex, _Property_14efad17c2904d73a0e5fafc6082561c_Out_0_Texture2D.samplerstate, _Property_14efad17c2904d73a0e5fafc6082561c_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_8e402452ef594350a7d467f89300b17d_R_4_Float = _SampleTexture2D_8e402452ef594350a7d467f89300b17d_RGBA_0_Vector4.r;
            float _SampleTexture2D_8e402452ef594350a7d467f89300b17d_G_5_Float = _SampleTexture2D_8e402452ef594350a7d467f89300b17d_RGBA_0_Vector4.g;
            float _SampleTexture2D_8e402452ef594350a7d467f89300b17d_B_6_Float = _SampleTexture2D_8e402452ef594350a7d467f89300b17d_RGBA_0_Vector4.b;
            float _SampleTexture2D_8e402452ef594350a7d467f89300b17d_A_7_Float = _SampleTexture2D_8e402452ef594350a7d467f89300b17d_RGBA_0_Vector4.a;
            float _Property_ba21194f9f0c448e9b5e236885880883_Out_0_Boolean = _BH;
            float4 _Multiply_48c6868bbd044c388a64fbd622f3e697_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_8e402452ef594350a7d467f89300b17d_RGBA_0_Vector4, (((float) _Property_ba21194f9f0c448e9b5e236885880883_Out_0_Boolean).xxxx), _Multiply_48c6868bbd044c388a64fbd622f3e697_Out_2_Vector4);
            float4 _Add_34c8346a6659446ebaf860a6cba3b7db_Out_2_Vector4;
            Unity_Add_float4(_Multiply_d549fb0c6e5d410cbad5908e8d8a1262_Out_2_Vector4, _Multiply_48c6868bbd044c388a64fbd622f3e697_Out_2_Vector4, _Add_34c8346a6659446ebaf860a6cba3b7db_Out_2_Vector4);
            UnityTexture2D _Property_e3c6f1d0922448b49b1aad8cb71b48c7_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BeamLow_Emi);
            float4 _SampleTexture2D_788e52d72b3f4f67bf3d22ea6bed1deb_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_e3c6f1d0922448b49b1aad8cb71b48c7_Out_0_Texture2D.tex, _Property_e3c6f1d0922448b49b1aad8cb71b48c7_Out_0_Texture2D.samplerstate, _Property_e3c6f1d0922448b49b1aad8cb71b48c7_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_788e52d72b3f4f67bf3d22ea6bed1deb_R_4_Float = _SampleTexture2D_788e52d72b3f4f67bf3d22ea6bed1deb_RGBA_0_Vector4.r;
            float _SampleTexture2D_788e52d72b3f4f67bf3d22ea6bed1deb_G_5_Float = _SampleTexture2D_788e52d72b3f4f67bf3d22ea6bed1deb_RGBA_0_Vector4.g;
            float _SampleTexture2D_788e52d72b3f4f67bf3d22ea6bed1deb_B_6_Float = _SampleTexture2D_788e52d72b3f4f67bf3d22ea6bed1deb_RGBA_0_Vector4.b;
            float _SampleTexture2D_788e52d72b3f4f67bf3d22ea6bed1deb_A_7_Float = _SampleTexture2D_788e52d72b3f4f67bf3d22ea6bed1deb_RGBA_0_Vector4.a;
            float _Property_e71de6f31aff460d8af325edec89b4d8_Out_0_Boolean = _BL;
            float4 _Multiply_86d7daad2d724d46a4aa26bd7e3b431b_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_788e52d72b3f4f67bf3d22ea6bed1deb_RGBA_0_Vector4, (((float) _Property_e71de6f31aff460d8af325edec89b4d8_Out_0_Boolean).xxxx), _Multiply_86d7daad2d724d46a4aa26bd7e3b431b_Out_2_Vector4);
            UnityTexture2D _Property_1986682f6c894519ace892145bccb678_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_IndicatorLeft_Emi);
            float4 _SampleTexture2D_080f715ff2954a038ad2eb004033c622_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_1986682f6c894519ace892145bccb678_Out_0_Texture2D.tex, _Property_1986682f6c894519ace892145bccb678_Out_0_Texture2D.samplerstate, _Property_1986682f6c894519ace892145bccb678_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_080f715ff2954a038ad2eb004033c622_R_4_Float = _SampleTexture2D_080f715ff2954a038ad2eb004033c622_RGBA_0_Vector4.r;
            float _SampleTexture2D_080f715ff2954a038ad2eb004033c622_G_5_Float = _SampleTexture2D_080f715ff2954a038ad2eb004033c622_RGBA_0_Vector4.g;
            float _SampleTexture2D_080f715ff2954a038ad2eb004033c622_B_6_Float = _SampleTexture2D_080f715ff2954a038ad2eb004033c622_RGBA_0_Vector4.b;
            float _SampleTexture2D_080f715ff2954a038ad2eb004033c622_A_7_Float = _SampleTexture2D_080f715ff2954a038ad2eb004033c622_RGBA_0_Vector4.a;
            float _Property_d810ea65138a4a1db5b33c768bd2e16e_Out_0_Boolean = _IL;
            float4 _Multiply_d6f12e9147294bffbe2a69a1b2fedbea_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_080f715ff2954a038ad2eb004033c622_RGBA_0_Vector4, (((float) _Property_d810ea65138a4a1db5b33c768bd2e16e_Out_0_Boolean).xxxx), _Multiply_d6f12e9147294bffbe2a69a1b2fedbea_Out_2_Vector4);
            float4 _Add_5b04689a8c2e4f4784439edb2d55bb1d_Out_2_Vector4;
            Unity_Add_float4(_Multiply_86d7daad2d724d46a4aa26bd7e3b431b_Out_2_Vector4, _Multiply_d6f12e9147294bffbe2a69a1b2fedbea_Out_2_Vector4, _Add_5b04689a8c2e4f4784439edb2d55bb1d_Out_2_Vector4);
            float4 _Add_7885016d549b4ec1956c048a65b86b84_Out_2_Vector4;
            Unity_Add_float4(_Add_34c8346a6659446ebaf860a6cba3b7db_Out_2_Vector4, _Add_5b04689a8c2e4f4784439edb2d55bb1d_Out_2_Vector4, _Add_7885016d549b4ec1956c048a65b86b84_Out_2_Vector4);
            UnityTexture2D _Property_4c2777612c45484dbf5970ee15fc1c27_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_IndicatorRight_Emi);
            float4 _SampleTexture2D_9c4b62721b7641f7ba4b3ebd42f53ed9_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_4c2777612c45484dbf5970ee15fc1c27_Out_0_Texture2D.tex, _Property_4c2777612c45484dbf5970ee15fc1c27_Out_0_Texture2D.samplerstate, _Property_4c2777612c45484dbf5970ee15fc1c27_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_9c4b62721b7641f7ba4b3ebd42f53ed9_R_4_Float = _SampleTexture2D_9c4b62721b7641f7ba4b3ebd42f53ed9_RGBA_0_Vector4.r;
            float _SampleTexture2D_9c4b62721b7641f7ba4b3ebd42f53ed9_G_5_Float = _SampleTexture2D_9c4b62721b7641f7ba4b3ebd42f53ed9_RGBA_0_Vector4.g;
            float _SampleTexture2D_9c4b62721b7641f7ba4b3ebd42f53ed9_B_6_Float = _SampleTexture2D_9c4b62721b7641f7ba4b3ebd42f53ed9_RGBA_0_Vector4.b;
            float _SampleTexture2D_9c4b62721b7641f7ba4b3ebd42f53ed9_A_7_Float = _SampleTexture2D_9c4b62721b7641f7ba4b3ebd42f53ed9_RGBA_0_Vector4.a;
            float _Property_e7f0c65c0bc04e0e9d632011ec198912_Out_0_Boolean = _IR;
            float4 _Multiply_8db9c699bf7c48169ec9ca5d5970e213_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_9c4b62721b7641f7ba4b3ebd42f53ed9_RGBA_0_Vector4, (((float) _Property_e7f0c65c0bc04e0e9d632011ec198912_Out_0_Boolean).xxxx), _Multiply_8db9c699bf7c48169ec9ca5d5970e213_Out_2_Vector4);
            UnityTexture2D _Property_c663960e066446399630485727185cdb_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Reverse_Emi);
            float4 _SampleTexture2D_3cb08f5f0d9f43e2b26e0d0dc5dbb1d0_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_c663960e066446399630485727185cdb_Out_0_Texture2D.tex, _Property_c663960e066446399630485727185cdb_Out_0_Texture2D.samplerstate, _Property_c663960e066446399630485727185cdb_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_3cb08f5f0d9f43e2b26e0d0dc5dbb1d0_R_4_Float = _SampleTexture2D_3cb08f5f0d9f43e2b26e0d0dc5dbb1d0_RGBA_0_Vector4.r;
            float _SampleTexture2D_3cb08f5f0d9f43e2b26e0d0dc5dbb1d0_G_5_Float = _SampleTexture2D_3cb08f5f0d9f43e2b26e0d0dc5dbb1d0_RGBA_0_Vector4.g;
            float _SampleTexture2D_3cb08f5f0d9f43e2b26e0d0dc5dbb1d0_B_6_Float = _SampleTexture2D_3cb08f5f0d9f43e2b26e0d0dc5dbb1d0_RGBA_0_Vector4.b;
            float _SampleTexture2D_3cb08f5f0d9f43e2b26e0d0dc5dbb1d0_A_7_Float = _SampleTexture2D_3cb08f5f0d9f43e2b26e0d0dc5dbb1d0_RGBA_0_Vector4.a;
            float _Property_3f79a615983f4b57abac960145641ee5_Out_0_Boolean = _REV;
            float4 _Multiply_ee601476b53a4345959083c075d56bad_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_3cb08f5f0d9f43e2b26e0d0dc5dbb1d0_RGBA_0_Vector4, (((float) _Property_3f79a615983f4b57abac960145641ee5_Out_0_Boolean).xxxx), _Multiply_ee601476b53a4345959083c075d56bad_Out_2_Vector4);
            float4 _Add_5da25797012a4573b9295f462a9e99e0_Out_2_Vector4;
            Unity_Add_float4(_Multiply_8db9c699bf7c48169ec9ca5d5970e213_Out_2_Vector4, _Multiply_ee601476b53a4345959083c075d56bad_Out_2_Vector4, _Add_5da25797012a4573b9295f462a9e99e0_Out_2_Vector4);
            float4 _Add_a47c008b6c174c32a2fe25117c67b858_Out_2_Vector4;
            Unity_Add_float4(_Add_5da25797012a4573b9295f462a9e99e0_Out_2_Vector4, float4(0, 0, 0, 0), _Add_a47c008b6c174c32a2fe25117c67b858_Out_2_Vector4);
            float4 _Add_7b729037ba5d4763818ac5ce7c552c5e_Out_2_Vector4;
            Unity_Add_float4(_Add_7885016d549b4ec1956c048a65b86b84_Out_2_Vector4, _Add_a47c008b6c174c32a2fe25117c67b858_Out_2_Vector4, _Add_7b729037ba5d4763818ac5ce7c552c5e_Out_2_Vector4);
            surface.BaseColor = (_SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_RGBA_0_Vector4.xyz);
            surface.Emission = (_Add_7b729037ba5d4763818ac5ce7c552c5e_Out_2_Vector4.xyz);
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
        float4 _Metallic_TexelSize;
        float _BH;
        float4 _Break_Emi_TexelSize;
        float4 _BeamLow_Emi_TexelSize;
        float _BL;
        float4 _IndicatorLeft_Emi_TexelSize;
        float _IR;
        float _IL;
        float4 _IndicatorRight_Emi_TexelSize;
        float _REV;
        float4 _Reverse_Emi_TexelSize;
        float4 _BeamHigh_Emi_TexelSize;
        float _BR;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Base);
        SAMPLER(sampler_Base);
        TEXTURE2D(_Metallic);
        SAMPLER(sampler_Metallic);
        TEXTURE2D(_Break_Emi);
        SAMPLER(sampler_Break_Emi);
        TEXTURE2D(_BeamLow_Emi);
        SAMPLER(sampler_BeamLow_Emi);
        TEXTURE2D(_IndicatorLeft_Emi);
        SAMPLER(sampler_IndicatorLeft_Emi);
        TEXTURE2D(_IndicatorRight_Emi);
        SAMPLER(sampler_IndicatorRight_Emi);
        TEXTURE2D(_Reverse_Emi);
        SAMPLER(sampler_Reverse_Emi);
        TEXTURE2D(_BeamHigh_Emi);
        SAMPLER(sampler_BeamHigh_Emi);
        
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
        float4 _Metallic_TexelSize;
        float _BH;
        float4 _Break_Emi_TexelSize;
        float4 _BeamLow_Emi_TexelSize;
        float _BL;
        float4 _IndicatorLeft_Emi_TexelSize;
        float _IR;
        float _IL;
        float4 _IndicatorRight_Emi_TexelSize;
        float _REV;
        float4 _Reverse_Emi_TexelSize;
        float4 _BeamHigh_Emi_TexelSize;
        float _BR;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Base);
        SAMPLER(sampler_Base);
        TEXTURE2D(_Metallic);
        SAMPLER(sampler_Metallic);
        TEXTURE2D(_Break_Emi);
        SAMPLER(sampler_Break_Emi);
        TEXTURE2D(_BeamLow_Emi);
        SAMPLER(sampler_BeamLow_Emi);
        TEXTURE2D(_IndicatorLeft_Emi);
        SAMPLER(sampler_IndicatorLeft_Emi);
        TEXTURE2D(_IndicatorRight_Emi);
        SAMPLER(sampler_IndicatorRight_Emi);
        TEXTURE2D(_Reverse_Emi);
        SAMPLER(sampler_Reverse_Emi);
        TEXTURE2D(_BeamHigh_Emi);
        SAMPLER(sampler_BeamHigh_Emi);
        
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
        float4 _Metallic_TexelSize;
        float _BH;
        float4 _Break_Emi_TexelSize;
        float4 _BeamLow_Emi_TexelSize;
        float _BL;
        float4 _IndicatorLeft_Emi_TexelSize;
        float _IR;
        float _IL;
        float4 _IndicatorRight_Emi_TexelSize;
        float _REV;
        float4 _Reverse_Emi_TexelSize;
        float4 _BeamHigh_Emi_TexelSize;
        float _BR;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Base);
        SAMPLER(sampler_Base);
        TEXTURE2D(_Metallic);
        SAMPLER(sampler_Metallic);
        TEXTURE2D(_Break_Emi);
        SAMPLER(sampler_Break_Emi);
        TEXTURE2D(_BeamLow_Emi);
        SAMPLER(sampler_BeamLow_Emi);
        TEXTURE2D(_IndicatorLeft_Emi);
        SAMPLER(sampler_IndicatorLeft_Emi);
        TEXTURE2D(_IndicatorRight_Emi);
        SAMPLER(sampler_IndicatorRight_Emi);
        TEXTURE2D(_Reverse_Emi);
        SAMPLER(sampler_Reverse_Emi);
        TEXTURE2D(_BeamHigh_Emi);
        SAMPLER(sampler_BeamHigh_Emi);
        
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
            float3 BaseColor;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_2798ac98d19c42c5899b3175f80c6a56_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base);
            float4 _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_2798ac98d19c42c5899b3175f80c6a56_Out_0_Texture2D.tex, _Property_2798ac98d19c42c5899b3175f80c6a56_Out_0_Texture2D.samplerstate, _Property_2798ac98d19c42c5899b3175f80c6a56_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_R_4_Float = _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_RGBA_0_Vector4.r;
            float _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_G_5_Float = _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_RGBA_0_Vector4.g;
            float _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_B_6_Float = _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_RGBA_0_Vector4.b;
            float _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_A_7_Float = _SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_RGBA_0_Vector4.a;
            surface.BaseColor = (_SampleTexture2D_d9a02454f9b64150bd2dda27792ae737_RGBA_0_Vector4.xyz);
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