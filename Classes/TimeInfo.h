//
//  TimeInfo.h
//  picrossGame
//
//  Created by loïc Abadie on 19/06/13.
//
//

#import "CCNode.h"

@interface TimeInfo : CCNode

// à 0 le temps ne s'affiche pas.
- (void)displayTime:(uint)time;

- (void)undisplay;
@end
