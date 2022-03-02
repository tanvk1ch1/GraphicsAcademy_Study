Shader "Example/StencilPlayer"
{
    Properties
    {
        _Color("Main Color", Color) = (1,1,1,1)
        _MainTex("Texture", 2D) = "white" {}
    }
        SubShader
    {
        Tags {"Queue" = "Geometry+1" }

        // ステンシルバッファの更新のみ
        Pass
        {
            ZTest Always        // 深度に左右されずに書き込む
            Stencil
            {
                Ref 1
                Comp Equal      // 1と一致するものに対して処理
                Pass IncrSat    // インクリメントする(1 + 1 = 2)
            }
            ColorMask 0         // ステンシルのみ書き込み
            ZWrite Off          // デプスバッファに書き込まない
        }

        // 隠れていない部分を描画
        Pass{
            Stencil
            {
                Ref 3
                Comp Always     // ZTest Alwaysではないので隠れている部分は対象外
                Pass Replace    // ステンシルバッファを3に書き換え
            }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            // 頂点シェーダーへの入力頂点構造体
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            // 頂点シェーダーの出力頂点構造体
            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            // 頂点シェーダー
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 _Color;
            sampler2D _MainTex;

            fixed4 frag(v2f i) : COLOR
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                col *= _Color;
                return col;
            }
            ENDCG
        }

        Pass
        {
            ZTest Always    // 深度に関わらず描画
            Stencil
            {
                Ref 2
                Comp Equal  // 2と一致するもの
            }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            // 頂点シェーダーへの入力頂点構造体
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            // 頂点シェーダーの出力頂点構造体
            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            // 頂点シェーダー
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 _Color;
            sampler2D _MainTex;

            fixed4 frag(v2f i) : COLOR
            {
                float alpha = tex2D(_MainTex, i.uv).a;
                fixed4 col = fixed4(0,0,0,alpha);
                return col;
            }
            ENDCG
        }
    }
}