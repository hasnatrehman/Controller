using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Swipe : MonoBehaviour
{
    private Vector2 startTouchPosition, endTouchPosition;
    Quaternion startRotation;
    [SerializeField]
    private float rotationSpeed = 2f;
    [SerializeField]
    private DragController orbitArea;
    private void Start()
    {
        startRotation = transform.rotation;
    }
    void Update()
    {
        
        if (Input.touchCount > 0 && orbitArea.pressing)
        {
          
            Touch touch = Input.GetTouch(0);

            switch (touch.phase)
            {
                case TouchPhase.Began:
                    startTouchPosition = touch.position;
                    break;

                case TouchPhase.Moved:
                    endTouchPosition = touch.position;
                    Vector2 swipeDelta = endTouchPosition - startTouchPosition;

                    // Determine swipe direction and apply rotation
                    if (Mathf.Abs(swipeDelta.x) > Mathf.Abs(swipeDelta.y))
                    {
                        float rotationAmount = swipeDelta.x * rotationSpeed * Time.deltaTime;
                        transform.Rotate(Vector3.up, rotationAmount);
                    }
                    startTouchPosition = endTouchPosition;
                    break;

                case TouchPhase.Ended:
                    startTouchPosition = Vector2.zero;
                    endTouchPosition = Vector2.zero;
                    break;
            }
        }
        else if(!orbitArea.pressing && transform.rotation != startRotation)
        {

            // Define the target rotation (no rotation)
            Quaternion targetRotation = Quaternion.Euler(8, 0, 0);

            // Smoothly interpolate from current rotation to target rotation
          //  transform.localRotation = Quaternion.Slerp(transform.localRotation, targetRotation, rotationSpeed * Time.deltaTime);
        
              transform.localRotation = Quaternion.RotateTowards(transform.localRotation, targetRotation, (rotationSpeed*10) * Time.deltaTime);
        
    }
    }
}
