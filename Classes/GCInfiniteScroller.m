//
//  CGInfiniteScroller.m
//  picrossGame
//
//  Created by loïc Abadie on 08/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GCInfiniteScroller.h"
#import "GameConfig.h"

@implementation GCInfiniteScroller
- (void) update:(ccTime) dt{
	CCSprite* sprite;
	CCARRAY_FOREACH([self children], sprite){
		sprite.position = (CGPoint){sprite.position.x + dt * 20, sprite.position.y};
		if(sprite.position.x > IPHONEWIDTH + 300)
			sprite.position =  (CGPoint){-sprite.contentSize.width, sprite.position.y};
	}
}

#pragma mark override
- (void)onExit{
	[self unscheduleUpdate];
	[super onExit];
}
/*
- (void)setOpacity:(GLubyte)opacity{
	NSLog(@"SET OPACITY");
	CCSprite* sprite;
	CCARRAY_FOREACH([self children], sprite){
		 [sprite setOpacity: opacity];
	 }
}*/

#pragma mark alloc/dealloc
+ (id)batchNodeWithFile:(NSString*) imageFile{
	id create = [[[self alloc] initWithFile: imageFile capacity: 29] autorelease];
	[create scheduleUpdate];
	return create;
}

- (void)dealloc{
    [super dealloc];
}

@end
