//
//  PCPicrossGalaxyMenu.m
//  picrossGame
//
//  Created by loïc Abadie on 01/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PCPicrossGalaxyMenu.h"
#import "PCPicrossGalaxyMenuHelper.h"
#import "PCConstelationMap.h"
#import "PCFilesManager.h"
#import "PCPicrossTableView.h"
#import "PCMrNono.h"
#import "PCConnectToDatabase.h"
#import "PCRequestInApp.h"
#import "PCBagroundAntiTouch.h"
#import "GCInfiniteScroller.h"
#import "GCAlertBox.h"
#import "GGTracks.h"

@interface PCPicrossGalaxyMenu()<PCPicrossesDBGalaxyHelperDelegate, PCRequestInAppDelegate, PCMrNonoDelegate, GGButonPressedDelegate>
- (void)setUpConstelationsList;
- (void)setUpConstelationMap;
- (void)saveTimeIfSuccess;
@property(nonatomic, assign)id<PCPicrossGalaxyMenuDelegate> delegate;
@property(nonatomic, assign)BOOL						isAlreadyRowing;
@property(nonatomic, assign)NSUInteger					currentIdx;
@property(nonatomic, assign)uint						currentConstelationIdx;
@property(nonatomic, retain)PCMicroConstelationMap*		_microConstelationsMap;
@property(nonatomic, retain)NSArray*					_constelationNameList;
@property(nonatomic, retain)PCPicrossGalaxyMenuHelper*	animationGalaxyHelper;
@property(nonatomic, retain)PCMrNono*					_MrNono;
@property(nonatomic, retain)PCPicrossTableView*			_mapsTable;
@property(nonatomic, retain)PCConnectToDatabase*		_connectToGamuGamu;
@property(nonatomic, retain)PCRequestInApp*				_requestInApp;
@property(nonatomic, assign)BOOL						isAnimating;
@end

@implementation PCPicrossGalaxyMenu
@synthesize delegate,
			currentConstelationIdx,
			isAlreadyRowing,
			currentIdx,
			isAnimating,
			animationGalaxyHelper = _animationGalaxyHelper,
			_microConstelationsMap,
			_constelationNameList,
			_MrNono,
			_mapsTable,
			_connectToGamuGamu,
            _requestInApp;

#define PCGXBTNTAG 15

- (void)blockInput{
	isAnimating = YES;
	[_mapsTable setIsAllowingToRow: NO];
}

- (void)unblockInput{
	isAnimating = NO;
	[_mapsTable setIsAllowingToRow: YES];
}

- (void)startInput{
	isAnimating = NO;
	[_mapsTable setIsAllowingToRow: YES];
	[_mapsTable askCurrentGalaxyOnList];
}

- (void)stopInput{
	isAnimating = YES;
	[_mapsTable setIsAllowingToRow: NO];
}

#pragma mark animationTransition
- (void)startAnimating{
	[_mapsTable runAction: [CCSpawn actions:	[CCFadeIn actionWithDuration: 1],
												[CCEaseBackInOut actionWithAction:  [CCMoveTo actionWithDuration: 1 position:ccp(0, 0)]], nil]];
	[_MrNono	runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1], 
												[CCSpawn actions: [CCFadeIn actionWithDuration: .9f], [CCEaseBackInOut actionWithAction: [CCScaleTo actionWithDuration: .5f scale: 1] ], nil],
												[CCCallBlockN actionWithBlock: BCA(^(CCNode *n){

        if(shouldAnimateConstelationCompleted)
            [self animateConstellationComplete];
        else
            [self startInput];})],
                            nil]];
}


- (void)animateNewMapAdded:(NSArray*)newMaps{
    [self setUpAnimation];
	[self animateHideMapsTable];

	[_animationGalaxyHelper animateNewMapAdded: newMaps intoNode: self nodeSelectorWhenDone: @selector(displayNewMapsDidFinish)];
}

