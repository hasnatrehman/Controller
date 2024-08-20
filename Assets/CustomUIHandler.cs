using NWH.VehiclePhysics2;
using NWH.VehiclePhysics2.Input;
using NWH.VehiclePhysics2.Powertrain;
using NWH.VehiclePhysics2.VehicleGUI;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using static NWH.VehiclePhysics2.Input.MobileVehicleInputProvider;

public class CustomUIHandler : MonoBehaviour
{
    public Toggle toggleButtonC;
    public Toggle toggleButtonCo;
    public Toggle toggleButtonR;
    public Toggle toggleButtonDiff;
    public MobileVehicleInputProvider inputProvider;
  
    public VehicleController controller;
    public List<Camera> PlayerCameras;
    private void Start()
    {
        //// Load the first scene additively
        //SceneManager.LoadScene("NVP2 Mobile Demo", LoadSceneMode.Additive);

        // Load the second scene additively
        SceneManager.LoadScene("Wanda Env Sorted 1", LoadSceneMode.Additive);
        Controller(false);
        Camera(true);
        Rotation(false);
        diff(true);
    }
    float _speed;
    private void FixedUpdate()
    {
        _speed = controller.Speed *3.6f;
        if (_speed > 50 && _speed < 80)
        {
            controller.steering.degreesPerSecondLimit = 5f;
            Debug.LogError("60");
        }
        else if (_speed >= 80)
        {
            controller.steering.degreesPerSecondLimit = 2f;
        }
        else
        {
            controller.steering.degreesPerSecondLimit = 10f;
        }


    }

    public void ControllerSwitcher()
    {
        
       
        Controller(toggleButtonCo.isOn);
    }
    public void CameraChanger()
    {
        Camera(toggleButtonC.isOn);
     
    }

    public void Differential()
    {
        diff(toggleButtonDiff.isOn);
    }
    void diff(bool b)
    {
        if (b)
        {
            controller.powertrain.differentials[0].DifferentialType = DifferentialComponent.Type.LimitedSlip;
            toggleButtonDiff.GetComponent<Image>().color = Color.white;
           
        }
        else
        {
            controller.powertrain.differentials[0].DifferentialType = DifferentialComponent.Type.Locked;
            toggleButtonDiff.GetComponent<Image>().color = Color.red;

        }
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
            controller.steering.degreesPerSecondLimit = 10f;
        
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
