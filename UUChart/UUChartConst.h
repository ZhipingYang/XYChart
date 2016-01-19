//
//  UUColor.h
//  UUChart
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define chartMargin         10
#define xLabelMargin        15
#define yLabelMargin        15
#define UULabelHeight       10
#define UUYLabelwidth       30
#define UUTagLabelwidth     80

//范围
struct Range {
    CGFloat max;
    CGFloat min;
};
typedef struct Range CGRange;
CG_INLINE CGRange CGRangeMake(CGFloat max, CGFloat min);

CG_INLINE CGRange
CGRangeMake(CGFloat max, CGFloat min){
    CGRange p;
    p.max = max;
    p.min = min;
    return p;
}

static const CGRange CGRangeZero = {0,0};

@interface UUColor : UIColor
+(UIColor *)randomColor;
+(UIColor *)randomColorDeep;
+(UIColor *)randomColorlight;
+(UIColor *)red;
+(UIColor *)green;
+(UIColor *)brown;
@end
