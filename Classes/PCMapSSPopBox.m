//
//  PCMapSSPopBox.m
//  picrossGame
//
//  Created by loïc Abadie on 01/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PCMapSSPopBox.h"
#import "GameConfig.h"

@interface PCMapSSPopBox()
- (void)setUpDisplay;
@property(nonatomic, assign)CCMenuItemImage*	goToBtn;
@property(nonatomic, retain)CCSprite*			_SSBox;
@end

@implementation PCMapSSPopBox
@synthesize delegate,
			isPoping,
			goToBtn,
			_SSBox;

#pragma mark public
- (void)popOutBox{
	if(!isPoping) 
		return;
	
	isPoping		= NO;
	self.visible	= isPoping;
}

- (void)popInBox{
	if(isPoping)
		return;
	
	isPoping		= YES;
	self.visible	= isPoping;
}

#pragma mark touchInput
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	if(isPoping){
		NSSet* eTouches = [event allTouches];
		switch ([eTouches count]) {
			case 1:	{
				UITouch* singleTouch	= [eTouches anyObject];
				CGPoint pnt				= [singleTouch locationInView: singleTouch.view];
				pnt.y					= IPHONEHEIGHT - pnt.y;
				CGRect rect				= CGRectOffset(_SSBox.boundingBox, self.boundingBox.origin.x, self.boundingBox.origin.y);
				if (CGRectContainsPoint(rect, pnt)){
					CGPoint relativPnt = CGPointMake(pnt.x - self.position.x, pnt.y - self.position.y);
					
					if(CGRectContainsPoint( goToBtn.boundingBox, relativPnt))
						[delegate buttonHasBeenPressed: self];

					return YES;
				}
				else return NO;
				break;
			}
			default:{ return NO;}
		}
	}
	else 
		return NO;
}

- (void)onEnter{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate: self priority: pctouchMapSSBox swallowsTouches: YES];
	[super onEnter];
}

- (void)onExit{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate: self];
	[super onExit];
}

#pragma mark setUp
- (void)setUPBackground{
	[self set_SSBox:[CCSprite spriteWithFile: @"goStg_ble.png"]];//<---
	[self addChild: _SSBox];
}

- (void)setUpDisplay{
	goToBtn						= [CCSprite spriteWithFile: @"sspopBtn.png"];//<---
	goToBtn.position			= ccp(45, 5);
	[self addChild: goToBtn];
	
	CCLabelBMFont* comment		= [CCLabelBMFont  labelWithString:@"select this\nstage?" fntFile: @"FntSnow_27.fnt"];//<---

	comment.position			= ccp(0, 30);
	[self addChild: comment];
}

#pragma mark alloc/dealloc
- (id)initWithDelegate:(id<GGButonPressedDelegate>) delegate_{
    if (self = [super init]) {
		self.visible	= isPoping;
		delegate		= delegate_;
		[self setUPBackground];
		[self setUpDisplay];
	   }
    
    return self;
}

- (void)dealloc{
	[_SSBox		release];
    [super		dealloc];
}

@end
