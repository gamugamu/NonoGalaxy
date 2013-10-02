//
//  TimeInfo.m
//  picrossGame
//
//  Created by loïc Abadie on 19/06/13.
//
//

#import "TimeInfo.h"
#import "cocos2d.h"

@interface TimeInfo()
@property(nonatomic, retain)CCSprite* clockSprite;
@property(nonatomic, retain)CCLabelBMFont* time;
@end

@implementation TimeInfo
@synthesize clockSprite = _clockSprite;

#pragma mark -------------------------- public ---------------------------------
#pragma mark -------------------------------------------------------------------

- (void)displayTime:(uint)time{
    int hour, min, sec;

    hour        = time / 3600;
    time        = time % 3600;
    min         = time / 60;
    time        = time % 60;
    sec         = time;
    
    self.visible = (BOOL)time;
    
    if(!hour)
        [_time setString: [NSString stringWithFormat: @"%.2u:%.2us", min, sec]];
    else
        [_time setString: [NSString stringWithFormat: @"%.2u:%.2u:%.2us", hour, min, sec]];
}

- (void)undisplay{
    self.visible = NO;
}

#pragma mark - alloc / dealloc

- (id)init{
    if(self = [super init]){
        [self setUpTime];
        [self setUpClock];
        [self undisplay];
    }
    return self;
}

- (void)dealloc{
    [_time release];
    [super dealloc];
}

#pragma mark -------------------------- private --------------------------------
#pragma mark -------------------------------------------------------------------

#pragma mark - display

- (void)setUpTime{    
	self.time = [CCLabelBMFont labelWithString: @"" fntFile: @"FntFutura_35.fnt"];
    _time.anchorPoint   = CGPointMake(0.0f, 0.5f);
    _time.position      = ccp(-100, 0);
    [self addChild: _time];
}

- (void)setUpClock{
    self.clockSprite        = [CCSprite spriteWithFile: @"clock.png"];
    _clockSprite.position   = ccp(-122, 0);
    [self addChild: _clockSprite];
}

- (void)setVisible:(BOOL)visible{
    _clockSprite.visible = visible;
    [super setVisible: visible];
}

@end
