Shader "Hidden/MultiLight"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }

        Pass
        {
            Tags { "LightMode" = "ForwardBase" }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // VERTEXLIGHT_ONなどが定義されたバリアントが生成される
            #pragma multi_compile_fwdbase

            #include "UnityCG.cginc"
            #include "AutoLight.cginc"

            struct appdata
            {
                half4 vertex : POSITION;
                half3 normal : NORMAL;
                half2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                half4 pos : SV_POSITION;
                half2 uv : TEXCOORD0;
                half3 normal: TEXCOORD1;
                half3 ambient: TEXCOORD2;
                half3 worldPos: TEXCOORD3;
                LIGHTING_COORDS(4, 5)
            };

            sampler2D _MainTex;
            half4 _MainTex_ST;
            half4 _LightColor0;

            v2f vert(appdata v)
            {
                v2f o = (v2f)0;

                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);

            // UnityStandardCoreの処理を参考に
            #if UNITY_SHOULD_SAMPLE_SH

               #if defined(VERTEXLIGHT_ON)
                o.ambient = Shade4PointLights(
                    unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
                    unity_LightColor[0].rgb, unity_LightColor[1].rgb,
                    unity_LightColor[2].rgb, unity_LightColor[3].rgb,
                    unity_4LightAtten0, o.worldPos, o.normal
                );
               #endif
                o.ambient += max(0, ShadeSH9(float4(o.normal, 1)));
            #else
                o.ambient = 0;
            #endif

            return o;
        }

        fixed4 frag(v2f i) : SV_Target
        {
            half4 col = tex2D(_MainTex, i.uv);

            // AutoLightに定義されているマクロで減衰を計算する
            UNITY_LIGHT_ATTENUATION(attenuation, i, i.normal);
            half3 diff = max(0, dot(i.normal, _WorldSpaceLightPos0.xyz)) * _LightColor0 * attenuation;
            col.rgb *= diff;
            col.rgb += i.ambient;
            return col;
        }
        ENDCG
    }

    Pass {

        Tags { "LightMode" = "ForwardAdd" }

        Blend One One
        ZWrite Off

            CGPROGRAM
           #pragma vertex vert
           #pragma fragment frag
           #pragma multi_compile_fwdadd

           #include "UnityCG.cginc"
           #include "AutoLight.cginc"

            struct appdata
            {
                half4 vertex : POSITION;
                half3 normal : NORMAL;
                half2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                half4 pos : SV_POSITION;
                half2 uv : TEXCOORD0;
                half3 normal: TEXCOORD1;
                half3 ambient: TEXCOORD2;
                half3 worldPos: TEXCOORD3;
                LIGHTING_COORDS(4, 5)
            };

            sampler2D _MainTex;
            half4 _MainTex_ST;
            half4 _LightColor0;

            v2f vert(appdata v)
            {
                v2f o = (v2f)0;

                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);

                return o;
            }

            half4 frag(v2f i) : COLOR
            {
                half4 col = tex2D(_MainTex, i.uv);

                // _WorldSpaceLightPos0.wはディレクショナルライトだったら0、それ以外は1となる
                half3 lightDir;
                if (_WorldSpaceLightPos0.w > 0) {
                    lightDir = _WorldSpaceLightPos0.xyz - i.worldPos.xyz;
                } else {
                    lightDir = _WorldSpaceLightPos0.xyz;
                }
                lightDir = normalize(lightDir);

                UNITY_LIGHT_ATTENUATION(attenuation, i, i.normal);
                half3 diff = max(0, dot(i.normal, lightDir)) * _LightColor0 * attenuation;
                col.rgb *= diff;
                return col;
            }
            ENDCG
            }
    }
}