//
//  LUActionRegistry.h
//  LunarConsole
//
//  Created by Alex Lementuev on 2/24/16.
//  Copyright © 2016 Space Madness. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LUAction;
@class LUActionGroup;
@class LUActionRegistry;

@protocol LUActionRegistryDelegate <NSObject>

- (void)actionRegistry:(LUActionRegistry *)registry didAddGroup:(LUActionGroup *)group atIndex:(NSUInteger)index;
- (void)actionRegistry:(LUActionRegistry *)registry didRemoveGroup:(LUActionGroup *)group atIndex:(NSUInteger)index;
- (void)actionRegistry:(LUActionRegistry *)registry didAddAction:(LUAction *)action atIndex:(NSUInteger)index groupIndex:(NSUInteger)groupIndex;
- (void)actionRegistry:(LUActionRegistry *)registry didRemoveAction:(LUAction *)action atIndex:(NSUInteger)index groupIndex:(NSUInteger)groupIndex;

@end

@interface LUActionRegistry : NSObject

@property (nonatomic, readonly) NSArray *groups;
@property (nonatomic, readonly) NSUInteger groupCount;

@property (nonatomic, assign) id<LUActionRegistryDelegate> delegate;

+ (instancetype)registry;

- (LUAction *)registerActionWithId:(int)actionId name:(NSString *)name group:(NSString *)group;
- (BOOL)unregisterActionWithId:(int)actionId;

@end
