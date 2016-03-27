//
//  LUActionRegistryTest.m
//  LunarConsole
//
//  Created by Alex Lementuev on 2/24/16.
//  Copyright © 2016 Space Madness. All rights reserved.
//

#import "TestCase.h"

#import "Lunar.h"

@interface LUActionRegistryTest : TestCase <LUActionRegistryDelegate>
{
    LUActionRegistry * _actionRegistry;
    int _nextActionId;
}
@end

@implementation LUActionRegistryTest

#pragma mark -
#pragma mark Setup/Teardown

- (void)setUp
{
    [super setUp];
    _actionRegistry = [[LUActionRegistry alloc] init];
    _actionRegistry.delegate = self;
    _nextActionId = 0;
}

- (void)tearDown
{
    [super tearDown];
    LU_RELEASE(_actionRegistry);
}

#pragma mark -
#pragma mark Register actions

- (void)testRegisterActionsDefaultGroup
{
    [self registerActionName:@"a2"];
    [self registerActionName:@"a1"];
    [self registerActionName:@"a3"];
    
    // should be in default group
    [self assertGroups:@"", nil];
    
    [self assertGroup:@"" actions:@"a1", @"a2", @"a3", nil];
}

- (void)testRegisterActionsMultipleGroups
{
    [self registerActionGroup:@"b" name:@"b2"];
    [self registerActionGroup:@"b" name:@"b1"];
    [self registerActionGroup:@"b" name:@"b3"];
    
    [self registerActionGroup:@"a" name:@"a2"];
    [self registerActionGroup:@"a" name:@"a1"];
    [self registerActionGroup:@"a" name:@"a3"];
    
    [self registerActionName:@"d2"];
    [self registerActionName:@"d1"];
    [self registerActionName:@"d3"];
    
    [self registerActionGroup:@"c" name:@"c2"];
    [self registerActionGroup:@"c" name:@"c1"];
    [self registerActionGroup:@"c" name:@"c3"];
    
    [self assertGroups:@"", @"a", @"b", @"c", nil];
    
    [self assertGroup:@"" actions:@"d1", @"d2", @"d3", nil];
    [self assertGroup:@"a" actions:@"a1", @"a2", @"a3", nil];
    [self assertGroup:@"b" actions:@"b1", @"b2", @"b3", nil];
    [self assertGroup:@"c" actions:@"c1", @"c2", @"c3", nil];
}

- (void)testRegisterMultipleActionsWithSameName
{
    [self registerActionName:@"a2"];
    [self registerActionName:@"a3"];
    [self registerActionName:@"a1"];
    [self registerActionName:@"a3"];
    
    // should be in default group
    [self assertGroups:@"", nil];
    
    [self assertGroup:@"" actions:@"a1", @"a2", @"a3", nil];
}

#pragma mark -
#pragma mark Unregister actions

- (void)testUnregisterAction
{
    int id2 = [self registerActionGroup:@"a" name:@"a2"].actionId;
    int id1 = [self registerActionGroup:@"a" name:@"a1"].actionId;
    int id3 = [self registerActionGroup:@"a" name:@"a3"].actionId;
    
    [self assertGroups:@"a", nil];
    
    [self unregisterActionWithId:id1];
    [self assertGroup:@"a" actions:@"a2", @"a3", nil];
    
    [self unregisterActionWithId:id2];
    [self assertGroup:@"a" actions:@"a3", nil];

    [self unregisterActionWithId:id3];
    [self assertGroups:nil];
    
    [self unregisterActionWithId:id3];
    [self assertGroups:nil];
}

#pragma mark -
#pragma mark Delegate notifications

- (void)testDelegateNotifications
{
    // empty
    [self registerActionGroup:@"a" name:@"a2"];
    [self assertResult:@"added group: a (0)", nil];
    
    // a/a2
    [self registerActionGroup:@"c" name:@"c1"];
    [self assertResult:@"added group: c (1)", nil];
    
    // a/a2
    // c/c1
    [self registerActionGroup:@"b" name:@"b1"];
    [self assertResult:@"added group: b (1)", nil];
    
    // a/a2
    // b/b1
    // c/c1
    [self registerActionName:@"d1"];
    [self assertResult:@"added group:  (0)", nil];
    
    //  /d1
    // a/a2
    // b/b1
    // c/c1
    [self registerActionGroup:@"a" name:@"a1"];
    [self assertResult:@"added: a/a1 (1/0)", nil];

    //  /d1
    // a/a1
    // a/a2
    // b/b1
    // c/c1
    [self registerActionGroup:@"a" name:@"a3"];
    [self assertResult:@"added: a/a3 (1/2)", nil];

    //  /d1
    // a/a1
    // a/a2
    // a/a3
    // b/b1
    // c/c1
    [self registerActionGroup:@"c" name:@"c2"];
    [self assertResult:@"added: c/c2 (3/1)", nil];

    //  /d1
    // a/a1
    // a/a2
    // a/a3
    // b/b1
    // c/c1
    // c/c2
    [self registerActionGroup:@"b" name:@"b3"];
    [self assertResult:@"added: b/b3 (2/1)", nil];

    //  /d1
    // a/a1
    // a/a2
    // a/a3
    // b/b1
    // b/b3
    // c/c1
    // c/c2
    [self registerActionGroup:@"b" name:@"b2"];
    [self assertResult:@"added: b/b2 (2/1)", nil];

    //  /d1
    // a/a1
    // a/a2
    // a/a3
    // b/b1
    // b/b2
    // b/b3
    // c/c1
    // c/c2
    [self registerActionName:@"d2"];
    [self assertResult:@"added: /d2 (0/1)", nil];
    
    //  /d1
    //  /d2
    // a/a1
    // a/a2
    // a/a3
    // b/b1
    // b/b2
    // b/b3
    // c/c1
    // c/c2
    [self unregisterActionWithName:@"b1"];
    [self assertResult:@"removed: b/b1 (2/0)", nil];
    
    //  /d1
    //  /d2
    // a/a1
    // a/a2
    // a/a3
    // b/b2
    // b/b3
    // c/c1
    // c/c2
    [self unregisterActionWithName:@"a1"];
    [self assertResult:@"removed: a/a1 (1/0)", nil];
    
    //  /d1
    //  /d2
    // a/a2
    // a/a3
    // b/b2
    // b/b3
    // c/c1
    // c/c2
    [self unregisterActionWithName:@"a3"];
    [self assertResult:@"removed: a/a3 (1/1)", nil];
    
    //  /d1
    //  /d2
    // b/b2
    // b/b3
    // c/c1
    // c/c2
    [self unregisterActionWithName:@"a2"];
    [self assertResult:@"removed group: a (1)", nil];

    //  /d2
    // b/b2
    // b/b3
    // c/c1
    // c/c2
    [self unregisterActionWithName:@"d1"];
    [self assertResult:@"removed: /d1 (0/0)", nil];
    
    //  /d2
    // b/b2
    // b/b3
    // c/c1
    // c/c2
    [self unregisterActionWithName:@"d2"];
    [self assertResult:@"removed group:  (0)", nil];
    
    // b/b3
    // c/c1
    // c/c2
    [self unregisterActionWithName:@"b2"];
    [self assertResult:@"removed: b/b2 (0/0)", nil];
    
    // b/b3
    // c/c2
    [self unregisterActionWithName:@"c1"];
    [self assertResult:@"removed: c/c1 (1/0)", nil];
    
    // b/b3
    [self unregisterActionWithName:@"c2"];
    [self assertResult:@"removed group: c (1)", nil];
    
    // empty
    [self unregisterActionWithName:@"b3"];
    [self assertResult:@"removed group: b (0)", nil];
}

