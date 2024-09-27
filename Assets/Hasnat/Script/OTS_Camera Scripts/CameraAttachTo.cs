using System;
using UnityEngine;

[Serializable]
public class CameraAttachTo : CameraMode
{
	public Transform attachTarget;

	private bool isEditor;

	private Touch t = default(Touch);

	private DragController orbitArea;

	[HideInInspector]
	public float m_orbitX;

	[HideInInspector]
	public float m_orbitY;

	private float zz;

	private float mx;

	private Transform mirror;

	private LayerMask lm;

	public override void Initialize(Transform self)
	{
		orbitArea = GameObject.Find("MobileDrag").GetComponent<DragController>();
		isEditor = Application.isEditor;
		lm = self.GetComponent<Camera>().cullingMask;
	}

	public override void OnEnable(Transform self, Transform target, Vector3 targetOffset)
	{
		attachTarget = target.transform.Find("CameraPos/1").transform;
		mirror = target.Find("Chassis/Head/Interior/Mirror/Sag").transform;
		self.GetComponent<Camera>().cullingMask = (int)lm & ~(1 << LayerMask.NameToLayer("RCC"));
		if (mx == 0f)
		{
			mx = mirror.localPosition.x;
		}
		target.transform.Find("Chassis/Head/Interior").gameObject.SetActive(value: true);
		target.transform.Find("Chassis/Head").GetComponent<ConfigurableJoint>().angularYZDrive = new JointDrive
		{
			positionSpring = 1000f,
			positionDamper = 100f,
			maximumForce = 3.402823E+38f
		};
		target.transform.Find("Chassis/Head").GetComponent<ConfigurableJoint>().angularXDrive = new JointDrive
		{
			positionSpring = 120f,
			positionDamper = 200f,
			maximumForce = 3.402823E+38f
		};
		target.transform.Find("All Audio Sources").localPosition = new Vector3(0f, 30f, 0f);
		target.transform.Find("Sounds/AirBrake").GetComponent<AudioSource>().volume = 0.1f;
		target.transform.Find("Sounds/BrakeOff").GetComponent<AudioSource>().volume = 0.1f;
		target.transform.Find("Sounds/Retarder").GetComponent<AudioSource>().volume = 0.1f;
		GameObject.Find("UI/DashBoard/RPM").gameObject.SetActive(value: false);
		GameObject.Find("UI").transform.Find("NavMask").gameObject.SetActive(value: false);
		GameObject.Find("UI/DashBoard/Nav").gameObject.SetActive(value: false);
		GameObject.Find("UI/DashBoard/BottomBg/Right").GetComponent<RectTransform>().sizeDelta = new Vector2(600f, 60f);
		GameObject.Find("UI/DashBoard/BottomBg/Right").GetComponent<RectTransform>().anchoredPosition = new Vector2(392f, 30f);
		GameObject.Find("UI/DashBoard/InCam").gameObject.SetActive(value: true);
		//GameObject.Find("UI/DashBoard").GetComponent<RCC_DashboardInputs>().isInside = true;
	//	Camera.main.GetComponent<Init>().isInside = true;
	//	GameObject.Find("UI/DashBoard").GetComponent<RCC_DashboardInputs>().RPMNeedle = target.transform.Find("Chassis/Head/Interior/Canvas/RpmNeedle").gameObject;
		//GameObject.Find("UI/DashBoard").GetComponent<RCC_DashboardInputs>().KmhNeedle = target.transform.Find("Chassis/Head/Interior/Canvas/KmhNeedle").gameObject;
	//	GameObject.FindWithTag("MainCamera").GetComponent<Init>().isInterior = true;
		GameObject.Find("Assets/Weather").GetComponent<AudioSource>().mute = false;
		//target.GetComponent<RCC_CarControllerV3>().isInterior = true;
		GameObject.Find("Assets/Sky Dome/Light").GetComponent<Light>().shadows = LightShadows.None;
		target.transform.Find("Wheel Models").gameObject.SetActive(value: false);
		int layer = LayerMask.NameToLayer("Default");
		target.transform.Find("Chassis/Lights/HeadLight/Projector").gameObject.layer = layer;
		if (GameObject.FindWithTag("Trailer") != null)
		{
			Transform transform = GameObject.FindWithTag("Trailer").transform;
			transform.Find("Chassis/Shadow").gameObject.SetActive(value: false);
			Transform[] componentsInChildren = transform.Find("Chassis").GetComponentsInChildren<Transform>(includeInactive: true);
			foreach (Transform transform2 in componentsInChildren)
			{
				transform2.gameObject.layer = layer;
			}
			transform.Find("Chassis/Shadow").gameObject.SetActive(value: true);
			Transform[] componentsInChildren2 = transform.Find("Wheel Models").GetComponentsInChildren<Transform>(includeInactive: true);
			foreach (Transform transform3 in componentsInChildren2)
			{
				transform3.gameObject.layer = layer;
			}
		}
	}

