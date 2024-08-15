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


        public override VehicleComponent GetModule()
        {
            return module;
        }


        public void OnTriggerEnter(Collider other)
        {
            module.OnTriggerEnter(other);
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
                
        ///    }



        }


        public override void SetModule(VehicleComponent module)
        {
            this.module = module as TrailerHitchModule;
        }
    }
}