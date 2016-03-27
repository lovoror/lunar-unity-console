//
//  LUActionOverlayView.m
//  LunarConsoleApp
//
//  Created by Alex Lementuev on 3/17/16.
//  Copyright © 2016 Space Madness. All rights reserved.
//

#import "ActionOverlayView.h"
#import "AlertView.h"
#import "ViewController.h"

#import "Lunar.h"

#include "lunar_unity_native_interface.h"

typedef void (^InputCallback)(NSString *input);

@interface ActionOverlayView ()
{
    int _nextActionId;
}
@end

@implementation ActionOverlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSString *nibName = NSStringFromClass([self class]);
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] firstObject];
        view.frame = self.bounds;
        [self addSubview:view];
    }
    return self;
}

#pragma mark -
#pragma mark Input

- (void)showInputControllerWithMessage:(NSString *)message callback:(InputCallback)callback
{
    AlertView *alertView = [[AlertView alloc] initWithTitle:@"Lunar"
                                                    message:message
                                              okButtonTitle:@"Ok"
                                                 completion:^(AlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0)
        {
            NSString *input = [alertView textFieldAtIndex:0].text;
            if (callback)
            {
                callback(input);
            }
        }
    }];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
    LU_RELEASE(alertView);
}

#pragma mark -
#pragma mark Actions

- (IBAction)onAddAction:(id)sender
{
    [self showInputControllerWithMessage:@"Add actions" callback:^(NSString *actionData) {
        
        NSData *data = [actionData dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        LUConsolePlugin *plugin = [ViewController pluginInstance];
        for (NSString *group in json)
        {
            NSArray *actions = [json objectForKey:group];
            for (NSString *action in actions)
            {
                [plugin registerActionWithId:_nextActionId++ name:action group:group];
            }
        }
    }];
}

- (IBAction)onRemoveAction:(id)sender
{
    [self showInputControllerWithMessage:@"Action name" callback:^(NSString *actionName) {
        LUConsolePlugin *plugin = [ViewController pluginInstance];
        for (LUActionGroup *group in plugin.actionRegistry.groups)
        {
            for (LUAction *action in group.actions)
            {
                if ([action.name isEqualToString:actionName])
                {
                    [plugin unregisterActionWithId:action.actionId];
                }
            }
        }
    }];
}

- (IBAction)onRemoveGroup:(id)sender
{
}

@end