- (void)animateHideMapsTable{
	[_mapsTable runAction: [CCSpawn actions:	[CCFadeOut actionWithDuration: .5f], 
							[CCEaseBackInOut actionWithAction:  [CCMoveTo actionWithDuration: 1.2f position:ccp(0, -200)]], nil]];
}

static bool shouldAnimateConstelationCompleted = NO;

- (void)animateShowMapsTable{
	_mapsTable.position = ccp(0, -100);
	[_mapsTable runAction: [CCSpawn actions:	[CCFadeIn actionWithDuration: .5f],
							[CCEaseBackOut actionWithAction:  [CCMoveTo actionWithDuration: 1.2f position:ccp(0, 0)]], nil]];
}

+ (void)shoulAnimateContelationCompleted{
    shouldAnimateConstelationCompleted = YES;
}

+ (BOOL)needToShowConstelationCompletion{
    return shouldAnimateConstelationCompleted;
}

- (void)animateConstellationComplete{
    [self startInput];
    [_MrNono stopTalkin];
    [self stopInput];

    [_microConstelationsMap animateCompletionConstellation:^{
        [_MrNono talk: @[ NSLocalizedString(@"Nono_Message_ConstelationComplete", nil)]];
        [self startInput];
        shouldAnimateConstelationCompleted = NO;
    }];
}

- (void)beforeStartAnimating{
	isAnimating			= YES;
	_MrNono.opacity		= 0;
	_MrNono.scale		= .4;
	_mapsTable.opacity	= 0;
	_mapsTable.position = ccp(0, -50);
	_MrNono.position	= ccp(130, 340);

	[self startAnimating];
}

- (void)beforeEndAnimating:(NSString*)constelationMap{
	CCLayerGradient* supGradient	= [[CCLayerGradient alloc] initWithColor: ccc4(0, 186, 255, 255) fadingTo:ccc4(0, 70, 70, 155) alongVector:ccp(0,1)];
	supGradient.position			= ccp(0, IPHONEHEIGHT);
	[self addChild: supGradient];
	[self getChildByTag: PCGXBTNTAG].visible = NO;
	
    [[NSNotificationCenter defaultCenter] postNotificationName: KSOUNDNOTIF object: SOUNDUPRISE];    
    
	[_MrNono stopTalkin];
	[_MrNono runAction: [CCSpawn actions: [CCFadeOut actionWithDuration: .5f], [CCEaseBackInOut actionWithAction: [CCScaleTo actionWithDuration: .5f scale: .3]], nil]];															   
	[_mapsTable runAction: [CCSpawn actions: [CCFadeOut actionWithDuration: .5f], [CCEaseBackInOut actionWithAction: [CCMoveTo actionWithDuration: 1 position:ccp(0, -150)]], nil]];
	
	[_microConstelationsMap undisplayBoard];
	[self runAction:	 [CCSequence actions: [CCDelayTime actionWithDuration: .5f], 
						 [CCEaseSineInOut actionWithAction: [CCMoveTo actionWithDuration:1.5	position: ccp(0, -IPHONEHEIGHT)]], 
						  [CCCallBlockN actionWithBlock: BCA(^(CCNode *n){[delegate constelationHasBeenSelected: constelationMap]; })],nil]];
	
	[supGradient release];
}

#pragma mark PCPicrossesDBGalaxyHelperDelegate

- (void)galaxyOnList:(NSUInteger)idx{
	if(isAnimating) 
		return;
	
	if(idx && (currentConstelationIdx != idx || isAlreadyRowing)){
        
		currentConstelationIdx	= idx;
		isAlreadyRowing			= NO;
		currentIdx				= idx;
		[_microConstelationsMap displayBoard: idx];

		if(_microConstelationsMap._mapMessage){
			_MrNono.delegate	= _requestInApp;
			[_MrNono changeAppearance: nonoStanding bubbleStyle: messageWithConstelation];
            [self makeNonoTalk: [NSArray arrayWithObject: _microConstelationsMap._mapMessage]];
		}
		
	}else if(!idx){
		isAlreadyRowing			= NO;
		currentIdx				= idx;
		[self displayCheckNewMapDialog];
	}
}


