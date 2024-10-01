using NWH.VehiclePhysics2.Input;
using System;
using UnityEngine;
using static UnityEngine.ParticleSystem;

namespace NWH.VehiclePhysics2.Modules.Trailer
{
    /// <summary>
    ///     MonoBehaviour wrapper for TrailerHitch module.
    /// </summary>
    [Serializable]
    public partial class TrailerHitchModuleWrapper : ModuleWrapper
    {
        public TrailerHitchModule module = new TrailerHitchModule();
        
        private VehicleController _vehicleController;


        private void Awake()
        {
            // Run some of the trailer initialization here since the trailer VehicleController
            // might be disabled and un-initialized at the time of attachment.
            _vehicleController = GetComponentInParent<VehicleController>();
            if (_vehicleController == null)
            {
                Debug.LogError($"No VehicleController attached to the TrailerModule {name}");
                return;
            }

            if (module.attachmentPoint == null)
            {
                Debug.LogError($"{name}: TrailerHitchModule attachmentPoint is null.");
                return;
            }

            SphereCollider triggerCollider = module.attachmentPoint.GetComponent<SphereCollider>();
            if (triggerCollider == null)
            {
                triggerCollider = module.attachmentPoint.gameObject.AddComponent<SphereCollider>();
                triggerCollider.radius = module.attachmentTriggerRadius;
                triggerCollider.isTrigger = true;
                triggerCollider.gameObject.layer = module.attachmentLayer;
            }

            module.vehicleController = _vehicleController;
        }

        MobileVehicleInputProvider ButtonCanvas;

        private void Start()
        {
            ButtonCanvas = FindObjectOfType<MobileVehicleInputProvider>();

        }


        public override VehicleComponent GetModule()
        {
            return module;
        }


        public void OnTriggerEnter(Collider other)
        {
            module.OnTriggerEnter(other);

            if (other.gameObject.tag == "Trailer")
                ButtonCanvas.trailerAttachDetachButton.gameObject.SetActive(true);
               //ButtonCanvas.trailerAttachDetachButton.interactable = true;
        }

        private void OnTriggerExit(Collider other)
        {
            //  if (other.gameObject.layer == 3)
            if (other.gameObject.tag == "Trailer")
                ButtonCanvas.trailerAttachDetachButton.gameObject.SetActive(false);
                //ButtonCanvas.trailerAttachDetachButton.interactable = false;

        }

        float angleTolerance = 1.0f;
        Vector3 truckAngles;
        Vector3 trailerAngles;
        public void OnTriggerStay(Collider other)
        {
            
         ////  truckAngles = gameObject.transform.eulerAngles; // Gabbar Trailer Attach Angle
         ////  trailerAngles = other.gameObject.transform.parent.transform.eulerAngles;

         ////   float angleDifferenceY = Mathf.Abs(Mathf.DeltaAngle(truckAngles.y, trailerAngles.y));

         ////   if (angleDifferenceY <= angleTolerance)
         ////   {
                module.OnTriggerStay(other);
                  // Gabbar
        ///    }



        }


        public override void SetModule(VehicleComponent module)
        {
            this.module = module as TrailerHitchModule;
        }
    }
}