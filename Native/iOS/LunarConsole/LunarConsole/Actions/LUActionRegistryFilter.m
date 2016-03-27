//
//  LUActionRegistryFilter.m
//  LunarConsole
//
//  Created by Alex Lementuev on 3/11/16.
//  Copyright © 2016 Space Madness. All rights reserved.
//

#import "Lunar.h"

#import "LUActionRegistryFilter.h"

@interface LUActionRegistryFilter () <LUActionRegistryDelegate>
{
    NSString * _filterText;
}

@property (nonatomic, strong) NSMutableArray * filteredGroups;

@end

@implementation LUActionRegistryFilter

+ (instancetype)filterWithActionRegistry:(LUActionRegistry *)actionRegistry
{
    return LU_AUTORELEASE([[self alloc] initWithActionRegistry:actionRegistry]);
}

- (instancetype)initWithActionRegistry:(LUActionRegistry *)actionRegistry
{
    self = [super init];
    if (self)
    {
        _registry = LU_RETAIN(actionRegistry);
        _registry.delegate = self;
    }
    return self;
}

- (void)dealloc
{
    if (_registry.delegate == self)
    {
        _registry.delegate = nil;
    }
    
    LU_RELEASE(_registry);
    LU_RELEASE(_filteredGroups);
    LU_RELEASE(_filterText);
    LU_SUPER_DEALLOC
}

#pragma mark -
#pragma mark Filtering

- (BOOL)setFilterText:(NSString *)filterText
{
    if (_filterText != filterText) // filter text has changed
    {
        NSString *oldFilterText = LU_AUTORELEASE(LU_RETAIN(_filterText)); // manual reference counting rocks!
        
        LU_RELEASE(_filterText);
        _filterText = LU_RETAIN(filterText);
        
        if (filterText.length > oldFilterText.length && (oldFilterText.length == 0 || [filterText hasPrefix:oldFilterText])) // added more characters
        {
            return [self appendFilter];
        }
        
        return [self applyFilter];
    }
    
    return NO;
}

/// applies filter to already filtered items
- (BOOL)appendFilter
{
    if (self.isFiltering)
    {
        self.filteredGroups = [self filterGroups:_filteredGroups];
        return YES;
    }
    
    return [self applyFilter];
}

/// setup filtering for the list
- (BOOL)applyFilter
{
    if (_filterText.length > 0)
    {
        self.filteredGroups = [self filterGroups:_registry.groups];
        return YES;
    }
    
    return [self removeFilter];
}

- (BOOL)removeFilter
{
    if (self.isFiltering)
    {
        self.filteredGroups = nil;
        return YES;
    }
    
    return NO;
}

- (NSMutableArray *)filterGroups:(NSArray *)groups
{
    NSMutableArray *filteredGroups = [NSMutableArray array];
    for (LUActionGroup *group in groups)
    {
        LUActionGroup *filteredGroup = nil;
        
        for (LUAction *action in group.actions)
        {
            if ([self filterAction:action])
            {
                if (filteredGroup == nil)
                {
                    filteredGroup = [LUActionGroup groupWithName:group.name];
                }
                
                [filteredGroup addAction:action];
            }
        }
        
        if (filteredGroup != nil)
        {
            [filteredGroups addObject:filteredGroup];
        }
    }
    
    return filteredGroups;
}

- (BOOL)filterAction:(LUAction *)action
{
    // filter by message
    return _filterText.length == 0 || [action.name rangeOfString:_filterText options:NSCaseInsensitiveSearch].location != NSNotFound;
}

- (NSUInteger)addFilteredGroup:(LUActionGroup *)group
{
    // insert in the sorted order
    for (NSUInteger index = 0; index < _filteredGroups.count; ++index)
    {
        NSComparisonResult comparisonResult = [group compare:_filteredGroups[index]];
        if (comparisonResult == NSOrderedAscending)
        {
            LUActionGroup *filteredGroup = [LUActionGroup groupWithName:group.name];
            [_filteredGroups insertObject:filteredGroup atIndex:index];
            return index;
        }
        else if (comparisonResult == NSOrderedSame)
        {
            return index; // filtered group exists
        }
    }
    
    [_filteredGroups addObject:[LUActionGroup groupWithName:group.name]];
    return _filteredGroups.count - 1;
}

