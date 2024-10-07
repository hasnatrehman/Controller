using ProjectCore.Events;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

using ProjectCore.UI;

public class GarageSelectionView : UiPanelInAndOut
{
    //[SerializeField] private Button PanelEnabler;
    [SerializeField] private Button gotoMainMenuBtn;

    [SerializeField] private GarageSelectionState GarageSelectionState;
    [SerializeField] private GameEvent GoToGPPanel;
    [SerializeField] private GameEvent GotoLevelSelection;

    //[SerializeField] private HP1State LevelCompleteViewState;

    private void OnEnable()
    {
       // PanelEnabler.onClick.AddListener(OnNextButtonPressed);
        gotoMainMenuBtn.onClick.AddListener(OnGotoLevelSelection);
    }

    private void OnDisable()
    {
      //  PanelEnabler.onClick.RemoveListener(OnNextButtonPressed);
        gotoMainMenuBtn.onClick.RemoveListener(OnGotoLevelSelection);
    }

    //private void OnNextButtonPressed()
    //{
    //    GoToPanel.Invoke();
    //}

    private void OnGotoLevelSelection()
    {
        GotoLevelSelection.Invoke();
       // GarageSelectionState.CloseView(UICloseReasons.ResumeAny);
    }
}
