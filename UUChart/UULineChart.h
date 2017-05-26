//
//  UULineChart.h
//  UUChartDemo
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "UUChartConst.h"

@interface UULineChart : UIView

@property (strong, nonatomic) NSArray <NSString *> * xAxisTitles;
@property (strong, nonatomic) NSArray <NSArray <NSString *> *> * yAxisValues;
@property (strong, nonatomic) NSArray <UIColor *> * colors;

@property (strong, nonatomic) NSMutableArray *showHorizonLine;
@property (nonatomic, assign) BOOL shouldShowMaxMin;

@property (nonatomic, assign) CGRange markRange;

@property (nonatomic, assign) CGRange chooseRange;

-(void)strokeChart;

- (NSArray *)chartLabelsForX;

- (void)reloadData;

@end
