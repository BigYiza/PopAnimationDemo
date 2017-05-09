//
//  UIColor+ACIHex.h
//  Bulb
//
//  Created by MaohuaLiu on 14-10-6.
//  Copyright (c) 2014年 ghzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ACIHex)

+ (UIColor *)aci_colorWithHex:(uint) hex;
+ (UIColor *)aci_colorWithHex:(uint) hex andAlpha:(float) alpha;

@end
