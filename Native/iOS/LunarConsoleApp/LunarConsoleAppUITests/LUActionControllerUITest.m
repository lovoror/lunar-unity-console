//
//  LUActionController.m
//  LunarConsoleApp
//
//  Created by Alex Lementuev on 3/23/16.
//  Copyright © 2016 Space Madness. All rights reserved.
//

#import "UITestCaseBase.h"

#import "Lunar.h"

@interface LUActionControllerUITest : UITestCaseBase

@end

@implementation LUActionControllerUITest

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNoActions
{
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [self appOpenActionsController:app];
    
    // should be no actions
    XCTAssert(app.otherElements[@"No Actions Warning View"].hittable);
}

- (void)testAddGroups
{
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.switches[@"Test Action Overlay Switch"] tap];
    
    [self app:app addActions:@{
       @"Group2" : @[@"Action22", @"Action21", @"Action23"],
       @"Group1" : @[@"Action12", @"Action11"],
       @"" : @[@"Action2", @"Action1", @"Action3"]
    }];
    
    [self appOpenActionsController:app];
    
    XCUIElement *table = app.tables.element;
    [self asserTable:table,
     @"Action1",
     @"Action2",
     @"Action3",
     @"Group1",
     @"Action11",
     @"Action12",
     @"Group2",
     @"Action21",
     @"Action22",
     @"Action23",
     nil];
    
    [self app:app addGroup:@"Group1" action:@"Action13"];
    
    [self asserTable:table,
     @"Action1",
     @"Action2",
     @"Action3",
     @"Group1",
     @"Action11",
     @"Action12",
     @"Action13",
     @"Group2",
     @"Action21",
     @"Action22",
     @"Action23",
     nil];
    
    [self app:app addGroup:@"Group2" action:@"Action222"];
    
    [self asserTable:table,
     @"Action1",
     @"Action2",
     @"Action3",
     @"Group1",
     @"Action11",
     @"Action12",
     @"Action13",
     @"Group2",
     @"Action21",
     @"Action22",
     @"Action222",
     @"Action23",
     nil];
    
    [self app:app addGroup:@"" action:@"Action22"];
    
    [self asserTable:table,
     @"Action1",
     @"Action2",
     @"Action22",
     @"Action3",
     @"Group1",
     @"Action11",
     @"Action12",
     @"Action13",
     @"Group2",
     @"Action21",
     @"Action22",
     @"Action222",
     @"Action23",
     nil];
}

#pragma mark -
#pragma mark Helpers

- (void)asserTable:(XCUIElement *)table, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *expected = [[NSMutableArray alloc] init];
    va_list ap;
    va_start(ap, table);
    
    for (NSString *value = va_arg(ap, NSString *); value; value = va_arg(ap, NSString *))
    {
        [expected addObject:value];
    }
    
    va_end(ap);
    
    XCUIElementQuery *staticTexts = table.staticTexts;
    
    XCTAssertEqual(staticTexts.count, expected.count);
    for (int i = 0; i < staticTexts.count; ++i)
    {
        XCUIElement *element = [staticTexts elementBoundByIndex:i];
        XCTAssert([expected[i] isEqualToString:element.label]);
    }
}

- (void)app:(XCUIApplication *)app addGroup:(NSString *)group action:(NSString *)action
{
    NSDictionary *actions = @{ group : @[action] };
    [self app:app addActions:actions];
}

- (void)app:(XCUIApplication *)app addActions:(NSDictionary *)actions
{
    [app.buttons[@"Test Add Action Button"] tap];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:actions options:0 error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self app:app alertWithName:@"Lunar" enterText:json];
    LU_RELEASE(json);
}

- (void)app:(XCUIApplication *)app alertWithName:(NSString *)alertName enterText:(NSString *)text
{
    XCUIElement *textElement = app.alerts[alertName].collectionViews.textFields.element;
    
    [textElement tap];
    [textElement typeText:text];
    
    [app.alerts[alertName].collectionViews.buttons[@"Ok"] tap];
}

- (void)appOpenActionsController:(XCUIApplication *)app
{
    [self app:app tapButton:@"Show Controller"];
    [app swipeLeft];
}

@end
