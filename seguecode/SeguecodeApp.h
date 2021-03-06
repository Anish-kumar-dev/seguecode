//
//  SeguecodeApp.h
//  seguecode
//
//  Created by Ian on 12/9/13.
//  Copyright (c) 2013 Adorkable. All rights reserved.
//

#import <DDCliApplication.h>

@interface SeguecodeApp : NSObject< DDCliApplicationDelegate >

+ (SeguecodeApp *)sharedDelegate;

@property (readwrite, assign) NSString *outputDir;
@property (readwrite, assign) NSString *constPrefix;

@property (readonly) BOOL exportConstants;

@end