- (NSUInteger)indexOfFilteredGroup:(LUActionGroup *)group
{
    // insert in the sorted order
    for (NSUInteger index = 0; index < _filteredGroups.count; ++index)
    {
        NSComparisonResult comparisonResult = [group compare:_filteredGroups[index]];
        if (comparisonResult == NSOrderedSame)
        {
            return index;
        }
    }
    
    return NSNotFound;
}

#pragma mark -
#pragma mark Public interface

- (LUActionGroup *)groupAtIndex:(NSInteger)index
{
    return self.isFiltering ? _filteredGroups[index] : _registry.groups[index];
}

#pragma mark -
#pragma mark LUActionRegistryDelegate

- (void)actionRegistry:(LUActionRegistry *)registry didAddGroup:(LUActionGroup *)group atIndex:(NSUInteger)index
{
    if (self.isFiltering)
    {
        // check if group has any actions which pass filter
        BOOL filtered = NO;
        for (LUAction *action in group.actions)
        {
            if ([self filterAction:action])
            {
                filtered = YES;
                break;
            }
        }
        
        if (!filtered)
        {
            return;
        }
        
        // add filtered group
        index = [self addFilteredGroup:group];
        LUActionGroup * filteredGroup = [_filteredGroups objectAtIndex:index];
        
        // add filtered actions
        for (LUAction *action in group.actions)
        {
            if ([self filterAction:action])
            {
                [filteredGroup addAction:action];
            }
        }
        
        group = filteredGroup;
    }
    
    [_delegate actionRegistryFilter:self didAddGroup:group atIndex:index];
}

- (void)actionRegistry:(LUActionRegistry *)registry didRemoveGroup:(LUActionGroup *)group atIndex:(NSUInteger)index
{
    if (self.isFiltering)
    {
        index = [self indexOfFilteredGroup:group];
        if (index == NSNotFound)
        {
            return;
        }
        
        group = LU_AUTORELEASE(LU_RETAIN([_filteredGroups objectAtIndex:index]));
        [_filteredGroups removeObjectAtIndex:index];
    }
    
    [_delegate actionRegistryFilter:self didRemoveGroup:group atIndex:index];
}

- (void)actionRegistry:(LUActionRegistry *)registry didAddAction:(LUAction *)action atIndex:(NSUInteger)index groupIndex:(NSUInteger)groupIndex
{
    if (self.isFiltering)
    {
        if (![self filterAction:action])
        {
            return;
        }
        
        NSUInteger oldFilteredGroupCount = _filteredGroups.count;
        
        LUActionGroup *group = [registry.groups objectAtIndex:groupIndex];
        groupIndex = [self addFilteredGroup:group];
        
        LUActionGroup *filteredGroup = [_filteredGroups objectAtIndex:groupIndex];
        index = [filteredGroup addAction:action];
        
        if (_filteredGroups.count > oldFilteredGroupCount) // check if filtered group did not exist before adding the action
        {
            [_delegate actionRegistryFilter:self didAddGroup:filteredGroup atIndex:groupIndex];
            return;
        }
    }
    
    [_delegate actionRegistryFilter:self didAddAction:action atIndex:index groupIndex:groupIndex];
}

- (void)actionRegistry:(LUActionRegistry *)registry didRemoveAction:(LUAction *)action atIndex:(NSUInteger)index groupIndex:(NSUInteger)groupIndex
{
    if (self.isFiltering)
    {
        if (![self filterAction:action])
        {
            return;
        }
        
        LUActionGroup *group = [registry.groups objectAtIndex:groupIndex];
        groupIndex = [self indexOfFilteredGroup:group];
        
        LUAssert(groupIndex != NSNotFound);
        if (groupIndex == NSNotFound)
        {
            return;
        }
        
        LUActionGroup *filteredGroup = [_filteredGroups objectAtIndex:groupIndex];
        index = [filteredGroup.actions indexOfObject:action];
        LUAssert(index != NSNotFound);
        if (index == NSNotFound)
        {
            return;
        }
        
        [filteredGroup removeActionAtIndex:index];
    }
    
    [_delegate actionRegistryFilter:self didRemoveAction:action atIndex:index groupIndex:groupIndex];
}

#pragma mark -
#pragma mark Properties

- (NSUInteger)groupCount
{
    return self.isFiltering ? _filteredGroups.count : _registry.groupCount;
}

- (BOOL)isFiltering
{
    return _filteredGroups != nil;
}

@end
