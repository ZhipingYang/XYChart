//
//  UUBar.m
//  XYChart
//
//  Created by Daniel on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "XYBarView.h"


@interface XYBarView ()

@property (nonatomic, strong) CADisplayLink *link;

@end

@implementation XYBarView

- (void)dealloc
{
    [_link invalidate];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.lineCap = kCALineCapSquare;
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
    const CGFloat percent = (_chartItem.value.floatValue-_range.min)/((_range.max-_range.min)==0 ? 1:(_range.max-_range.min));
    
    _showLayer.frame = CGRectMake(0, selfSize.height*(1-percent), selfSize.width, selfSize.height * percent);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(xy_width(_showLayer)/2.0, xy_height(_showLayer))];
    [bezierPath addLineToPoint:CGPointMake(xy_width(_showLayer)/2.0, 0)];
    _shapeLayer.path = bezierPath.CGPath;
    _shapeLayer.lineWidth = xy_width(_showLayer);
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
    if (animate == NO) { return; }
    if (_shapeLayer.strokeEnd > 0 && _shapeLayer.strokeEnd < 1) { return; }
    
    _shapeLayer.strokeEnd = 0;
    if (_link == nil) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(animateFlipAction)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)animateFlipAction
{
    _shapeLayer.strokeEnd += 1/(60.0 * self.chartItem.duration);
    if (_shapeLayer.strokeEnd > 1) {
        [_link invalidate];
        _link = nil;
        _shapeLayer.strokeEnd = 1;
    }
}

#pragma mark - UIMenu

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
