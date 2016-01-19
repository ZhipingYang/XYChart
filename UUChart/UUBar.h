//
//  PNBar.h
//  PNChartDemo
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUBar : UIView

@property (nonatomic) float gradePercent;

@property (nonatomic, strong) CAShapeLayer * chartLine;

@property (nonatomic, strong) UIColor * barColor;

@end
