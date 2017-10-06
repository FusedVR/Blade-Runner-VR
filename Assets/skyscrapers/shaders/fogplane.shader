// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Shader created with Shader Forge v1.04 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.04;sub:START;pass:START;ps:flbk:Transparent/Diffuse,lico:1,lgpr:1,nrmq:1,limd:1,uamb:True,mssp:True,lmpd:False,lprd:False,rprd:False,enco:False,frtr:True,vitr:True,dbil:False,rmgx:True,rpth:0,hqsc:True,hqlp:False,tesm:0,blpr:1,bsrc:3,bdst:7,culm:2,dpts:2,wrdp:False,dith:2,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.6544118,fgcg:0.5928201,fgcb:0.5004326,fgca:1,fgde:0.005,fgrn:0,fgrf:300,ofsf:0,ofsu:0,f2p0:False;n:type:ShaderForge.SFN_Final,id:3247,x:33006,y:32677,varname:node_3247,prsc:2|diff-1632-RGB,amdfl-4516-RGB,alpha-8098-OUT;n:type:ShaderForge.SFN_Color,id:1632,x:32426,y:32587,ptovrint:False,ptlb:fogcolor,ptin:_fogcolor,varname:node_1632,prsc:2,glob:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Tex2d,id:4826,x:32545,y:32959,ptovrint:False,ptlb:alphamap,ptin:_alphamap,varname:node_4826,prsc:2,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:1581,x:32562,y:33184,ptovrint:False,ptlb:fogtile,ptin:_fogtile,varname:node_1581,prsc:2,tex:1209b80a796b8844395bbfa38c8f69cb,ntxv:0,isnm:False|UVIN-3685-UVOUT;n:type:ShaderForge.SFN_Multiply,id:8098,x:32775,y:33206,varname:node_8098,prsc:2|A-4826-A,B-1581-A;n:type:ShaderForge.SFN_Panner,id:3685,x:32380,y:33184,varname:node_3685,prsc:2,spu:1,spv:1|DIST-4982-OUT;n:type:ShaderForge.SFN_Color,id:4516,x:32355,y:32797,ptovrint:False,ptlb:ambientcolor,ptin:_ambientcolor,varname:node_4516,prsc:2,glob:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Time,id:1668,x:32004,y:33217,varname:node_1668,prsc:2;n:type:ShaderForge.SFN_ValueProperty,id:5314,x:31988,y:33411,ptovrint:False,ptlb:speed,ptin:_speed,varname:node_5314,prsc:2,glob:False,v1:0.01;n:type:ShaderForge.SFN_Power,id:4982,x:32192,y:33235,varname:node_4982,prsc:2|VAL-1668-TSL,EXP-5314-OUT;proporder:1632-4826-1581-4516-5314;pass:END;sub:END;*/

Shader "custom/fogplane" {
    Properties {
        _fogcolor ("fogcolor", Color) = (0.5,0.5,0.5,1)
        _alphamap ("alphamap", 2D) = "white" {}
        _fogtile ("fogtile", 2D) = "white" {}
        _ambientcolor ("ambientcolor", Color) = (0.5,0.5,0.5,1)
        _speed ("speed", Float ) = 0.01
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform float4 _TimeEditor;
            uniform float4 _fogcolor;
            uniform sampler2D _alphamap; uniform float4 _alphamap_ST;
            uniform sampler2D _fogtile; uniform float4 _fogtile_ST;
            uniform float4 _ambientcolor;
            uniform float _speed;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = mul(unity_ObjectToWorld, float4(v.normal,0)).xyz;
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
/////// Vectors:
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                
                float nSign = sign( dot( viewDirection, i.normalDir ) ); // Reverse normal if this is a backface
                i.normalDir *= nSign;
                normalDirection *= nSign;
                
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float attenuation = 1;
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 indirectDiffuse = float3(0,0,0);
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                indirectDiffuse += UNITY_LIGHTMODEL_AMBIENT.rgb; // Ambient Light
                indirectDiffuse += _ambientcolor.rgb; // Diffuse Ambient Light
                float3 diffuse = (directDiffuse + indirectDiffuse) * _fogcolor.rgb;
/// Final Color:
                float3 finalColor = diffuse;
                float4 _alphamap_var = tex2D(_alphamap,TRANSFORM_TEX(i.uv0, _alphamap));
                float4 node_1668 = _Time + _TimeEditor;
                float2 node_3685 = (i.uv0+pow(node_1668.r,_speed)*float2(1,1));
                float4 _fogtile_var = tex2D(_fogtile,TRANSFORM_TEX(node_3685, _fogtile));
                return fixed4(finalColor,(_alphamap_var.a*_fogtile_var.a));
            }
            ENDCG
        }
        Pass {
            Name "ForwardAdd"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            Cull Off
            ZWrite Off
            
            Fog { Color (0,0,0,0) }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdadd
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform float4 _TimeEditor;
            uniform float4 _fogcolor;
            uniform sampler2D _alphamap; uniform float4 _alphamap_ST;
            uniform sampler2D _fogtile; uniform float4 _fogtile_ST;
            uniform float _speed;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                LIGHTING_COORDS(3,4)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = mul(unity_ObjectToWorld, float4(v.normal,0)).xyz;
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos(v.vertex);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
/////// Vectors:
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                
                float nSign = sign( dot( viewDirection, i.normalDir ) ); // Reverse normal if this is a backface
                i.normalDir *= nSign;
                normalDirection *= nSign;
                
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                float3 diffuse = directDiffuse * _fogcolor.rgb;
/// Final Color:
                float3 finalColor = diffuse;
                float4 _alphamap_var = tex2D(_alphamap,TRANSFORM_TEX(i.uv0, _alphamap));
                float4 node_1668 = _Time + _TimeEditor;
                float2 node_3685 = (i.uv0+pow(node_1668.r,_speed)*float2(1,1));
                float4 _fogtile_var = tex2D(_fogtile,TRANSFORM_TEX(node_3685, _fogtile));
                return fixed4(finalColor * (_alphamap_var.a*_fogtile_var.a),0);
            }
            ENDCG
        }
    }
    FallBack "Transparent/Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
