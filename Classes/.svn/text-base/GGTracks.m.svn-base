//
//  GGTracks.m
//  picrossGame
//
//  Created by Abadie Loic on 11/08/13.
//
//

#import "GGTracks.h"
#import "GAI.h"

const NSString* GAHomeTracks = @"HOME";
const NSString* GAGalaxyTracks = @"GALAXYSELECTION";
const NSString* GAMapTracks = @"MAP";

@implementation GGTracks

id<GAITracker> tracker = nil;
+ (void)initializeTracks{
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;

    // Create tracker instance.
    tracker = [[GAI sharedInstance] trackerWithTrackingId: @"UA-43107551-1"];
}

+ (void)trackCurrent:(const NSString*)current{
    [tracker sendView: (NSString*)current];
    NSLog(@"tracks sended %@", current);
}

+ (void)trackStage:(NSString*)levelName stage:(uint)stage{
    [tracker sendView: [NSString stringWithFormat:@"STAGE_%@_%u", levelName, stage]];
    NSLog(@"tracks levelName %@", levelName);
}
@end
