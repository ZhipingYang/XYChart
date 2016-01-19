//
//  UUColor.m
//  UUChart
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUChartConst.h"

@implementation UUColor
+(UIColor *)randomColor
{
    return [self colorWithRed:arc4random()%255/255.0
                        green:arc4random()%255/255.0
                         blue:arc4random()%255/255.0
                        alpha:1.0f];
}

+(UIColor *)randomColorDeep
{
    return [UIColor colorWithRed:(arc4random()%100 + 55)/255.0
                           green:(arc4random()%100 + 55)/255.0
                            blue:(arc4random()%100 + 55)/255.0
                           alpha:1.0f];
}

+(UIColor *)randomColorlight
{
    return [UIColor colorWithRed:(arc4random()%100 + 155)/255.0
                           green:(arc4random()%100 + 155)/255.0
                            blue:(arc4random()%100 + 155)/255.0
                           alpha:1.0f];
}

+(UIColor *)red
{
    return [UIColor colorWithRed:245.0/255.0 green:94.0/255.0 blue:78.0/255.0 alpha:1.0f];
}

+(UIColor *)green
{
    return [UIColor colorWithRed:77.0/255.0 green:186.0/255.0 blue:122.0/255.0 alpha:1.0f];
}

+(UIColor *)brown
{
    return [UIColor colorWithRed:119.0/255.0 green:107.0/255.0 blue:95.0/255.0 alpha:1.0f];
}

+ (CGFloat)getRandomByNum:(int)num {
    
    return (arc4random()%num + 100)/255.0;
}
@end