- (void)galaxiesRowing{
	if(isAnimating) 
		return;

	if(!isAlreadyRowing){
		isAlreadyRowing = YES;
		[_microConstelationsMap undisplayBoard];
		[_MrNono				stopTalkin];
	}
}

#pragma mark - PCMapStoreDelegate

/*transaction done*/
- (void)requestDone:(BOOL)didBought{
	if(didBought)
		[_microConstelationsMap reloadData];

	// on réaffiche Nono à sa position initial
	_MrNono.position	= ccp(130, 340);

	NSUInteger redirectToConstelation	= currentConstelationIdx;
	currentConstelationIdx				= -1;	// un petit hack pour forcer le rafraichissement de la constellation.
	[self galaxyOnList: redirectToConstelation];
}

#pragma mark - PCMicroConstelationMapDelegate

- (BOOL)didMapShouldStay{
    return [_microConstelationsMap didNeedRequirement];
}

// on detecte si la carte est payante ou non
- (void)buttonHasBeenPressed:(id)sender{
    
#if MAP_NO_LOCKED == 0
    if([_microConstelationsMap didNeedRequirement])
        return;
    
	if(_microConstelationsMap.hasUnlockedMap)
#endif
		[self beforeEndAnimating: _microConstelationsMap._currentConstelationName];
#if MAP_NO_LOCKED == 0
	else
		[_requestInApp requestInAppMap: _microConstelationsMap._inAppid currentMapIdx: currentConstelationIdx];
#endif
}

- (void)backPressed{
    [delegate backPressed];
}

#pragma mark PCConnectToDatabaseDelegate

- (void)dispayCantConnect{
	[_MrNono changeAppearance: nonoStanding bubbleStyle: messageWithOkButton];
    [self makeNonoTalk: [NSArray arrayWithObject: NSLocalizedString(@"Nono_CantConnect", nil)]];
}

- (void)dispayNothingNew{
	[_MrNono changeAppearance: nonoStanding bubbleStyle: messageWithConstelation];
    [self makeNonoTalk: [NSArray arrayWithObject: NSLocalizedString(@"Nono_NothingNewToday", nil)]];
	[self saveTimeIfSuccess];
}

- (void)dispayDownloadSuccessfully:(NSArray*)newMaps{
	// on demande à pcFileManager de r&actualiser son contenu, et ensuite à _mapTable.
	[[PCFilesManager sharedPCFileManager] reUpdateFolder];
	[self saveTimeIfSuccess];
	[self animateNewMapAdded: newMaps];
    [self unblockInput];
}

- (void)displayLoadingData{
}

- (void)stopDisplayLoadingData{
}

- (void)saveTimeIfSuccess{
    return;
	[[NSUserDefaults standardUserDefaults] setObject: [NSDate date] forKey: @"lastTimeMapUpdated"];
}

#pragma mark PCMrNonoDelegate

- (void)buttonSelected:(buttonStyle)buttonIdx forBubleStyle:(bubbleStyle)bubbleStyle{
	if(bubbleStyle == messageWithCheckNewMap){
        [self blockInput];
        
        if(_connectToGamuGamu.isReadyToDownload){
            [_MrNono changeAppearance: nonoStanding bubbleStyle: messageWithConstelation];
            [_MrNono talk: @[NSLocalizedString(@"Nono_isCheking", nil)]];
            
            [self performSelector: @selector(checkUpstreamConstelationList)
                       withObject: nil
                       afterDelay: 1];
        }
    }else if(bubbleStyle == messageWithOkButton){ // probleme de connection
        _MrNono.delegate = self;
		[_MrNono changeAppearance: nonoStanding bubbleStyle: messageWithCheckNewMap];
        [self makeNonoTalk: [NSArray arrayWithObject: NSLocalizedString(@"Nono_FirstTime", nil)]];
    }
}

