//
//  LUActionRegistryFilter.h
//  LunarConsole
//
//  Created by Alex Lementuev on 3/11/16.
//  Copyright © 2016 Space Madness. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LUActionRegistry.h"

@class LUActionRegistryFilter;

@protocol LUActionRegistryFilterDelegate <NSObject>

- (void)actionRegistryFilter:(LUActionRegistryFilter *)registryFilter didAddGroup:(LUActionGroup *)group atIndex:(NSUInteger)index;
- (void)actionRegistryFilter:(LUActionRegistryFilter *)registryFilter didRemoveGroup:(LUActionGroup *)group atIndex:(NSUInteger)index;
- (void)actionRegistryFilter:(LUActionRegistryFilter *)registryFilter didAddAction:(LUAction *)action atIndex:(NSUInteger)index groupIndex:(NSUInteger)groupIndex;
- (void)actionRegistryFilter:(LUActionRegistryFilter *)registryFilter didRemoveAction:(LUAction *)action atIndex:(NSUInteger)index groupIndex:(NSUInteger)groupIndex;

@end

@interface LUActionRegistryFilter : NSObject

@property (nonatomic, readonly) LUActionRegistry *registry;
@property (nonatomic, readonly) BOOL isFiltering;
@property (nonatomic, assign) id<LUActionRegistryFilterDelegate> delegate;
@property (nonatomic, readonly) NSUInteger groupCount;

+ (instancetype)filterWithActionRegistry:(LUActionRegistry *)actionRegistry;
- (instancetype)initWithActionRegistry:(LUActionRegistry *)actionRegistry;

- (BOOL)setFilterText:(NSString *)filterText;
- (LUActionGroup *)groupAtIndex:(NSInteger)index;

@end
