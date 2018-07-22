//
//  UIColor+xy_random.h
//  XYChart
//
//  Created by Daniel on 2018/7/21.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor(XYChart)

/**
 随机色
 */
+ (UIColor *)xy_random;
/**
 随机-淡色
 */
+ (UIColor *)xy_randomLigt;

+ (UIColor *)xy_randomLigtRed;
+ (UIColor *)xy_randomLigtGreen;
+ (UIColor *)xy_randomLigtBlue;

/**
 随机-暗色
 */
+ (UIColor *)xy_randomDark;

/**
 分割线颜色
 */
+ (UIColor *)xy_separatedColor;

+ (UIColor *)xy_rainBow:(NSInteger)index;

@end