- (void)checkUpstreamConstelationList{
    __block PCPicrossGalaxyMenu* this = self;

    [_connectToGamuGamu downloadConstelationslist:^(CDBDownloadError error, NSArray *newMap) {
        switch (error) {
            case CDBDownloadError_none:
                if(newMap)
                    [this dispayDownloadSuccessfully: newMap];
                else{
                    [this dispayNothingNew];
                    [this unblockInput];
                }
                break;
            case CDBDownloadError_RequestFailed:
                [this dispayCantConnect];
                [this unblockInput];
                break;
            case CDBDownloadError_cantConnectToServer:
                [this dispayCantConnect];
                [this unblockInput];
                break;
            case CDBDownloadError_DataWrong:
                [this dispayCantConnect];
                [this unblockInput];
                break;
            case CDBDownloadError_NotingNew:
                [this dispayNothingNew];
                [this unblockInput];
                break;
        }
    }];

}

#pragma mark - animationGalaxy callBack

- (void)displayNewMapsDidFinish{
    [_mapsTable updateTable];
	self.animationGalaxyHelper = nil;
	[self animateShowMapsTable];
}


#pragma mark display
// if no update has been made in the day, it's ok. Overwelse, try another day
- (void)displayCheckNewMapDialog{
	NSDate* lastTimeChecked			= [[NSUserDefaults standardUserDefaults] objectForKey: @"lastTimeMapUpdated"];
	uint differenceInDays			= ([[NSDate date] timeIntervalSince1970] - [lastTimeChecked timeIntervalSince1970]) / 60 / 60 / 24;
	
	// si il n'y a qu'une cellule, alors s'est un début de partie
	if(_mapsTable.numberOfCells == 1){
		_MrNono.delegate = self;
		[_MrNono changeAppearance: nonoStanding bubbleStyle: messageWithCheckNewMap];
        [self makeNonoTalk: [NSArray arrayWithObject: NSLocalizedString(@"Nono_FirstTime", nil)]];
	}
	else if(differenceInDays){
		_MrNono.delegate = self;
		[_MrNono changeAppearance: nonoStanding bubbleStyle: messageWithCheckNewMap];
        [self makeNonoTalk: [NSArray arrayWithObject: NSLocalizedString(@"Nono_askToFindNewMap", nil)]];
        NSLog(@"---> %@", NSLocalizedString(@"Nono_askToFindNewMap", nil));
        NSLog(@"localeIdentifier: %@", [[NSLocale currentLocale] localeIdentifier]);

	}
	else{
		[_MrNono changeAppearance: nonoStanding bubbleStyle: messageWithConstelation];
        [self makeNonoTalk: [NSArray arrayWithObject: NSLocalizedString(@"Nono_alreadyChecked", nil)]];
	}
}

- (void)makeNonoTalk:(NSArray*)message{
    [_MrNono talk: message];
    [[NSNotificationCenter defaultCenter] postNotificationName: KSOUNDNOTIF object: SOUNDNONOMOVE];
}

#pragma mark setUp
#define menu_Tag 1
- (void)setUpConstelationsList{	
	PCPicrossTableView* galaxyHelper = [[PCPicrossTableView alloc] initWithDelegate: self];
	[self set_mapsTable: galaxyHelper];
	[self addChild: _mapsTable];
	[galaxyHelper release];
}

- (void)setUpConstelationMap{
	PCMicroConstelationMap* microMap = [[PCMicroConstelationMap alloc] initWithButtonDelegate: self];
	[self set_microConstelationsMap: microMap];
	[microMap release];
	[self addChild: _microConstelationsMap];
}

- (void)setUpBackground{
	GCInfiniteScroller* bgk		= [GCInfiniteScroller batchNodeWithFile: @"bkg.png"];
    
    [self background: bgk addChild:ccp(100, 500) name:@"bkg_03.png" scale: 1];
    [self background: bgk addChild:ccp(-300, 400) name:@"bkg_06.png" scale: .3f];
    [self background: bgk addChild:ccp(-100, 700) name:@"bkg_07.png" scale: 1];
    [self background: bgk addChild:ccp(400, 700) name:@"bkg_08.png" scale: .5f];

   // [self background: bgk addChild:ccp(800, 400) name:@"bkg_10.png" scale: 1];
    [self background: bgk addChild:ccp(1900, 600) name:@"bkg_11.png" scale: .5f];
  //  [self background: bgk addChild:ccp(200, 250) name:@"bkg_12.png" scale: 1];


	[self	addChild: bgk];
    
	//animation
	bgk.opacity	= 0;
	[bgk runAction: [CCFadeIn actionWithDuration: 3]];
}

