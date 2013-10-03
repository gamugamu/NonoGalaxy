//
//  PCLoader.m
//  picrossGame
//
//  Created by loïc Abadie on 22/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PCLoader.h"
@interface PCLoader()
@property(nonatomic, assign)id delegate;
@property(nonatomic, copy)void (^loadingDone)();
@end

@implementation PCLoader
@synthesize delegate,
            loadingDone = _loadingDone;

#pragma mark alloc/dealloc
- (id)scene{
	CCScene *scene = [CCScene node];
	[scene addChild: self];
	[scene setSceneDelegate:self];
	return scene;
}

- (void)onEnterTransitionDidFinish{
    SEL selector = sel_registerName("loadingPageIsSet");
	[(id)delegate performSelector: selector];

    if(_loadingDone)
        _loadingDone();
    
	[super onEnterTransitionDidFinish];
}

- (id)initWithLoaderDelegate:(id)delegate_ callBackWhenLoadingIsDone:(void(^)())loadingDone{
	if(self = [super init]){
		delegate = delegate_;
        self.loadingDone = loadingDone;
	}
	return self;
}

- (void)dealloc{
    [_loadingDone release];
    [super dealloc];
}

@end
