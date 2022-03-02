Shader "Example/02"
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
            #pragma vertex VSMain	   // ���_�V�F�[�_�[�̓����
            #pragma fragment PSMain    // �t���O�����g�V�F�[�_�[�̓����

            // ���_�V�F�[�_�[�ւ̓��͒��_�\����
            struct VSInput
            {
                float4 pos : POSITION;
            };

            // ���_�V�F�[�_�[�̏o�͒��_�\����
            struct VSOutput
            {
                float4 pos : SV_POSITION;
            };

            // ���_�V�F�[�_�[
            VSOutput VSMain(VSInput In)
            {
                VSOutput vsOut;
                vsOut.pos = UnityObjectToClipPos(In.pos);
                return vsOut;
            }

            // �}�e���A���Ŏw�肵��Color
            fixed4 _Color;

            // �t���O�����g�V�F�[�_�[
            fixed4 PSMain(VSOutput vsOut) : SV_Target
            {
                return _Color; // �}�e���A���Ŏw�肵��Color��ԋp
            }
            ENDCG
        }
    }
}
