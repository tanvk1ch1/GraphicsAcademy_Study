Shader "Day3/ToonLit_Task2"
{
	Properties
	{
		_Color ("Main Color", Color) = (0.5, 0.5, 0.5, 1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Ramp ("Toon Ramp (RGB)", 2D) = "gray" {} 
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		// 1パス目
		Pass
		{
			// CGPROGRAM
			// #pragma surface surf ToonRamp
			// sampler2D _Ramp;
			// #pragma lighting ToonRamp exclude_path:prepass
			//
			// inline half4 LightingToonRamp (SurfaceOutput s, half3 lightDir, half atten)
			// {
			// 	#ifndef USING_DIRECTIONAL_LIGHT
			// 	lightDir = normalize(lightDir);
			// 	#endif
			// 	
			// 	half d = dot (s.Normal, lightDir)*0.5 + 0.5;
			// 	half3 ramp = tex2D (_Ramp, float2(d,d)).rgb;
			// 	
			// 	half4 c;
			// 	c.rgb = s.Albedo * _LightColor0.rgb * ramp * (atten * 2);
			// 	c.a = 0;
			// 	return c;
			// }
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

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex); // MVP変換
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
            {
            	
            }
			// struct Input
			// {
			// 	float2 uv_MainTex : TEXCOORD0;
			// };
			//
			// void surf (Input IN, inout SurfaceOutput o)
			// {
			// 	half4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			// 	o.Albedo = c.rgb;
			// 	o.Alpha = c.a;
			// }
			ENDCG
		}
		// 2パス目
		Pass
		{
			
		}
	} 
	//Fallback "Diffuse"
}
