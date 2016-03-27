using UnityEngine;
using System.Collections;

using LunarConsolePlugin;

public class QuickActions : MonoBehaviour
{
    // Use this for initialization
    void Start()
    {
        LunarConsole.RegisterAction("Reload Scene", delegate {
            Application.LoadLevel(Application.loadedLevelName);
        });
    }

    // Update is called once per frame
    void Update()
    {
    }
}
