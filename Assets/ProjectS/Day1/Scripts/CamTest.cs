using UnityEngine;

public class CamTest : MonoBehaviour
{
    [SerializeField] private Camera m_camera;

    void Start()
    {
        //! ローカル座標
        var vertex = new Vector4(2, 0, 0, 1);
        Debug.Log("ローカル座標:" + vertex);

        // モデル行列(このモデルからワールド空間に座標する行列)
        var mMatrix = transform.localToWorldMatrix;
        // とあるモデルの頂点とみなしたもの(ここでは説明用に1頂点だけ。さらに同次座標を利用)
        // Point: 頂点がワールドを基準とした座標系に変換される
        Debug.Log("M * v:" + mMatrix * vertex);

        // カメラ行列(ワールドからカメラ座標系に変換する行列)
        // ※カメラ空間は右手系から左手系に変わる
        //! ビュー空間への変換
        var vMatrix = m_camera.worldToCameraMatrix;

        // モデル行列 * カメラ行列(モデルの頂点の1つ1つをカメラの空間に変換する行列)
        var vp = vMatrix * mMatrix;
        var targetPos = vp * vertex;
        // カメラ空間の座標系はxy平面に関する鏡映S(1, 1, -1)のため、Z方向に-1を掛ける
        targetPos.z *= -1;
        // Point: 頂点がカメラを基準とした座標系に変換される
        Debug.Log("vp * v" + targetPos);
    }
}

//! 参考URL
// 空間とプラットフォームの狭間で – Unityの座標変換にまつわるお話 –
// https://tech.drecom.co.jp/knowhow-about-unity-coordinate-system/
