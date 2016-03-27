//
//  LUActionGroup.h
//  LunarConsole
//
//  Created by Alex Lementuev on 3/6/16.
//  Copyright © 2016 Space Madness. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LUAction;

@interface LUActionGroup : NSObject

@property (nonatomic, readonly) NSString * name;
@property (nonatomic, readonly) NSArray  * actions;
@property (nonatomic, readonly) NSUInteger actionCount;

+ (instancetype)groupWithName:(NSString *)name;
- (instancetype)initWithName:(NSString *)name;

- (NSUInteger)addAction:(LUAction *)action;
- (LUAction *)actionAtIndex:(NSUInteger)index;
- (LUAction *)removeActionAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfActionWithName:(NSString *)name;

- (NSComparisonResult)compare:(LUActionGroup *)other;

@end
