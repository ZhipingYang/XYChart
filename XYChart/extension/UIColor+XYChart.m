//
//  UIColor+Random.m
//  XYChart
//
//  Created by Daniel on 2018/7/21.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import "UIColor+XYChart.h"

#define uucc(color) [UIColor color]

@implementation UIColor(XYChart)

+ (UIColor *)xy_random
{
    return [UIColor colorWithRed:arc4random()%255/255.0
                           green:arc4random()%255/255.0
                            blue:arc4random()%255/255.0
                           alpha:1];
}

+ (UIColor *)xy_randomDark
{
    return [UIColor colorWithRed:arc4random()%100/255.0
                           green:arc4random()%100/255.0
                            blue:arc4random()%100/255.0
                           alpha:1];
}

+ (UIColor *)xy_randomLigt
{
    return [UIColor colorWithRed:(arc4random()%100+155)/255.0
                           green:(arc4random()%100+155)/255.0
                            blue:(arc4random()%100+155)/255.0
                           alpha:1];
}

+ (UIColor *)xy_randomLigtRed
{
    return [UIColor colorWithRed:(arc4random()%100+155)/255.0
                           green:155/255.0
                            blue:155/255.0
                           alpha:1];
}
+ (UIColor *)xy_randomLigtGreen
{
    return [UIColor colorWithRed:155/255.0
                           green:(arc4random()%100+155)/255.0
                            blue:155/255.0
                           alpha:1];
}
+ (UIColor *)xy_randomLigtBlue
{
    return [UIColor colorWithRed:155/255.0
                           green:155/255.0
                            blue:(arc4random()%100+155)/255.0
                           alpha:1];
}

+ (UIColor *)xy_separatedColor
{
    return [UIColor colorWithRed:200/255.0
                           green:200/255.0
                            blue:200/255.0
                           alpha:1];
}
+ (UIColor *)xy_rainBow:(NSInteger)index
{
    return @[
             uucc(redColor),
             uucc(orangeColor),
             uucc(yellowColor),
             uucc(greenColor),
             uucc(blueColor),
             uucc(cyanColor),
             uucc(purpleColor)
             ][index%7];
}
@end

