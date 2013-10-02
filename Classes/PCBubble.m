//
//  PCBubble.m
//  picrossGame
//
//  Created by loïc Abadie on 09/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PCBubble.h"
#import "CCLabelBMFontMultiline.h"
#import "GameConfig.h"

@interface  PCBubble()
@property(nonatomic, retain)CCSpriteBatchNode*	_bubbleBatch;
@property(nonatomic, retain)CCNode*				_displayTextLayer;
@property(nonatomic, retain)CCMenu*				_buttons;
@property(nonatomic, assign)bubbleStyle			currentBubleStyle;
- (void)setUpMessageWithCancelButton;
- (void)setUpConstelationComment;
@end


@implementation PCBubble
@synthesize currentBubleStyle,
			delegate,
			_buttons,
			_bubbleBatch,
			_displayTextLayer;

- (void)changeBubbleStyle:(bubbleStyle)bubbleStyle{
	if(currentBubleStyle != bubbleStyle){
		[self cleanLayers];
		
		switch (bubbleStyle) {
			case messageWithInApp:			[self setUpMessageInapp];				break;
			case messageWithCancelButton:	[self setUpMessageWithCancelButton];	break;
			case messageWithVictory:		[self setUpMessageVictory];				break;
			case messageWithCheckNewMap:	[self setUpCheckNewMap];				break;
            case messageWithOkButton:       [self setUpMessageWithOkButton];        break;
			default:						[self setUpConstelationComment];		break;
		}
		currentBubleStyle = bubbleStyle;
	}
}

- (void)popUpBubbleWithMessages:(NSArray*)messages{
	_bubbleBatch.visible		= YES;
	_displayTextLayer.visible	= YES;
	self.visible				= YES;
	
	for(CCNode* bubble in [_bubbleBatch children]){
		bubble.visible			= YES;
		float currentScale		= bubble.scale;
		bubble.scale			= currentScale - .4f;
		bubble.opacity			= 0;
		[bubble	runAction: [CCSpawn actions: [CCFadeIn actionWithDuration: .3f], 
							[CCEaseBackOut actionWithAction: [CCScaleTo actionWithDuration:.3f scale: currentScale]],
							nil]];
	}

	NSUInteger enumerate	= 0;
	NSUInteger lenght		= [messages count];
	
	for(CCLabelBMFontMultiline* message in [_displayTextLayer children]){
		message.visible = YES;
		message.opacity	= 0;
		[message runAction: [CCSpawn actions: [CCFadeIn actionWithDuration: .3f], nil]];
		
		if(enumerate < lenght)
			[message setString: [messages objectAtIndex: enumerate++]];
	}
}

- (void)unPopBubble{
	[_bubbleBatch			stopAllActions];
	[_displayTextLayer		stopAllActions];
	_bubbleBatch.visible		= NO;
	_displayTextLayer.visible	= NO;
	self.visible				= NO;
}

#pragma mark - private
- (void)btnTouched:(CCMenuItem*)btn{
	if([delegate respondsToSelector: @selector(buttonSelected:forBubleStyle:)])
		[delegate buttonSelected: btn.tag forBubleStyle: currentBubleStyle];
}

- (void)cleanLayers{
	if(_buttons.parent)
		[self removeChild: _buttons cleanup: YES];
	[_bubbleBatch		removeAllChildrenWithCleanup: NO];
	[_displayTextLayer	removeAllChildrenWithCleanup: NO];
}

#pragma mark - ovveride
- (void)onExit{
	[self stopAllActions];
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile: @"nono.plist"];//<---
	[super onExit];
}

- (void)onEnter{
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"nono.plist"];//<---
	[super onEnter];
}

#pragma mark - setUp