- (void)background:(CCNode*)node addChild:(CGPoint)pnt name:(NSString*)name scale:(float)scale{
    CCSprite* sprite    = [CCSprite spriteWithSpriteFrameName: name];
	sprite.position     = pnt;
    sprite.scale        = scale;
	[node	addChild: sprite];
}

- (void)setUpMrNono{
	PCMrNono* nono = [[PCMrNono alloc] initWithDelegate: nil appearance: nonoStanding bubbleAppearance: messageWithConstelation];
	[self set_MrNono: nono];
	[self addChild: _MrNono z: 2]; // super, CCNode n'incrémente pas les zOrder!
	[nono release];
}

- (void)setUpBackButton{
	CCSprite* hilighted		= [CCSprite spriteWithFile: @"bckBtn.png"];
	hilighted.opacity		= 100;
	CCMenuItemSprite* btnS	= [CCMenuItemSprite itemFromNormalSprite: [CCSprite spriteWithFile: @"bckBtn.png"]
													 selectedSprite: hilighted
															 target: self
														   selector: @selector(backPressed)];
	CCMenu* btn		= [CCMenu menuWithItems: btnS, nil];
	btn.position	= ccp(185, 720);
	[self addChild: btn z:0 tag: PCGXBTNTAG];
}

- (void)setUpRequestInApp{
	_requestInApp			= [[PCRequestInApp alloc] initWithMrNono: _MrNono];
	_requestInApp.delegate	= self;
	[self addChild: _requestInApp z: 0];
}

- (void)setUpAnimation{
    self.animationGalaxyHelper      = [[PCPicrossGalaxyMenuHelper new] autorelease];
    _animationGalaxyHelper.MrNono	= _MrNono;
}

#pragma mark setting
- (void)saveSetting{
	[[NSUserDefaults standardUserDefaults] setInteger: currentIdx forKey:@"lastMapSelected"];
}

#pragma mark override
- (void)loadTexture{
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"bkg.plist"];//<---
}

-(void)unloadTexture{
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile: @"bkg.plist"];
}

- (void)onEnter{
	currentIdx = [[NSUserDefaults standardUserDefaults] integerForKey:@"lastMapSelected"];

#ifdef INITIALSETUP
	currentIdx = 0;
#endif
	[_mapsTable selectCell: currentIdx needAnimate: NO];
	[super onEnter];
}

- (void)onExit{
	[self saveSetting];
	[self unloadTexture];
	[super onExit];
}

#pragma mark alloc/dealloc
- (id)scene{
	CCScene *scene = [CCScene node];
	[scene addChild: self];
	[scene setSceneDelegate:self];
    [GGTracks trackCurrent: GAGalaxyTracks];
	return scene;
}

- (id)initWithGalaxyDelegate:(id <PCPicrossGalaxyMenuDelegate>)delegate_{
	if(self =[super initWithColor: ccc4(245, 222, 133, 255) fadingTo:ccc4(0, 186, 255, 255) alongVector:ccp(0,1)]) {
		delegate			= delegate_;
		_connectToGamuGamu	= [PCConnectToDatabase new];
		[self loadTexture];
		[self setUpBackground];
		[self setUpConstelationsList];
		[self setUpConstelationMap];
		[self setUpMrNono];
		[self setUpBackButton];
		[self setUpRequestInApp];
		[self beforeStartAnimating];
	}
	return self;
}


- (void)dealloc{
	[_animationGalaxyHelper release];
	[_MrNono				release];
	[_microConstelationsMap	release];
	[_constelationNameList	release];
	[_connectToGamuGamu		release];
	[_requestInApp			release];
	[super					dealloc];
}
@end