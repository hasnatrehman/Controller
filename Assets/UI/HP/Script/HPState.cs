using ProjectCore.Events;
using ProjectCore.StateMachine;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[CreateAssetMenu(fileName = "HPSXState", menuName = "ProjectCore/State Machine/States/HPSXState")]
public class HPState : State
{
    [SerializeField] private string PrefabName;

    [SerializeField] private GameEvent GoToBeeratherPanel;
    
   
    

   

    public void OnGotoPanel()
    {
        GoToBeeratherPanel.Invoke();
    }
    
}
