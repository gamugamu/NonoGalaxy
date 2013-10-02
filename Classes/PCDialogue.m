//
//  PCDialogue.m
//  picrossGame
//
//  Created by loïc Abadie on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PCDialogue.h"
#import "CCLabelBMFontMultiline.h"
#import "GameConfig.h"

@interface PCDialogue()
@property(nonatomic, retain)CCLabelBMFontMultiline* _dialogue;
@property(nonatomic, retain)CCSpriteBatchNode*		_batch;
@property(nonatomic, retain)CCSprite*               _bubble;
@property(nonatomic, assign)NSTimer*				_timer;
@property(nonatomic, assign)CCSprite*				currentTutoDisplay;
@property(nonatomic, assign)CCMenuItemImage*		next;
@property(nonatomic, assign)CCMenuItemImage*		previous;
@property(nonatomic, assign)uint					count;
@property(nonatomic, assign)id <GCDialogueDelegate>	delegate;
@property(nonatomic, assign)PCNonoDisplay*          MrNono;

@end

@implementation PCDialogue
@synthesize next, 
			previous, 
			delegate,
			currentTutoDisplay,
			count,
            MrNono,
			_timer,
			_batch,
			_dialogue,
            _bubble;

#pragma mark public

- (void)dialogue:(NSString*)dialogueText{
	[_dialogue setString: [dialogueText stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"]];
	previous.visible	= [delegate hasBack];
	next.visible		= [delegate hasNext];
    
    if(![delegate hasNext])
        [self hideTutoAfterDelay: 2];

    [self shouldDisplayTuto: NO];
}

- (void)displayTutoImage:(uint)tutoImage{
	[currentTutoDisplay setDisplayFrame: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"tuto_%u.png", tutoImage]]];//<---
    [self shouldDisplayTuto: YES];
}

- (void)displaySequencesImage:(NSArray*)images{
	count = 0;
	[self set_timer: [NSTimer scheduledTimerWithTimeInterval: .5f target: self selector: @selector(switchImage:) userInfo: images repeats: YES]];
	[_timer fire];
    [self shouldDisplayTuto: YES];
}

- (void)switchImage:(NSTimer*)timer{
	[currentTutoDisplay setDisplayFrame: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [timer.userInfo objectAtIndex: count % 2]]];
	count++;
}

- (void)hideNext:(BOOL)needHide{
	if(needHide)
		next.visible = NO;
	else
		next.visible = [delegate hasNext];
}

- (void)hidePrevious:(BOOL)needHide{
	if(needHide)
		previous.visible = NO;
	else
		previous.visible = [delegate hasBack];
}

- (void)hideTutoAfterDelay:(float)delay{
    [self performSelector: @selector(shouldHideDialogue:) withObject: [NSNumber numberWithBool: YES] afterDelay: delay];
}

- (void)shouldHideDialogue:(BOOL)isHiding{
    [_batch     runAction: [CCFadeOut actionWithDuration: .3f]];
    [_dialogue  runAction: [CCFadeOut actionWithDuration: .3f]];
    [previous   runAction: [CCFadeOut actionWithDuration: .3f]];
    [MrNono     runAction:
     [CCSequence actions:
      [CCSpawn actionOne: [CCFadeTo actionWithDuration: .8f opacity: 0]
                     two: [CCEaseBackInOut actionWithAction: [CCScaleTo actionWithDuration: .8f scale: .8f]]],
      [CCCallBlockN actionWithBlock: BCA(^{ [MrNono removeFromParentAndCleanup: YES];})], nil]];
}

#pragma mark logic button
- (void)backPressed{
	[_timer invalidate];
	_timer = nil;
	[delegate askUndo];
}

- (void)nextPressed{
	[_timer invalidate];
	_timer = nil;
	[delegate askNext];
}

#pragma mark setup
- (void)setUpButton{
	next						= [CCMenuItemImage itemFromNormalImage: @"btn_tutRight.png" selectedImage: @"btn_tutRight.png" target: self selector: @selector(nextPressed)];//<---
	previous					= [CCMenuItemImage itemFromNormalImage: @"btn_tutleft.png" selectedImage: @"btn_tutleft.png" target: self selector:  @selector(backPressed)];//<---
	next.position				= ccp(-IPHONEWIDTHDEMI + 150, -30);
	previous.position			= ccp(-IPHONEWIDTHDEMI, -30);
	[self addChild: [CCMenu menuWithItems: next, previous, nil]];
}

- (void)setUpDialogue{
	[self set_dialogue: [CCLabelBMFontMultiline labelWithString: @""
														fntFile: @"FntProvi_25.fnt" //<---
														  width: 280
													  alignment: LeftAlignment]];
	_dialogue.position = ccp(40, 450);
	[self addChild: _dialogue];
}

- (void)setUpBatch{
	[self set_batch: [CCSpriteBatchNode batchNodeWithFile: @"tutoPics.png"]];//<---
	[self addChild: _batch];
    
    CCSprite* background    = [CCSprite spriteWithSpriteFrameName: @"tuto_bkg.png"];
	currentTutoDisplay      = [CCSprite spriteWithSpriteFrameName: @"tuto_0.png"];
    _bubble                 = [[CCSprite spriteWithSpriteFrameName: @"tuto_anchor.png"] retain];

    [_batch addChild: background z: 0 tag: 2];
	[_batch addChild: currentTutoDisplay ];
    [_batch addChild: _bubble];
    
    _bubble.scaleY              = 1.3;
    _bubble.position            = ccp(40, 440);
    background.position         = ccp(730, 30);
    currentTutoDisplay.position = ccp(730, 30);
    [self shouldDisplayTuto: NO];
}

- (void)onExit{
	[self stopAllActions];
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile: @"tutoPics.plist"];//<---
	[super onExit];
}

#pragma mark - display

- (void)shouldDisplayTuto:(BOOL)isDisplaying{
    [_batch getChildByTag: 2].visible   = isDisplaying; // background
    currentTutoDisplay.visible          = isDisplaying;
}

#pragma mark alloc/dealloc
- (id)initWithDelegate:(id <GCDialogueDelegate>)delegate_ andMrNono:(PCNonoDisplay*)mrNono_{
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"tutoPics.plist"];//<---

	if(self = [super init]){
		delegate    = delegate_;
        MrNono      = mrNono_;
		[self setUpBatch];
        [self setUpDialogue];
        [self setUpButton];
	}
	return self;
}

-(void)dealloc{
    [_bubble        release];
	[_timer			invalidate];
	[_batch			release];
	[_dialogue		release];
	[super			dealloc];
}
@end

//*****************************************************************************************************************//
@implementation PCStateDialogue
@synthesize _actions,
			_stateDialogue,
			isUndoIsForced,
			stateEvent, 
			stateButton,
			stateDisplay;

- (NSString*)description{
	return [NSString stringWithFormat: @"StateDialogue: %@ [event: %u], [lastStateButton: %u]", _stateDialogue, stateEvent, stateButton];
}

- (void)distroyActions{
	[_actions release];
	_actions = nil;
}

- (void)dealloc{
	[_actions		release];
	[_stateDialogue	release];
	[super			dealloc];
}
@end