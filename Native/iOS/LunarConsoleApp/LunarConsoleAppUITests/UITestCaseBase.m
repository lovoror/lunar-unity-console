//
//  UITestCaseBase.m
//
//  Lunar Unity Mobile Console
//  https://github.com/SpaceMadness/lunar-unity-console
//
//  Copyright 2016 Alex Lementuev, SpaceMadness.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "UITestCaseBase.h"

@implementation UITestCaseBase

- (void)app:(XCUIApplication *)app tapButton:(NSString *)title
{
    XCTAssertTrue(app.buttons[title].exists);
    [app.buttons[title] tap];
}

- (void)app:(XCUIApplication *)app tapSwitch:(NSString *)title
{
    XCTAssertTrue(app.switches[title].exists);
    [app.switches[title] tap];
}

- (void)app:(XCUIApplication *)app tapTextField:(NSString *)title
{
    XCUIElement *element = app.textFields[title];
    [self waitUntilElementExists:element timeout:5.0];
    [element tap];
}

- (void)app:(XCUIApplication *)app tapSearchField:(NSString *)title
{
    XCUIElement *element = app.searchFields[title];
    [self waitUntilElementExists:element timeout:5.0];
    [element tap];
}

- (void)appDeleteText:(XCUIApplication *)app
{
    [[self appDeleteKey:app] pressForDuration:2.5];
}

- (void)appDeleteChar:(XCUIApplication *)app
{
    [[self appDeleteKey:app] tap];
}

- (void)app:(XCUIApplication *)app textField:(NSString *)textField enterText:(NSString *)text
{
    // find element
    XCUIElement *element = app.textFields[textField];
    
    // tap element
    [element tap];
    
    // delete old text
    [self appDeleteText:app];
    
    // type new text
    [element typeText:text];
    
    // hit 'return'
    [[self appReturnButton:app] tap];
}

- (XCUIElement *)appDeleteKey:(XCUIApplication *)app
{
    if (app.keys[@"Delete"].exists) return app.keys[@"Delete"];
    if (app.keys[@"delete"].exists) return app.keys[@"delete"];
    
    XCTFail(@"Can't resolve 'delete' button");
    return nil;
}

- (XCUIElement *)appReturnButton:(XCUIApplication *)app
{
    if (app.buttons[@"Return"].exists) return app.buttons[@"Return"];
    if (app.buttons[@"return"].exists) return app.buttons[@"return"];
    
    XCTFail(@"Can't resolve 'return' button");
    return nil;
}

- (void)app:(XCUIApplication *)app runCommandName:(NSString *)name payload:(NSDictionary *)payload
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:payload];
    dict[@"name"] = name;
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    if (error) {
        NSLog(@"Unable to serialize command: %@", error);
        return;
    }
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"Running command: %@", json);
    
    [self app:app tapButton:@"Test Run Command Button"];
    XCUIElement *alert = app.alerts[@"Command"];
    [alert.textFields[@"Text Input Field"] typeText:json];
    [alert.buttons[@"Run"] tap];
}

- (void)checkTable:(XCUIElement *)table items:(NSArray<NSString *> *)items
{
    XCUIElementQuery *staticTexts = table.staticTexts;
    XCTAssertEqual(staticTexts.count, items.count);
    for (int i = 0; i < staticTexts.count; ++i)
    {
        XCUIElement *element = [staticTexts elementBoundByIndex:i];
        XCTAssert([items[i] isEqualToString:element.label]);
    }
}

@end
