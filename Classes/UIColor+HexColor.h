//
//  UIColor+HexColor.h
//  picrossGame
//
//  Created by loïc Abadie on 03/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)
+ (UIColor *)colorWithHexString:(NSString *)str;
+ (UIColor *)colorWithHex:(UInt32)col;
@end
