using System;
using UnityEngine;
using UnityEngine.PlayerLoop;

[Serializable]
public class CameraMouseOrbit : CameraMode
{
	public float distance = 0;

	[Space(5f)]
	public float minVerticalAngle = -20f;

	public float maxVerticalAngle = 80f;

	public float horizontalSpeed = 5f;

	public float verticalSpeed = 2.5f;

	public float orbitDamping = 4f;

	[Space(5f)]
	public float minDistance = 5f;

	public float maxDistance = 50f;

	public float distanceSpeed = 10f;

	public float distanceDamping = 4f;

	[HideInInspector]
	public float m_orbitX;

	[HideInInspector]
	public float m_orbitY;

	private float m_orbitDistance;

	[HideInInspector]
	public bool orbit = true;

	private float wantedYawRotationAngle;

	private float orjYlimit;

	private float x;

	private float y;

	private Quaternion CurrentRotation;

	public DragController orbitArea;

	private bool isEditor;

	public float _horizontalSpeed;

	public float _verticalSpeed;

	public float trailerMinDistance = 15f;

	public bool isTrailerAttached = true;

	public float _distance=0;

	public Transform trailer;

	private Touch t = default(Touch);
	public bool updateStoper;
    //public static event Action<bool> RefreshMainCamera;

    public override void Initialize(Transform self)
	{
		isEditor = Application.isEditor;
		orjYlimit = minVerticalAngle;
		SetTrailer();
		if (isTrailerAttached)
		{
			m_orbitDistance = distance + _distance;
		}
		else
		{
			m_orbitDistance = distance;
		}
		m_orbitX = 0f;
		m_orbitY = 15f;
		x = m_orbitX;
		y = m_orbitY;
		wantedYawRotationAngle = UnityEngine.Object.FindObjectOfType<BoxCollider>().transform.eulerAngles.y;
		
		_horizontalSpeed = horizontalSpeed * (1f /** Prefs.Resolution*/);
		_verticalSpeed = verticalSpeed * (1f /** Prefs.Resolution*/);
	}

	public void SetTrailer()
	{
		//if(trailer == null)
  //         trailer = UnityEngine.Object.FindObjectOfType<RCC_CarControllerV3>().transform;
        
        //if ((bool)GameObject.FindWithTag("Trailer") && Prefs.IsTrailerContacted)
        //{
        //	trailer = GameObject.FindWithTag("Trailer").transform;
        //	isTrailerAttached = true;
        //	trailerMinDistance = trailer.GetComponent<RCC_TruckTrailer>().MinDistance;
        //	_distance = trailerMinDistance - trailerMinDistance * 20f / 100f;
        //}
        //else
        //{
        //	isTrailerAttached = false;
        //	_distance = 0f;
        //}
    }

	bool singleTimeCaller;
	
	public override void Update(Transform self, Transform target, Vector3 targetOffset, float z)
	{

		
            if (target == null || !orbit)
            {
                return;
            }
            float num = 0f;
            if (isEditor)
            {
                if (Input.GetMouseButton(0) && orbitArea.pressing)
                {
                    m_orbitX += CameraMode.GetInputForAxis("Mouse X") * _horizontalSpeed;
                    m_orbitY -= CameraMode.GetInputForAxis("Mouse Y") * _verticalSpeed;
                }
                num = CameraMode.GetInputForAxis("Mouse ScrollWheel");
                distance -= num * distanceSpeed;
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
                    bool flag3 = false;
                    if (orbitArea.pressing && t.phase == TouchPhase.Moved)
                    {
                        flag = true;
                        flag2 = true;
                    }
                    Touch touch = Input.GetTouch(1);
                    if (orbitArea.pressing && touch.phase == TouchPhase.Moved)
                    {
                        if (!flag2)
                        {
                            t = touch;
                            flag = true;
                        }
                        flag3 = true;
                    }
                    if (flag2 && flag3)
                    {
                        flag = false;
                        Vector2 vector = t.position - t.deltaPosition;
                        Vector2 vector2 = touch.position - touch.deltaPosition;
                        float magnitude = (vector - vector2).magnitude;
                        float magnitude2 = (t.position - touch.position).magnitude;
                        num = magnitude - magnitude2;
                        distance -= 0f - num * 0.1f;
                    }
                }
                if (flag)
                {
                    m_orbitX += t.deltaPosition.x * (_horizontalSpeed * 0.065f);
                    m_orbitY -= t.deltaPosition.y * (_verticalSpeed * 0.065f);
                }
            }
            m_orbitY = Mathf.Clamp(m_orbitY, minVerticalAngle, maxVerticalAngle);
            distance = Mathf.Clamp(distance, minDistance, maxDistance);
            x = Mathf.Lerp(x, m_orbitX, Time.deltaTime * 10f);
            y = Mathf.Lerp(y, m_orbitY, Time.deltaTime * 10f);
            if (isTrailerAttached)
            {

                singleTimeCaller = false;
                float num2 = self.localEulerAngles.y - trailer.localEulerAngles.y;
                if (num2 > 360f || num2 < 0f)
                {
                    if (num2 < 0f)
                    {
                        num2 *= -1f;
                    }
                    num2 %= 360f;
                }
                if (num2 > 180f)
                {
                    num2 = 360f - num2;
                }
                float num3 = Mathf.Clamp(num2 / 180f * 350f, 20f, 100f);

                _distance = (trailerMinDistance - trailerMinDistance * num3 / 100f);



                //Debug.LogError("!!!! " + _distance);
            }
            else
            {

                if (!singleTimeCaller)
                {

                    singleTimeCaller = true;
                    _distance = 0f;
                    distance = 9;   // Default Distance Gabbar
                    //RefreshMainCamera?.Invoke(false);


                }
            }
            m_orbitDistance = Mathf.Lerp(m_orbitDistance, distance + _distance, distanceDamping * 3f * Time.deltaTime);
            minVerticalAngle = Mathf.Lerp(minVerticalAngle, orjYlimit + (distance + _distance) * 0.45f, Time.deltaTime * distanceSpeed * 10f);
            wantedYawRotationAngle = Mathf.LerpAngle(wantedYawRotationAngle, target.eulerAngles.y, orbitDamping * Time.deltaTime);

            CurrentRotation = Quaternion.Euler(y, x + wantedYawRotationAngle, 0f);
            self.rotation = Quaternion.Slerp(self.rotation, CurrentRotation, 14f /*4f * Time.deltaTime*/);  // Gabbar Come here
            self.position = target.position + CurrentRotation * new Vector3(0f, 1.2f, 0f - m_orbitDistance);

        }

    
}
