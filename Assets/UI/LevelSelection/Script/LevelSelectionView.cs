using ProjectCore.Events;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

using ProjectCore.UI;

public class LevelSelectionView : UiPanelInAndOut
{
    [SerializeField] private Button GoNext;
    [SerializeField] private Button GoBack;

    [SerializeField] private GameEvent GotoMainMenu;
    [SerializeField] private GameEvent GotoGarageSelection;



    //[SerializeField] private HP1State LevelCompleteViewState;

    private void OnEnable()
    {
        GoBack.onClick.AddListener(OnBack);
        GoNext.onClick.AddListener(OnNext);
    }

    private void OnDisable()
    {
        GoBack.onClick.RemoveListener(OnBack);
        GoNext.onClick.RemoveListener(OnNext);

    }

    private void OnNext()
    {
        GotoGarageSelection.Invoke();
    }

    private void OnBack()
    {
        GotoMainMenu.Invoke();
    }
}
