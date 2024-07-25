using NWH.VehiclePhysics2;
using NWH.VehiclePhysics2.Input;
using NWH.VehiclePhysics2.VehicleGUI;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using static NWH.VehiclePhysics2.Input.MobileVehicleInputProvider;

public class CustomUIHandler : MonoBehaviour
{
    public Toggle toggleButtonC;
    public Toggle toggleButtonCo;
    public Toggle toggleButtonR;
    public MobileVehicleInputProvider inputProvider;
  
    public VehicleController controller;
    public List<Camera> PlayerCameras;
    private void Start()
    {
        Controller(true);
        Camera(true);
        Rotation(true);
    }
    public void ControllerSwitcher()
    {
        
       
        Controller(toggleButtonCo.isOn);
    }
    public void CameraChanger()
    {
        Camera(toggleButtonC.isOn);
     
    }

    public void RotationChanger()
    {
        Rotation(toggleButtonR.isOn);

    }

    public void Controller(bool b)
    {
        if (b)
        {

            toggleButtonCo.isOn = true;
         
            inputProvider.steeringInputType = HorizontalAxisType.SteeringWheel;
            inputProvider.steerLeftButton.gameObject.SetActive(false);
            inputProvider.steerRightButton.gameObject.SetActive(false);
            inputProvider.steeringWheel.gameObject.SetActive(true);
            controller.steering.degreesPerSecondLimit = 100f;




}
        else
        {
           
            toggleButtonCo.isOn = false;
            inputProvider.steeringInputType = HorizontalAxisType.Button;
            inputProvider.steeringWheel.gameObject.SetActive(false);
            inputProvider.steerLeftButton.gameObject.SetActive(true);
            inputProvider.steerRightButton.gameObject.SetActive(true);
            controller.steering.degreesPerSecondLimit = 20f;
        
        }
    }

    public void Camera(bool b)
    {
        if (b)
        {
            toggleButtonC.isOn = true;

            PlayerCameras[0].gameObject.SetActive(false);
            PlayerCameras[1].gameObject.SetActive(true);



        }
        else
        {
            toggleButtonC.isOn = false;
            PlayerCameras[1].gameObject.SetActive(false);
            PlayerCameras[0].gameObject.SetActive(true);
        }
    }

    public void Rotation(bool b)
    {
        if (b)
        {

            toggleButtonR.isOn = true;
            GetComponent<MobileVehicleInputProvider>().steeringWheel.
            GetComponent<SteeringWheel>().returnToCenterSpeed = 400;

            controller.steering.returnToCenter = true;



        }
        else
        {
            toggleButtonR.isOn = false;
            GetComponent<MobileVehicleInputProvider>().steeringWheel.
           GetComponent<SteeringWheel>().returnToCenterSpeed = 0;

            controller.steering.returnToCenter = false;

        }
    }
}
