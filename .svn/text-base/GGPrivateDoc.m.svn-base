//
//  GGPrivateDoc.m
//  picrossGame
//
//  Created by loïc Abadie on 08/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GGPrivateDoc.h"


@implementation GGPrivateDoc

+ (NSString *)privateDocsDirectory:(NSString*)fileName{
	
    NSArray *paths					= NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory	= [paths objectAtIndex:0];
    documentsDirectory				= [documentsDirectory stringByAppendingPathComponent: @"PrivateDocuments"];
	documentsDirectory				= [documentsDirectory stringByAppendingPathComponent: fileName];
	NSError *error					= nil;
	
	NSFileManager* fileManager		= [[NSFileManager alloc] init];

	if(![fileManager fileExistsAtPath: documentsDirectory])
		[fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];   
	
	if(error)
		NSLog(@"GGPrivateDoc: can't create folder reason %@", error);
	
	[fileManager release];

    return documentsDirectory;
}
@end
