using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CoordinateTransformation : MonoBehaviour
{
    [SerializeField] private Camera     m_camera;
    [SerializeField] private bool       m_applyMatrix;

    private Mesh                        m_mesh;
    private Vector3[]                   m_vertices;

    private void Awake()
    {
        m_mesh = new Mesh();
        GetComponent<MeshFilter>().mesh = m_mesh;
        m_vertices = new Vector3[8];

        // メッシュを初期化
        var triangles = new int[]
        {
            0, 2, 1,
            1, 2, 3,
            1, 3, 5,
            7, 5, 3,
            3, 2, 7,
            6, 7, 2,
            2, 0, 6,
            4, 6, 0,
            0, 1, 4,
            5, 4, 1,
            4, 7, 6,
            5, 7, 4,
        };

        var colors = new Color[]
        {
            new Color(0.0f, 0.0f, 0.0f),
            new Color(1.0f, 0.0f, 0.0f),
            new Color(0.0f, 1.0f, 0.0f),
            new Color(1.0f, 1.0f, 0.0f),
            new Color(0.0f, 0.0f, 1.0f),
            new Color(1.0f, 0.0f, 1.0f),
            new Color(0.0f, 1.0f, 1.0f),
            new Color(1.0f, 1.0f, 1.0f),
        };
        m_mesh.vertices = m_vertices;
        m_mesh.triangles = triangles;
        m_mesh.colors = colors;
        UpdateVertices();
    }

    private void Update()
    {
        UpdateVertices();
    }

    /// <summary>
    /// 頂点をカメラの視錐台に合わせたものに更新する
    /// </summary>
    private void UpdateVertices()
    {
        var near = m_camera.nearClipPlane;
        var far  = m_camera.farClipPlane;

        //! 視錐台の大きさの求め方は以下を参考
        // https://docs.unity3d.com/jp/current/Manual/FrustumSizeAtDistance.html
        var nearFrustumHeight       = 2.0f * near * Mathf.Tan(m_camera.fieldOfView * 0.5f * Mathf.Deg2Rad);
        var nearFrustumWidth        = nearFrustumHeight * m_camera.aspect;
        var farFrustumHeight        = 2.0f * far  * Mathf.Tan(m_camera.fieldOfView * 0.5f * Mathf.Deg2Rad);
        var farFrustumWidth         = farFrustumHeight  * m_camera.aspect;

        m_vertices[0] = new Vector3(nearFrustumWidth * -0.5f, nearFrustumHeight * -0.5f, near);
        m_vertices[1] = new Vector3(nearFrustumWidth *  0.5f, nearFrustumHeight * -0.5f, near);
        m_vertices[2] = new Vector3(nearFrustumWidth * -0.5f, nearFrustumHeight *  0.5f, near);
        m_vertices[3] = new Vector3(nearFrustumWidth *  0.5f, nearFrustumHeight *  0.5f, near);

        m_vertices[4] = new Vector3(farFrustumWidth * -0.5f, farFrustumHeight * -0.5f, far);
        m_vertices[5] = new Vector3(farFrustumWidth *  0.5f, farFrustumHeight * -0.5f, far);
        m_vertices[6] = new Vector3(farFrustumWidth * -0.5f, farFrustumHeight *  0.5f, far);
        m_vertices[7] = new Vector3(farFrustumWidth *  0.5f, farFrustumHeight *  0.5f, far);

        if (m_applyMatrix)
        {
            //! VP行列を適用する
            for (int i = 0; i < m_vertices.Length; i++)
            {
                //! 検証のため、頂点情報を4次元の同次座標にする
                //  Vec3(通常座標？)からVec4(同次座標、wは1)にする
                var vertex = new Vector4(m_vertices[i].x, m_vertices[i].y, m_vertices[i].z, 1);
                //! VP行列を作成
                //  World座標をカメラ基準に変えるために使う
                var vpMat = m_camera.projectionMatrix * m_camera.worldToCameraMatrix;
                //! VP行列を適用(正規化)
                vertex = vpMat * vertex;

                //! W除算
                //  Vec4(同次座標)のx,y,zそれぞれをw除算すると、Vec3(通常座標？)になる。
                //? 疑問：正規化ビューボリュームをすることで、どういったメリットがあるのか？
                //  プロジェクション座標変換で作られた空間(クリップ空間)内部で画面に表示されることで、
                //  何らかの不都合がなくなる？
                //  空間内のオブジェクトが歪む等の影響がなくなる...？
                vertex /= vertex.w;

                m_vertices[i] = vertex;
            }
        }
        
        m_mesh.vertices = m_vertices;
        m_mesh.RecalculateBounds();
    }
}

//! 主な参考URL
// ・【Unity】プロジェクション行列は掛けるだけじゃなくてw除算しなきゃダメだよという話
// https://light11.hatenadiary.com/entry/2018/06/10/233954
// ・【Unity】【数学】Unityでのビュー＆プロジェクション行列とプラットフォームの関係
// https://logicalbeat.jp/blog/929/

//! その他参考
// ・プロジェクション座標変換
// https://yttm-work.jp/gmpg/gmpg_0004.html