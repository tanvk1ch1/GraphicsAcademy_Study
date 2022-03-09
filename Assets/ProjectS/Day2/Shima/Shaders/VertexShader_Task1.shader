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
            
            // ���_�V�F�[�_�[���͒��_�\����
            struct appdata
            {
                float4 vertex   : POSITION;
                fixed4 color    : COLOR;        // �Z�}���e�B�N�X�ɒ��_�J���[���w��
            };
            
            // ���_�V�F�[�_�[�o�͒��_�\����
            struct v2f
            {
                float4 vertex   : SV_POSITION;
                fixed4 color    : COLOR0;        // �J���[�̏����o��
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
                return i.color;                 // �J���[�����̂܂܏o��
            }
            ENDCG
        }
    }
}
