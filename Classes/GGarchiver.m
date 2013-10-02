//
//  GGarchiver.m
//  Lover's Day
//
//  Created by loïc Abadie on 14/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GGarchiver.h"


@implementation GGarchiver
#pragma mark archive
+ (void)archivingData:(id)Data withName:(NSString*)name{
	NSString *docsPath	= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];	
	[NSKeyedArchiver	archiveRootObject: Data
								toFile: [docsPath stringByAppendingPathComponent:name]];
}

+ (id)unarchiveData:(NSString*)path{
	NSString *docsPath	= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	id archive			= [NSKeyedUnarchiver unarchiveObjectWithFile:[docsPath stringByAppendingPathComponent:path]];

	if(!archive){
		NSString* newPath	= [[NSBundle mainBundle] pathForResource:path ofType:@"plist"];
		archive				= [NSDictionary dictionaryWithContentsOfFile:newPath];
	}
	return archive;
}

@end
