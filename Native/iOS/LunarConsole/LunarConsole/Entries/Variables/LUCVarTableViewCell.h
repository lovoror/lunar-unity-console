//
//  LUCVarTableViewCell.h
//  LunarConsole
//
//  Created by Alex Lementuev on 4/7/16.
//  Copyright © 2016 Space Madness. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LUCVar;

@interface LUCVarTableViewCell : UITableViewCell

@property (nonatomic, readonly) NSString *cellNibName;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

- (void)setupVariable:(LUCVar *)variable;

@end
