//
//  UUBar.m
//  XYChart
//
//  Created by Daniel on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "XYBarView.h"

@implementation XYBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
        _line = [CAShapeLayer layer];
        _line.lineCap = kCALineCapSquare;
        _line.fillColor = [UIColor clearColor].CGColor;
        _line.lineWidth = self.frame.size.width;
        _line.strokeEnd = 1.0;
        [self.layer addSublayer:_line];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(handleTap:)];
        [self addGestureRecognizer:tap];
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.line removeAllAnimations];
//
//            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//            animation.duration = 1;
//            animation.fromValue = @(0.0f);
//            animation.toValue = @(1.0f);
//            animation.fillMode = kCAFillModeForwards;
//            animation.removedOnCompletion = YES;
//            [self.line addAnimation:animation forKey:@"strokeEnd"];
//        });
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
    const CGFloat percent = (_chartItem.value.floatValue-_range.min)/((_range.max-_range.min)==0 ? 1:(_range.max-_range.min));
    
    _line.frame = CGRectMake(0, selfSize.height*(1-percent), selfSize.width, selfSize.height * percent);
//    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
//    [bezierPath moveToPoint:CGPointMake(xy_width(_line)/2.0, xy_height(_line))];
//    [bezierPath addLineToPoint:CGPointMake(xy_width(_line)/2.0, 0)];
//    bezierPath.lineWidth = xy_width(_line);
//    _line.path = bezierPath.CGPath;
}

- (void)setChartItem:(id<XYChartItem>)chartItem range:(XYRange)range
{
    if (_chartItem.value.floatValue == chartItem.value.floatValue && (range.min == _range.min && range.max == _range.max)) { return; }
    _chartItem = chartItem;
    _range = range;
    _line.backgroundColor = chartItem.color.CGColor;
//    _line.strokeColor = [chartItem.color colorWithAlphaComponent:0.3].CGColor;
    [self updateLineFrame];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)handleTap:(UIGestureRecognizer*)recognizer
{
    !_handleBlock ?: _handleBlock(self);
    if (_chartItem.showName.length > 0) {
        const CGFloat percent = (_chartItem.value.floatValue-_range.min)/(_range.max-_range.min);

        [self becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:_chartItem.showName action:@selector(showItemName:)];
        menu.menuItems = @[item];
        
        [menu setTargetRect:CGRectMake(xy_left(self), xy_top(self)+xy_height(self)*(1-percent), xy_width(self), xy_height(self)*percent) inView:self.superview];
        [menu setMenuVisible:YES animated:YES];
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
