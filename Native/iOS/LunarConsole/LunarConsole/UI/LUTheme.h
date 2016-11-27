//
//  LUTheme.h
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

#import <UIKit/UIKit.h>

@interface LUCellSkin : NSObject

+ (instancetype)cellSkin;

@property (weak, nonatomic, readonly) UIImage *icon;
@property (weak, nonatomic, readonly) UIColor *textColor;
@property (weak, nonatomic, readonly) UIColor *backgroundColorLight;
@property (weak, nonatomic, readonly) UIColor *backgroundColorDark;

@end

@interface LUTheme : NSObject

@property (weak, nonatomic, readonly) UIColor *tableColor;
@property (weak, nonatomic, readonly) UIColor *logButtonTitleColor;
@property (weak, nonatomic, readonly) UIColor *logButtonTitleSelectedColor;

@property (weak, nonatomic, readonly) LUCellSkin *cellLog;
@property (weak, nonatomic, readonly) LUCellSkin *cellError;
@property (weak, nonatomic, readonly) LUCellSkin *cellWarning;

@property (weak, nonatomic, readonly) UIFont *font;
@property (weak, nonatomic, readonly) UIFont *fontSmall;
@property (nonatomic, readonly) NSLineBreakMode lineBreakMode;

@property (nonatomic, readonly) CGFloat cellHeight;
@property (nonatomic, readonly) CGFloat indentHor;
@property (nonatomic, readonly) CGFloat indentVer;
@property (nonatomic, readonly) CGFloat buttonWidth;
@property (nonatomic, readonly) CGFloat buttonHeight;

@property (weak, nonatomic, readonly) UIImage *collapseBackgroundImage;
@property (weak, nonatomic, readonly) UIColor *collapseBackgroundColor;
@property (weak, nonatomic, readonly) UIColor *collapseTextColor;

@property (weak, nonatomic, readonly) UIFont  *actionsWarningFont;
@property (weak, nonatomic, readonly) UIColor *actionsWarningTextColor;
@property (weak, nonatomic, readonly) UIFont  *actionsFont;
@property (weak, nonatomic, readonly) UIColor *actionsTextColor;
@property (weak, nonatomic, readonly) UIColor *actionsBackgroundColorLight;
@property (weak, nonatomic, readonly) UIColor *actionsBackgroundColorDark;
@property (weak, nonatomic, readonly) UIFont  *actionsGroupFont;
@property (weak, nonatomic, readonly) UIColor *actionsGroupTextColor;
@property (weak, nonatomic, readonly) UIColor *actionsGroupBackgroundColor;

@property (weak, nonatomic, readonly) UIFont  *contextMenuFont;
@property (weak, nonatomic, readonly) UIColor *contextMenuBackgroundColor;
@property (weak, nonatomic, readonly) UIColor *contextMenuTextColor;
@property (weak, nonatomic, readonly) UIColor *contextMenuTextHighlightColor;

+ (LUTheme *)mainTheme;

@end

