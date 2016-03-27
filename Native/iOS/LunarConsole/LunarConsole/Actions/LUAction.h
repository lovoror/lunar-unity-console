//
//  LUAction.h
//  LunarConsole
//
//  Created by Alex Lementuev on 2/24/16.
//  Copyright © 2016 Space Madness. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LUActionGroup;

@interface LUAction : NSObject

@property (nonatomic, assign) LUActionGroup *group;
@property (nonatomic, readonly) NSString *groupName;

@property (nonatomic, readonly) int actionId;
@property (nonatomic, readonly) NSString *name;

+ (instancetype)actionWithId:(int)actionId name:(NSString *)name;
- (instancetype)initWithId:(int)actionId name:(NSString *)name;

- (NSComparisonResult)compare:(LUAction *)other;

@end
