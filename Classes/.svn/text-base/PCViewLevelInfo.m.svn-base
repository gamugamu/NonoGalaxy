//
//  PCViewLevelInfo.m
//  picrossGame
//
//  Created by loïc Abadie on 12/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PCViewLevelInfo.h"
#import "GameConfig.h"

@implementation PCViewLevelInfo

- (id)initWithLevelInfo:(PCLevelInfo*)info{
	if((self = [super initWithColor:ccc4(200, 200, 200, 255) width: 200 height: 50])){
		NSString* name	= [info.constelationName stringByReplacingOccurrencesOfString: FORMATmap withString:@""];
		name			= [name substringWithRange: NSMakeRange(Const000format, [name length] - Const000format)];
		name			= [name stringByDeletingPathExtension];
		CCLabelBMFont* labelName	= [CCLabelBMFont labelWithString:name fntFile: @"bitmapFontTest4.fnt"];
		labelName.position			= CGPointMake(90, 30);
		[self addChild: labelName];
	}
	
	return  self;
}
@end
