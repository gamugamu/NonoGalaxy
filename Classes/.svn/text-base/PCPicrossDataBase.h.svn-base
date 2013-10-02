//
//  PCPicrossDataBase.h
//  picrossGame
//
//  Created by loïc Abadie on 28/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCLevelInfo.h"
#import "cocos2d.h"
#import "PCConstelationInfo.h"

typedef struct {
	BOOL        isDone;
	NSUInteger	timeElapsed;
	uint        level;
}levelInfoDB;

@interface PCPicrossDataBase : NSObject
+ (PCPicrossDataBase*)sharedPCPicrossDataBase;
// permet de retrouver les stages qui ont été rajouté durant l'animation du puzzle success. Permet de ne pas
// rajouter le même stage rajouté 2 fois.
// @param level: le level qui vient d'être rajouté.
// @param constelationName: le nom de la constelation rajouté.
// @return BOOl: si le stage a déjà été affiché, retourne NO.
- (BOOL)stageElibgibleHasAlreadyBeenDisplayed:(uint)level forConstelationName:(NSString*)constelationName;

// retourne les information sur le stage demandé.
// @params constelationName: le nom de la constelation demandée.
// @params level: le numéro du stage erquis.
// @return PCLevelInfo: les info du stage demandé, ou nil si n'existe pas encore.
- (PCLevelInfo*)levelInfoForConstelationName:(NSString*)constelationName level:(uint)level;
- (void)addNewEntry:(levelInfoDB*)managedObject forName:(NSString*)constelationName;
- (void)removeEntry:(levelInfoDB*)managedObject forName:(NSString*)constelationName;
- (void)addPaidedMap:(NSString*)mapName;
- (void)removePaidedMap:(NSString*)mapName;
- (PCConstelationInfo*)constelationForIdx:(uint)idx;
- (NSDictionary*)entriesForConstelation:(NSString*)constelationName;
- (NSArray*)allConstelationComplete;
- (NSSet*)mapPaid;
- (void)cleanDataBase;
- (void)saveRequirment:(NSString*)requirmentName;
- (NSArray*)requirmentsDone;
@end
