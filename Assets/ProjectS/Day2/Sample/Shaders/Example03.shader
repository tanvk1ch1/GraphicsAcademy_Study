Shader "Example/03"
{
    Properties
    {
        // �C���X�y�N�^�[�ɁuMain Color�v�v���p�e�B��\�����܂��B
        _Color("Main Color", Color) = (1,1,1,1)
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert	   // ���_�V�F�[�_�[�̓����
            #pragma fragment frag    // �t���O�����g�V�F�[�_�[�̓����

            // ���_�V�F�[�_�[�ւ̓��͒��_�\����
            struct appdata
            {
                float4 vertex : POSITION;
            };

            // ���_�V�F�[�_�[�̏o�͒��_�\����
            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            // ���_�V�F�[�_�[
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            // �}�e���A���Ŏw�肵��Color
            fixed4 _Color;

            // �t���O�����g�V�F�[�_�[
            fixed4 frag(v2f i) : SV_Target
            {
                return _Color; // �}�e���A���Ŏw�肵��Color��ԋp
            }
            ENDCG
        }
    }
}
