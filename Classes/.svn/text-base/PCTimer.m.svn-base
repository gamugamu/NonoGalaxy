//
//  PCTimer.m
//  picrossGame
//
//  Created by loïc Abadie on 15/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PCTimer.h"

@interface PCTimer(){
    float currentScale;
}
@property(nonatomic, retain)CCSequence* redFlashSequence;
@end

@implementation PCTimer
@synthesize currentTime,
			redFlashSequence = _redFlashSequence;

#pragma mark --------------------------------------------------------------------------------------#
#pragma mark --------------------------------------- public ---------------------------------------#

- (void)addTime:(uint)second{
	currentTime += second;
	[self displayTimePenalty];
}

- (void)reset{
	currentTime = 0;
}

- (void)start{
	[self setAnchorPoint: ccp(0.5f, 0.5f)];
	[self schedule:@selector(tickTack:)];
}

- (void)stop{
	[self unschedule:@selector(tickTack:)];
}

#pragma mark --------------------------------------------------------------------------------------#
#pragma mark -------------------------------------- private ---------------------------------------#

- (void)tickTack:(ccTime) dt{
	static int refreshTimer = -1;
	currentTime += dt;
	
	if(refreshTimer != (int)currentTime){
		refreshTimer = (int)currentTime;

        if(((uint)(currentTime/3600) % 60))
            [self setString: [NSString stringWithFormat: @"%02u:%02u:%02u",(uint)(currentTime/3600) % 60, (uint)(currentTime/60) % 60, refreshTimer % 60]];
        else
            [self setString: [NSString stringWithFormat: @"%02u:%02u",(uint)(currentTime/60) % 60, refreshTimer % 60]];
	}
}

- (void)dealloc{
	[_redFlashSequence release];
	[super dealloc];
}

+ (id) labelWithString:(NSString *)string fntFile:(NSString *)fntFile{
    PCTimer* timer = [[[self alloc] initWithString:string fntFile:fntFile width: 150 alignment: CenterAlignment] autorelease];
    if(timer)
        [timer setUpSequences];
    
	 return timer;
}

- (id)initWithString:(NSString *)string fntFile:(NSString *)font width:(float)width alignment:(CCLabelBMFontMultilineAlignment)alignment {
	if(self = [super initWithString: string fntFile: font width: width alignment: alignment]){
		[self setUpSequences];
        currentScale = 1;
	}
	return self;
}

- (void)setScale:(float)scale{
    currentScale = scale;
    [self setUpSequences];
    [super setScale: scale];
}

#pragma mark - setUp

- (void)setUpSequences{
	self.redFlashSequence = [CCSequence actionOne: [CCTintBy actionWithDuration: .2f red: 250 green: 250 blue: 0]
											  two: [CCEaseBackInOut actionWithAction: [CCScaleTo actionWithDuration: .3f scale: currentScale]]];
}

#pragma mark - display

- (void)displayTimePenalty{
    if(![self numberOfRunningActions])
        [self runAction: _redFlashSequence];
}
@end
