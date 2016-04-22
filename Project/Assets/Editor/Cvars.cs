using UnityEngine;
using UnityEditor;

using System.Collections;

using LunarConsolePlugin;

[InitializeOnLoad]
public static class Cvars
{
    public static readonly CVar c_bool = new CVar("bool", false);
    public static readonly CVar c_int = new CVar("int", 0);
    public static readonly CVar c_float = new CVar("float", 0.0f);
    public static readonly CVar c_string = new CVar("string", "text");
    public static readonly CVar c_color = new CVar("color", new Color());
    public static readonly CVar c_rect = new CVar("rect", new Rect());
    public static readonly CVar c_vector2 = new CVar("vector2", new Vector2());
    public static readonly CVar c_vector3 = new CVar("vector3", new Vector3());
    public static readonly CVar c_vector4 = new CVar("vector4", new Vector4());
}
