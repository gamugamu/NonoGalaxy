//
//  PCHomePage.m
//  picrossGame
//
//  Created by Abadie Loic on 12/03/13.
//
//

#import "PCHomePage.h"
#import "cocos2d.h"
#import "GGTracks.h"

@interface PCHomePage ()
@property(nonatomic, copy)void(^callBack)();
@end

@implementation PCHomePage
@synthesize callBack = _callBack;

#pragma mark ============================ public ===============================
#pragma mark ===================================================================

- (void)displayButton:(void(^)(void))blockCallBack{
    self.callBack = blockCallBack;
    CCMenuItemSprite *starMenuItem    = [CCMenuItemSprite
                                         itemFromNormalSprite: [CCSprite spriteWithFile: @"button_start.png"]
                                         selectedSprite: nil
                                         target: self
                                         selector: @selector(done)];
    
    starMenuItem.position   = ccp(480, -200);
    CCMenu *starMenu        = [CCMenu menuWithItems: starMenuItem, nil];
    starMenu.anchorPoint = (CGPoint){.5f, .5f};
    starMenu.position       = CGPointZero;
    [self addChild: starMenu];
    [self animateGlowPop: starMenuItem];
}

- (id)scene{
	CCScene *scene = [CCScene node];
	[scene addChild: self];
	[scene setSceneDelegate:self];
	return scene;
}

- (id)init{
    if(self = [super init]){
        self.position = ccp(IPHONEWIDTHDEMI, IPHONEHEIGHTDEMI);
        CCSprite* sprite = [CCSprite spriteWithFile: @"homePage.jpg"];
        [self addChild: sprite];
        [GGTracks trackCurrent: GAHomeTracks];
    }
    return self;
}

- (void)dealloc{
    [_callBack release];
    [super dealloc];
}

#pragma mark ============================ private ==============================
#pragma mark ===================================================================

- (void)done{
    if(_callBack)
        _callBack();
}

- (void)animateGlowPop:(CCNode*)node{
    CCSequence* glowPop = [CCRepeatForever actionWithAction:[CCSequence actions:
                                                           [CCScaleTo actionWithDuration: .3f scale: 1.05],
                                                           [CCScaleTo actionWithDuration: .3f scale: 1], Nil]];

    [node runAction: glowPop];
}
@end
