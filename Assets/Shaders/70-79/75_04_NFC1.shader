﻿// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/70-79/75_04_NFC1"
{
    Properties
    {
        _Normal("Normal", 2D) = "bump" {}
    }
    
    SubShader
    {
        Pass 
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            
            sampler2D _Normal;
            float4 _Normal_ST;
            
            float3 normalFromColor(float4 col)
            {
                #if defined(UNITY_NO_DXT5nm)
                    return col.xyz * 2 - 1;
                #else
                    float3 normVal;
                    normVal = float3(col.a * 2 - 1, col.g * 2 - 1, 0.0);
                    normVal.z = sqrt(1 - (pow(normVal.x, 2) + pow(normVal.y, 2)));
                    return normVal;
                #endif
            }
            
            struct vertexInput
            {
                float4 vertex : POSITION;
                float4 texcoord : TEXCOORD0;
            };
            
            struct vertexOuput
            {
                float4 pos : SV_POSITION;
                float4 normalTexcoord : TEXCOORD0;
            };
            
            vertexOuput vert(vertexInput v)
            {
                vertexOuput o;
                UNITY_INITIALIZE_OUTPUT(vertexOuput, o);
                o.pos = UnityObjectToClipPos(v.vertex);
                o.normalTexcoord.xy = v.texcoord.xy * _Normal_ST.xy + _Normal_ST.zw; 
                return o;
            }
            
            float4 frag(vertexOuput i) : COLOR
            {
                float4 col = tex2D(_Normal, i.normalTexcoord);
                float4 norm = float4(normalFromColor(col), 0); 
                return norm;
            }
            ENDCG
        }
    }
}   