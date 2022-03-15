Shader "Custom/SpliteAnimation_Task5"
{
    Properties
    {
        [NoScaleOffset]
        _MainTex ("Texture", 2D) = "white" {}
        _Width ("Width Separate", int) = 4 // 縦情報の分割
        _Height ("Height Separate", int) = 4 // 横情報の分割
        _Sec ("Change Sec", float) = 0.1 // アニメーション切替速度
    }
    SubShader
    {
        //! テクスチャを透過させる
        Tags { "RenderType"="Transparent" "Queue" = "Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 100
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
            
            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };
            
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Width;
            float _Height;
            half _Sec;
            
            v2f vert (appdata v)
            {
                v2f o;
                // 1の分割。uv=0~1
                float2 xy = 1.0f / float2 (_Width, _Height);
                // gridを何番目で出すか
                float index = floor(_Time.y / _Sec % (_Width * _Height));
                o.vertex = UnityObjectToClipPos(v.vertex);
                // uvをずらす
                o.uv = TRANSFORM_TEX(v.uv, _MainTex) * xy + float2(index % _Width, 1.0 - floor(index / _Height)) * xy;
                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                return tex2D(_MainTex, i.uv);
            }
            ENDCG
        }
    }
}
