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
}

- (void)setChartItem:(id<XYChartItem>)chartItem range:(XYRange)range
{
    if (_chartItem.value.floatValue == chartItem.value.floatValue && (range.min == _range.min && range.max == _range.max)) { return; }
    _chartItem = chartItem;
    _range = range;
    _line.backgroundColor = chartItem.color.CGColor;
    [self updateLineFrame];
    
//    if (animation) {
//        [_line removeAllAnimations];
//        _line.strokeEnd = 0.0;
//        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//        pathAnimation.duration = chartItem.duration;
//        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        pathAnimation.fromValue = @0.0;
//        pathAnimation.toValue = @1.0;
//        pathAnimation.autoreverses = NO;
//        [_line addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
//    } else {
//        _line.strokeEnd = 1.0;
//    }
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
