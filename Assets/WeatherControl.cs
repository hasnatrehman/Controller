using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WeatherControl : MonoBehaviour
{
   public Light DirectionalLightImp;
   public Light DirectionalLightNotImp;
    public ParticleSystem RainParticle;
   public Color DirectionalLightTargetColor;
   public Material[] Roads;

    public float lerpDuration = 2f;
    
    private Color initialColorImp;
    private Color initialColorNotImp;
    private bool isLerping = false;
    private float lerpTime = 0f;

    private void Start()
    {
        Roads[0].SetFloat("_Opacity", Mathf.Lerp(0, 1f, lerpTime));
        Roads[1].SetFloat("_Opacity", Mathf.Lerp(0, 1f, lerpTime));
        Roads[2].SetFloat("_Opacity", Mathf.Lerp(0, 1f, lerpTime));

        Roads[0].SetFloat("_Wetness", Mathf.Lerp(1, 1.5f, lerpTime));
        Roads[1].SetFloat("_Wetness", Mathf.Lerp(1, 1.5f, lerpTime));
        Roads[2].SetFloat("_Wetness", Mathf.Lerp(1, 1.5f, lerpTime));

        if (DirectionalLightImp != null)
        {
            DirectionalLightImp = DirectionalLightImp.GetComponent<Light>();
            if (DirectionalLightImp != null)
            {
                initialColorImp = DirectionalLightImp.color;
            }
        }

        if (DirectionalLightNotImp != null)
        {
            DirectionalLightNotImp = DirectionalLightNotImp.GetComponent<Light>();
            if (DirectionalLightNotImp != null)
            {
                initialColorNotImp = DirectionalLightNotImp.color;
            }
        }
    }

    private void Update()
    {
        if (isLerping)
        {
            lerpTime += Time.deltaTime / lerpDuration;
            DirectionalLightImp.color = Color.Lerp(initialColorImp, DirectionalLightTargetColor, lerpTime);
            DirectionalLightNotImp.color = Color.Lerp(initialColorNotImp, DirectionalLightTargetColor, lerpTime);
            Roads[0].SetFloat("_Opacity", Mathf.Lerp(0,1f, lerpTime));
            Roads[1].SetFloat("_Opacity", Mathf.Lerp(0, 1f, lerpTime));
            Roads[2].SetFloat("_Opacity", Mathf.Lerp(0, 1f, lerpTime));

            Roads[0].SetFloat("_Wetness", Mathf.Lerp(1, 1.5f, lerpTime));
            Roads[1].SetFloat("_Wetness", Mathf.Lerp(1, 1.5f, lerpTime));
            Roads[2].SetFloat("_Wetness", Mathf.Lerp(1, 1.5f, lerpTime));

            if (lerpTime >= 1f)
            {
                isLerping = false;
            }
        }
    }


    public void Hasnat()
    {
        if (!isLerping)
        {
            isLerping = true;
            lerpTime = 0f;
        }
        
    }

    public void H2()
    {
        Roads[0].SetFloat("_Opacity", 0);
        Roads[1].SetFloat("_Opacity", 0);
        Roads[2].SetFloat("_Opacity", 0);

        Roads[0].SetFloat("_Wetness",1);
        Roads[1].SetFloat("_Wetness", 1);
        Roads[2].SetFloat("_Wetness", 1);
    }

}
