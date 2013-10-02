//
//  PCImpact.h
//  picrossGame
//
//  Created by loïc Abadie on 15/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCNode.h"
#import "cocos2d.h"
#import "PCStageBoard.h"

// l'impact lorsque la selection dans le puzzle s'active.
@interface PCImpact : CCNode

// permet de calibrer la position des impact par rapport au stageBoard.
// params pnt: le position ou calibrer les impacts. 
- (void)calibrate:(CGPoint)pnt;
// permet de faire un impact à une position donnée.
// @params pnt: le position par rapport à la grille du stageBoard.
// @params state: l'état du picross en train d'être impacté.
- (void)makeImpactAtPosition:(CGPoint)pnt forState:(picrossState)state;
@end
