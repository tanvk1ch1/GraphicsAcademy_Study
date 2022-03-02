Shader "Example/01"
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
            #pragma vertex vert		// 頂点シェーダーの入り口
            #pragma fragment frag	// フラグメントシェーダーの入り口

            // 頂点シェーダー
            float4 vert(float4 vertex : POSITION) : SV_POSITION
            {
                return UnityObjectToClipPos(vertex);
            }

            // マテリアルで指定した_Color
            fixed4 _Color;

            // フラグメントシェーダー
            fixed4 frag() : SV_Target
            {
                return _Color; // マテリアルで指定したColorを返却
            }
            ENDCG
        }
    }
}
