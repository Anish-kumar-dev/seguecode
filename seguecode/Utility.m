//
//  Utility.m
//  seguecode
//
//  Created by Ian on 12/11/13.
//  Copyright (c) 2013 Adorkable. All rights reserved.
//

#import "Utility.h"

@implementation NSString (seguecode)
    
- (NSString *)segueCodeTemplateFromDict:(NSDictionary *)dict
{
    CCTemplate *parser = [ [CCTemplate alloc] init];
    parser.head = @"<#(";
    parser.tail = @")#>";
    return [parser scan:self dict:dict];
}
    
@end