Shader "Day3/Lambert_Task1"
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
            Tags { "LightMode" = "ForwardBase"}
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            #include "Lighting.cginc" // ライティング考慮に必要
            
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };
            
            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };
            
            sampler2D _MainTex;
            float4 _MainTex_ST;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex); // MVP変換
                o.normal = UnityObjectToWorldNormal(v.normal); // 法線を回転させる
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                // ディレクションライトのデータを作成
                float3 ligDirection = normalize(_WorldSpaceLightPos0.xyz);
                
                // ピクセルの法線とライトの方向の内積を計算
                float t = dot(i.normal, ligDirection);
                
                // 内積の結果が0以下なら0にする
                if (t < 0.0f)
                {
                    t = 0.0f;
                }
                
                // ピクセルが受けているライトの光を求める
                fixed3 ligColor = _LightColor0.xyz;
                fixed3 diffuseLig = ligColor * t;
                
                float4 finalColor = tex2D(_MainTex, i.uv);
                
                // 最終出力カラーに光を乗算する
                finalColor.xyz *= diffuseLig;
                
                return finalColor;
            }
            ENDCG
        }
    }
}
