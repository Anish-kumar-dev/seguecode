//
//  ViewControllerDefinition.m
//  seguecode
//
//  Created by Ian on 12/10/13.
//  Copyright (c) 2013 Adorkable. All rights reserved.
//

#import "ViewControllerDefinition.h"

#import <RaptureXML/RXMLElement.h>

#import "SegueDefinition.h"

#import "Utility.h"

#import "HeaderTemplate.h"

#import <TypeForKey/NSDictionary+TypeForKey.h>

#import <ddcli/DDCliUtil.h>
#import "SeguecodeApp.h"

@interface ViewControllerDefinition ()
{
    NSMutableDictionary *_segues;
}

@property (strong) RXMLElement *element;

@end

@implementation ViewControllerDefinition

@synthesize segues = _segues;

- (instancetype)initWithDefinition:(RXMLElement *)definitionElement
{
    if (definitionElement)
    {
        self = [self init];
        if (self)
        {
            self.element = definitionElement;
            [self parseSegues];
        }
    } else
    {
        ddprintf(@"Error: attempt to create a View Controller Definition without XML\n");
        self = nil;
    }
    return self;
}

+ (instancetype)definitionFrom:(RXMLElement *)definitionElement
{
    return [ [ViewControllerDefinition alloc] initWithDefinition:definitionElement];
}

- (void)parseSegues
{
    _segues = [NSMutableDictionary dictionary];

    if ( [SeguecodeApp useVerboseOutput] )
    {
        ddprintf(@"Parsing segues for %@\n", self.storyboardIdentifier);
    }

    [_element iterate:@"connections" usingBlock:^(RXMLElement *connections)
    {
        if ( [SeguecodeApp useVerboseOutput] )
        {
            ddprintf(@"%d segue(s) found\n", [_element children:@"connections"].count);
        }
        [connections iterate:@"segue" usingBlock:^(RXMLElement *segue)
        {
            SegueDefinition *definition = [SegueDefinition definitionFrom:segue andSource:self];
            if (definition)
            {
                [_segues setObject:definition forKey:definition.id];
            }
        }];
    }];
}

XMLMappedProperty(id, @"id");
XMLMappedProperty(storyboardIdentifier, @"storyboardIdentifier");
XMLMappedProperty(customClass, @"customClass");
XMLMappedProperty(sceneMemberID, @"sceneMemberID");
    
- (NSArray *)segueConstantDeclarations
{
    NSMutableArray *result = [NSMutableArray array];
    for (id object in [self.segues allValues] )
    {
        if ( [object isKindOfClass:[SegueDefinition class] ] )
        {
            SegueDefinition* segueDefinition = (SegueDefinition *)object;
            [result addObject:[segueDefinition constantDeclaration] ];
        }
    }
    return result;
}
    
- (NSArray *)segueConstantDefinitions
{
    NSMutableArray *result = [NSMutableArray array];
    for (id object in [self.segues allValues] )
    {
        if ( [object isKindOfClass:[SegueDefinition class] ] )
        {
            SegueDefinition* segueDefinition = (SegueDefinition *)object;
            [result addObject:[segueDefinition constantDefinition] ];
        }
    }
    return result;
}

- (NSString *)categoryDeclarations:(NSString *)categoryName
{
    NSString *result;
    NSDictionary *templateMap = [self categoryTemplateMap:categoryName];
    
    if ( [ [templateMap stringForKey:@"SegueSelectorDeclarations"] length] > 0)
    {
        result = [DefaultControllerCategoryDeclaration segueCodeTemplateFromDict:[self categoryTemplateMap:categoryName] ];
    }
    
    return result;
}

- (NSString *)categoryDefinitions:(NSString *)categoryName
{
    NSString *result;
    NSDictionary *templateMap = [self categoryTemplateMap:categoryName];

    if ( [ [templateMap stringForKey:@"SegueSelectorDefinitions"] length] > 0)
    {
        result = [DefaultControllerCategoryDefinition segueCodeTemplateFromDict:templateMap ];
    }
    
    return result;
}

- (NSString *)segueSelectorDeclarations
{
    NSMutableString *result = [NSMutableString string];
    for (id object in [self.segues allValues] )
    {
        if ( [object isKindOfClass:[SegueDefinition class] ] )
        {
            SegueDefinition* segueDefinition = (SegueDefinition *)object;
            [result appendString:[segueDefinition selectorDeclarations]
                      joinedWith:@"\n"];
        }
    }
    return result;
}

- (NSString *)segueSelectorDefinitions
{
    NSMutableString *result = [NSMutableString string];
    for (id object in [self.segues allValues] )
    {
        if ( [object isKindOfClass:[SegueDefinition class] ] )
        {
            SegueDefinition* segueDefinition = (SegueDefinition *)object;
            [result appendString:[segueDefinition selectorDefinitions]
                      joinedWith:@"\n"];
        }
    }
    return result;
}

- (NSDictionary *)categoryTemplateMap:(NSString *)categoryName
{
    NSString *viewControllerName = self.customClass;
    if (!viewControllerName)
    {
        viewControllerName = @"UIViewController";
    }
    return @{
             @"ViewControllerName" : viewControllerName
             , @"StoryboardName" : categoryName
             , @"SegueSelectorDeclarations" : self.segueSelectorDeclarations
             , @"SegueSelectorDefinitions" : self.segueSelectorDefinitions
             };
}

@end
