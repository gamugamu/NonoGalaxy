//
//  PCTutoEffectHint.h
//  picrossGame
//
//  Created by Abadie Loic on 29/10/12.
//
//

#import <Foundation/Foundation.h>
#ifndef picrossGame_PCTutoEffectHint_h
#define picrossGame_PCTutoEffectHint_h

typedef enum{
    PCEffectType_showHint,
    PCEffectType_showArrow
}PCEffectType;

typedef struct{
    CGPoint pnt;
    PCEffectType effectType;
}PCTutoEffectHint;
#endif
