using System.Collections;
using UnityEngine;
using UnityEngine.Serialization;

public class VehicleCameraController : MonoBehaviour
{
	public enum Mode
	{
		AttachTo,
		MouseOrbit,
		LookAt
	}

	public Mode mode = Mode.MouseOrbit;

	public Transform target;

	public bool followCenterOfMass = true;

	public KeyCode changeCameraKey = KeyCode.C;

	public CameraAttachTo attachTo = new CameraAttachTo();

	[FormerlySerializedAs("smoothFollowSettings")]
	[FormerlySerializedAs("orbitSettings")]

	public CameraMouseOrbit mouseOrbit = new CameraMouseOrbit();

	public CameraLookAt lookAt = new CameraLookAt();

	public float z;

	public Transform m_transform;

	private Mode m_prevMode;

	[HideInInspector]
	public CameraMode[] m_cameraModes = new CameraMode[0];

	private Transform m_prevTarget;

	private Vector3 m_localTargetOffset;

	private Vector3 m_targetOffset;
 //   private void Awake()
 //   {
	//	StartCoroutine(Camsec());
 //   }
	//IEnumerator Camsec()
	//{
		
	//	yield return new WaitForSeconds(2);
	//	gameObject.GetComponent<VehicleCameraController>().enabled = true;
	//}
    private void Start()
	{
        //CameraMouseOrbit.RefreshMainCamera += CameraAssigner;

        //if (target == null)
        //    target = Object.FindObjectOfType<RCC_CarControllerV3>().transform;  // yahan observer laga
        m_transform = GetComponent<Transform>();
        m_cameraModes = new CameraMode[3] { attachTo, mouseOrbit, lookAt };
        CameraMode[] cameraModes = m_cameraModes;
        foreach (CameraMode cameraMode in cameraModes)
        {
            cameraMode.Initialize(m_transform);
        }
        m_prevTarget = target;
        m_cameraModes[(int)mode].OnEnable(m_transform, target, m_targetOffset);
        m_cameraModes[(int)mode].Reset(m_transform, target, m_targetOffset);
        m_prevMode = mode;
        //mode = (Mode)Prefs.Camera;
        
    }

	bool trailerTrigger = false;
	public void TrailerAttach()
	{
		if (trailerTrigger)
		{
			//Debug.LogError("CamInstall");
            mouseOrbit.isTrailerAttached = false;
			trailerTrigger = false;
		}
		else
		{
			//Debug.LogError("!CamInstall");
            mouseOrbit.isTrailerAttached = true;
			trailerTrigger = true;

        }
    }
	
	public void CameraAssigner(bool b)
	{
       
    }

    private void OnDisable()
	{
        m_cameraModes[(int)mode].OnDisable(m_transform, target, m_targetOffset);
        //CameraMouseOrbit.RefreshMainCamera -= CameraAssigner;
	}

    
   
    private void LateUpdate()
    {
		if (mode != m_prevMode)
		{
			m_cameraModes[(int)m_prevMode].OnDisable(m_transform, target, m_targetOffset);
			m_cameraModes[(int)mode].OnEnable(m_transform, target, m_targetOffset);
			m_cameraModes[(int)mode].Reset(m_transform, target, m_targetOffset);
			m_prevMode = mode;
		}
		
		m_cameraModes[(int)mode].Update(m_transform, target, m_targetOffset*10, z*0);
	}

	public void NextCameraMode()
	{
		if (base.enabled)
		{
			mode++;
			if ((int)mode >= m_cameraModes.Length)
			{
				mode = Mode.AttachTo;
			}
		}
	}

	public void SetCamera()
	{
		//target = Object.FindObjectOfType<RCC_CarControllerV3>().transform;
		if (mode == Mode.AttachTo)
		{
			attachTo.OnEnable(base.transform, target.transform, default(Vector3));
		}
	}

	public void ResetCamera()
	{
		if (base.enabled)
		{
			m_cameraModes[(int)mode].Reset(m_transform, target, m_targetOffset);
		}
	}
}
