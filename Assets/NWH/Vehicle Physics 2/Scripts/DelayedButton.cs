using UnityEngine;
using System.Collections;
using UnityEngine.EventSystems;
using NWH.Common.Input;
using UnityEngine.InputSystem.XR;
using NWH.VehiclePhysics2;

public class DelayedButton : MonoBehaviour
{
    public MobileInputButton Button;
    Coroutine coroutine;
    public VehicleController controller;
    public bool IsFunctional;
    private void Update()
    {

        if((controller?.Speed * 3.6) > 25)
        {
            Button.enabled = false;
            if (Button.hasBeenClicked)
            {
                Button.isPressed = true;
                Debug.LogError("=>OnPointerDow => ISPressed");
                Button.hasBeenClicked = false;

            }
            IsFunctional = true;
           
        }
        else
        {
         
            IsFunctional = false;
            Button.enabled = true;
        }

        
    }

    public void OnPointerDown()
    {

        if (IsFunctional)
        {
            if (coroutine != null)
                StopCoroutine(coroutine);
            //base.OnPointerDown(eventData);
            Debug.LogError("=>OnPointerDow<=");
            coroutine = StartCoroutine(EnableButtonAfterDelay());
        }
           
        
        

    }


    public void OnPointerUp()
    {
        if (IsFunctional)
        {
            Button.isPressed = false;
            StopCoroutine(coroutine);
        }
           

    }



    IEnumerator EnableButtonAfterDelay()
    {
        // Wait for the specified delay
        yield return new WaitForSeconds(0.25f);

        // Enable the button interaction


        Debug.LogError("=>OnPointerDow => Update");
         Button.hasBeenClicked = true;
    }


}

