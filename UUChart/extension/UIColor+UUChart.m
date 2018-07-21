//
//  UIColor+Random.m
//  UUChartView
//
//  Created by Daniel on 2018/7/21.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import "UIColor+UUChart.h"

@implementation UIColor(Random)

+ (UIColor *)random
{
    return [UIColor colorWithRed:arc4random()%255/255.0
                           green:arc4random()%255/255.0
                            blue:arc4random()%255/255.0
                           alpha:1];
}

+ (UIColor *)randomDark
{
    return [UIColor colorWithRed:arc4random()%100/255.0
                           green:arc4random()%100/255.0
                            blue:arc4random()%100/255.0
                           alpha:1];
}

+ (UIColor *)randomLigt
{
    return [UIColor colorWithRed:(arc4random()%100+155)/255.0
                           green:(arc4random()%100+155)/255.0
                            blue:(arc4random()%100+155)/255.0
                           alpha:1];
}

+ (UIColor *)randomLigtRed
{
    return [UIColor colorWithRed:(arc4random()%100+155)/255.0
                           green:155/255.0
                            blue:155/255.0
                           alpha:1];
}
+ (UIColor *)randomLigtGreen
{
    return [UIColor colorWithRed:155/255.0
                           green:(arc4random()%100+155)/255.0
                            blue:155/255.0
                           alpha:1];
}
+ (UIColor *)randomLigtBlue
{
    return [UIColor colorWithRed:155/255.0
                           green:155/255.0
                            blue:(arc4random()%100+155)/255.0
                           alpha:1];
}

+ (UIColor *)separatedColor
{
    return [UIColor colorWithRed:200/255.0
                           green:200/255.0
                            blue:200/255.0
                           alpha:1];
}
@end
