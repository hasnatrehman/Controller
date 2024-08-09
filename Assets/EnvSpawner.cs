using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnvSpawner : MonoBehaviour
{
    public GameObject Env;



    





private void Start()
    {
        GameObject prefab = Resources.Load<GameObject>("Prefabs/MyPrefab");
        if (prefab != null)
        {
            Env = Instantiate(prefab);
        }
        else
        {
            Debug.LogError("Prefab could not be loaded.");
        }
    }
}
