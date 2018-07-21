//
//  UUBar.m
//  UUChartView
//
//  Created by Daniel on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUBar.h"

@implementation UUBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 2.0;
        
        _line = [CAShapeLayer layer];
        _line.lineCap = kCALineCapSquare;
        _line.fillColor = [UIColor clearColor].CGColor;
        _line.lineWidth = self.frame.size.width;
        _line.strokeEnd = 0.0;
        [self.layer addSublayer:_line];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updateLineFrame];
}

- (void)updateLineFrame
{
    const CGSize selfSize = self.bounds.size;
    
    _line.frame = CGRectMake(0, selfSize.height*(1-_chartItem.percent), selfSize.width, selfSize.height * _chartItem.percent);
}

- (void)setChartItem:(id<UUChartItem>)chartItem
{
    [self setChartItem:chartItem animation:YES];
}

- (void)setChartItem:(id<UUChartItem> _Nonnull)chartItem animation:(BOOL)animation
{
    if (_chartItem.percent == chartItem.percent) { return; }
    _chartItem = chartItem;
    _line.backgroundColor = chartItem.color.CGColor;
    [self updateLineFrame];
    
    if (animation) {
        [_line removeAllAnimations];
        _line.strokeEnd = 0.0;
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = chartItem.duration;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = @0.0;
        pathAnimation.toValue = @1.0;
        pathAnimation.autoreverses = NO;
        [_line addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    } else {
        _line.strokeEnd = 1.0;
    }
}

@end
