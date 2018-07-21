//
//  UUChartConst.h
//  UUChartView
//
//  Created by Daniel on 2018/7/22.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#ifndef UUChartConst_h
#define UUChartConst_h

// 纵轴文案宽度
#define UUChartYLabelWidth 30
// 横轴文案高度
#define UUChartXLabelHeight 20
// 折线图，线条宽度
#define UUChartLineWidth 3

// 获取宽度
#define uu_width(obj) obj.frame.size.width
// 获取高度
#define uu_height(obj) obj.frame.size.height


/**
 图表类型

 - UUChartStyleLine: 折线图
 - UUChartStyleBar: 条形图
 */
typedef NS_ENUM(NSInteger, UUChartStyle){
    UUChartStyleLine = 0,
    UUChartStyleBar
};

#endif /* UUChartConst_h */
