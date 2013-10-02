//
//  CCFlash.h
//  picrossGame
//
//  Created by Abadie Loic on 18/06/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCFlash : NSObject

+ (void)makeFlashInView:(CCNode*)node duration:(ccTime)time onCompletion:(void(^)(void))completion;
@end
