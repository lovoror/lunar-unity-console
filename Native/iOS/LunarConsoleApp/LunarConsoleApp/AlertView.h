//
//  AlertView.h
//  LunarConsoleApp
//
//  Created by Alex Lementuev on 3/17/16.
//  Copyright © 2016 Space Madness. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlertView;

typedef void (^AlertViewCompletion)(AlertView *alertView, NSInteger buttonIndex);

@interface AlertView : UIAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message okButtonTitle:(NSString *)okButtonCancel completion:(AlertViewCompletion)completion;

@end
