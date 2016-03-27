using UnityEngine;
using UnityEditor;

using System.Collections;

using LunarConsolePlugin;

namespace LunarConsolePluginInternal
{
    public class QuickActionWindow : EditorWindow
    {
        [SerializeField]
        string m_filterText;

        [SerializeField]
        Vector2 m_scrollPos;

        public QuickActionWindow()
        {
            this.titleContent = new GUIContent("Quick Actions");
        }

        void OnGUI()
        {
            if (LunarConsole.actionRegistry == null)
            {
                GUILayout.Label(Constants.PluginDisplayName + " is not initialized");
            }
            else
            {
                m_scrollPos = GUILayout.BeginScrollView(m_scrollPos, GUILayout.Width(this.position.width), GUILayout.Height(this.position.height));
                QuickActionRegistry registry = LunarConsole.actionRegistry;
                foreach (var actionGroup in registry.actionGroups)
                {
                    OnActionGroupGUI(actionGroup);
                }
                GUILayout.EndScrollView();
            }
        }

        void OnActionGroupGUI(QuickActionGroup actionGroup)
        {
            if (!string.IsNullOrEmpty(actionGroup.name))
            {
                GUILayout.Label(actionGroup.name, EditorStyles.largeLabel);
            }

            foreach (var action in actionGroup.actions)
            {
                OnActionGroupGUI(action);
            }
        }

        void OnActionGroupGUI(QuickAction action)
        {
            if (GUILayout.Button(action.name))
            {
                Debug.Log(action.id);
            }
        }
    }
}
