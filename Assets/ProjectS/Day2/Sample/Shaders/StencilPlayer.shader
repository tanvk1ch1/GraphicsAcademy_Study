Shader "Example/StencilPlayer"
{
    Properties
    {
        _Color("Main Color", Color) = (1,1,1,1)
        _MainTex("Texture", 2D) = "white" {}
    }
        SubShader
    {
        Tags {"Queue" = "Geometry+1" }

        // �X�e���V���o�b�t�@�̍X�V�̂�
        Pass
        {
            ZTest Always        // �[�x�ɍ��E���ꂸ�ɏ�������
            Stencil
            {
                Ref 1
                Comp Equal      // 1�ƈ�v������̂ɑ΂��ď���
                Pass IncrSat    // �C���N�������g����(1 + 1 = 2)
            }
            ColorMask 0         // �X�e���V���̂ݏ�������
            ZWrite Off          // �f�v�X�o�b�t�@�ɏ������܂Ȃ�
        }

        // �B��Ă��Ȃ�������`��
        Pass{
            Stencil
            {
                Ref 3
                Comp Always     // ZTest Always�ł͂Ȃ��̂ŉB��Ă��镔���͑ΏۊO
                Pass Replace    // �X�e���V���o�b�t�@��3�ɏ�������
            }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

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

            fixed4 _Color;
            sampler2D _MainTex;

            fixed4 frag(v2f i) : COLOR
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                col *= _Color;
                return col;
            }
            ENDCG
        }

        Pass
        {
            ZTest Always    // �[�x�Ɋւ�炸�`��
            Stencil
            {
                Ref 2
                Comp Equal  // 2�ƈ�v�������
            }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

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

            fixed4 _Color;
            sampler2D _MainTex;

            fixed4 frag(v2f i) : COLOR
            {
                float alpha = tex2D(_MainTex, i.uv).a;
                fixed4 col = fixed4(0,0,0,alpha);
                return col;
            }
            ENDCG
        }
    }
}