//
//  XYChartConst.h
//  XYChart
//
//  Created by Daniel on 2018/7/22.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#ifndef UUChartConst_h
#define UUChartConst_h

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
typedef NS_ENUM(NSInteger, XYChartStyle){
    XYChartStyleLine = 0,
    XYChartStyleBar
};

#endif /* UUChartConst_h */
