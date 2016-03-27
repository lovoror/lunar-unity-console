package spacemadness.com.lunarconsole.console;

import android.util.Log;

import com.unity3d.player.UnityPlayer;

public class UnityScriptMessenger
{
    private static final String TAG = UnityScriptMessenger.class.getSimpleName();

    private final String objectName;
    private final String methodName;

    public UnityScriptMessenger(String objectName, String methodName)
    {
        if (objectName == null || objectName.length() == 0)
        {
            throw new IllegalArgumentException("Object name is null or empty");
        }

        if (methodName == null || methodName.length() == 0)
        {
            throw new IllegalArgumentException("Methods name is null or empty");
        }

        this.objectName = objectName;
        this.methodName = methodName;
    }

    public void sendMessage(String message)
    {
        if (message != null && message.length() > 0)
        {
            UnityPlayer.UnitySendMessage(objectName, methodName, message);
        }
        else
        {
            Log.e(TAG, "Can't send null or empty message");
        }
    }
}
