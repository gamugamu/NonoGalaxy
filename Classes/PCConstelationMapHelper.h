//
//  PCConstelationMapHelper.h
//  picrossGame
//
//  Created by loïc Abadie on 08/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCStageData.h"

@interface PCConstelationMapHelper : NSObject
// fais une animation lorsqu'un stage a été réussi et que l'on retourne sur la map. Permet de comprendre
// sa propre progression dans le jeu.
// @param stageData: un pointer sur un tableau de struct stageData.
// @param lenght: la longueur du tableau stageData.
// @param callBack: le callBack lorsque l'animation est terminée.
+ (void)animateStageSucceedIfNeedWithStageSet:(stageData*)stageData_ forConstelationName:(NSString*)constelationName lenght:(uint)lenght onCompletion:(void(^)())callBack;
@end
