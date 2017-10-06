// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Shader created with Shader Forge v1.04 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.04;sub:START;pass:START;ps:flbk:Bumped Specular,lico:1,lgpr:1,nrmq:1,limd:1,uamb:True,mssp:True,lmpd:False,lprd:False,rprd:False,enco:False,frtr:True,vitr:True,dbil:False,rmgx:True,rpth:0,hqsc:True,hqlp:False,tesm:0,blpr:0,bsrc:0,bdst:1,culm:0,dpts:2,wrdp:True,dith:2,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.6544118,fgcg:0.5928201,fgcb:0.5004326,fgca:1,fgde:0.005,fgrn:0,fgrf:300,ofsf:0,ofsu:0,f2p0:False;n:type:ShaderForge.SFN_Final,id:5409,x:32719,y:32712,varname:node_5409,prsc:2|diff-9390-RGB,spec-590-RGB,gloss-1566-OUT,normal-8810-RGB,emission-6763-OUT,amdfl-3624-RGB;n:type:ShaderForge.SFN_Tex2d,id:9390,x:32332,y:32714,ptovrint:False,ptlb:diffuse,ptin:_diffuse,varname:node_9390,prsc:2,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Slider,id:1566,x:32147,y:32894,ptovrint:False,ptlb:gloss,ptin:_gloss,varname:node_1566,prsc:2,min:0,cur:0,max:4;n:type:ShaderForge.SFN_Tex2d,id:2734,x:32143,y:33117,ptovrint:False,ptlb:illumination,ptin:_illumination,varname:node_2734,prsc:2,ntxv:2,isnm:False;n:type:ShaderForge.SFN_Color,id:2736,x:32256,y:33303,ptovrint:False,ptlb:illumcolor,ptin:_illumcolor,varname:node_2736,prsc:2,glob:False,c1:1,c2:0.7273834,c3:0.3823529,c4:1;n:type:ShaderForge.SFN_Multiply,id:6763,x:32463,y:33271,varname:node_6763,prsc:2|A-2736-RGB,B-2734-RGB;n:type:ShaderForge.SFN_Tex2d,id:8810,x:32359,y:33027,ptovrint:False,ptlb:normalmap,ptin:_normalmap,varname:node_8810,prsc:2,ntxv:3,isnm:True;n:type:ShaderForge.SFN_Color,id:590,x:32524,y:32523,ptovrint:False,ptlb:speccolor,ptin:_speccolor,varname:node_590,prsc:2,glob:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Color,id:3624,x:32204,y:32604,ptovrint:False,ptlb:diffusecolor,ptin:_diffusecolor,varname:node_3624,prsc:2,glob:False,c1:0.5,c2:0.5,c3:0.5,c4:1;proporder:9390-1566-2734-2736-8810-590-3624;pass:END;sub:END;*/

Shader "custom/building" {
    Properties {
        _diffuse ("diffuse", 2D) = "white" {}
        _gloss ("gloss", Range(0, 4)) = 0
        _illumination ("illumination", 2D) = "black" {}
        _illumcolor ("illumcolor", Color) = (1,0.7273834,0.3823529,1)
        _normalmap ("normalmap", 2D) = "bump" {}
        _speccolor ("speccolor", Color) = (0.5,0.5,0.5,1)
        _diffusecolor ("diffusecolor", Color) = (0.5,0.5,0.5,1)
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform sampler2D _diffuse; uniform float4 _diffuse_ST;
            uniform float _gloss;
            uniform sampler2D _illumination; uniform float4 _illumination_ST;
            uniform float4 _illumcolor;
            uniform sampler2D _normalmap; uniform float4 _normalmap_ST;
            uniform float4 _speccolor;
            uniform float4 _diffusecolor;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 binormalDir : TEXCOORD4;
                LIGHTING_COORDS(5,6)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = mul(unity_ObjectToWorld, float4(v.normal,0)).xyz;
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.binormalDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos(v.vertex);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.binormalDir, i.normalDir);
/////// Vectors:
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 _normalmap_var = UnpackNormal(tex2D(_normalmap,TRANSFORM_TEX(i.uv0, _normalmap)));
                float3 normalLocal = _normalmap_var.rgb;
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
///////// Gloss:
                float gloss = _gloss;
                float specPow = exp2( gloss * 10.0+1.0);
////// Specular:
                float NdotL = max(0, dot( normalDirection, lightDirection ));
                float3 specularColor = _speccolor.rgb;
                float3 directSpecular = (floor(attenuation) * _LightColor0.xyz) * pow(max(0,dot(halfDirection,normalDirection)),specPow);
                float3 specular = directSpecular * specularColor;
/////// Diffuse:
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 indirectDiffuse = float3(0,0,0);
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                indirectDiffuse += UNITY_LIGHTMODEL_AMBIENT.rgb; // Ambient Light
                indirectDiffuse += _diffusecolor.rgb; // Diffuse Ambient Light
                float4 _diffuse_var = tex2D(_diffuse,TRANSFORM_TEX(i.uv0, _diffuse));
                float3 diffuse = (directDiffuse + indirectDiffuse) * _diffuse_var.rgb;
////// Emissive:
                float4 _illumination_var = tex2D(_illumination,TRANSFORM_TEX(i.uv0, _illumination));
                float3 emissive = (_illumcolor.rgb*_illumination_var.rgb);
/// Final Color:
                float3 finalColor = diffuse + specular + emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
        Pass {
            Name "ForwardAdd"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            
            
            Fog { Color (0,0,0,0) }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform sampler2D _diffuse; uniform float4 _diffuse_ST;
            uniform float _gloss;
            uniform sampler2D _illumination; uniform float4 _illumination_ST;
            uniform float4 _illumcolor;
            uniform sampler2D _normalmap; uniform float4 _normalmap_ST;
            uniform float4 _speccolor;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 binormalDir : TEXCOORD4;
                LIGHTING_COORDS(5,6)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = mul(unity_ObjectToWorld, float4(v.normal,0)).xyz;
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.binormalDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos(v.vertex);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.binormalDir, i.normalDir);
/////// Vectors:
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 _normalmap_var = UnpackNormal(tex2D(_normalmap,TRANSFORM_TEX(i.uv0, _normalmap)));
                float3 normalLocal = _normalmap_var.rgb;
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
///////// Gloss:
                float gloss = _gloss;
                float specPow = exp2( gloss * 10.0+1.0);
////// Specular:
                float NdotL = max(0, dot( normalDirection, lightDirection ));
                float3 specularColor = _speccolor.rgb;
                float3 directSpecular = attenColor * pow(max(0,dot(halfDirection,normalDirection)),specPow);
                float3 specular = directSpecular * specularColor;
/////// Diffuse:
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                float4 _diffuse_var = tex2D(_diffuse,TRANSFORM_TEX(i.uv0, _diffuse));
                float3 diffuse = directDiffuse * _diffuse_var.rgb;
/// Final Color:
                float3 finalColor = diffuse + specular;
                return fixed4(finalColor * 1,0);
            }
            ENDCG
        }
    }
    FallBack "Bumped Specular"
    CustomEditor "ShaderForgeMaterialInspector"
}
