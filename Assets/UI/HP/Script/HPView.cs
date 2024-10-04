using ProjectCore.Events;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class HPView : MonoBehaviour
{
    [SerializeField] private Button PanelEnabler;
    [SerializeField] private HPState HPState;
    [SerializeField] private GameEvent GoToPanel;

    [SerializeField] private LevelCompleteViewState LevelCompleteViewState;

    private void OnEnable()
    {
        PanelEnabler.onClick.AddListener(OnNextButtonPressed);
    }

    private void OnDisable()
    {
        PanelEnabler.onClick.RemoveListener(OnNextButtonPressed);
    }

    private void OnNextButtonPressed()
    {
        GoToPanel.Invoke();
    }
}
