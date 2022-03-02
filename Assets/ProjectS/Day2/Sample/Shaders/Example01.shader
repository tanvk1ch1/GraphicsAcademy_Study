Shader "Example/01"
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
            #pragma vertex vert		// ���_�V�F�[�_�[�̓����
            #pragma fragment frag	// �t���O�����g�V�F�[�_�[�̓����

            // ���_�V�F�[�_�[
            float4 vert(float4 vertex : POSITION) : SV_POSITION
            {
                return UnityObjectToClipPos(vertex);
            }

            // �}�e���A���Ŏw�肵��_Color
            fixed4 _Color;

            // �t���O�����g�V�F�[�_�[
            fixed4 frag() : SV_Target
            {
                return _Color; // �}�e���A���Ŏw�肵��Color��ԋp
            }
            ENDCG
        }
    }
}