	public override void OnDisable(Transform self, Transform target, Vector3 targetOffset)
	{
		if (!self.gameObject.activeInHierarchy)
		{
			return;
		}
		self.GetComponent<Camera>().cullingMask = lm;
		target.transform.Find("Chassis/Head/Interior").gameObject.SetActive(value: false);
		target.transform.Find("Chassis/Head").GetComponent<ConfigurableJoint>().angularYZDrive = new JointDrive
		{
			positionSpring = 400f,
			positionDamper = 100f,
			maximumForce = 3.402823E+38f
		};
		target.transform.Find("Chassis/Head").GetComponent<ConfigurableJoint>().angularXDrive = new JointDrive
		{
			positionSpring = 120f,
			positionDamper = 20f,
			maximumForce = 3.402823E+38f
		};
		target.transform.Find("All Audio Sources").localPosition = new Vector3(0f, 0f, 0f);
		target.transform.Find("Sounds/AirBrake").GetComponent<AudioSource>().volume = 0.9f;
		target.transform.Find("Sounds/BrakeOff").GetComponent<AudioSource>().volume = 0.9f;
		target.transform.Find("Sounds/Retarder").GetComponent<AudioSource>().volume = 0.5f;
	//	GameObject.Find("UI/DashBoard").GetComponent<RCC_DashboardInputs>().RPMNeedle = GameObject.Find("UI/DashBoard/RPM/RpmNeedle").gameObject;
		//GameObject.Find("UI/DashBoard").GetComponent<RCC_DashboardInputs>().KmhNeedle = null;
		GameObject.Find("UI/DashBoard/BottomBg/Right").GetComponent<RectTransform>().sizeDelta = new Vector2(400f, 60f);
		GameObject.Find("UI/DashBoard/BottomBg/Right").GetComponent<RectTransform>().anchoredPosition = new Vector2(492f, 30f);
		GameObject.Find("UI/DashBoard/InCam").gameObject.SetActive(value: false);
		//GameObject.Find("UI/DashBoard").GetComponent<RCC_DashboardInputs>().isInside = false;
		//Camera.main.GetComponent<Init>().isInside = false;
		GameObject.Find("UI").transform.Find("NavMask").gameObject.SetActive(value: true);
		GameObject.Find("UI/DashBoard/RPM").gameObject.SetActive(value: true);
		GameObject.Find("UI/DashBoard/Nav").gameObject.SetActive(value: true);
		target.transform.Find("Wheel Models").gameObject.SetActive(value: true);
		//GameObject.FindWithTag("MainCamera").GetComponent<Init>().isInterior = false;
		GameObject.Find("Assets/Weather").GetComponent<AudioSource>().mute = true;
		//target.GetComponent<RCC_CarControllerV3>().isInterior = false;
		int layer = LayerMask.NameToLayer("RCC");
		target.transform.Find("Chassis/Lights/HeadLight/Projector").gameObject.layer = layer;
		if (GameObject.FindWithTag("Trailer") != null)
		{
			Transform transform = GameObject.FindWithTag("Trailer").transform;
			transform.Find("Chassis/Shadow").gameObject.SetActive(value: false);
			Transform[] componentsInChildren = transform.Find("Chassis").GetComponentsInChildren<Transform>(includeInactive: true);
			foreach (Transform transform2 in componentsInChildren)
			{
				transform2.gameObject.layer = layer;
			}
			transform.Find("Chassis/Shadow").gameObject.SetActive(value: true);
			Transform[] componentsInChildren2 = transform.Find("Wheel Models").GetComponentsInChildren<Transform>(includeInactive: true);
			foreach (Transform transform3 in componentsInChildren2)
			{
				transform3.gameObject.layer = layer;
			}
		}
		//if (Prefs.Shadows == "On")
		//{
		//	GameObject.Find("Assets/Sky Dome/Light").GetComponent<Light>().shadows = LightShadows.Hard;
		//}
	}

	public override void Update(Transform self, Transform target, Vector3 targetOffset, float z)
	{
		if (attachTarget != null)
		{
			target = attachTarget;
		}
		if (target == null)
		{
			return;
		}
		if (isEditor)
		{
			if (Input.GetMouseButton(0) && orbitArea.pressing)
			{
				m_orbitX += CameraMode.GetInputForAxis("Mouse X") * 5f;
				m_orbitY -= CameraMode.GetInputForAxis("Mouse Y") * 2.5f;
			}
		}
		else
		{
			bool flag = false;
			if (Input.touchCount == 1)
			{
				t = Input.GetTouch(0);
				if (orbitArea.pressing && t.phase == TouchPhase.Moved)
				{
					flag = true;
				}
			}
			else if (Input.touchCount == 2)
			{
				t = Input.GetTouch(0);
				bool flag2 = false;
				if (orbitArea.pressing && t.phase == TouchPhase.Moved)
				{
					flag = true;
					flag2 = true;
				}
				Touch touch = Input.GetTouch(1);
				if (orbitArea.pressing && touch.phase == TouchPhase.Moved && !flag2)
				{
					t = touch;
					flag = true;
				}
			}
			if (flag)
			{
				m_orbitX += t.deltaPosition.x * 0.325f;
				m_orbitY -= t.deltaPosition.y * 0.1625f;
			}
		}
		m_orbitY = Mathf.Clamp(m_orbitY, -2f, 10f);
		m_orbitX = Mathf.Clamp(m_orbitX, -7f, 15f);
		if (m_orbitX > 0f)
		{
			mirror.localPosition = new Vector3(mx + m_orbitX / 26f, mirror.localPosition.y, mirror.localPosition.z);
		}
		self.position = target.position;
		self.rotation = Quaternion.Euler(target.rotation.eulerAngles.x + m_orbitY, target.rotation.eulerAngles.y + m_orbitX, target.rotation.eulerAngles.z);
	}
}
