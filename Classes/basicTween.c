//
//  basicTween.c
//  picrossGame
//
//  Created by loïc Abadie on 01/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "basicTween.h"
#include <math.h>

int easeOutCubic(float t, float b, float c, float d){
	return c * (pow(t/d-1, 3) + 1) + b;
}

int easeInOutQuad(float t, float b, float c, float d){
	if ((t/=d/2) < 1) 
		return c/2*t*t + b; 
	else{
        t--;
		return -c/2 * (t * (t-2) - 1) + b;
    }
}

#define ovs 1.70158
int easeOutBack(float t, float b, float c, float d){
	t=t/d-1;
	return c*(t*t*((ovs+1)*t + ovs) + 1) + b;
}