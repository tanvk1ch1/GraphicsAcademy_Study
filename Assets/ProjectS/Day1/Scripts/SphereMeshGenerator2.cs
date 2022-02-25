using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(MeshFilter))]
[RequireComponent(typeof(MeshRenderer))]
public class SphereMeshGenerator2 : MonoBehaviour
{
    [SerializeField] private int        vertical        = 3;
    [SerializeField] private int        horizontal      = 3;
    [SerializeField] private float      radius          = 1;

    private Mesh                        m_mesh;
    private MeshFilter                  m_filter;

    private void Start()
    {
        m_mesh = GetComponent<Mesh>();
        m_filter = GetComponent<MeshFilter>();

        CreateMesh();
    }

    private void CreateMesh()
    {
        if (m_mesh == null)
        {
            m_mesh = new Mesh();
        }
        m_mesh.Clear();

        // var (verts, triangles) = CreateSphereMesh();
        // m_mesh.vertices = verts.ToArray();

        List<Vector3> verts = new List<Vector3>();
        List<int> triangles = new List<int>();

        float x, y, z;

        //! 頂点の定義
        verts.Add(new Vector3(0, 1, 0));

        for (int i = 0; i < vertical; i++)
        {
            y = Mathf.Cos((Mathf.PI / 180) * i * 180.0f / vertical) * radius;
            var a = Mathf.Sin((Mathf.PI / 180) * i * 180.0f / vertical) * radius;

            for (int j = 0; j < horizontal; j++)
            {
                x = Mathf.Cos((Mathf.PI / 180) * j * 360.0f / horizontal) * a;
                z = Mathf.Sin((Mathf.PI / 180) * j * 360.0f / horizontal) * a;
                verts.Add(new Vector3(x, y, z));
            }
        }
        //! 底面の先端1頂点を定義
        verts.Add(new Vector3(0, -1, 0));

        //! 以下、三角形の定義
        //! 天面
        for (int k = 0; k < horizontal; k++)
        {
            //! 組んでいく最後の頂点箇所の例外処理
            if (k == horizontal - 1)
            {
                triangles.Add(0);
                triangles.Add(1);
                triangles.Add(k + 1);
                break;
            }

            triangles.Add(0);
            triangles.Add(k + 2);
            triangles.Add(k + 1);
        }

        for (int l = 0; l < vertical; l++)
        {
            //! 最初の頂点index
            var index = l * horizontal + 1;

            for (int m = 0; m < horizontal; m++)
            {
                //! 次の段に渡すための処理
                if (m == horizontal - 1)
                {
                    triangles.Add(index + m);
                    triangles.Add(index);
                    triangles.Add(index + horizontal);

                    triangles.Add(index);
                    triangles.Add(index + horizontal);
                    triangles.Add(index + m + horizontal);

                    break;
                }

                triangles.Add(index + m);
                triangles.Add(index + m + 1);
                triangles.Add(index + m + 1 + horizontal);

                triangles.Add(index + m);
                triangles.Add(index + m + horizontal + 1);
                triangles.Add(index + m + horizontal);
            }
        }

        //! 底面部分
        for (int n = 0; n < horizontal; n++)
        {
            //! 組んでいく最後の頂点箇所の例外処理
            if (n == horizontal - 1)
            {
                triangles.Add(verts.Count - 1);
                triangles.Add(verts.Count - 1 - horizontal + n);
                triangles.Add(verts.Count - 1 - horizontal);
                break;
            }

            triangles.Add(verts.Count - 1);
            triangles.Add(verts.Count - 1 - horizontal + n);
            triangles.Add(verts.Count - horizontal + n);
        }

        m_mesh.SetVertices(verts); // 頂点登録
        m_mesh.SetTriangles(triangles, 0); // indexの登録
        m_mesh.SetIndices(triangles, MeshTopology.Triangles, 0); // インデックスバッファ
        m_mesh.RecalculateNormals(); // 法線計算
        m_filter.mesh = m_mesh;
    }

}

//! 参考URL
// Unity 動的に球のメッシュを描画をしてみる
// https://shibuya24.info/entry/dynamic_sphere_mesh