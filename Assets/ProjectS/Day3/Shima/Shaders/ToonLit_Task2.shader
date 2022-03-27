Shader "Day3/ToonLit_Task2"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_OutlineWidth ("Outline width", Range (0.005, 0.03)) = 0.01
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		// 1パス目 (単純にテクスチャそのまま)
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
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex); // MVP変換
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				return col;
			}
			ENDCG
		}
		
		// 2パス目 (アウトライン)
		Pass
		{
			Cull Front
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			
			float  _OutlineWidth;
			float4 _OutlineColor;
			
			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};
			
			struct v2f
			{
				float4 vert : SV_POSITION;
			};
			
			// 頂点シェーダー
			v2f vert(appdata v)
			{
				v2f o;
				// オブジェクト座標をクリップ座標に変換
				o.vert = UnityObjectToClipPos(v.vertex);
				
				// 法線をモデル座標系からビュー座標系に変換して正規化する
				// v.normalはモデル原点を基準にした法線方向
				// カメラから見た法線方向に変換
				float3 normal = normalize(mul((float3x3)UNITY_MATRIX_IT_MV, v.normal));
				
				// ビュー座標系に変換した法線を投影座標系に変換
				// アウトラインの描画を行う
				float2 offset = TransformViewToProjection(normal.xy);
				// クリップ座標に足す(ベクトル*太さ)
				o.vert.xy += offset * _OutlineWidth;
				
				return o;
			}
			
			// フラグメントシェーダー
			fixed4 frag(v2f i) : SV_Target
			{
				return _OutlineColor;
			}
			ENDCG
		}
	}
}
