//
//  LUActionGroupTest.m
//  LunarConsole
//
//  Created by Alex Lementuev on 3/9/16.
//  Copyright © 2016 Space Madness. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Lunar.h"

@interface LUActionGroupTest : XCTestCase
{
    LUActionGroup * _actionGroup;
    int _nextActionId;
}

@end

@implementation LUActionGroupTest

- (void)setUp
{
    [super setUp];
    _actionGroup = [[LUActionGroup alloc] initWithName:@"Action Group"];
    _nextActionId = 0;
}

- (void)tearDown
{
    LU_RELEASE(_actionGroup);
    [super tearDown];
}

#pragma mark -
#pragma mark Testing

- (void)testSortedAdd
{
    LUAction *action2 = [self addActionWithName:@"a2"];
    LUAction *action3 = [self addActionWithName:@"a3"];
    LUAction *action1 = [self addActionWithName:@"a1"];
    
    [self assertActions:action1, action2, action3, nil];
}

- (void)testDuplicatedAction
{
    LUAction *action2 = [self addActionWithName:@"a2"];
    [self addActionWithName:@"a3"];
    LUAction *action1 = [self addActionWithName:@"a1"];
    LUAction *action4 = [self addActionWithName:@"a3"];
    
    [self assertActions:action1, action2, action4, nil];
}

- (void)testRemove
{
    LUAction *action1 = [self addActionWithName:@"a1"];
    LUAction *action2 = [self addActionWithName:@"a2"];
    LUAction *action3 = [self addActionWithName:@"a3"];
    
    [self assertActions:action1, action2, action3, nil];
    
    [self removeAction:action1];
    [self assertActions:action2, action3, nil];
    
    [self removeAction:action2];
    [self assertActions:action3, nil];
    
    [self removeAction:action3];
    [self assertActions:nil];
    
    [self removeAction:action3];
    [self assertActions:nil];
}

#pragma mark -
#pragma mark Helpers

- (LUAction *)addActionWithName:(NSString *)name
{
    LUAction *action = [[LUAction alloc] initWithId:_nextActionId++ name:name];
    [_actionGroup addAction:action];
    return LU_AUTORELEASE(action);
}

- (BOOL)removeAction:(LUAction *)action
{
    for (NSUInteger index = 0; index < _actionGroup.actionCount; ++index)
    {
        if ([_actionGroup actionAtIndex:index].actionId == action.actionId)
        {
            [_actionGroup removeActionAtIndex:index];
            return YES;
        }
    }
    
    return NO;
}

- (void)assertActions:(LUAction *)first, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *expected = [NSMutableArray array];
    
    va_list ap;
    va_start(ap, first);
    for (LUAction *action = first; action != nil; action = va_arg(ap, LUAction *))
    {
        [expected addObject:action];
    }
    va_end(ap);
    
    XCTAssertEqual(expected.count, _actionGroup.actionCount);
    
    NSUInteger index = 0;
    for (LUAction *action in _actionGroup.actions)
    {
        XCTAssertEqualObjects(expected[index], action);
        ++index;
    }
}

@end
