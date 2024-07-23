using NWH.VehiclePhysics2.Input;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using static NWH.VehiclePhysics2.Input.MobileVehicleInputProvider;

public class CustomUIHandler : MonoBehaviour
{
    public Toggle toggleButton;
    public MobileVehicleInputProvider inputProvider;

    private void Start()
    {
        Controller(true);
    }
    public void ControllerSwitcher()
    {
        
       
        Controller(toggleButton.isOn);
    }

    public void Controller(bool b)
    {
        if (b)
        {
            toggleButton.isOn = true;
            inputProvider.steeringInputType = HorizontalAxisType.SteeringWheel;
            inputProvider.steerLeftButton.gameObject.SetActive(false);
            inputProvider.steerRightButton.gameObject.SetActive(false);
            inputProvider.steeringWheel.gameObject.SetActive(true);
}
        else
        {
            toggleButton.isOn = false;
            inputProvider.steeringInputType = HorizontalAxisType.Button;
            inputProvider.steeringWheel.gameObject.SetActive(false);
            inputProvider.steerLeftButton.gameObject.SetActive(true);
            inputProvider.steerRightButton.gameObject.SetActive(true);
        }
    }
}
