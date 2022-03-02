Shader "Example/05"
{
    Properties
    {
        // インスペクターに「Main Color」プロパティを表示します。
        _Color("Main Color", Color) = (1,1,1,1)
        // テクスチャを設定
         _MainTex("Texture", 2D) = "white" { }
    }

    SubShader
    {
        Tags { "Queue" = "Transparent" }

        Blend SrcAlpha OneMinusSrcAlpha // 一般的なアルファ合成
        //Blend One OneMinusSrcAlpha	  // プリマルチプライド・アルファ合成

        // BlendOp Add // (普通の加算っぽい)
        // BlendOp Sub // (輪の周囲が暗くなる)
        // BlendOp RevSub // (暗い輪になる)
        // BlendOp Min // (見えなくなる)
        // BlendOp Max // (真っ白になる)

        Pass
        {

            CGPROGRAM
            #pragma vertex vert	   // 頂点シェーダーの入り口
            #pragma fragment frag  // フラグメントシェーダーの入り口

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

            // マテリアルで指定したColor
            fixed4 _Color;
            // マテリアルで設定したテクスチャ
            sampler2D _MainTex;

            // ピクセルシェーダー
            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                col *= _Color; // Colorを乗算
                return col;  
            }
            ENDCG
        }
    }
}
