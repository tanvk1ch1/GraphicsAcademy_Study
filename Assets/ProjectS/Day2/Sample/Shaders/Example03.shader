Shader "Example/03"
{
    Properties
    {
        // インスペクターに「Main Color」プロパティを表示します。
        _Color("Main Color", Color) = (1,1,1,1)
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert	   // 頂点シェーダーの入り口
            #pragma fragment frag    // フラグメントシェーダーの入り口

            // 頂点シェーダーへの入力頂点構造体
            struct appdata
            {
                float4 vertex : POSITION;
            };

            // 頂点シェーダーの出力頂点構造体
            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            // 頂点シェーダー
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            // マテリアルで指定したColor
            fixed4 _Color;

            // フラグメントシェーダー
            fixed4 frag(v2f i) : SV_Target
            {
                return _Color; // マテリアルで指定したColorを返却
            }
            ENDCG
        }
    }
}
