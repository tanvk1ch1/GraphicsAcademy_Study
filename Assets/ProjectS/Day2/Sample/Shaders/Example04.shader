Shader "Example/04"
{
    Properties
    {
        // �C���X�y�N�^�[�ɁuMain Color�v�v���p�e�B��\�����܂��B
        _Color("Main Color", Color) = (1,1,1,1)
        // �e�N�X�`����ݒ�
         _MainTex("Texture", 2D) = "white" { }
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert	   // ���_�V�F�[�_�[�̓����
            #pragma fragment frag  // �t���O�����g�V�F�[�_�[�̓����

            // ���_�V�F�[�_�[�ւ̓��͒��_�\����
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            // ���_�V�F�[�_�[�̏o�͒��_�\����
            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            // ���_�V�F�[�_�[
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            // �}�e���A���Ŏw�肵��Color
            fixed4 _Color;
            // �}�e���A���Őݒ肵���e�N�X�`��
            sampler2D _MainTex;

            // �s�N�Z���V�F�[�_�[
            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                col *= _Color; // Color����Z
                return col;  
            }
            ENDCG
        }
    }
}
