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


    //[SerializeField] private HP1State LevelCompleteViewState;

    private void OnEnable()
    {
        GoBack.onClick.AddListener(OnBack);
    }

    private void OnDisable()
    {
        GoBack.onClick.RemoveListener(OnBack);

    }

    private void OnNext()
    {

    }

    private void OnBack()
    {
        GotoMainMenu.Invoke();
    }
}
