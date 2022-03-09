Shader "Custom/SpliteAnimation_Task4"
{
    Properties
    {
        [NoScaleOffset]
        _MainTex ("Texture", 2D) = "white" {}
        
        _Width ("Width Separate", int) = 8      // x軸方向への分割数
        _Height ("Height Separate", int) = 8    // y軸方向への分割数
        _Sec ("Change Sec" , float) = 0.1       // 切り替え速度
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
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
            float _Sec;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                float2 xy = 1.0 / float2 (_Width, _Height);
                
                float index = floor(_Time.y / _Sec % (_Width * _Height));
                
                // o.uv = TRANSFORM_TEX(v.uv, _MainTex) * xy + float2(index % _Width, index % _Height) * xy;
                // o.uv = TRANSFORM_TEX(v.uv, _MainTex) + float2(index % _Width, floor(index / _Width)) * xy;
                
                o.uv = TRANSFORM_TEX(v.uv, _MainTex) * xy + float2 (index % _Width, floor(index / _Height)) * xy;
                
                // float2 index2 = float2(floor(index % _Width), floor(index / _Width));
                // o.uv = (index2 + v.uv) * xy;
                
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
