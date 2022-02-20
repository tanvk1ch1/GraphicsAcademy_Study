using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(MeshFilter))]
[RequireComponent(typeof(MeshRenderer))]
public class SphereMeshGeneratorSS : MonoBehaviour
{
    private MeshRenderer        m_renderer;
    private MeshFilter          m_filter;
    private Mesh                m_mesh;

    private void Start()
    {
        Mesh();
    }

    struct MeshData
    {
        public Vector3[]        verticles;
        public int[]            indices;
    }

    public Vector2Int divide;

    [ContextMenu("Create")]
    private void Mesh()
    {
        m_renderer = GetComponent<MeshRenderer>();
        m_filter = GetComponent<MeshFilter>();

        int divideX = divide.x;
        int divideY = divide.y;

        var data = CreateSphere(divideX, divideY);
        if (m_mesh == null)
        {
            // m_mesh.Clear();
            m_mesh = new Mesh();
            m_mesh.vertices = data.verticles;
            
            m_mesh.SetIndices(data.indices, MeshTopology.Triangles, 0);
            m_mesh.RecalculateNormals();
            m_filter.mesh = m_mesh;
        }
    }

    MeshData CreateSphere(int divideX, int divideY)
    {
        divideX = divideX < 4 ? 4 : divideX;
        divideY = divideY < 4 ? 4 : divideY;

        //! 半径
        float size = 1.0f;
        float r = size * 0.5f;
        int cnt = 0;
        int vertCount = divideX * (divideY - 1) + 2;
        var verticles = new Vector3[vertCount];

        //! 中心角
        float centerRadianX = 2f * Mathf.PI / (float)divideX;
        float centerRadianY = 2f * Mathf.PI / (float)divideY;

        //! 天面
        verticles[cnt++] = new Vector3(0, r, 0);
        for (int vy = 0; vy < divideY - 1; vy++)
        {
            var yRadian = (float)(vy + 1) * centerRadianY / 2f;

            //! 1辺の長さ
            var tmpLength = Mathf.Abs(Mathf.Sin(yRadian));

            var y = Mathf.Cos(yRadian);
            for (int vx = 0; vx < divideX; vx++)
            {
                var pos = new Vector3
                (
                    tmpLength * Mathf.Sin((float) vx * centerRadianX),
                    y,
                    tmpLength * Mathf.Cos((float) vx * centerRadianX)
                );
                //! サイズ反映
                verticles[cnt++] = pos * r;
            }
        }

        //! 底面
        verticles[cnt] = new Vector3(0, -r, 0);



        int topAndBottomTriCnt = divideX * 2;
        //! 側面三角形の数
        int aspectTriCnt = divideX * (divideY - 2) * 2;

        int[] indices = new int[(topAndBottomTriCnt + aspectTriCnt) * 3];

        //! 天面
        int offsetIndex = 0;
        cnt = 0;
        for (int i = 0; i < divideX * 3; i++)
        {
            if ( i % 3 == 0)
            {
                indices[cnt++] = 0;
            }
            else if (i % 3 == 1)
            {
                indices[cnt++] = 1 + offsetIndex;
            }
            else if (i % 3 == 2)
            {
                var index = 2 + offsetIndex++;
                //! 蓋
                index = index > divideX ? indices[1] : index;
                indices[cnt++] = index;
            }
        }

        return new MeshData()
        {
            indices = indices,
            verticles = verticles
        };
    }
}
