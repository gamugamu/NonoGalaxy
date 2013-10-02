//
//  CCFlash.m
//  picrossGame
//
//  Created by Abadie Loic on 18/06/13.
//
//

#import "CCFlash.h"

@implementation CCFlash

+ (void)makeFlashInView:(CCNode*)node duration:(ccTime)time onCompletion:(void(^)(void))completion{
    CCColorLayer* blank = [CCColorLayer layerWithColor:(ccColor4B){255, 255, 255, 255}
                                                 width: node.contentSize.width
                                                height: node.contentSize.height];
    blank.opacity = 0;
    
    CCSequence* action = [CCSequence actions:
                          [CCFadeIn actionWithDuration: time / 2],
                          [CCFadeOut actionWithDuration: time ],
                          [CCCallBlockN actionWithBlock: BCA(^(CCNode *n){
            [blank removeFromParentAndCleanup: YES];
        
        if(completion)
            completion();
    })], nil];
    
    [blank runAction: action];
    [node addChild: blank];
}
@end
