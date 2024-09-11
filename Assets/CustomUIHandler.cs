using NWH.VehiclePhysics2;
using NWH.VehiclePhysics2.Input;
using NWH.VehiclePhysics2.Powertrain;
using NWH.VehiclePhysics2.VehicleGUI;
using NWH.WheelController3D;
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
    public List<WheelController> Wheels;
    public List <Button> InteractibleButtons;
    public static CustomUIHandler instance;

    private void Awake()
    {
        instance = this;
    }
    private void Start()
    {


        
        //// Load the first scene additively
        //SceneManager.LoadScene("NVP2 Mobile Demo", LoadSceneMode.Additive);

        // Load the second scene additively
        SceneManager.LoadScene("Wanda Env Sorted 1", LoadSceneMode.Additive);
        Controller(true);
        Camera(true);
        Rotation(true);
        diff(true);
    }

    public void RevertColor()
    {
        foreach (var item in InteractibleButtons)
        {
            item.image.color = Color.white;
        }
    }

    bool B, L;
    public void LeanAdjuster(bool T)    // Gabbar Juggar
    {
        if (T)
        {
            L = false;
            if (!B)
            {
                foreach (var item in Wheels)
                {
                    item.forceApplicationPointDistance = -0.7f;
                }
                B = true;
            }
        }
        else
        {
            B = false;
            if (!L)
            {
                foreach (var item in Wheels)
                {
                    item.forceApplicationPointDistance = 0.7f;
                }
                L = true;
            }
        }
        
    }
    
        


    private void FixedUpdate()
    {

        //if (controller.Speed * 3.6 > 20 && controller.Speed * 3.6 < 40)
        //{
        //    controller.steering.degreesPerSecondLimit = 9f;

        //}
        //else if (controller.Speed * 3.6 > 40 && controller.Speed * 3.6 < 60)
        //{
        //    controller.steering.degreesPerSecondLimit = 7f;

        //}
        //else if (controller.Speed * 3.6 > 60 && controller.Speed * 3.6 < 80)
        //{
        //    controller.steering.degreesPerSecondLimit = 5f;
        //}
        //else if (controller.Speed * 3.6 >= 80)
        //{
        //    controller.steering.degreesPerSecondLimit = 2f;
        //}
        //else
        //{
        //    controller.steering.degreesPerSecondLimit = 10f;

        //}


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
            //controller.powertrain.differentials[0].DifferentialType = DifferentialComponent.Type.LimitedSlip;
            toggleButtonDiff.GetComponent<Image>().color = Color.white;
            controller.powertrain.engine.maxPower = 240;
        }
        else
        {
            //controller.powertrain.differentials[0].DifferentialType = DifferentialComponent.Type.Locked;
            toggleButtonDiff.GetComponent<Image>().color = Color.green;
            controller.powertrain.engine.maxPower = 360;
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


            inputProvider.steeringInputType = HorizontalAxisType.Button;
            inputProvider.steeringWheel.gameObject.SetActive(false);
            inputProvider.steerLeftButton.gameObject.SetActive(true);
            inputProvider.steerRightButton.gameObject.SetActive(true);
            controller.steering.degreesPerSecondLimit = 11f;



        }
        else
        {
           
            toggleButtonCo.isOn = false;

            inputProvider.steeringInputType = HorizontalAxisType.SteeringWheel;
            inputProvider.steerLeftButton.gameObject.SetActive(false);
            inputProvider.steerRightButton.gameObject.SetActive(false);
            inputProvider.steeringWheel.gameObject.SetActive(true);
            controller.steering.degreesPerSecondLimit = 100f;


           
        
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
           GetComponent<SteeringWheel>().returnToCenterSpeed = 0;

            controller.steering.returnToCenter = false;


        }
        else
        {
            toggleButtonR.isOn = false;
            GetComponent<MobileVehicleInputProvider>().steeringWheel.
           GetComponent<SteeringWheel>().returnToCenterSpeed = 400;

            controller.steering.returnToCenter = true;



            

        }
    }

    //public void OnPostRender(bool b)
    //{

    //    if (b)
    //    {

    //        toggleButtonR.isOn = true;

    //        controller.powertrain.engine.maxPower = 320;

    //    }
    //    else
    //    {

    //        toggleButtonR.isOn = false;

    //        controller.powertrain.engine.maxPower = 240;

    //    }

       
    //}
}
