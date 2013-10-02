//
//  PCGlowingStarsBackground.m
//  picrossGame
//
//  Created by loïc Abadie on 03/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PCGlowingStarsBackground.h"
#import "PCFallingStar.h"
#import "GameConfig.h"

@interface PCStars : CCSprite
+ (id)spriteWithSpriteFrameName:(NSString*)spriteFrameName;
@end

@interface PCGlowingStarsBackground()
@property(nonatomic, assign)CGPoint				lastAccelerometer;
@property(nonatomic, retain)CCSpriteBatchNode*	_stars;
@property(nonatomic, retain)CCSpriteBatchNode*	_galaxies;
@property(nonatomic, assign)CCArray*			_starsList;
@end

@implementation PCGlowingStarsBackground
@synthesize lastAccelerometer,
			_stars,
			_starsList,
			_galaxies;

#pragma mark
#define kFilteringFactor	0.08f
#define kSpeed				5
UIAccelerationValue rollingX, rollingY, rollingZ;
- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration{
	rollingX			= (acceleration.x * kFilteringFactor) + (rollingX * (1 - kFilteringFactor));
    rollingY			= (acceleration.y * kFilteringFactor) + (rollingY * (1 - kFilteringFactor));
	float accelX		= (acceleration.x - rollingX) * kSpeed;
	float accelY		= (acceleration.y - rollingY) * kSpeed;

	_stars.position	= (CGPoint){_stars.position.x - accelY, _stars.position.y + accelX};
}

- (void)loadTexture{
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"stars.plist"];
	[self set_stars: [CCSpriteBatchNode batchNodeWithFile: @"stars.png"]];	
	[self addChild: _stars];
}

-(void)unloadTexture{
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile: @"stars.plist"];
}

#pragma mark override

- (void)onExit{
	[self unloadTexture];
	[super onExit];
}

- (void)setUpNebulary{
	// aurores
	CCSprite* aurorOne	= [CCSprite spriteWithFile: @"auror.png"];
	aurorOne.position	= CGPointMake(300, 550);
	aurorOne.rotation	= 70;
	
	CCSprite* aurorTwo	= [CCSprite spriteWithFile: @"auror.png"];
	aurorTwo.position	= CGPointMake(800, 350);
	aurorTwo.rotation	= 45;
	
	[self addChild: aurorOne];
	[self addChild: aurorTwo];
	
	// falling stars
	PCFallingStar* fallingStar = [[PCFallingStar alloc] init];
	[self addChild: fallingStar];
	[fallingStar release];
}

- (void)setUpStars{
	srand(time(0));
	uint	starRatePerGrid	= 2;
	float	iteration		= 10;
	float	segmentWidth	= IPHONEWIDTH / iteration;
	float	segmentHeight	= IPHONEHEIGHT / iteration;
	
	for(int i = 0; i <= iteration; i++){
		for(int j = 0; j <= iteration; j++){
			if(!(rand() % starRatePerGrid)){
				PCStars* s	= [PCStars spriteWithSpriteFrameName: [NSString stringWithFormat: @"str_%u.png", rand()%3]];
				s.position	= ccp(segmentWidth * i + rand() % (uint)segmentWidth / 2, segmentHeight * j + rand() % (uint)segmentHeight / 2);
				s.scale		= rand()%100 / 100.f + .2f;
				s.rotation	= rand()%360;
				s.opacity	= rand()%100;
				[_stars addChild: s];
			}
		}
	};
}

static CGRect ipadFrame	= (CGRect){{-50, 0}, {IPHONEWIDTH + 100, IPHONEHEIGHT}};

- (void)rainStars:(ccTime)interval{
	const float deltaX			= 20;
	const float deltaRotation	= 20;

	for (CCSprite* children in [_stars children]) {
		CGPoint move = children.position;

		if(CGRectContainsPoint(ipadFrame, children.position))
			move.x = move.x + deltaX * interval;
		else
			move.x = -30;

		children.rotation = children.rotation + deltaRotation * interval;
		children.position = move;
	}	
}

#pragma mark alloc / dealloc
- (id)init{
    if (self = [super init]) {
		[self loadTexture];
		[self setUpNebulary];
		[self setUpStars];
		[self schedule: @selector(rainStars:)];
    }
    
    return self;
}

- (void)dealloc{
	[_stars		release];
	[_galaxies	release];
    [super		dealloc];
}
@end

//*********************************************************************************************//
@interface PCStars()
@property(nonatomic, assign)uint rotationSpeed;
@end

@implementation PCStars
@synthesize rotationSpeed;

- (id) initWithSpriteFrame:(CCSpriteFrame*)spriteFrame{
	NSAssert(spriteFrame!=nil, @"Invalid spriteFrame for sprite");

	if (self = [self initWithTexture:spriteFrame.texture rect:spriteFrame.rect]) {
		[self setDisplayFrame:spriteFrame];
		self.rotationSpeed		= rand() % 30 + 30;
	}
	return self;
}

+ (id)spriteWithSpriteFrameName:(NSString*)spriteFrameName{
	CCSpriteFrame *frame	= [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:spriteFrameName];
	return [self spriteWithSpriteFrame:frame];
}

- (void) update:(ccTime)deltaTime{
	self.rotation = self.rotation + rotationSpeed * deltaTime;
}
@end