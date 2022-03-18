Shader "Day3/Phong_Task1"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };
            
            struct v2f
            {
                float4 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };
            
            sampler2D _MainTex;
            float4 _MainTex_ST;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex); // MVP変換
                o.uv = v.vertex;
                o.normal = mul(unity_ObjectToWorld, v.normal);
                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                float3 ligDirection = normalize(_WorldSpaceLightPos0.xyz);
                fixed3 ligColor = _LightColor0.xyz;
                float3 refVec = reflect(ligDirection, i.normal); // 反射ベクトルを求める
                
                // 光が当たったサーフェース(カメラ)から、視線に伸びる視線ベクトルを求める
                float3 toEye = _WorldSpaceCameraPos - i.uv;
                toEye = normalize(toEye); // 正規化
                
                // 反射ベクトルと視線ベクトルから、内積を求める
                float t = dot(refVec, toEye);
                // 内積tがマイナスになるので0.0にする
                if (t < 0.0f)
                {
                    t = 0.0f;
                }
                // 鏡面反射の強さを絞る
                t = pow(t, 5.0f);
                
                float3 specularLig = ligColor * t; // 鏡面反射光を求める
                float3 diffuseLig = ligColor * t; // 拡散反射光を求める
                float3 lig = diffuseLig + specularLig; // 拡散反射光と鏡面反射光を足す
                float4 finalColor = float4(1,1,1,1);
                finalColor.xyz *= lig; // 乗算で最終的な出力カラーを求める
                
                return finalColor;
            }
            ENDCG
        }
    }
}