- (void)setUpMessageWithCancelButton{
	CCNode* simpleBubble					= [CCSprite spriteWithSpriteFrameName: bubbleInAppCancel];
	CCLabelBMFontMultiline* simpleMessage	= [CCLabelBMFontMultiline labelWithString: nil fntFile: @"FntSnow_28w.fnt" width: 350 alignment: CenterAlignment];
	
	simpleBubble.position		= ccp(350, 280);
	simpleMessage.anchorPoint	= ccp(0.5f, 0.5f);
	simpleMessage.position		= ccp(350, 360);
	
	[_bubbleBatch addChild: simpleBubble];
	[_displayTextLayer	addChild: simpleMessage];
	
	// bouton cancel
	CCSprite* btnSprite		= [CCSprite spriteWithFile: buttonCancel];
	CCMenuItemSprite* btnS	= [CCMenuItemSprite itemFromNormalSprite: btnSprite
													  selectedSprite: btnSprite
															  target: self
														   selector: @selector(btnTouched:)];
	
	self._buttons		= [CCMenu menuWithItems: btnS, nil];
	_buttons.position	= CGPointZero;
	btnS.tag			= buttonCancelPressed;
	btnS.position		= ccp(440, 310);
	[self addChild: _buttons];
}

- (void)setUpMessageInapp{
    
	CCNode* bubbleInApp						= [CCSprite spriteWithSpriteFrameName: bubbleInAppPropose];
	CCLabelBMFontMultiline* messageInapp	= [CCLabelBMFontMultiline labelWithString: nil fntFile: @"FntSnow_28w.fnt" width: 200 alignment: RightAlignment];
	// CCLabelTTF parce qu'avec les localisations, on peut avoir plus de 8000 charactères. Un BmFont, n'a plus aucun intérêt
	CCLabelTTF *messagePrice				= [CCLabelTTF labelWithString: nil dimensions:CGSizeMake(400, 100) alignment:UITextAlignmentLeft  fontName: @"Arial Rounded MT Bold" fontSize:70];
	CCLabelBMFontMultiline *priceExplanation			= [CCLabelBMFontMultiline labelWithString: NSLocalizedString(@"Nono_priceExpl", nil)
                                                                     fntFile: @"Fntsnow_22.fnt"
                                                                       width: 600
                                                                   alignment: LeftAlignment];

	[_bubbleBatch		addChild: bubbleInApp];
	[_displayTextLayer	addChild: messageInapp];
	[_displayTextLayer	addChild: messagePrice];
    [_displayTextLayer addChild: priceExplanation];
    
	// bouton OUI / NON
	CCSprite* btnYeah		= [CCSprite spriteWithFile: buttonCancelStraight];
	CCMenuItemSprite* btnSY	= [CCMenuItemSprite itemFromNormalSprite: btnYeah
													 selectedSprite: btnYeah
															 target: self
														   selector: @selector(btnTouched:)];
	
	
	CCSprite* btnBuyIt			= [CCSprite spriteWithFile: buttonBuyIt];
	CCMenuItemSprite* btnBI		= [CCMenuItemSprite itemFromNormalSprite: btnBuyIt
														selectedSprite: btnBuyIt
															 target: self
														   selector: @selector(btnTouched:)];

	
	btnSY.tag			= buttonCancelPressed;
	btnBI.tag			= buttonBuyItPressed;

	self._buttons		= [CCMenu menuWithItems: btnSY, btnBI, nil];
	_buttons.position	= CGPointZero;
	
	btnSY.position              = ccp(240, 280);
	btnBI.position              = ccp(440, 290);
	messageInapp.position       = ccp(180, 400);
	messagePrice.position       = ccp(500, 400);
    priceExplanation.position   = ccp(250, 320);
    bubbleInApp.scale           = 1.3f;
	bubbleInApp.position        = ccp(230, 290);

	[self addChild: _buttons];
}

- (void)setUpMessageVictory{
	CCSprite* simpleBubble					= [CCSprite spriteWithSpriteFrameName: bubbleInVictory];
	CCLabelBMFontMultiline* simpleMessage	= [CCLabelBMFontMultiline labelWithString: nil
                                                                            fntFile: @"FntSnow_28w.fnt"
                                                                              width: 200
                                                                          alignment: LeftAlignment];
	
	simpleBubble.flipX			= YES;
	simpleBubble.scale			= 0.6f;
	simpleBubble.rotation		= 13;
	simpleBubble.position		= ccp(0, 190);
	simpleMessage.position		= ccp(10, 210);
	
	[_bubbleBatch		addChild: simpleBubble];
	[_displayTextLayer	addChild: simpleMessage];
}

