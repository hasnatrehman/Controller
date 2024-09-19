using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WeatherControl : MonoBehaviour
{
   public Light DirectionalLightImp;
   public Light DirectionalLightNotImp;
   public GameObject RainParticle;
   public Color DirectionalLightTargetColor;
   public Material[] Roads;

   public float lerpDuration = 2f;

   public static Action RainParticles;
    public static Func<GameObject> getPlayerObject;
    private Color initialColorImp;
   private Color initialColorNotImp;
   private bool isLerping = false;
   private float lerpTime = 0f;

    private void Start()
    {

        RainParticle = getPlayerObject.Invoke();
        H2();


        if (DirectionalLightImp != null)
        {
           // DirectionalLightImp = DirectionalLightImp.GetComponent<Light>();
            if (DirectionalLightImp != null)
            {
                initialColorImp = DirectionalLightImp.color;
            }
        }

        if (DirectionalLightNotImp != null)
        {
          //  DirectionalLightNotImp = DirectionalLightNotImp.GetComponent<Light>();
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
            foreach (Material M in Roads)
            {
                M.SetFloat("_Opacity", Mathf.Lerp(0, 1f, lerpTime));
                M.SetFloat("_Wetness", Mathf.Lerp(1, 1.5f, lerpTime));
            }
           

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
        DirectionalLightImp.shadows = LightShadows.None;
        DirectionalLightNotImp.shadows = LightShadows.None;

        RainParticle.SetActive(true);

    }

    public void H2()
    {
        foreach (Material M in Roads)
        {
            M.SetFloat("_Opacity", 0);
            M.SetFloat("_Wetness", 1);
        }
        DirectionalLightImp.shadows = LightShadows.Hard;
        

        DirectionalLightImp.color = Color.white;

        DirectionalLightNotImp.color = Color.white;

        RainParticle.SetActive(false);

    }

}
