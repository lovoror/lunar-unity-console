//
//  LUActionRegistry.m
//  LunarConsole
//
//  Created by Alex Lementuev on 2/24/16.
//  Copyright © 2016 Space Madness. All rights reserved.
//

#import "Lunar.h"

#import "LUActionRegistry.h"

@interface LUActionRegistry()
{
    LUSortedList * _groups;
}
@end

@implementation LUActionRegistry

+ (instancetype)registry
{
    return LU_AUTORELEASE([[self alloc] init]);
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _groups = [LUSortedList new];
    }
    return self;
}

- (void)dealloc
{
    LU_RELEASE(_groups);
    LU_SUPER_DEALLOC
}

#pragma mark -
#pragma mark Actions

- (LUAction *)registerActionWithId:(int)actionId name:(NSString *)actionName group:(NSString *)groupName
{
    BOOL addedGroup = NO;
    
    NSUInteger groupIndex = [self indexOfGroupWithName:groupName];
    if (groupIndex == NSNotFound)
    {
        groupIndex = [self addGroupWithName:groupName];
        addedGroup = YES;
    }
    
    LUActionGroup *group = [self groupAtIndex:groupIndex];
    NSUInteger actionIndex = [group indexOfActionWithName:actionName];
    if (actionIndex == NSNotFound)
    {
        LUAction *action = [LUAction actionWithId:actionId name:actionName];
        action.group = group;
        actionIndex = [group addAction:action];
        
        if (addedGroup)
        {
            [_delegate actionRegistry:self didAddGroup:group atIndex:groupIndex];
        }
        else
        {
            [_delegate actionRegistry:self didAddAction:action atIndex:actionIndex groupIndex:groupIndex];
        }
    }
    
    return [group actionAtIndex:actionIndex];
}

- (BOOL)unregisterActionWithId:(int)actionId
{
    for (NSInteger groupIndex = _groups.count - 1; groupIndex >= 0; --groupIndex)
    {
        LUActionGroup *group = _groups[groupIndex];
        for (NSInteger actionIndex = group.actionCount - 1; actionIndex >= 0; --actionIndex)
        {
            LUAction *action = [group actionAtIndex:actionIndex];
            if (action.actionId == actionId)
            {
                action = LU_AUTORELEASE(LU_RETAIN(action));
                [group removeActionAtIndex:actionIndex];
                
                if (group.actionCount == 0) // group is empty
                {
                    group = LU_AUTORELEASE(LU_RETAIN(group)); // keep a reference to the group
                    [_groups removeObjectAtIndex:groupIndex]; // remove group
                    
                    [_delegate actionRegistry:self didRemoveGroup:group atIndex:groupIndex];
                }
                else // should delete group
                {
                    [_delegate actionRegistry:self didRemoveAction:action atIndex:actionIndex groupIndex:groupIndex];
                }
                
                return YES;
            }
        }
    }
    
    return NO;
}

- (BOOL)unregisterGroupWithName:(NSString *)name
{
    LUAssert(name);
    if (name == nil) return NO;
    
    for (NSInteger groupIndex = _groups.count - 1; groupIndex >= 0; --groupIndex)
    {
        LUActionGroup *group = _groups[groupIndex];
        if ([group.name isEqualToString:name])
        {
            group = LU_AUTORELEASE(LU_RETAIN(group)); // keep a reference to the group
            [_groups removeObjectAtIndex:groupIndex]; // remove group
            
            [_delegate actionRegistry:self didRemoveGroup:group atIndex:groupIndex];
            return YES;
        }
    }
    
    return NO;
}

#pragma mark -
#pragma mark Groups

- (LUActionGroup *)groupAtIndex:(NSUInteger)index
{
    return [_groups objectAtIndex:index];
}

- (NSUInteger)indexOfGroupWithName:(NSString *)name
{
    for (NSInteger index = 0; index < _groups.count; ++index)
    {
        LUActionGroup *group = _groups[index];
        if ([group.name isEqualToString:name])
        {
            return index;
        }
    }
    
    return NSNotFound;
}

- (NSInteger)addGroupWithName:(NSString *)name
{
    return [_groups addObject:[LUActionGroup groupWithName:name]];
}

- (NSUInteger)indexOfGroup:(LUActionGroup *)group
{
    NSInteger index = 0;
    for (LUActionGroup *g in _groups)
    {
        if (g == group)
        {
            return index;
        }
        
        ++index;
    }
    
    return NSNotFound;
}

#pragma mark -
#pragma mark Properties

- (NSArray *)groups
{
    return _groups.innerArray;
}

- (NSUInteger)groupCount
{
    return _groups.count;
}

@end
