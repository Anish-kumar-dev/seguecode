//
//  StoryboardFile.h
//  seguecode
//
//  Created by Ian on 12/10/13.
//  Copyright (c) 2013 Adorkable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoryboardFile : NSObject

+ (instancetype)storyboardFileAtPathFileName:(NSString*)pathFileName;
    
@property (strong, readwrite) NSString *name;

@property (readonly) NSDictionary *viewControllersByStoryboardID;
@property (readonly) NSDictionary *viewControllersByClassName;
@property (readwrite) BOOL exportViewControllersSeparately;

@property (readonly) NSString *categoryName;
    
- (void)exportTo:(NSString *)outputPath
withTemplateHeader:(NSString *)templateHeader
       andSource:(NSString *)templateSource;

@end
