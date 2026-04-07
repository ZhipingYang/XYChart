//
//  XYLineGradientLayer.m
//  XYChart
//
//  Created by Daniel on 2018/7/22.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import "XYLineGradientLayer.h"

@interface XYLineGradientLayer()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) id <XYChartItem>pre;
@property (nonatomic, strong) id <XYChartItem>next;
@property (nonatomic) XYRange range;
    
@end

@implementation XYLineGradientLayer

+ (instancetype)layerWithPre:(id<XYChartItem>)pre next:(id<XYChartItem>)next range:(XYRange)range
{
    XYLineGradientLayer *gradient = [super layer];
    [gradient updateWithPre:pre next:next range:range];
    return gradient;
}

- (void)updateWithPre:(id<XYChartItem>)pre next:(id<XYChartItem>)next range:(XYRange)range
{
    self.hidden = !pre || !next;
    if (self.hidden) { return; }
    
    _pre = pre;
    _next = next;
    _range = range;

    CGFloat startY = pre.value.floatValue > next.value.floatValue ? 0:1;
    CGFloat endY = pre.value.floatValue > next.value.floatValue ? 1:0;
    self.colors = @[(id)pre.color.CGColor, (id)next.color.CGColor];
    self.startPoint = CGPointMake(0, startY);
    self.endPoint = CGPointMake(1, endY);
    
    if (_shapeLayer == nil) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.lineWidth = XYChartLineWidth;
        _shapeLayer.lineCap = kCALineCapRound;
        _shapeLayer.lineJoin = kCALineJoinRound;
        _shapeLayer.fillColor = UIColor.clearColor.CGColor;
        _shapeLayer.strokeColor = UIColor.whiteColor.CGColor;
        [self addSublayer:_shapeLayer];
        self.mask = _shapeLayer;
    }
}

- (void)layoutSublayers
{
    [super layoutSublayers];
    
    CGFloat topY = XYChartLineWidth*2;
    CGFloat bottomY = (xy_height(self)-XYChartLineWidth*2);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, _pre.value.floatValue>_next.value.floatValue ? topY : bottomY);
    CGPathAddLineToPoint(path, NULL, xy_width(self), _pre.value.floatValue>_next.value.floatValue ? bottomY : topY);
    _shapeLayer.frame = CGRectMake(0, 0, xy_width(self), xy_height(self));
    _shapeLayer.path = path;
    CGPathRelease(path);
}

- (void)startAnimate:(BOOL)animate
{
    [self startAnimate:animate delay:0];
}

- (void)startAnimate:(BOOL)animate delay:(NSTimeInterval)delay
{
    [_shapeLayer removeAnimationForKey:@"xy.line.stroke"];
    _shapeLayer.strokeEnd = 1;
    if (animate == NO || self.hidden) {
        return;
    }

    NSTimeInterval duration = MAX(XYChartResolvedAnimationDuration(self.pre.duration),
                                  XYChartResolvedAnimationDuration(self.next.duration));
    CFTimeInterval beginTime = CACurrentMediaTime() + MAX(delay, 0);

    CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeAnimation.fromValue = @0;
    strokeAnimation.toValue = @1;

    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @0.18;
    opacityAnimation.toValue = @1;

    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[strokeAnimation, opacityAnimation];
    group.duration = duration;
    group.beginTime = beginTime;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.fillMode = kCAFillModeBackwards;
    group.removedOnCompletion = YES;
    [_shapeLayer addAnimation:group forKey:@"xy.line.stroke"];
}

@end
