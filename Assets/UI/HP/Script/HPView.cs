using ProjectCore.Events;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

using ProjectCore.UI;

public class HPView : UiPanelInAndOut
{
    [SerializeField] private Button PanelEnabler;
    [SerializeField] private Button gotoMainMenuBtn;

    [SerializeField] private HPState HPState;
    [SerializeField] private GameEvent GoToPanel;
    [SerializeField] private GameEvent GotoMainMenu;

    //[SerializeField] private HP1State LevelCompleteViewState;

    private void OnEnable()
    {
        PanelEnabler.onClick.AddListener(OnNextButtonPressed);
        gotoMainMenuBtn.onClick.AddListener(OnGotoMainMenu);
    }

    private void OnDisable()
    {
        PanelEnabler.onClick.RemoveListener(OnNextButtonPressed);
        gotoMainMenuBtn.onClick.RemoveListener(OnGotoMainMenu);
    }

    private void OnNextButtonPressed()
    {
        GoToPanel.Invoke();
    }

    private void OnGotoMainMenu()
    {
        //GotoMainMenu.Invoke();
        HPState.CloseView(UICloseReasons.ResumeAny);
    }
}
