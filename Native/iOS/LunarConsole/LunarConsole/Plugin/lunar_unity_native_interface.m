//
//  lunar_unity_native_interface.m
//
//  Lunar Unity Mobile Console
//  https://github.com/SpaceMadness/lunar-unity-console
//
//  Copyright 2016 Alex Lementuev, SpaceMadness.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#include <Foundation/Foundation.h>

#include "lunar_unity_native_interface.h"

#import "Lunar.h"
#import "LUConsolePlugin.h"

static LUConsolePlugin * _lunarConsolePlugin;

OBJC_EXTERN // see: https://github.com/SpaceMadness/lunar-unity-console/pull/18
void __lunar_console_initialize(const char *targetNameStr, const char *methodNameStr, const char * versionStr, int capacity, int trimCount, const char *gestureStr)
{
    lunar_dispatch_main(^{
        if (_lunarConsolePlugin == nil) {
            NSString *targetName = [[NSString alloc] initWithUTF8String:targetNameStr];
            NSString *methodName = [[NSString alloc] initWithUTF8String:methodNameStr];
            NSString *version = [[NSString alloc] initWithUTF8String:versionStr];
            NSString *gesture = [[NSString alloc] initWithUTF8String:gestureStr];
            
            _lunarConsolePlugin = [[LUConsolePlugin alloc] initWithTargetName:targetName
                                                                   methodName:methodName
                                                                      version:version
                                                                  capacity:capacity
                                                                 trimCount:trimCount
                                                               gestureName:gesture];
            [_lunarConsolePlugin start];
            
        }
    });
}

OBJC_EXTERN // see: https://github.com/SpaceMadness/lunar-unity-console/pull/18
void __lunar_console_destroy() {
    lunar_dispatch_main(^{
        _lunarConsolePlugin = nil;
    });
}

OBJC_EXTERN // see: https://github.com/SpaceMadness/lunar-unity-console/pull/18
void __lunar_console_show()
{
    lunar_dispatch_main(^{
        LUAssert(_lunarConsolePlugin);
        [_lunarConsolePlugin showConsole];
    });
}

OBJC_EXTERN // see: https://github.com/SpaceMadness/lunar-unity-console/pull/18
void __lunar_console_hide()
{
    lunar_dispatch_main(^{
        LUAssert(_lunarConsolePlugin);
        [_lunarConsolePlugin hideConsole];
    });
}

OBJC_EXTERN // see: https://github.com/SpaceMadness/lunar-unity-console/pull/18
void __lunar_console_clear()
{
    lunar_dispatch_main(^{
        LUAssert(_lunarConsolePlugin);
        [_lunarConsolePlugin clear];
    });
}

OBJC_EXTERN // see: https://github.com/SpaceMadness/lunar-unity-console/pull/18
void __lunar_console_log_message(const char * messageStr, const char * stackTraceStr, int type)
{
    NSString *message = [[NSString alloc] initWithUTF8String:messageStr];
    NSString *stackTrace = [[NSString alloc] initWithUTF8String:stackTraceStr];

    [_lunarConsolePlugin logMessage:message stackTrace:stackTrace type:type];
    
}

void __lunar_console_action_add(int actionId, const char *actionNameStr)
{
    NSString *actionName = [[NSString alloc] initWithUTF8String:actionNameStr];
    lunar_dispatch_main(^{
        [_lunarConsolePlugin registerActionWithId:actionId name:actionName];
    });
}

void __lunar_console_action_remove(int actionId)
{
    lunar_dispatch_main(^{
        [_lunarConsolePlugin unregisterActionWithId:actionId];
    });
}

void __lunar_console_cvar_add(int entryId, const char *nameStr, const char *typeStr, const char *valueStr)
{
    lunar_dispatch_main(^{
        NSString *name = [[NSString alloc] initWithUTF8String:nameStr];
        NSString *type = [[NSString alloc] initWithUTF8String:typeStr];
        NSString *value = [[NSString alloc] initWithUTF8String:valueStr];
        [_lunarConsolePlugin registerVariableWithId:entryId name:name type:type value:value];
    });
}

void __lunar_console_cvar_set(int entryId, const char *valueStr)
{
    lunar_dispatch_main(^{
        NSString *value = [[NSString alloc] initWithUTF8String:valueStr];
        [_lunarConsolePlugin setValue:value forVariableWithId:entryId];
    });
}
