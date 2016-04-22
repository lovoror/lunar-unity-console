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
            #if UNITY_5_0
            this.title = "Quick Actions";
            #else
            this.titleContent = new GUIContent("Quick Actions");
            #endif

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
                foreach (var cvar in registry.cvars)
                {
                    OnCVarGUI(cvar);
                }
                GUILayout.EndScrollView();
            }
        }

        #region Actions

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

        #endregion

        #region CVars

        void OnCVarGUI(CVar cvar)
        {
            switch (cvar.Type)
            {
                case CVarType.Boolean:
                {
                    bool value = EditorGUILayout.Toggle(cvar.Name, cvar.BoolValue);
                    if (value != cvar.BoolValue)
                    {
                        cvar.BoolValue = value;
                    }
                    break;
                }
                case CVarType.Integer:
                {
                    int value = EditorGUILayout.IntField(cvar.Name, cvar.IntValue);
                    if (value != cvar.IntValue)
                    {
                        cvar.IntValue = value;
                    }
                    break;
                }
                case CVarType.Float:
                {
                    float value = EditorGUILayout.FloatField(cvar.Name, cvar.FloatValue);
                    if (value != cvar.FloatValue)
                    {
                        cvar.FloatValue = value;
                    }
                    break;
                }
                case CVarType.String:
                {
                    string value = EditorGUILayout.TextField(cvar.Name, cvar.Value);
                    if (value != cvar.Value)
                    {
                        cvar.Value = value;
                    }
                    break;
                }
                case CVarType.Color:
                {
                    Color value = EditorGUILayout.ColorField(cvar.Name, cvar.ColorValue);
                    if (value != cvar.ColorValue)
                    {
                        cvar.ColorValue = value;
                    }
                    break;
                }
                case CVarType.Rect:
                {
                    Rect value = EditorGUILayout.RectField(cvar.Name, cvar.RectValue);
                    if (value != cvar.RectValue)
                    {
                        cvar.RectValue = value;
                    }
                    break;
                }
                case CVarType.Vector2:
                {
                    Vector2 value = EditorGUILayout.Vector2Field(cvar.Name, cvar.Vector2Value);
                    if (value != cvar.Vector2Value)
                    {
                        cvar.Vector2Value = value;
                    }
                    break;
                }
                case CVarType.Vector3:
                {
                    Vector3 value = EditorGUILayout.Vector3Field(cvar.Name, cvar.Vector3Value);
                    if (value != cvar.Vector3Value)
                    {
                        cvar.Vector3Value = value;
                    }
                    break;
                }
                case CVarType.Vector4:
                {
                    Vector4 value = EditorGUILayout.Vector4Field(cvar.Name, cvar.Vector4Value);
                    if (value != cvar.Vector4Value)
                    {
                        cvar.Vector4Value = value;
                    }
                    break;
                }
            }
        }

        #endregion
    }
}
