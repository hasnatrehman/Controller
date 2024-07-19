using System;
using UnityEngine;

[Serializable]
public class CameraLookAt : CameraMode
{
	public float damping = 6f;

	[Space(5f)]
	public float minFov = 10f;

	public float maxFov = 60f;

	public float fovSpeed = 20f;

	public float fovDamping = 4f;

	public bool autoFov;

	public string fovAxis = "Mouse ScrollWheel";

	[Space(5f)]
	public bool enableMovement;

	public float movementSpeed = 2f;

	public float movementDamping = 5f;

	public string forwardAxis = string.Empty;

	public string sidewaysAxis = string.Empty;

	public string verticalAxis = string.Empty;

	private Camera m_camera;

	private float m_fov;

	private float dist;

	public override void Initialize(Transform self)
	{
		m_camera = self.GetComponentInChildren<Camera>();
	}

	public override void OnEnable(Transform self, Transform target, Vector3 targetOffset)
	{
		if (m_camera != null)
		{
			m_fov = m_camera.fieldOfView;
			m_camera.fieldOfView = 40f;
		}
	}

	public override void Update(Transform self, Transform target, Vector3 targetOffset, float z)
	{
		if (target != null)
		{
			self.rotation = Quaternion.Slerp(self.rotation, Quaternion.LookRotation(target.position + targetOffset - self.position), damping * Time.deltaTime);
			if (dist < 130f)
			{
				m_camera.fieldOfView = 40f - (dist - 75f) * 0.35f;
			}
			if (dist > 150f)
			{
				self.position = target.position + Quaternion.Euler(0f, target.eulerAngles.y - 180f, 0f) * new Vector3(UnityEngine.Random.Range(-15, 15), 5f, -110f);
				self.rotation = Quaternion.LookRotation(target.position + targetOffset - self.position);
			}
			dist = Vector3.Distance(self.position, target.position);
		}
	}

	public override void OnDisable(Transform self, Transform target, Vector3 targetOffset)
	{
		if (m_camera != null)
		{
			m_camera.fieldOfView = m_fov;
		}
	}
}
