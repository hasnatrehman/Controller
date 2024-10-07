using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class JobTriggerDetector : MonoBehaviour
{
    private void OnTriggerEnter(Collider other)
    {
        if(other.gameObject.layer == 3 && other.CompareTag("Chassis"))
        {
            Debug.LogError("trigger number of time: ");
            
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.layer == 3 && other.CompareTag("Chassis"))
        {
            Debug.LogError("trigger number of time: ");

        }
    }
}
