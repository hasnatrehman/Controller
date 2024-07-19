using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.EventSystems;

public class DragController : MonoBehaviour, IPointerDownHandler, IPointerUpHandler
{
    public bool pressing;
    public void OnPointerDown(PointerEventData eventData)
    {
        pressing = true;
    }

    // This method is called when the pointer is released from the button
    public void OnPointerUp(PointerEventData eventData)
    {
        
        pressing = false;
        // Handle your pointer up logic here
    }
}
