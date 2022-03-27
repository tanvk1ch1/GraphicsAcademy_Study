Shader "Day5/Bloom"
{
    Properties{
        _MainTex("Texture", 2D) = "white" {}
    }

    CGINCLUDE
    #include "UnityCG.cginc"

    sampler2D _MainTex;
    float4 _MainTex_ST;
    float2 _MainTex_TexelSize;  // テクセルサイズ
    float4 _MainTex_HDR;        // HDRテクスチャ

    // Vertex Input
    struct appdata {
        float4 vertex : POSITION;
        float2 uv     : TEXCOORD0;
    };

    // Vertex to Fragment
    struct v2f {
        float4 pos : SV_POSITION;
        float2 uv  : TEXCOORD0;
    };

    // 頂点シェーダー(全Pass共通)
    v2f vert(appdata v) {
        v2f o;
        o.pos = UnityObjectToClipPos(v.vertex);
        o.uv = TRANSFORM_TEX(v.uv, _MainTex);
        return o;
    }
    ENDCG

    SubShader
    {
        Cull Off        // カリングは不要
        ZTest Always    // ZTestは常に通す
        ZWrite Off      // ZWriteは不要

        Tags { "RenderType" = "Opaque" }

        //0: SamplingLuminanceシェーダー
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            fixed4  frag(v2f i) : SV_Target
            {
                // メインレンダリングターゲットからカラーをサンプリング
                fixed4  color = tex2D(_MainTex, i.uv);

                // サンプリングしたカラーの明るさを計算
                float t = dot(color.xyz, float3(0.2125f, 0.7154f, 0.0721f));

                // clip()関数は引数の値がマイナスになると、以降の処理をスキップする
                // なので、マイナスになるとピクセルカラーは出力されない
                // 今回の実装はカラーの明るさが1以下ならピクセルキルする
                clip(t - 1.0f);

                return color;
            }
            ENDCG
        }

        //1: Blurシェーダー(ガウシアンブラー)
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float2 _Direction;         // ガウシアンブラーをかける方向
            static const int WEIGHT_SIZE = 8;

            fixed4  frag(v2f i) : SV_Target
            {
                // ガウシアン関数で事前計算した重みテーブル
                float weights[WEIGHT_SIZE] = {
                    0.12445063, 0.116910554, 0.096922256, 0.070909835,
                    0.04578283, 0.02608627,  0.013117,    0.0058206334
                };

                // _MainTex_TexelSize
                // x : 1.0 / 幅
                // y : 1.0 / 高さ
                // z : 幅
                // w : 高さ
                float2 dir = _Direction * _MainTex_TexelSize.xy;

                fixed4  color = 0;
                for (int j = 0; j < WEIGHT_SIZE; j++) {
                    float2 offset = dir * ((j + 1) * 2 - 1);
                    color.rgb += tex2D(_MainTex, i.uv + offset) * weights[j];
                    color.rgb += tex2D(_MainTex, i.uv - offset) * weights[j];
                }
                color.a = 1;

                return color;
            }
            ENDCG
        }

        //2: BloomFinalシェーダー
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _Boke0;
            sampler2D _Boke1;
            sampler2D _Boke2;
            sampler2D _Boke3;

            fixed4  frag(v2f i) : SV_Target
            {
                // step-6 ボケ画像をサンプリングして、平均をとって出力する
                fixed4  combineColor = 0;
                combineColor += tex2D(_Boke0, i.uv);
                combineColor += tex2D(_Boke1, i.uv);
                combineColor += tex2D(_Boke2, i.uv);
                combineColor += tex2D(_Boke3, i.uv);
                combineColor /= 4.0f;
                
                // オリジナルはアルファブレンディングでしたが、
                // ここでは処理簡略化して単なる加算にしています。
                combineColor = tex2D(_MainTex, i.uv) + combineColor;

                combineColor.a = 1.0f;

                return combineColor;
            }
            ENDCG
        }
    }
}
