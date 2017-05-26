//
//  UUBar.m
//  UUChartDemo
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUBar.h"
#import "UUChartConst.h"

@implementation UUBar
{
    CAShapeLayer * _chartLine;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		_chartLine = [CAShapeLayer layer];
		_chartLine.lineCap = kCALineCapSquare;
		_chartLine.fillColor = [UIColor clearColor].CGColor;
		_chartLine.lineWidth = self.frame.size.width;
		_chartLine.strokeEnd = 0.0;
        [self.layer addSublayer:_chartLine];
		self.clipsToBounds = YES;
        self.layer.cornerRadius = 2.0;
    }
    return self;
}

-(void)setGradePercent:(float)gradePercent
{
    gradePercent = gradePercent<0 ? 0 : (gradePercent>1 ? 1:gradePercent);
    
    if (gradePercent == _gradePercent) { return; }
    
	_gradePercent = gradePercent;
    
	UIBezierPath *progressline = [UIBezierPath bezierPath];
    //TODO:
    [progressline moveToPoint:CGPointMake(self.frame.size.width/2.0, self.frame.size.height+30)];
	[progressline addLineToPoint:CGPointMake(self.frame.size.width/2.0, (1 - gradePercent) * self.frame.size.height+15)];
    [progressline setLineWidth:1.0];
    [progressline setLineCapStyle:kCGLineCapSquare];
	_chartLine.path = progressline.CGPath;
    _chartLine.strokeColor = _barColor.CGColor ?: [UUColor green].CGColor;
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.5;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = @0.0;
    pathAnimation.toValue = @1.0;
    pathAnimation.autoreverses = NO;
    [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    //TODO:
    _chartLine.strokeEnd = 2.0;
}

@end
