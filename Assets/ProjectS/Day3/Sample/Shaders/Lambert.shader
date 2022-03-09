Shader "Day3/Lambert"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        Pass
        {
            Tags { "LightMode" = "ForwardBase" }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            struct appdata
            {
                float4 vertex   : POSITION;
                float3 normal   : NORMAL;
                float2 uv       : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex   : SV_POSITION;
                float3 normal   : NORMAL;
                float2 uv       : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert(appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);  // MVP�ϊ�
                // step-6 ���_�@�����s�N�Z���V�F�[�_�[�ɓn��
                o.normal = UnityObjectToWorldNormal(v.normal); // �@������]������
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // step-2 �f�B���N�V�������C�g�̃f�[�^���쐬����
                float3 ligDirection = normalize(_WorldSpaceLightPos0.xyz);

                // step-7 �s�N�Z���̖@���ƃ��C�g�̕����̓��ς��v�Z����
                float t = dot(i.normal, ligDirection);

                // �f�B���N�V���i�����C�g(_WorldSpaceLightPos0)��
                // ���[���h��ԍ��W�ɂȂ��Ă��܂��B
                // ����ADirectX�̃T���v���R�[�h�̓��f����Ԃ̂܂܂̂���
                // ���̕␳�����邽�߂Ɂu���ς̌��ʂ�-1����Z����v��
                // ���Ă���Ɨ\�z�B�����ł͕s�v�Ȃ��߃R�����g�ɂ��܂��B
                // ���ς̌��ʂ�-1����Z����
                //t *= -1.0f;

                // step-8 ���ς̌��ʂ�0�ȉ��Ȃ�0�ɂ���
                if (t < 0.0f)
                {
                    t = 0.0f;
                }
                // ����if���̑���ɁAt = max(0.0f, t); �܂��� t = saturate(t); �����p�\

                // step-9 �s�N�Z�����󂯂Ă��郉�C�g�̌������߂�
                fixed3 ligColor = _LightColor0.xyz; // #include "Lighting.cginc" �ɂĒ�`
                fixed3 diffuseLig = ligColor * t;

                float4 finalColor = tex2D(_MainTex, i.uv);

                // step-10 �ŏI�o�̓J���[�Ɍ�����Z����
                finalColor.xyz *= diffuseLig;

                return finalColor;
            }
            ENDCG
        }
    }
}
