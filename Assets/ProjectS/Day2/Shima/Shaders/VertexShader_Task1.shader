Shader "Custom/VertexShader_Task1"
{
    Properties
    {
        [NoScaleOffset]
        _MainTex("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque"}
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex      vert
            #pragma fragment    frag
            
            // 頂点シェーダー入力頂点構造体
            struct appdata
            {
                float4 vertex   : POSITION;
                fixed4 color    : COLOR;        // セマンティクスに頂点カラーを指定
            };
            
            // 頂点シェーダー出力頂点構造体
            struct v2f
            {
                float4 vertex   : SV_POSITION;
                fixed4 color    : COLOR0;        // カラーの情報を出力
            };

            sampler2D   _MainTex;
            float4      _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.color  = v.color;             
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return i.color;                 // カラーをそのまま出力
            }
            ENDCG
        }
    }
}
