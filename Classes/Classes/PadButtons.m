//
//  PadButtons.m
//  UsingTiled
//
//  Created by loïc Abadie on 15/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PadButtons.h"
#import "ButtonSkin.h"
#import "GameConfig.h"

@interface PadButtons(){
    BOOL isLocked;
}
- (void)addButtonType:(NSString*)b highLight:(NSString*)h position:(CGPoint)p touch:(buttonType)t;
@property(nonatomic, assign)buttonType currentPadButton;
@end

@implementation PadButtons
@synthesize currentPadButton,
			islocked;

#define NUMBEROFPADBUTTONS		1
#define TOUCHBUTTONTOLERANCE	15
#define zoomPadBtn		@"zoomBtn.png"
#define movePadBtn		@"moveBtn.png"

- (id)initWithDelegate:(id<buttonPadDelegate>)bpd{
	if(self = [super init]){
		padDelegate			= bpd;
		buttonPadArray		= malloc(sizeof(CGRect) * NUMBEROFPADBUTTONS);
		
		[self addButtonType: buttonCrossOn
				  highLight: buttonFillOn
				   position: CGPointMake(100, 150)
					  touch: 0];
	}
	return self;
}

- (void)setLock:(BOOL)isLocked_{
    isLocked = isLocked_;
}

- (CCNode*)buttonForTag:(buttonType)BType{
    return [self getChildByTag: BType];
}

- (void)addButtonType:(NSString*)display highLight:(NSString*)high position:(CGPoint)point touch:(buttonType)Btype{
	ButtonSkin* button				= [[ButtonSkin alloc]	initWithSkin:display
														andHighlightSkin:high];
	button.position					= point;
	CGSize buttonSize				= [button buttonSize];
	buttonPadArray[Btype]			= CGRectMake(point.x - buttonSize.height / 2, point.y - buttonSize.height + 25, buttonSize.width + TOUCHBUTTONTOLERANCE, buttonSize.height + TOUCHBUTTONTOLERANCE);
	[self addChild:button z:0 tag:Btype];
	[button release];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	if(islocked)
        return NO;
	
    CGPoint ct = [[CCDirector sharedDirector] convertToGL:[touch locationInView: [touch view]]];
	for(int i = 0; i < NUMBEROFPADBUTTONS; i++){
        if(CGRectContainsPoint( buttonPadArray[i], ct)){
            [self changeButtonState: currentPadButton == FILL? CROSS : FILL];
			[padDelegate buttonPressed: currentPadButton];
			return YES;
		}
	}
	return NO;
}

- (void)changeButtonState:(buttonType)btnType{
    ButtonSkin* button = (ButtonSkin*)[self getChildByTag: 0];
	[button setHightLight: btnType];
	currentPadButton = btnType;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
}

#pragma mark subscrib_CCTouch
- (void)onEnter{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate: self priority: 0 swallowsTouches: YES];
	[super onEnter];
}

- (void)onExit{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}

#pragma mark alloc/dealloc
- (void)dealloc{
	free(buttonPadArray);
	[super dealloc];
}

@end
