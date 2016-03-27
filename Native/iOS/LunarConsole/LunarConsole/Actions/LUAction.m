//
//  LUAction.m
//  LunarConsole
//
//  Created by Alex Lementuev on 2/24/16.
//  Copyright © 2016 Space Madness. All rights reserved.
//

#import "Lunar.h"

#import "LUAction.h"

@implementation LUAction

+ (instancetype)actionWithId:(int)actionId name:(NSString *)name
{
    return LU_AUTORELEASE([[self alloc] initWithId:actionId name:name]);
}

- (instancetype)initWithId:(int)actionId name:(NSString *)name
{
    self = [super init];
    if (self)
    {
        if (name.length == 0)
        {
            NSLog(@"Can't create an action: title is nil or empty");
            LU_RELEASE(self);
            self = nil;
            return nil;
        }
        
        _actionId = actionId;
        _name = LU_RETAIN(name);
    }
    return self;
}

- (void)dealloc
{
    LU_RELEASE(_name);
    LU_SUPER_DEALLOC
}

#pragma mark -
#pragma mark NSComparisonMethods

- (NSComparisonResult)compare:(LUAction *)other
{
    return [_name compare:other.name];
}

#pragma mark -
#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[LUAction class]])
    {
        LUAction *action = object;
        return _actionId == action.actionId && [_name isEqualToString:action.name];
    }
    
    return NO;
}

#pragma mark -
#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"%d: %@", _actionId, _name];
}

#pragma mark -
#pragma mark Properties

- (NSString *)groupName
{
    return _group.name;
}

@end
