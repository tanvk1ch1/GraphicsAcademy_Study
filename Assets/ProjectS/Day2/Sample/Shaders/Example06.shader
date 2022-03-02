Shader "Example/06"
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
        // source と destination
        Blend One One                   // 加算合成
        // Blend OneMinusDstColor One	  // ソフトな加算合成
        // Blend DstColor Zero             // 乗算合成
        // Blend DstColor SrcColor         // 2x 乗算合成

        // BlendOp Add // ()
        // BlendOp Sub // ()
        // BlendOp RevSub // (destinationからソースを減算)
        // BlendOp Min // (sourceとdestinationから小さい方を使用する)
        BlendOp Max // (sourceとdestinationから大きい方を使用する)

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
