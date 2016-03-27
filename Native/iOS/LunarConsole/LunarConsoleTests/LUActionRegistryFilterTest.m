//
//  LUActionRegistryFilterTest.m
//  LunarConsole
//
//  Created by Alex Lementuev on 3/11/16.
//  Copyright © 2016 Space Madness. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Lunar.h"
#import "TestCase.h"

@interface LUActionGroupInfo : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSArray *actions;

+ (instancetype)groupInfoWithName:(NSString *)name actions:(NSString *)first, ... NS_REQUIRES_NIL_TERMINATION;

- (instancetype)initWithName:(NSString *)name actions:(NSArray *)actions;

@end

@interface LUActionRegistryFilterTest : TestCase <LUActionRegistryFilterDelegate>
{
    LUActionRegistry * _actionRegistry;
    LUActionRegistryFilter * _registryFilter;
    int _nextActionId;
}

@end

@implementation LUActionRegistryFilterTest

#pragma mark -
#pragma mark Setup

- (void)setUp
{
    [super setUp];
    
    _actionRegistry = [[LUActionRegistry alloc] init];
    _registryFilter = [[LUActionRegistryFilter alloc] initWithActionRegistry:_actionRegistry];
    _registryFilter.delegate = self;
    _nextActionId = 0;
}

- (void)tearDown
{
    [super tearDown];
    
    LU_RELEASE(_actionRegistry);
    LU_RELEASE(_registryFilter);
}

#pragma mark -
#pragma mark Filter by text

