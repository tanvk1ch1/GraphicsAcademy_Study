using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(MeshFilter))]
[RequireComponent(typeof(MeshRenderer))]
public class CubeMeshGenerator : MonoBehaviour
{
    private void Start()
    {
        Mesh();
    }

    private void Mesh()
    {
        List<Vector3> verts = new List<Vector3>()
        {
            //! 正面
            new Vector3(0.0f, 0.0f, 0.0f), // 0
            new Vector3(1.0f, 0.0f, 0.0f), // 1
            new Vector3(1.0f, 1.0f, 0.0f), // 2
            new Vector3(0.0f, 1.0f, 0.0f), // 3

            //! 背面
            new Vector3(0.0f, 1.0f, 1.0f), // 4
            new Vector3(1.0f, 1.0f, 1.0f), // 5
            new Vector3(1.0f, 0.0f, 1.0f), // 6
            new Vector3(0.0f, 0.0f, 1.0f), // 7

            //! 上面
            new Vector3(0.0f, 1.0f, 1.0f), // 8  (4)
            new Vector3(0.0f, 1.0f, 0.0f), // 9  (3)
            new Vector3(1.0f, 1.0f, 0.0f), // 10 (2)
            new Vector3(1.0f, 1.0f, 1.0f), // 11 (5)
            
            //! 右面
            new Vector3(1.0f, 1.0f, 1.0f), // 12 (5)
            new Vector3(1.0f, 1.0f, 0.0f), // 13 (2)
            new Vector3(1.0f, 0.0f, 0.0f), // 14 (1)
            new Vector3(1.0f, 0.0f, 1.0f), // 15 (6)

            //! 左面
            new Vector3(0.0f, 0.0f, 0.0f), // 16 (0)
            new Vector3(0.0f, 1.0f, 0.0f), // 17 (3)
            new Vector3(0.0f, 1.0f, 1.0f), // 18 (4)
            new Vector3(0.0f, 0.0f, 1.0f), // 19 (7)

            //! 下面
            new Vector3(0.0f, 0.0f, 0.0f), // 20 (0)
            new Vector3(1.0f, 0.0f, 0.0f), // 21 (1)
            new Vector3(1.0f, 0.0f, 1.0f), // 22 (6)
            new Vector3(0.0f, 0.0f, 1.0f), // 23 (7)
        };

        List<int> triangles = new List<int>
        {
             0,  2,  1,  0,  3,  2, // 正面
             5,  4,  7,  5,  7,  6, // 背面
             8, 10,  9,  8, 11, 10, // 上面
            12, 15, 14, 12, 14, 13, // 右面
            16, 19, 18, 16, 18, 17, // 左面
            21, 23, 20, 21, 22, 23, // 下面
        };

        Mesh mesh = new Mesh();     // 作成
        mesh.Clear();               // 初期化処理
        mesh.SetVertices(verts);    // 頂点登録

        mesh.SetIndices(triangles, MeshTopology.Triangles, 0); // インデックスバッファ設定
        mesh.RecalculateNormals();  // 法線計算

        //! メッシュをフィルタに設定
        MeshFilter meshFilter = GetComponent<MeshFilter>();
        meshFilter.mesh = mesh;
    }
}
