using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PAtchEnabler : MonoBehaviour
{
    public GameObject Patch;
    


    private void OnTriggerEnter(Collider other)
    {
        if(other.CompareTag("Vehicle"))
        {
            if (Patch.activeInHierarchy)
            {
                Patch.SetActive(false);
                Debug.LogError("false");
            }
            else
            {
                Patch.SetActive(true);
                Debug.LogError("true");

            }
        }
       
            
        
            
        
    }
}
