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
        
        _line = [CAShapeLayer layer];
        _line.lineCap = kCALineCapSquare;
        _line.fillColor = [UIColor clearColor].CGColor;
        _line.lineWidth = self.frame.size.width;
        _line.strokeEnd = 0.0;
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
    
    _line.frame = CGRectMake(0, selfSize.height*(1-_chartItem.percent), selfSize.width, selfSize.height * _chartItem.percent);
}

- (void)setChartItem:(id<UUChartItem>)chartItem
{
    [self setChartItem:chartItem animation:NO];
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

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)handleTap:(UIGestureRecognizer*)recognizer
{
    if (_chartItem.name.length > 0) {
        [self becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:_chartItem.name action:@selector(showItemName:)];
        menu.menuItems = @[item];
        
        [menu setTargetRect:CGRectMake(uu_left(self), uu_top(self)+uu_height(self)*(1-_chartItem.percent), uu_width(self), uu_height(self)*_chartItem.percent) inView:self.superview];
        [menu setMenuVisible:YES animated:YES];
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return (action == @selector(showItemName:)) && sender == [UIMenuController sharedMenuController];
}

- (void)showItemName:(id)sender
{
    // do nothing
}

@end
