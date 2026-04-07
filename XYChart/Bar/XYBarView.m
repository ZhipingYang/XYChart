//
//  UUBar.m
//  XYChart
//
//  Created by Daniel on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "XYBarView.h"


@interface XYBarView ()

@end

@implementation XYBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.lineCap = kCALineCapRound;
        _shapeLayer.lineJoin = kCALineJoinRound;
        _shapeLayer.fillColor = UIColor.clearColor.CGColor;
        _shapeLayer.strokeEnd = 1.0;
        _shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        
        _showLayer = [CALayer layer];
        [_showLayer addSublayer:_shapeLayer];
        _showLayer.mask = _shapeLayer;
        [self.layer addSublayer:_showLayer];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(handleTap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updateLineFrame];
}

#pragma mark - private

- (void)updateLineFrame
{
    const CGSize selfSize = self.bounds.size;
    const CGFloat percent = XYChartClampedPercent(_chartItem.value.floatValue, _range);
    
    _showLayer.frame = CGRectMake(0, selfSize.height*(1-percent), selfSize.width, selfSize.height * percent);
    _showLayer.cornerRadius = MIN(xy_width(_showLayer) * 0.32, 7.0);
    _showLayer.masksToBounds = YES;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    CGFloat capInset = MIN(xy_width(_showLayer) / 2.0, 6.0);
    [bezierPath moveToPoint:CGPointMake(xy_width(_showLayer)/2.0, MAX(xy_height(_showLayer) - capInset, capInset))];
    [bezierPath addLineToPoint:CGPointMake(xy_width(_showLayer)/2.0, MIN(capInset, xy_height(_showLayer)))];
    _shapeLayer.path = bezierPath.CGPath;
    _shapeLayer.lineWidth = MAX(xy_width(_showLayer) - 2.0, 0);
}

#pragma mark - public

- (void)setChartItem:(id<XYChartItem>)chartItem range:(XYRange)range
{
    if (_chartItem.value.floatValue == chartItem.value.floatValue && (range.min == _range.min && range.max == _range.max)) { return; }
    _chartItem = chartItem;
    _range = range;
    _showLayer.backgroundColor = chartItem.color.CGColor;
    
    [self updateLineFrame];
}

#pragma mark - animation

- (void)startAnimate:(BOOL)animate
{
    [self startAnimate:animate delay:0];
}

- (void)startAnimate:(BOOL)animate delay:(NSTimeInterval)delay
{
    [_shapeLayer removeAnimationForKey:@"xy.bar.stroke"];
    _shapeLayer.strokeEnd = 1;
    if (animate == NO) {
        _showLayer.opacity = 1;
        return;
    }

    NSTimeInterval duration = XYChartResolvedAnimationDuration(self.chartItem.duration);
    CFTimeInterval beginTime = CACurrentMediaTime() + MAX(delay, 0);

    CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeAnimation.fromValue = @0;
    strokeAnimation.toValue = @1;

    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @0.2;
    opacityAnimation.toValue = @1;

    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[strokeAnimation, opacityAnimation];
    group.duration = duration;
    group.beginTime = beginTime;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.fillMode = kCAFillModeBackwards;
    group.removedOnCompletion = YES;
    _showLayer.opacity = 1;
    [_shapeLayer addAnimation:group forKey:@"xy.bar.stroke"];
}

#pragma mark - UIMenu

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)handleTap:(UIGestureRecognizer*)recognizer
{
    if (_handleBlock) {
        _handleBlock(self);
    } else {
        [self showMenu];
    }
}

- (void)showMenu
{
    if (_chartItem.showName.length == 0) {
        return;
    }
    const CGFloat percent = XYChartClampedPercent(_chartItem.value.floatValue, _range);

    [self becomeFirstResponder];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:_chartItem.showName action:@selector(showItemName:)];
    menu.menuItems = @[item];

    CGRect menuRect = CGRectMake(xy_left(self), xy_top(self)+xy_height(self)*(1-percent), xy_width(self), xy_height(self)*percent);
    if (@available(iOS 13.0, *)) {
        [menu showMenuFromView:self.superview rect:menuRect];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [menu setTargetRect:menuRect inView:self.superview];
        [menu setMenuVisible:YES animated:YES];
#pragma clang diagnostic pop
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    BOOL can = (action == @selector(showItemName:)) && sender == [UIMenuController sharedMenuController];
    return can ?: [super canPerformAction:action withSender:sender];
}

- (void)showItemName:(id)sender
{
    // do nothing
}

@end
