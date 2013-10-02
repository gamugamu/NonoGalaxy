//
//  PCPicrossRequestInApp.m
//  picrossGame
//
//  Created by loïc Abadie on 08/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PCRequestInApp.h"
#import "PCBagroundAntiTouch.h"
#import "PCPicrossDataBase.h"
#import "PCMapStore.h"
#import "PCRequestedMap.h"

@interface PCRequestInApp() <PCMapStoreDelegate>
@property(nonatomic, retain)PCMapStore*	_mapStore;
@property(nonatomic, retain)PCMrNono*	_mrNono;
@property(nonatomic, retain)NSString*	_currentBuyableMapName;
@property(nonatomic, assign)BOOL		hasPaidMap;
@property(nonatomic, assign)BOOL		hasCanceled;
- (void)displayBagroundAntiTouch;
- (void)makeAppStoreRequest;
- (void)displayRequestedMap:(NSUInteger)mapIdx;
- (void)undisplayRequestedMap;
@end

@implementation PCRequestInApp 
@synthesize delegate,
			hasPaidMap,
			hasCanceled,
			_currentBuyableMapName,
			_mapStore,
			_mrNono;

typedef enum{
	kInAppCancel_tag = 10,
	kInAppWaitBackground,
	kInAppRequestedMap_tag,
}InAppLayers_tag;

#define messageDuration 2
#pragma mark public
- (void) requestInAppMap:(NSString*)mapName currentMapIdx:(NSUInteger)mapIdx{	
	[[PCPicrossDataBase sharedPCPicrossDataBase] removePaidedMap: @"com.gamugamu.nonoGalaxy.map_Sand"];
	//[_mapStore userBoughtItems]; // pour tester ce que l'utilisateur à déjà acheter
	//[_mapStore productPrice: nil];//pour connaître le prix d'un produit
	hasPaidMap					= NO;
	hasCanceled					= NO;
	self._currentBuyableMapName = mapName;

	[self displayBagroundAntiTouch];
	[self displayRequestedMap: mapIdx];
	
	[_mapStore productPrice: mapName];
	
	_mrNono.position	= ccp(230, 270);
	[_mrNono changeAppearance: nonoRequestingInApp bubbleStyle: messageWithCancelButton];
	[_mrNono talk: [NSArray arrayWithObjects: NSLocalizedString(@"Nono_asktToConnectToAppStore", nil), nil]];
}

#pragma mark PCMrNonoDelegate
- (void)buttonSelected:(buttonStyle)buttonIdx forBubleStyle:(bubbleStyle)bubbleStyle{
	switch (buttonIdx) {
		case buttonCancelPressed:
			[self cancelInAppRequest];
			break;
			
		case buttonBuyItPressed:
			[self makeAppStoreRequest];
			break;
	}
}

#pragma mark PCMapStoreDelegate

- (void)productInfoFound:(SKProduct*)product{
	NSString* devise		= [product.priceLocale objectForKey: NSLocaleCurrencySymbol];
	NSString* messagePrice	= [NSString stringWithFormat:@"%.2f%@", [product.price doubleValue], devise];
	[_mrNono talk: [NSArray arrayWithObjects: NSLocalizedString(@"Nono_displayPrice", nil), messagePrice, nil]];
}

- (void)requestFinishDidPaid:(BOOL)hasPaid{
	hasPaidMap = hasPaid;
	[self unDisplayAppStoreBackground];

	if(hasPaidMap){
		[[PCPicrossDataBase sharedPCPicrossDataBase] addPaidedMap: _currentBuyableMapName];
		[_mrNono talk: [NSArray arrayWithObject: NSLocalizedString(@"Nono_mapHasBeenPaid", nil)]];
		[self performSelector:@selector(cancelInAppRequest) withObject: self afterDelay: messageDuration];
	}
	else
		[self cancelInAppRequest];
}

- (void)requestFailedWithError:(NSError *)error{
	[_mrNono changeAppearance: nonoRequestingInApp bubbleStyle: messageWithCancelButton];

	switch (error.code) {
            
		case -10:
            [_mrNono talk: [NSArray arrayWithObject: NSLocalizedString(@"Nono_errorMapPaid", nil)]];
            break;
		case -11:
            [_mrNono talk: [NSArray arrayWithObject: NSLocalizedString(@"Nono_errorTimeOut", nil)]];
            break;
		default:
            [_mrNono talk: [NSArray arrayWithObject: NSLocalizedString(@"Nono_errorOccured", nil)]];
	}
	[self performSelector:@selector(cancelInAppRequest) withObject: self afterDelay: messageDuration];
}

