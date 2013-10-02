//
//  GCAlertBox.m
//  picrossGame
//
//  Created by loïc Abadie on 23/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GCAlertBox.h"

@interface CustomLayer : CCColorLayer
-(void) unregisterWithTouchDispatcher;
@end

@implementation CustomLayer
-(void) registerWithTouchDispatcher {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:-1 swallowsTouches: YES];
}

-(void) unregisterWithTouchDispatcher {
	[[CCTouchDispatcher sharedDispatcher] removeDelegate: self];
}
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	return  YES;
}

@end

@implementation GCAlertBox
#pragma mark publics methods
#define GCAlertBox_TAG 170
+ (void)displayMessage:(NSString*)message withButtonsMessages:(NSArray*)buttonMessages delegate:(id <GCAlertBoxDelegate>)delegate{
	NSLog(@"****************");
	CCScene* scene				= [[CCDirector sharedDirector] runningScene];
	CGSize sceneSize			= scene.contentSize;
	CustomLayer* blackLayer		= [CustomLayer layerWithColor: ccc4(0, 0, 10, 100) width: sceneSize.width height: sceneSize.height];
	blackLayer.tag				= GCAlertBox_TAG;
	[blackLayer registerWithTouchDispatcher];
	[scene addChild: blackLayer];
}

+ (void)buttonPressed:(NSUInteger)button{
	CCScene* scene				= [[CCDirector sharedDirector] runningScene];
	CustomLayer* blackLayer		= (CustomLayer*)[scene getChildByTag: GCAlertBox_TAG];
	[blackLayer unregisterWithTouchDispatcher];
	[scene removeChild: blackLayer cleanup: YES];
}

#pragma mark Singleton methods

static GCAlertBox *sharedInstance = nil;
+ (GCAlertBox*)sharedInstance{   
	@synchronized([GCAlertBox class]){
        if (!sharedInstance){
			sharedInstance = [[self alloc] init];
		}
		return sharedInstance;
    }
	
	return nil;
}

+ (id)alloc{
	@synchronized([GCAlertBox class]){
		NSAssert(sharedInstance == nil, @"Attempted to allocate a second instance of a singleton.");
		sharedInstance = [super alloc];
		return sharedInstance;
	}
	
	return nil;
}

- (id)copyWithZone:(NSZone *)zone{
	return self;
}

- (id)retain{
    return self;
}

- (NSUInteger)retainCount{
    return NSUIntegerMax;
}

- (id)autorelease{
    return self;
}
@end
