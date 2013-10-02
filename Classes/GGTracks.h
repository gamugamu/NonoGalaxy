//
//  GGTracks.h
//  picrossGame
//
//  Created by Abadie Loic on 11/08/13.
//
//

#import <Foundation/Foundation.h>

extern const NSString* GAHomeTracks;
extern const NSString* GAGalaxyTracks;
extern const NSString* GAMapTracks;

@interface GGTracks : NSObject

// pour initialiser google analytics
+ (void)initializeTracks;

// pour traquer une vue (exemple home page, carte).
+ (void)trackCurrent:(const NSString*)current;

// spécifique pour traquer un stage.
+ (void)trackStage:(NSString*)levelName stage:(uint)stage;
@end
