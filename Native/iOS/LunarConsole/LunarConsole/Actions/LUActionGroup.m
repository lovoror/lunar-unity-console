//
//  LUActionGroup.m
//  LunarConsole
//
//  Created by Alex Lementuev on 3/6/16.
//  Copyright © 2016 Space Madness. All rights reserved.
//

#import "Lunar.h"

#import "LUActionGroup.h"

@interface LUActionGroup ()
{
    LUSortedList * _actions;
}

@end

@implementation LUActionGroup

+ (instancetype)groupWithName:(NSString *)name
{
    return LU_AUTORELEASE([[self alloc] initWithName:name]);
}

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self)
    {
        _name = LU_RETAIN(name);
        _actions = [LUSortedList new];
    }
    return self;
}

- (void)dealloc
{
    LU_RELEASE(_name);
    LU_RELEASE(_actions);
    
    LU_SUPER_DEALLOC
}

#pragma mark -
#pragma mark Actions

- (NSUInteger)addAction:(LUAction *)action
{
    LUAssert(action != nil);
    if (action != nil)
    {
        return [_actions addObject:action];
    }
    
    return NSNotFound;
}

- (LUAction *)actionAtIndex:(NSUInteger)index
{
    LUAssert(index < _actions.count);
    return [_actions objectAtIndex:index];
}

- (LUAction *)removeActionAtIndex:(NSUInteger)index
{
    LUAction *action = LU_RETAIN([_actions objectAtIndex:index]);
    [_actions removeObjectAtIndex:index];
    return LU_AUTORELEASE(action);
}

- (NSUInteger)indexOfActionWithName:(NSString *)name
{
    for (NSUInteger index = 0; index < _actions.count; ++index)
    {
        LUAction *action = _actions[index];
        if ([action.name isEqualToString:name])
        {
            return index;
        }
    }
    
    return NSNotFound;
}

#pragma mark -
#pragma mark Comparable

- (NSComparisonResult)compare:(LUActionGroup *)other
{
    return [_name compare:other.name];
}

#pragma mark -
#pragma mark Properties

- (NSArray *)actions
{
    return _actions.innerArray;
}

- (NSUInteger)actionCount
{
    return _actions.count;
}

@end