#pragma mark -
#pragma mark LUActionRegistryDelegte

- (void)actionRegistry:(LUActionRegistry *)registry didAddGroup:(LUActionGroup *)group atIndex:(NSUInteger)index
{
    [self addResult:[NSString stringWithFormat:@"added group: %@ (%d)", group.name, (int) index]];
}

- (void)actionRegistry:(LUActionRegistry *)registry didRemoveGroup:(LUActionGroup *)group atIndex:(NSUInteger)index
{
    [self addResult:[NSString stringWithFormat:@"removed group: %@ (%d)", group.name, (int) index]];
}

- (void)actionRegistry:(LUActionRegistry *)registry didAddAction:(LUAction *)action atIndex:(NSUInteger)index groupIndex:(NSUInteger)groupIndex
{
    [self addResult:[NSString stringWithFormat:@"added: %@/%@ (%d/%d)", action.group.name, action.name, (int) groupIndex, (int) index]];
}

- (void)actionRegistry:(LUActionRegistry *)registry didRemoveAction:(LUAction *)action atIndex:(NSUInteger)index groupIndex:(NSUInteger)groupIndex
{
    [self addResult:[NSString stringWithFormat:@"removed: %@/%@ (%d/%d)", action.group.name, action.name, (int) groupIndex, (int) index]];
}

#pragma mark -
#pragma mark Helpers

- (LUActionGroup *)findGroupWithName:(NSString *)name
{
    for (LUActionGroup *group in _actionRegistry.groups)
    {
        if ([group.name isEqualToString:name])
        {
            return group;
        }
    }
    
    return nil;
}

- (LUAction *)registerActionName:(NSString *)name
{
    return [self registerActionGroup:@"" name:name];
}

- (LUAction *)registerActionGroup:(NSString *)groupName name:(NSString *)name
{
    return [_actionRegistry registerActionWithId:_nextActionId++ name:name group:groupName];
}

- (void)unregisterActionWithId:(int)actionId
{
    [_actionRegistry unregisterActionWithId:actionId];
}

- (BOOL)unregisterActionWithName:(NSString *)name
{
    for (LUActionGroup *group in _actionRegistry.groups)
    {
        for (LUAction* action in group.actions)
        {
            if ([action.name isEqualToString:name])
            {
                [_actionRegistry unregisterActionWithId:action.actionId];
                return YES;
            }
        }
    }
    
    return NO;
}

- (void)assertGroups:(NSString *)first, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *expected = [NSMutableArray array];
    va_list ap;
    va_start(ap, first);
    
    for (NSString *name = first; name != nil; name = va_arg(ap, NSString *))
    {
        [expected addObject:name];
    }
    
    va_end(ap);
    
    XCTAssertEqual(expected.count, _actionRegistry.groupCount);
    
    NSUInteger index = 0;
    for (LUActionGroup *group in _actionRegistry.groups)
    {
        XCTAssertEqualObjects(expected[index], group.name);
        ++index;
    }
}

- (void)assertGroup:(NSString *)groupName actions:(NSString *)first, ... NS_REQUIRES_NIL_TERMINATION
{
    LUActionGroup *group = [self findGroupWithName:groupName];
    XCTAssertNotNil(group);
    
    NSMutableArray *expected = [NSMutableArray array];
    va_list ap;
    va_start(ap, first);
    
    for (NSString *name = first; name != nil; name = va_arg(ap, NSString *))
    {
        [expected addObject:name];
    }
    
    va_end(ap);
    
    XCTAssertEqual(expected.count, group.actionCount);
    
    NSUInteger index = 0;
    for (LUAction *action in group.actions)
    {
        XCTAssertEqualObjects(expected[index], action.name);
        ++index;
    }
}

@end
