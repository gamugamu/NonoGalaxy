//
//  PCConstelationMapHelper.m
//  picrossGame
//
//  Created by loïc Abadie on 08/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PCConstelationMapHelper.h"
#import "PCStageJustAchieved.h"
#import "PCConstelar.h"
#import "PCPicrossDataBase.h"

@implementation PCConstelationMapHelper

+ (void)animateStageSucceedIfNeedWithStageSet:(stageData*)stageData_ forConstelationName:(NSString*)constelationName lenght:(uint)lenght onCompletion:(void(^)())callBack{
	uint				stageJustAchieved		= [PCStageJustAchieved lastLevelCompletedInMap: nil];	
	PCConstelar*		constelarSucceed		= nil;
	PCPicrossDataBase*	dataBase				= [PCPicrossDataBase sharedPCPicrossDataBase];

	// si jamais le stage n'est pas identifié, ou bien qu'il a déjà été animé parce qu'accompli, 
	// on retourne de cette fonction
	if(stageJustAchieved != PCStageJustAchieved_notAchieved){
		PCLevelInfo* levelInfo = [dataBase levelInfoForConstelationName: constelationName level: stageJustAchieved];
		
		// si le stage a été accomplie plus d'une fois, on n'affiche pas l'animation de débloquage du niveau.
		if([levelInfo.totalDone unsignedIntValue] >= 1){
			[self callBackAndUnset: callBack];
			return;
		}
	}
	
	// ça peut paraître étrange mais c'est le seul hack pour que le compilateur me laisse accéder à mon tableau dans un block
	// sinon ne compile pas.
	__block struct {
		uint constelationList[4];
	} ct;
	
	uint constelationListLenght	= 0;
	
	// d'abord on retrouve la référence du stage qui vient d'être terminé, ainsi que les stages qui
	// sont maintenant jouable (accessible).
	for (int i = 0; i <= lenght; i++) {
		if(stageData_[i].isEligible){
			// si on a jamais affiché le stage, on le garde en référence. Normalement dataBase retourne NO la première fois
			// pas la deuxième.
			if(![dataBase stageElibgibleHasAlreadyBeenDisplayed: stageData_[i].level forConstelationName: constelationName]){
				PCConstelar* constelar = stageData_[i].pointer;
				[constelar undoEligible: &stageData_[i]];
				[constelar setHilighted: NO];
			
				ct.constelationList[constelationListLenght++] = i;
			}
		}
		else if (stageJustAchieved ==  stageData_[i].level){
			constelarSucceed = stageData_[i].pointer;
		}
	}
	
	// anime la constellation, la fait apparaître puis affiche l'image du puzzle résolu.
	//[constelarSucceed undisplayAgregate];
   // CCSprite* agregate = constelarSucceed.aggregate;
    
	//constelarSucceed._screenDisplay.scale = .2f;
   // agregate.scale = .2f;
   // constelarSucceed._screenDisplay.opacity = 0;
    
	/*[constelarSucceed._screenDisplay runAction:
     [CCSequence actions:
      [CCDelayTime actionWithDuration: .3f],
      [CCSpawn actionOne: [CCFadeTo actionWithDuration: .5f opacity: 255]
                     two:[CCEaseBackOut actionWithAction: [CCScaleTo actionWithDuration: 1 scale: 1]]],
      [CCCallBlockN actionWithBlock: BCA(^(CCNode *n){
         agregate.opacity = 100;
*/
         for (int i = 0; i < constelationListLenght; i++) {
             uint idx = ct.constelationList[i];
             PCConstelar* constelar =  stageData_[idx].pointer;
             [constelar makeEligible: &stageData_[idx]];
         }
         
         [self callBackAndUnset: callBack];
    /* })], nil]];*/
}

+(void)callBackAndUnset:(void(^)())callBack{
	if(callBack){
		[PCStageJustAchieved setStageAccomplished: PCStageJustAchieved_notAchieved];
		callBack();
	}
}

@end
