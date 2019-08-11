//
//  TableViewCell.m
//  UUChartView
//
//  Created by shake on 15/1/4.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import "ChartViewCell.h"
#import <XYChart/XYChart.h>

NSString *const lineChartReuseIdentifier = @"lineChartReuseIdentifier";
NSString *const barChartReuseIdentifier = @"barChartReuseIdentifier";

@interface ChartViewCell ()<XYChartDelegate>
{
    XYChart *_chartView;
}
@end

@implementation ChartViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        XYChartType type = [reuseIdentifier isEqualToString:lineChartReuseIdentifier]
                         ? XYChartTypeLine : XYChartTypeBar;
        _chartView = [[XYChart alloc] initWithFrame:CGRectZero chartType:type];
        _chartView.delegate = self;
        [self.contentView addSubview:_chartView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (@available(iOS 11.0, *)) {
        CGFloat safeSpace = self.safeAreaInsets.left+self.safeAreaInsets.right;
        _chartView.frame = CGRectMake(0, 30, xy_width(self)-20-safeSpace, xy_height(self)-40);
    } else {
        _chartView.frame = CGRectMake(0, 30, xy_width(self)-20, xy_height(self)-40);
    }
}

- (void)setDataSource:(RandomChartDataSource *)dataSource
{
    _dataSource = dataSource;
    [_chartView setDataSource:dataSource animation:YES];
}

#pragma mark - XYChartDelegate

- (BOOL)chart:(XYChart *)chart shouldShowMenu:(NSIndexPath *)index
{
    return YES;
}

- (void)chart:(XYChart *)chart itemDidClick:(id<XYChartItem>)item
{
    // actions
}

- (CAAnimation *)chart:(XYChart *)chart clickAnimationOfIndex:(NSIndexPath *)index
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.3;
    animation.repeatCount = 1;
    animation.removedOnCompletion = true;
    
    int style = arc4random()%3;
    if (style == 0) {
        animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)];
        animation.autoreverses = true;
    } else if (style == 1) {
        CATransform3D rotate = CATransform3DMakeRotation(M_PI, 1, 0, 0);
        rotate.m34 = 1.0/100.0;
        animation.toValue = [NSValue valueWithCATransform3D:rotate];
    } else if (style == 2) {
        CATransform3D rotate = CATransform3DMakeRotation(M_PI, 0, 1, 0);
        rotate.m34 = -1.0/100.0;
        animation.toValue = [NSValue valueWithCATransform3D:rotate];
    }
    return animation;
}

@end
