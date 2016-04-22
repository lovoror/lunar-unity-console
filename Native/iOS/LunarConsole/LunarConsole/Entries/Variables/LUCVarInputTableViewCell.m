//
//  LUCVarInputTableViewCell.m
//  LunarConsole
//
//  Created by Alex Lementuev on 4/20/16.
//  Copyright © 2016 Space Madness. All rights reserved.
//

#import "LUCVarInputTableViewCell.h"

#import "Lunar.h"

@interface LUCVarInputTableViewCell () <UITextFieldDelegate>

@property (nonatomic, assign) IBOutlet UITextField *inputField;

@end

@implementation LUCVarInputTableViewCell

#pragma mark -
#pragma mark Inheritance

- (void)setupVariable:(LUCVar *)variable
{
    [super setupVariable:variable];
    
    _inputField.text = variable.value;
}

- (BOOL)isValidInputText:(NSString *)text
{
    LU_SHOULD_IMPLEMENT_METHOD
    return NO;
}

#pragma mark -
#pragma mark Cell loading

- (NSString *)cellNibName
{
    return NSStringFromClass([LUCVarInputTableViewCell class]);
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![self isValidInputText:textField.text])
    {
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

@end
