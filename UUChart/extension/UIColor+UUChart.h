//
//  UIColor+Random.h
//  UUChartView
//
//  Created by Daniel on 2018/7/21.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor(Random)

/**
 随机色
 */
+ (UIColor *)random;
/**
 随机-淡色
 */
+ (UIColor *)randomLigt;

+ (UIColor *)randomLigtRed;
+ (UIColor *)randomLigtGreen;
+ (UIColor *)randomLigtBlue;

/**
 随机-暗色
 */
+ (UIColor *)randomDark;

/**
 分割线颜色
 */
+ (UIColor *)separatedColor;

+ (UIColor *)rainBow:(NSInteger)index;

@end
