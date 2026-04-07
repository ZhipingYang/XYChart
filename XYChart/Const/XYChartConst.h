//
//  XYChartConst.h
//  XYChart
//
//  Created by Daniel on 2018/7/22.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

@import UIKit;
#import <math.h>

// 纵轴文案宽度
#define XYChartSectionLabelWidth 30
// 横轴文案高度
#define XYChartRowLabelHeight 20
// 折线图，线条宽度
#define XYChartLineWidth 3

// 获取宽度
#define xy_width(obj) obj.frame.size.width
// 获取高度
#define xy_height(obj) obj.frame.size.height
#define xy_left(obj) obj.frame.origin.x
#define xy_top(obj) obj.frame.origin.y

/**
 图表类型

 - UUChartStyleLine: 折线图
 - UUChartStyleBar: 条形图
 */
typedef NS_ENUM(NSInteger, XYChartType){
    XYChartTypeLine = 0,
    XYChartTypeBar
};

//范围
struct xy_range {
    CGFloat min;
    CGFloat max;
};
typedef struct xy_range XYRange;
CG_INLINE XYRange XYRangeMake(CGFloat min, CGFloat max);
CG_INLINE XYRange XYRangeMake(CGFloat min, CGFloat max){
    XYRange r;
    r.min = min;
    r.max = max;
    return r;
}

static const XYRange XYRangeZero = {0,0};

CG_INLINE CGFloat XYChartRangeSpan(XYRange range) {
    CGFloat span = range.max - range.min;
    return fabs(span) > CGFLOAT_EPSILON ? span : 0;
}

CG_INLINE CGFloat XYChartClampedPercent(CGFloat value, XYRange range) {
    CGFloat span = XYChartRangeSpan(range);
    if (span == 0 || !isfinite(value)) {
        return 0;
    }
    CGFloat percent = (value - range.min) / span;
    if (!isfinite(percent)) {
        return 0;
    }
    return MIN(MAX(percent, 0), 1);
}

CG_INLINE CGFloat XYChartAnimationStep(NSTimeInterval duration) {
    if (duration <= 0) {
        return 1;
    }
    return 1 / (60.0 * duration);
}

CG_INLINE NSUInteger XYChartSafeLevels(NSUInteger levels) {
    return levels > 0 ? levels : 1;
}