- (void)testFilteringByText
{
    LUActionRegistryFilter *filter = createFilter(
        [LUActionGroupInfo groupInfoWithName:@"" actions:@"line1",
                                                         @"line11",
                                                         @"line111",
                                                         @"line1111",
                                                         @"foo", nil], nil);
    
    XCTAssert(!filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"l"]);
    [self assertFilterGroups:filter, [LUActionGroupInfo groupInfoWithName:@"" actions:@"line1", @"line11", @"line111", @"line1111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert(![filter setFilterText:@"l"]);
    [self assertFilterGroups:filter, [LUActionGroupInfo groupInfoWithName:@"" actions:@"line1", @"line11", @"line111", @"line1111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"li"]);
    [self assertFilterGroups:filter, [LUActionGroupInfo groupInfoWithName:@"" actions:@"line1", @"line11", @"line111", @"line1111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"lin"]);
    [self assertFilterGroups:filter, [LUActionGroupInfo groupInfoWithName:@"" actions:@"line1", @"line11", @"line111", @"line1111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"line"]);
    [self assertFilterGroups:filter, [LUActionGroupInfo groupInfoWithName:@"" actions:@"line1", @"line11", @"line111", @"line1111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"line1"]);
    [self assertFilterGroups:filter, [LUActionGroupInfo groupInfoWithName:@"" actions:@"line1", @"line11", @"line111", @"line1111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"line11"]);
    [self assertFilterGroups:filter, [LUActionGroupInfo groupInfoWithName:@"" actions:@"line11", @"line111", @"line1111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"line111"]);
    [self assertFilterGroups:filter, [LUActionGroupInfo groupInfoWithName:@"" actions:@"line111", @"line1111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"line1111"]);
    [self assertFilterGroups:filter, [LUActionGroupInfo groupInfoWithName:@"" actions:@"line1111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"line11111"]);
    [self assertFilterGroups:filter, nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"line1111"]);
    [self assertFilterGroups:filter, [LUActionGroupInfo groupInfoWithName:@"" actions:@"line1111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"line111"]);
    [self assertFilterGroups:filter, [LUActionGroupInfo groupInfoWithName:@"" actions:@"line111", @"line1111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"line11"]);
    [self assertFilterGroups:filter, [LUActionGroupInfo groupInfoWithName:@"" actions:@"line11", @"line111", @"line1111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"line1"]);
    [self assertFilterGroups:filter, [LUActionGroupInfo groupInfoWithName:@"" actions:@"line1", @"line11", @"line111", @"line1111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"line"]);
    [self assertFilterGroups:filter, [LUActionGroupInfo groupInfoWithName:@"" actions:@"line1", @"line11", @"line111", @"line1111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"lin"]);
    [self assertFilterGroups:filter, [LUActionGroupInfo groupInfoWithName:@"" actions:@"line1", @"line11", @"line111", @"line1111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"li"]);
    [self assertFilterGroups:filter, [LUActionGroupInfo groupInfoWithName:@"" actions:@"line1", @"line11", @"line111", @"line1111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"l"]);
    [self assertFilterGroups:filter, [LUActionGroupInfo groupInfoWithName:@"" actions:@"line1", @"line11", @"line111", @"line1111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert([filter setFilterText:@""]);
    [self assertFilterGroups:filter, [LUActionGroupInfo groupInfoWithName:@"" actions:@"foo", @"line1", @"line11", @"line111", @"line1111", nil], nil];
    XCTAssert(!filter.isFiltering);
}

#pragma mark -
#pragma mark Register actions

- (void)testRegisterActionsDefaultGroup
{
    [self registerActionName:@"a11"];
    [self registerActionName:@"a1"];
    [self registerActionName:@"a111"];
    
    // should be in default group
    [self assertGroups:@"", nil];
    
    [self assertGroup:@"" actions:@"a1", @"a11", @"a111", nil];
}

- (void)testRegisterActionsDefaultGroupFiltered
{
    [self setFilterText:@"a11"];
    
    [self registerActionName:@"a11"];
    [self registerActionName:@"a1"];
    [self registerActionName:@"a111"];
    
    // should be in default group
    [self assertGroups:@"", nil];
    
    [self assertGroup:@"" actions:@"a11", @"a111", nil];
    
    // remove the filter
    [self setFilterText:@""];
    
    [self assertGroup:@"" actions:@"a1", @"a11", @"a111", nil];
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

- (void)testRegisterActionsMultipleGroupsFiltered
{
    [self setFilterText:@"a11"];
    
    [self registerActionGroup:@"b" name:@"b2"];
    [self registerActionGroup:@"b" name:@"b1"];
    [self registerActionGroup:@"b" name:@"b3"];
    
    [self registerActionGroup:@"a" name:@"a11"];
    [self registerActionGroup:@"a" name:@"a1"];
    [self registerActionGroup:@"a" name:@"a111"];
    
    [self registerActionName:@"d2"];
    [self registerActionName:@"d1"];
    [self registerActionName:@"d3"];
    
    [self registerActionGroup:@"c" name:@"c2"];
    [self registerActionGroup:@"c" name:@"c1"];
    [self registerActionGroup:@"c" name:@"c3"];
    
    [self assertGroups:@"a", nil];
    
    [self assertGroup:@"a" actions:@"a11", @"a111", nil];
    
    // remove filter
    [self setFilterText:@""];
    [self assertGroups:@"", @"a", @"b", @"c", nil];
    
    [self assertGroup:@"" actions:@"d1", @"d2", @"d3", nil];
    [self assertGroup:@"a" actions:@"a1", @"a11", @"a111", nil];
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

- (void)testRegisterMultipleActionsWithSameNameFiltered
{
    [self setFilterText:@"a11"];
    
    [self registerActionName:@"a11"];
    [self registerActionName:@"a111"];
    [self registerActionName:@"a1"];
    [self registerActionName:@"a111"];
    
    // should be in default group
    [self assertGroups:@"", nil];
    
    [self assertGroup:@"" actions:@"a11", @"a111", nil];
    
    // remove filter
    [self setFilterText:@""];
    [self assertGroup:@"" actions:@"a1", @"a11", @"a111", nil];
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

- (void)testUnregisterActionFiltered
{
    [self setFilterText:@"a11"];
    
    int id2 = [self registerActionGroup:@"a" name:@"a11"].actionId;
    int id1 = [self registerActionGroup:@"a" name:@"a1"].actionId;
    int id3 = [self registerActionGroup:@"a" name:@"a111"].actionId;
    
    [self assertGroups:@"a", nil];
    
    [self unregisterActionWithId:id1];
    [self assertGroup:@"a" actions:@"a11", @"a111", nil];
    
    [self unregisterActionWithId:id2];
    [self assertGroup:@"a" actions:@"a111", nil];
    
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

- (void)testDelegateNotificationsFiltered
{
    [self setFilterText:@"a"];
    
    // empty
    [self registerActionGroup:@"a" name:@"aa2"];
    [self assertResult:@"added group: a (0)", nil];
    
    // a/aa2
    [self registerActionGroup:@"c" name:@"ca1"];
    [self assertResult:@"added group: c (1)", nil];
    
    // a/aa2
    // c/ca1
    [self registerActionGroup:@"b" name:@"ba1"];
    [self assertResult:@"added group: b (1)", nil];
    
    // a/aa2
    // b/ba1
    // c/ca1
    [self registerActionName:@"d1"]; // filtered out
    
    // a/aa2
    // b/ba1
    // c/ca1
    [self registerActionGroup:@"a" name:@"aa1"];
    [self assertResult:@"added: a/aa1 (0/0)", nil];
    
    // a/aa1
    // a/aa2
    // b/ba1
    // c/ca1
    [self registerActionGroup:@"a" name:@"aa3"];
    [self assertResult:@"added: a/aa3 (0/2)", nil];
    
    // a/aa1
    // a/aa2
    // a/aa3
    // b/ba1
    // c/ca1
    [self registerActionGroup:@"c" name:@"ca2"];
    [self assertResult:@"added: c/ca2 (2/1)", nil];
    
    // a/aa1
    // a/aa2
    // a/aa3
    // b/ba1
    // c/ca1
    // c/ca2
    [self registerActionGroup:@"b" name:@"ba3"];
    [self assertResult:@"added: b/ba3 (1/1)", nil];
    
    // a/aa1
    // a/aa2
    // a/aa3
    // b/ba1
    // b/ba3
    // c/ca1
    // c/ca2
    [self registerActionGroup:@"b" name:@"ba2"];
    [self assertResult:@"added: b/ba2 (1/1)", nil];
    
    // a/aa1
    // a/aa2
    // a/aa3
    // b/ba1
    // b/ba2
    // b/ba3
    // c/ca1
    // c/ca2
    [self registerActionName:@"d2"]; // filtered out
    
    // a/aa1
    // a/aa2
    // a/aa3
    // b/ba1
    // b/ba2
    // b/ba3
    // c/ca1
    // c/ca2
    [self unregisterActionWithName:@"ba1"];
    [self assertResult:@"removed: b/ba1 (1/0)", nil];
    
    // a/aa1
    // a/aa2
    // a/aa3
    // b/ba2
    // b/ba3
    // c/ca1
    // c/ca2
    [self unregisterActionWithName:@"aa1"];
    [self assertResult:@"removed: a/aa1 (0/0)", nil];
    
    // a/aa2
    // a/aa3
    // b/ba2
    // b/ba3
    // c/ca1
    // c/ca2
    [self unregisterActionWithName:@"aa3"];
    [self assertResult:@"removed: a/aa3 (0/1)", nil];
    
    // b/ba2
    // b/ba3
    // c/ca1
    // c/ca2
    [self unregisterActionWithName:@"aa2"];
    [self assertResult:@"removed group: a (0)", nil];
    
    // b/ba2
    // b/ba3
    // c/ca1
    // c/ca2
    [self unregisterActionWithName:@"d1"]; // filtered out
    
    // b/ba2
    // b/ba3
    // c/ca1
    // c/ca2
    [self unregisterActionWithName:@"d2"]; // filtered out
    
    // b/ba3
    // c/ca1
    // c/ca2
    [self unregisterActionWithName:@"ba2"];
    [self assertResult:@"removed: b/ba2 (0/0)", nil];
    
    // b/ba3
    // c/ca2
    [self unregisterActionWithName:@"ca1"];
    [self assertResult:@"removed: c/ca1 (1/0)", nil];
    
    // b/ba3
    [self unregisterActionWithName:@"ca2"];
    [self assertResult:@"removed group: c (1)", nil];
    
    // empty
    [self unregisterActionWithName:@"ba3"];
    [self assertResult:@"removed group: b (0)", nil];
}

- (void)testFilteringByTextMultipleGroups
{
    LUActionRegistryFilter *filter = createFilter(
        [LUActionGroupInfo groupInfoWithName:@"group1" actions:@"line1", @"line11", nil],
        [LUActionGroupInfo groupInfoWithName:@"group2" actions:@"line111", @"line1111", nil],
        [LUActionGroupInfo groupInfoWithName:@"group3" actions:@"foo", nil], nil);
    
    XCTAssert(!filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"l"]);
    [self assertFilterGroups:filter,
     [LUActionGroupInfo groupInfoWithName:@"group1" actions:@"line1", @"line11", nil],
     [LUActionGroupInfo groupInfoWithName:@"group2" actions:@"line111", @"line1111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert(![filter setFilterText:@"l"]);
    [self assertFilterGroups:filter,
     [LUActionGroupInfo groupInfoWithName:@"group1" actions:@"line1", @"line11", nil],
     [LUActionGroupInfo groupInfoWithName:@"group2" actions:@"line111", @"line1111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"li"]);
    [self assertFilterGroups:filter,
     [LUActionGroupInfo groupInfoWithName:@"group1" actions:@"line1", @"line11", nil],
     [LUActionGroupInfo groupInfoWithName:@"group2" actions:@"line111", @"line1111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"lin"]);
    [self assertFilterGroups:filter,
     [LUActionGroupInfo groupInfoWithName:@"group1" actions:@"line1", @"line11", nil],
     [LUActionGroupInfo groupInfoWithName:@"group2" actions:@"line111", @"line1111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"line"]);
    [self assertFilterGroups:filter,
     [LUActionGroupInfo groupInfoWithName:@"group1" actions:@"line1", @"line11", nil],
     [LUActionGroupInfo groupInfoWithName:@"group2" actions:@"line111", @"line1111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"line1"]);
    [self assertFilterGroups:filter,
     [LUActionGroupInfo groupInfoWithName:@"group1" actions:@"line1", @"line11", nil],
     [LUActionGroupInfo groupInfoWithName:@"group2" actions:@"line111", @"line1111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"line11"]);
    [self assertFilterGroups:filter,
     [LUActionGroupInfo groupInfoWithName:@"group1" actions:@"line11", nil],
     [LUActionGroupInfo groupInfoWithName:@"group2" actions:@"line111", @"line1111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"line111"]);
    [self assertFilterGroups:filter,
     [LUActionGroupInfo groupInfoWithName:@"group2" actions:@"line111", @"line1111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"line1111"]);
    [self assertFilterGroups:filter,
     [LUActionGroupInfo groupInfoWithName:@"group2" actions:@"line1111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"line11111"]);
    [self assertFilterGroups:filter, nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"line1111"]);
    [self assertFilterGroups:filter,
     [LUActionGroupInfo groupInfoWithName:@"group2" actions:@"line1111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"line111"]);
    [self assertFilterGroups:filter,
     [LUActionGroupInfo groupInfoWithName:@"group2" actions:@"line111", @"line1111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"line11"]);
    [self assertFilterGroups:filter,
     [LUActionGroupInfo groupInfoWithName:@"group1" actions:@"line11", nil],
     [LUActionGroupInfo groupInfoWithName:@"group2" actions:@"line111", @"line1111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"line1"]);
    [self assertFilterGroups:filter,
     [LUActionGroupInfo groupInfoWithName:@"group1" actions:@"line1", @"line11", nil],
     [LUActionGroupInfo groupInfoWithName:@"group2" actions:@"line111", @"line1111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"line"]);
    [self assertFilterGroups:filter,
     [LUActionGroupInfo groupInfoWithName:@"group1" actions:@"line1", @"line11", nil],
     [LUActionGroupInfo groupInfoWithName:@"group2" actions:@"line111", @"line1111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"lin"]);
    [self assertFilterGroups:filter,
     [LUActionGroupInfo groupInfoWithName:@"group1" actions:@"line1", @"line11", nil],
     [LUActionGroupInfo groupInfoWithName:@"group2" actions:@"line111", @"line1111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"li"]);
    [self assertFilterGroups:filter,
     [LUActionGroupInfo groupInfoWithName:@"group1" actions:@"line1", @"line11", nil],
     [LUActionGroupInfo groupInfoWithName:@"group2" actions:@"line111", @"line1111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"l"]);
    [self assertFilterGroups:filter,
     [LUActionGroupInfo groupInfoWithName:@"group1" actions:@"line1", @"line11", nil],
     [LUActionGroupInfo groupInfoWithName:@"group2" actions:@"line111", @"line1111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    XCTAssert([filter setFilterText:@""]);
    [self assertFilterGroups:filter,
     [LUActionGroupInfo groupInfoWithName:@"group1" actions:@"line1", @"line11", nil],
     [LUActionGroupInfo groupInfoWithName:@"group2" actions:@"line111", @"line1111", nil],
     [LUActionGroupInfo groupInfoWithName:@"group3" actions:@"foo", nil], nil];
    XCTAssert(!filter.isFiltering);
}

- (void)testFilteringByTextAddActions
{
    LUActionRegistryFilter *filter = createFilter(nil);
    XCTAssert(!filter.isFiltering);
    
    XCTAssert([filter setFilterText:@"line11"]);
    [filter.registry registerActionWithId:0 name:@"line111" group:@""];
    
    [self assertFilterGroups:filter, [LUActionGroupInfo groupInfoWithName:@"" actions:@"line111", nil], nil];
    XCTAssert(filter.isFiltering);
    
    [filter.registry registerActionWithId:1 name:@"line1" group:@""];
    [filter.registry registerActionWithId:2 name:@"line11" group:@""];
    
    [self assertFilterGroups:filter, [LUActionGroupInfo groupInfoWithName:@"" actions:@"line11", @"line111", nil], nil];
    
    [filter.registry unregisterActionWithId:2];
    [self assertFilterGroups:filter, [LUActionGroupInfo groupInfoWithName:@"" actions:@"line111", nil], nil];
    
    [filter.registry unregisterActionWithId:1];
    [self assertFilterGroups:filter, [LUActionGroupInfo groupInfoWithName:@"" actions:@"line111", nil], nil];
    
    [filter.registry unregisterActionWithId:0];
    [self assertFilterGroups:filter, nil];
    
    [filter.registry registerActionWithId:3 name:@"line1" group:@"a"];
    [self assertFilterGroups:filter, nil];
    
    [filter.registry registerActionWithId:4 name:@"line11" group:@"a"];
    [self assertFilterGroups:filter, [LUActionGroupInfo groupInfoWithName:@"a" actions:@"line11", nil], nil];
    
    [filter setFilterText:@""];
    [self assertFilterGroups:filter, [LUActionGroupInfo groupInfoWithName:@"a" actions:@"line1", @"line11", nil], nil];
}

#pragma mark -
#pragma mark LUActionRegistryFilterDelegate

- (void)actionRegistryFilter:(LUActionRegistryFilter *)registryFilter didAddGroup:(LUActionGroup *)group atIndex:(NSUInteger)index
{
    [self addResult:[NSString stringWithFormat:@"added group: %@ (%d)", group.name, (int) index]];
}

- (void)actionRegistryFilter:(LUActionRegistryFilter *)registryFilter didRemoveGroup:(LUActionGroup *)group atIndex:(NSUInteger)index
{
    [self addResult:[NSString stringWithFormat:@"removed group: %@ (%d)", group.name, (int) index]];
}

- (void)actionRegistryFilter:(LUActionRegistryFilter *)registryFilter didAddAction:(LUAction *)action atIndex:(NSUInteger)index groupIndex:(NSUInteger)groupIndex
{
    [self addResult:[NSString stringWithFormat:@"added: %@/%@ (%d/%d)", action.group.name, action.name, (int) groupIndex, (int) index]];
}

- (void)actionRegistryFilter:(LUActionRegistryFilter *)registryFilter didRemoveAction:(LUAction *)action atIndex:(NSUInteger)index groupIndex:(NSUInteger)groupIndex
{
    [self addResult:[NSString stringWithFormat:@"removed: %@/%@ (%d/%d)", action.group.name, action.name, (int) groupIndex, (int) index]];
}

#pragma mark -
#pragma mark Helpers

- (void)setFilterText:(NSString *)text
{
    [_registryFilter setFilterText:text];
}

- (LUActionGroup *)findGroupWithName:(NSString *)name
{
    for (NSUInteger index = 0; index < _registryFilter.groupCount; ++index)
    {
        LUActionGroup *group = [_registryFilter groupAtIndex:index];
        if ([group.name isEqualToString:name])
        {
            return group;
        }
    }
    
    return nil;
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
    
    XCTAssertEqual(expected.count, _registryFilter.groupCount);
    
    for (NSUInteger index = 0; index < _registryFilter.groupCount; ++index)
    {
        LUActionGroup *group = [_registryFilter groupAtIndex:index];
        XCTAssertEqualObjects(expected[index], group.name);
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

- (void)assertFilterGroups:(LUActionRegistryFilter *)filter, ... NS_REQUIRES_NIL_TERMINATION
{
    va_list ap;
    va_start(ap, filter);
    NSMutableArray *expectedGroups = [NSMutableArray array];
    for (LUActionGroupInfo *group = va_arg(ap, LUActionGroupInfo *); group != nil; group = va_arg(ap, LUActionGroupInfo *))
    {
        [expectedGroups addObject:group];
    }
    va_end(ap);
    
    for (int groupIndex = 0; groupIndex < filter.groupCount; ++groupIndex)
    {
        LUActionGroupInfo *expectedGroup = expectedGroups[groupIndex];
        LUActionGroup *actualGroup = [filter groupAtIndex:groupIndex];
        XCTAssertEqualObjects(expectedGroup.name, actualGroup.name);
        
        NSMutableArray *actualActions = [NSMutableArray array];
        for (int actionIndex = 0; actionIndex < actualGroup.actionCount; ++actionIndex)
        {
            [actualActions addObject:[[actualGroup.actions objectAtIndex:actionIndex] name]];
        }
        
        NSMutableArray *expectedActions = [NSMutableArray array];
        for (int actionIndex = 0; actionIndex < expectedGroup.actions.count; ++actionIndex)
        {
            [expectedActions addObject:expectedGroup.actions[actionIndex]];
        }
        
        XCTAssertEqual(expectedActions.count, actualActions.count, @"Expected [%@] but was [%@]", [expectedActions componentsJoinedByString:@","], [actualActions componentsJoinedByString:@","]);
        for (int i = 0; i < expectedGroup.actions.count; ++i)
        {
            XCTAssertEqualObjects(expectedActions[i], actualActions[i], @"Expected [%@] but was [%@]", [expectedActions componentsJoinedByString:@","], [actualActions componentsJoinedByString:@","]);
        }
    }
}

- (LUAction *)registerActionName:(NSString *)name
{
    return [self registerActionGroup:@"" name:name];
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

- (LUAction *)registerActionGroup:(NSString *)groupName name:(NSString *)name
{
    return [_actionRegistry registerActionWithId:_nextActionId++ name:name group:groupName];
}

- (void)unregisterActionWithId:(int)actionId
{
    [_actionRegistry unregisterActionWithId:actionId];
}

static LUActionRegistryFilter *createFilter(LUActionGroupInfo *first, ...)
{
    LUActionRegistry *registry = [LUActionRegistry registry];
    
    int actionId = 0;
    
    va_list ap;
    va_start(ap, first);
    for (LUActionGroupInfo *groupInfo = first; groupInfo != nil; groupInfo = va_arg(ap, LUActionGroupInfo *))
    {
        for (NSString *actionName in groupInfo.actions)
        {
            [registry registerActionWithId:actionId++ name:actionName group:groupInfo.name];
        }
    }
    va_end(ap);
    
    return [LUActionRegistryFilter filterWithActionRegistry:registry];
}


@end

@implementation LUActionGroupInfo

+ (instancetype)groupInfoWithName:(NSString *)name actions:(NSString *)first, ... NS_REQUIRES_NIL_TERMINATION
{
    va_list ap;
    va_start(ap, first);
    NSMutableArray *actions = [NSMutableArray array];
    for (NSString *action = first; action != nil; action = va_arg(ap, NSString *))
    {
        [actions addObject:action];
    }
    va_end(ap);
    
    return LU_AUTORELEASE([[self alloc] initWithName:name actions:actions]);
}

- (instancetype)initWithName:(NSString *)name actions:(NSArray *)actions
{
    self = [super init];
    if (self)
    {
        _name = LU_RETAIN(name);
        _actions = LU_RETAIN(actions);
    }
    return self;
}

- (void)dealloc
{
    LU_RELEASE(_name);
    LU_RELEASE(_actions);
    LU_SUPER_DEALLOC
}

@end
