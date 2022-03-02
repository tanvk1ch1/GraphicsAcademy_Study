using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(MeshFilter))]
[RequireComponent(typeof(MeshRenderer))]
public class MeshGeneratorWithColor : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        CubeWithColor();
    }

    void CubeWithColor()
    {
        List<Vector3> vertices = new List<Vector3>() {
            // 0
            new Vector3(0.0f, 0.0f, 0.0f), // ����
            new Vector3(1.0f, 0.0f, 0.0f),
            new Vector3(1.0f, 1.0f, 0.0f),
            new Vector3(0.0f, 1.0f, 0.0f),
            // 4
            new Vector3(1.0f, 1.0f, 0.0f), // ���
            new Vector3(0.0f, 1.0f, 0.0f),
            new Vector3(0.0f, 1.0f, 1.0f),
            new Vector3(1.0f, 1.0f, 1.0f),
            // 8
            new Vector3(1.0f, 0.0f, 0.0f), // �E��
            new Vector3(1.0f, 1.0f, 0.0f),
            new Vector3(1.0f, 1.0f, 1.0f),
            new Vector3(1.0f, 0.0f, 1.0f),
            // 12
            new Vector3(0.0f, 0.0f, 0.0f), // ����
            new Vector3(0.0f, 1.0f, 0.0f),
            new Vector3(0.0f, 1.0f, 1.0f),
            new Vector3(0.0f, 0.0f, 1.0f),
            // 16
            new Vector3(0.0f, 1.0f, 1.0f), // �w��
            new Vector3(1.0f, 1.0f, 1.0f),
            new Vector3(1.0f, 0.0f, 1.0f),
            new Vector3(0.0f, 0.0f, 1.0f),
            // 20
            new Vector3(0.0f, 0.0f, 0.0f), // ����
            new Vector3(1.0f, 0.0f, 0.0f),
            new Vector3(1.0f, 0.0f, 1.0f),
            new Vector3(0.0f, 0.0f, 1.0f),

        };
        List<int> triangles = new List<int> {
            0, 3, 2,  0, 2, 1, //�O�� ( 0 -  3)
            5, 6, 7,  5, 7, 4, //��� ( 4 -  7)
            8, 9,10,  8,10,11, //�E�� ( 8 - 11)
           15,14,13, 15,13,12, //���� (12 - 15)
           16,18,17, 16,19,18, //���� (16 - 19)
           23,20,21, 23,21,22, //���� (20 - 23)
        };
        List<Color> colors = new List<Color>
        {
            Color.blue,
            Color.cyan,
            Color.gray,
            Color.green,
            Color.grey,
            Color.magenta,
            Color.red,
            Color.yellow,

            Color.blue,
            Color.cyan,
            Color.gray,
            Color.green,
            Color.grey,
            Color.magenta,
            Color.red,
            Color.yellow,

            Color.blue,
            Color.cyan,
            Color.gray,
            Color.green,
            Color.grey,
            Color.magenta,
            Color.red,
            Color.yellow,
        };
        

        Mesh mesh = new Mesh();             // ���b�V�����쐬
        mesh.Clear();                       // ���b�V��������
        mesh.SetVertices(vertices);         // ���b�V���ɒ��_��o�^����
        mesh.SetColors(colors);             // ���_�J���[��o�^
        mesh.SetTriangles(triangles, 0);    // ���b�V���ɃC���f�b�N�X���X�g��o�^����
        mesh.RecalculateNormals();          // �@���̍Čv�Z

        // �쐬�������b�V�������b�V���t�B���^�[�ɐݒ肷��
        MeshFilter meshFilter = GetComponent<MeshFilter>();
        meshFilter.mesh = mesh;
    }
}