- (void)transactionsDone:(PCMapStore*)mapStore{
	[self performSelector:@selector(cancelInAppRequest) withObject: self afterDelay: messageDuration];
}

- (void)requestReceivedResponse{
	// comme c'est asynchrone, il est possible que la requête soit annulé mais que cette méthode soit appelé
	if(!hasCanceled){
		[_mrNono changeAppearance: nonoRequestingInApp bubbleStyle: messageWithInApp];
		[_mrNono talk: [NSArray arrayWithObjects:
                        NSLocalizedString(@"Nono_ReceiveResponse", nil),
                        NSLocalizedString(@"Nono_letsCheck", nil), nil]];
	}else
		[_mapStore cancelRequest];
}


#pragma mark private

- (void)displayBagroundAntiTouch{
	PCBagroundAntiTouch* layer	= [PCBagroundAntiTouch layerWithColor: ccc4(0, 0, 0, 170) width: 1024 height: 768];
	layer.position				= ccp(0, 0);
	[self.parent addChild: layer z: 1 tag: kInAppCancel_tag];
}

- (void)cancelInAppRequest{
	if(!hasCanceled){
		[self undisplay];
		[self undisplayRequestedMap];
		[_mapStore cancelRequest];
		// on remet l'apparence tel que c'était
		[_mrNono changeAppearance: nonoStanding bubbleStyle: messageWithConstelation];
		[delegate requestDone: hasPaidMap];
		hasCanceled = YES;
	}
}

- (void)undisplay{
	PCBagroundAntiTouch* layer = (PCBagroundAntiTouch*)[self.parent getChildByTag: kInAppCancel_tag];
	// si il n'y a plus de PCBagroundAntiTouch, c'est que l'action a déj été faite.
	if (layer){
		[layer cancelDSwallow];
		[self.parent removeChild: layer cleanup: YES];
	}
}

- (void)displayAppStoreBackground:(void(^)())request{
	CCSprite* appStoreBackground	= [CCSprite spriteWithFile: @"requestBkg.png"];
	appStoreBackground.anchorPoint	= CGPointZero;
	appStoreBackground.position		= CGPointZero;
	appStoreBackground.tag			= kInAppWaitBackground;
	appStoreBackground.opacity		= 0;
	
	[self.parent addChild: appStoreBackground z: kInAppWaitBackground];//<--
	
	[appStoreBackground runAction: [CCSequence actions: [CCFadeIn actionWithDuration: 0.2f], 
									[CCCallBlockN actionWithBlock: BCA(^(CCNode *n){request(); })], nil]];	 
}

- (void)unDisplayAppStoreBackground{
	CCSprite* appStoreBackground = (CCSprite*)[self.parent getChildByTag: kInAppWaitBackground];
	[appStoreBackground removeFromParentAndCleanup: NO];//<--
}

- (void)displayRequestedMap:(NSUInteger)mapIdx{
	PCRequestedMap* requestedMap	= [[PCRequestedMap alloc] initWithMapRequested: mapIdx];
	requestedMap.position			= ccp(650, 220);
	requestedMap.tag				= kInAppRequestedMap_tag;
	[self.parent addChild: requestedMap z: kInAppRequestedMap_tag];
	[requestedMap release];
}

- (void)undisplayRequestedMap{
	PCRequestedMap* requestedMAp = (PCRequestedMap*)[self.parent getChildByTag: kInAppRequestedMap_tag];
	// si il n'y a plus de PCBagroundAntiTouch, c'est que l'action a déj été faite.
	if (requestedMAp){
		[requestedMAp undisplayMapWithAnimation];
		[self.parent removeChild: requestedMAp cleanup: YES];
	}
}
/*-----------*/
// le client à confirmé son intention d'acheter. On affiche une image spécifique et on fait 
// une requête à l'app store de la map concernée. Comme l'info bulle gèle l'écran, on doit s'assurer
// que l'image s'est affichée avant l'appel.
/*-----------*/
- (void)makeAppStoreRequest{
	void (^storeRequest)() = ^{
		[_mapStore requestProductData: [NSSet setWithObjects: _currentBuyableMapName, nil]];
	};
	
	[self displayAppStoreBackground: storeRequest];
}

#undef cancel_Tag
#undef messageDuration

#pragma mark alloc / dealloc
- (id)initWithMrNono:(PCMrNono*)mrNono{
	if(self = [super init]){
		_mapStore			= [[PCMapStore alloc] initWithDelegate: self];
		self._mrNono		= mrNono;
		_mrNono.delegate	= self;
	}
	return self;
}

- (void)dealloc{
	[_currentBuyableMapName release];
	[_mapStore				release];
	[_mrNono				release];
	[super dealloc];
}
@end
