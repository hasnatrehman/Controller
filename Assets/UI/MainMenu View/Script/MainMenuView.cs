using ProjectCore.Events;
using UnityEngine;
using UnityEngine.UI;

public class MainMenuView : UiPanelInAndOut
{
    [SerializeField] private Button PlayButton;
    [SerializeField] private Button HpButton;

    [SerializeField] private GameEvent ShowLevelCompleteView;
    [SerializeField] private GameEvent GoToHP;

    [SerializeField] private GameEvent GoToLevelSelection;

    [SerializeField] private MainMenuState MainMenuState;
    private void OnEnable()
    {
        PlayButton.onClick.AddListener(OpenViewButtonPressed);
        HpButton.onClick.AddListener(ONGoToHP);
    }

    private void OnDisable()
    {
        PlayButton.onClick.RemoveListener(OpenViewButtonPressed);
        HpButton.onClick.RemoveListener(ONGoToHP);
    }

    

    private void OpenViewButtonPressed()
    {
        /*  ShowLevelCompleteView.Invoke()*/
        //MainMenuState.GotoGame();
        GoToLevelSelection.Invoke();
    }

    private void ONGoToHP()
    {
        GoToHP.Invoke();
    }
}
