//
//  UUBarChart.h
//  UUChartDemo
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUChartConst.h"

@interface UUBarChart : UIView

@property (strong, nonatomic) NSArray * xLabels;
@property (strong, nonatomic) NSArray * yLabels;
@property (strong, nonatomic) NSArray * yValues;
@property (strong, nonatomic) NSArray * colors;

@property (nonatomic) float xLabelWidth;
@property (nonatomic) float yValueMax;
@property (nonatomic) float yValueMin;
@property (nonatomic) CGRange chooseRange;


- (NSArray *)chartLabelsForX;

- (void)strokeChart;

@end
