//
//  PCFilesManager.h
//  picrossGame
//
//  Created by loïc Abadie on 03/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "PCStageData.h"
#import "GameConfig.h"

//<-- check for unused function
@interface PCFilesManager : NSObject
+ (PCFilesManager*)sharedPCFileManager;
// map
- (void)getMap:(NSString*)constelationName returnedMap:(CCTMXLayer**)rconstelation  returnedLeveLLinker:(CCTMXLayer**)rlinker returnedSize:(CGSize*)rsize returnedProperies:(NSMutableDictionary**)rinfo;
- (void)getMapFromIdx:(NSUInteger)idx returnedName:(NSString**)constelationName returnedConstelation:(CCTMXLayer**)rconstelation  returnedLeveLLinker:(CCTMXLayer**)rlinker returnedSize:(CGSize*)rsize returnedProperies:(NSMutableDictionary**)rinfo;
- (NSDictionary*)infoFromIndexedMap:(uint)idx;
- (CCTMXTiledMap*)getMap:(NSString*)constelationName;
- (NSString*)getMapPNGNameFromIdx:(NSUInteger)idx;
- (NSArray*)zipMapsList;
- (NSUInteger)countOfMaps;
- (NSUInteger)idxOfMapTmxName:(NSString*)mapTmxName;
// stage
- (CCTMXTiledMap*)stagesSetforMapName:(NSString*)constelationName;
- (CCTMXLayer*)getSelectedStage:(uint)stage forConstelation:(NSString*)constelationName;
- (CCTMXLayer*)getSelectedStage:(uint)stage forConstelationMap:(CCTMXTiledMap*)map;
- (void)getStageDataForMap:(NSString*)stageSetsName retainedData:(stageData**)data lenght:(uint*)lenght;
- (uint)getTotalStageForMap:(NSString*)stageSetsName;

//info
- (NSDictionary*)getInfoForMapName:(NSString*)mapName;
// image
- (NSString*)getDisplayImageforMapName:(NSString*)mapName;
- (NSString*)getSkinForMapName:(NSString*)constelationName;
- (NSString*)getDisplayStageForIdx:(NSUInteger)idx;
- (NSString*)indicePathName:(NSString*)mapName;
- (NSString*)getIndiceForMapName:(NSString*)mapName;

// affiche l'image du level sur la map lorsqu'il a été accompli.
- (NSString*)getResolvedStageInMap:(NSUInteger)stageIdx forCurrentLevel:(NSUInteger)levelIdx;
// logic
- (void)reUpdateFolder;
// uncompresseData
- (NSString*)downloadedFiles:(NSString*)nonoSetName;
- (BOOL)unzipDownloadedData:(NSError**)error;
@end
