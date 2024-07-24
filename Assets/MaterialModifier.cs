using UnityEditor;
#if UNITY_EDITOR
using UnityEngine;

[ExecuteInEditMode]
public class MaterialModifier : MonoBehaviour
{
    private Material materialInstance;

    [SerializeField]
    private Vector2 tiling = new Vector2(1, 1);
    public Vector2 Tiling
    {
        get { return tiling; }
        set
        {
            tiling = value;
            ChangeTiling(tiling);
        }
    }

    public Vector2 offset = new Vector2(0, 0);

    void Start()
    {
        Renderer renderer = GetComponent<Renderer>();
        if (renderer == null)
        {
            Debug.LogError("No Renderer attached to this object!");
            return;
        }

        materialInstance = new Material(renderer.sharedMaterial);
        renderer.material = materialInstance;

        materialInstance.mainTextureScale = tiling;
        materialInstance.mainTextureOffset = offset;
    }

    // Function to change tiling
    public void ChangeTiling(Vector2 newTiling)
    {
        tiling = newTiling;
        if (materialInstance != null)
        {
            materialInstance.mainTextureScale = tiling;
        }
    }

    // Function to change offset
    public void ChangeOffset(Vector2 newOffset)
    {
        offset = newOffset;
        if (materialInstance != null)
        {
            materialInstance.mainTextureOffset = offset;
        }
    }
    private void OnValidate()
    {
        if (!EditorApplication.isPlayingOrWillChangePlaymode)
        {
            ChangeTiling(tiling);
            ChangeOffset(offset);
        }
           
    }
}
#endif