- (void)setUpConstelationComment{
	CCNode* simpleBubble					= [CCSprite spriteWithSpriteFrameName: bubbleConstellation];
	CCLabelBMFontMultiline* simpleMessage	= [CCLabelBMFontMultiline labelWithString: nil
                                                                            fntFile: @"FntSnow_28w.fnt"
                                                                              width: 200
                                                                          alignment: LeftAlignment];
	
	simpleBubble.scale			= 1;
	simpleBubble.position		= ccp(23, 210);
	simpleMessage.position		= ccp(20, 230);

	[_bubbleBatch		addChild: simpleBubble];
	[_displayTextLayer	addChild: simpleMessage];
}

- (void)setUpMessageWithOkButton{
	CCNode* simpleBubble					= [CCSprite spriteWithSpriteFrameName: bubbleInVictory];
	CCLabelBMFontMultiline* simpleMessage	= [CCLabelBMFontMultiline labelWithString: nil
                                                                            fntFile: @"FntSnow_28w.fnt"
                                                                              width: 350
                                                                          alignment: LeftAlignment];
	
	simpleBubble.scale			= 1;
	simpleBubble.position		= ccp(240, 230);
	simpleMessage.position		= ccp(240, 300);

	[_bubbleBatch		addChild: simpleBubble];
	[_displayTextLayer	addChild: simpleMessage];
    
    // bouton cancel
	CCSprite* btnSprite		= [CCSprite spriteWithFile: buttonOk];
	CCMenuItemSprite* btnS	= [CCMenuItemSprite itemFromNormalSprite: btnSprite
													 selectedSprite: btnSprite
															 target: self
														   selector: @selector(btnTouched:)];
	
	self._buttons		= [CCMenu menuWithItems: btnS, nil];
	_buttons.position	= CGPointZero;
	btnS.tag			= buttonCancelPressed;
	btnS.position		= ccp(430, 260);
	[self addChild: _buttons];
}

- (void)setUpCheckNewMap{
	CCNode* simpleBubble					= [CCSprite spriteWithSpriteFrameName: bubbleInAppCancel];
	CCLabelBMFontMultiline* simpleMessage	= [CCLabelBMFontMultiline labelWithString: nil
                                                                            fntFile: @"FntSnow_28w.fnt"
                                                                              width: 200
                                                                          alignment: CenterAlignment];
	
	simpleBubble.scale			= 1;
	simpleBubble.position		= ccp(260, 180);
	simpleMessage.anchorPoint	= ccp(0.5, 0.5f);
	simpleMessage.position		= ccp(200, 260);
	
	[_bubbleBatch addChild: simpleBubble];
	[_displayTextLayer	addChild: simpleMessage];
	
	// bouton cancel
	CCSprite* btnSprite		= [CCSprite spriteWithFile: buttonCheckNewMap];
	CCMenuItemSprite* btnS	= [CCMenuItemSprite itemFromNormalSprite: btnSprite
													 selectedSprite: btnSprite
															 target: self
														   selector: @selector(btnTouched:)];
	
	self._buttons		= [CCMenu menuWithItems: btnS, nil];
	_buttons.position	= CGPointZero;
	btnS.tag			= buttonCancelPressed;
	btnS.position		= ccp(460, 200);
	[self addChild: _buttons];
}

- (void)setUpBubbleBatch{
	[self set_bubbleBatch: [CCSpriteBatchNode batchNodeWithFile: @"nono.png"]];//<---
	[self addChild: _bubbleBatch];
	_bubbleBatch.visible		= NO;
}

- (void)setUpDisplayTextLayer{
	self._displayTextLayer = [CCNode node];
	[self addChild: _displayTextLayer];
	_displayTextLayer.visible	= NO;
}

#pragma mark - alloc / dealloc
- (id)initWithDelegate:(id<PCMrNonoBubbleDelegate>)delegate_{
	if(self = [super init]){
		currentBubleStyle	= -1;
		delegate			= delegate_;
		[self setUpBubbleBatch];
		[self setUpDisplayTextLayer];
	}
	return self;
}

- (void)dealloc{
	[_buttons			release];
	[_displayTextLayer	release];
	[_bubbleBatch		release];
	[super dealloc];
}
@end
