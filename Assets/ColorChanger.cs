using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class ColorChanger : MonoBehaviour, IPointerClickHandler
{
    public Color TargetColor;
    Color _defaultColor;
    bool _isClickingAgain;
    public bool NeedToRevert;

    private void Start()
    {
        
    }
    public void OnPointerClick(PointerEventData eventData)
    {

        if (NeedToRevert)
            CustomUIHandler.instance.RevertColor();
        
            if(GetComponent<Button>() != null)
            {
                if(GetComponent<Button>().image.color == Color.green)
                {
                      GetComponent<Button>().image.color = Color.white;
                }
                else
                {
                  GetComponent<Button>().image.color = Color.green;
                }
            }
            else
            {

                if (GetComponent<Toggle>().image.color == Color.green)
                {
                    GetComponent<Toggle>().image.color = Color.white;
                }
                else
                {
                    GetComponent<Toggle>().image.color = Color.green;
                }
            }

            
        
        

        
      

    }

}
