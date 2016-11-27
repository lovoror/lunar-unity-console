//
//  AlertView.m
//  LunarConsoleApp
//
//  Created by Alex Lementuev on 3/17/16.
//  Copyright © 2016 Space Madness. All rights reserved.
//

#import "AlertView.h"
#import "Lunar.h"

@interface AlertView () <UIAlertViewDelegate>
{
    AlertViewCompletion _completion;
}

@end

@implementation AlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message okButtonTitle:(NSString *)okButtonCancel completion:(AlertViewCompletion)completion
{
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:okButtonCancel otherButtonTitles:@"Cancel", nil];
    if (self)
    {
        _completion = [completion copy];
    }
    return self;
}


#pragma mark -
#pragma mark UIAlertViewDelegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_completion)
    {
        _completion(self, buttonIndex);
    }
}

@end
