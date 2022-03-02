Shader "Example/02"
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
            #pragma vertex VSMain	   // 頂点シェーダーの入り口
            #pragma fragment PSMain    // フラグメントシェーダーの入り口

            // 頂点シェーダーへの入力頂点構造体
            struct VSInput
            {
                float4 pos : POSITION;
            };

            // 頂点シェーダーの出力頂点構造体
            struct VSOutput
            {
                float4 pos : SV_POSITION;
            };

            // 頂点シェーダー
            VSOutput VSMain(VSInput In)
            {
                VSOutput vsOut;
                vsOut.pos = UnityObjectToClipPos(In.pos);
                return vsOut;
            }

            // マテリアルで指定したColor
            fixed4 _Color;

            // フラグメントシェーダー
            fixed4 PSMain(VSOutput vsOut) : SV_Target
            {
                return _Color; // マテリアルで指定したColorを返却
            }
            ENDCG
        }
    }
}
