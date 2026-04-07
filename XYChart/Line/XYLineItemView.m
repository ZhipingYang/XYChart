//
//  UULineItemView.m
//  XYChart
//
//  Created by Daniel on 2018/7/21.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import "XYLineItemView.h"
#import "XYChartItem.h"

@interface XYLineItemView()
{
    CALayer *_separatedLine;
}

@property (nonatomic, strong) NSArray <id<XYChartItem>>* chartItems;
@property (nonatomic) XYRange range;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) NSMutableArray <CALayer *>* circles;

@end

@implementation XYLineItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _circles = @[].mutableCopy;
        _nameLabel = [UILabel new];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        _nameLabel.minimumScaleFactor = 0.65;
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:_nameLabel];
        
        _separatedLine = [CALayer layer];
        _separatedLine.zPosition = -100;
        _separatedLine.backgroundColor = [UIColor xy_separatedColor].CGColor;
        [self.layer addSublayer:_separatedLine];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(handleTap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat plotHeight = XYChartPlotHeight(xy_height(self));
    _separatedLine.frame = CGRectMake(0, 0, XYChartPixel(), plotHeight);
    _nameLabel.frame = CGRectMake(0, xy_height(self)-XYChartRowLabelHeight, xy_width(self), XYChartRowLabelHeight);
    
    const CGFloat circleLength = XYChartLineWidth*4;
    __weak typeof(self) weakSelf = self;
    [_circles enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat value = weakSelf.chartItems.xy_safeIdx(idx).value.floatValue;
        CGFloat percent = XYChartClampedPercent(value, weakSelf.range);
        obj.frame = CGRectMake((xy_width(self)-circleLength)/2.0,
                               plotHeight*(1-percent) - circleLength/2.0,
                               circleLength, circleLength);
        obj.shadowPath = [UIBezierPath bezierPathWithOvalInRect:obj.bounds].CGPath;
    }];
}

- (void)setItems:(NSArray <id<XYChartItem>>*)items name:(NSAttributedString *)name range:(XYRange)range
{
    [_circles makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [_circles removeAllObjects];

    _chartItems = items;
    _range = range;
    _nameLabel.attributedText = name;
    
    [_chartItems enumerateObjectsUsingBlock:^(id<XYChartItem>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CALayer *circle = [CALayer layer];
        circle.backgroundColor = [UIColor whiteColor].CGColor;
        circle.cornerRadius = XYChartLineWidth*2;
        circle.borderColor = obj.color.CGColor;
        circle.borderWidth = XYChartLineWidth;
        circle.shadowColor = obj.color.CGColor;
        circle.shadowOffset = CGSizeZero;
        circle.shadowOpacity = 0.18;
        circle.shadowRadius = 6.0;
        [self.layer addSublayer:circle];
        [self.circles addObject:circle];
    }];
    [self setNeedsLayout];
}

- (void)startAnimate:(BOOL)animate delay:(NSTimeInterval)delay
{
    [_circles enumerateObjectsUsingBlock:^(CALayer * _Nonnull circle, NSUInteger idx, BOOL * _Nonnull stop) {
        [circle removeAnimationForKey:@"xy.line.circle"];
        circle.transform = CATransform3DIdentity;
        if (animate == NO) {
            circle.opacity = 1;
            return;
        }

        CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.values = @[@0.24, @1.2, @0.94, @1.0];
        scaleAnimation.keyTimes = @[@0, @0.58, @0.84, @1];

        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.fromValue = @0;
        opacityAnimation.toValue = @1;

        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.animations = @[scaleAnimation, opacityAnimation];
        group.duration = 0.22;
        group.beginTime = CACurrentMediaTime() + MAX(delay, 0) + ((NSTimeInterval)idx * 0.02);
        group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        group.fillMode = kCAFillModeBackwards;
        group.removedOnCompletion = YES;
        circle.opacity = 1;
        [circle addAnimation:group forKey:@"xy.line.circle"];
    }];
}

- (void)showMenuForItems:(NSArray<id<XYChartItem>> *)items targetCircles:(NSArray<CALayer *> *)circles
{
    if (items.count == 0 || circles.count == 0) {
        return;
    }
    [self becomeFirstResponder];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    NSMutableArray<UIMenuItem *> *menus = @[].mutableCopy;
    [items enumerateObjectsUsingBlock:^(id<XYChartItem>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:obj.showName action:@selector(showItemName:)];
        [menus addObject:item];
    }];
    menu.menuItems = menus;
    __block CGRect targetRect = circles.firstObject.frame;
    [circles enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        targetRect = CGRectUnion(targetRect, obj.frame);
    }];
    CGRect menuRect = CGRectInset(targetRect, -6.0, -6.0);
    if (@available(iOS 13.0, *)) {
        [menu showMenuFromView:self rect:menuRect];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [menu setTargetRect:menuRect inView:self];
        [menu setMenuVisible:YES animated:YES];
#pragma clang diagnostic pop
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)handleTap:(UIGestureRecognizer*)recognizer
{
    CGPoint touchpoint = [recognizer locationInView:self];
    NSMutableArray <id<XYChartItem>>* inTouchItems = @[].mutableCopy;
    NSMutableArray <CALayer *>* inTouchCircles = @[].mutableCopy;
    NSMutableArray <NSNumber *>* sectionIndexes = @[].mutableCopy;
    [_circles enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect rect = obj.frame;
        id <XYChartItem> item = self.chartItems[idx];
        CGFloat minimumTouchSize = 30.0;
        CGFloat extraWidth = MAX(minimumTouchSize - CGRectGetWidth(rect), 0) / 2.0;
        CGFloat extraHeight = MAX(minimumTouchSize - CGRectGetHeight(rect), 0) / 2.0;
        if (extraWidth > 0 || extraHeight > 0) {
            rect = CGRectInset(rect, -extraWidth, -extraHeight);
        }
        if (CGRectContainsPoint(rect, touchpoint)) {
            [inTouchItems addObject:item];
            [inTouchCircles addObject:obj];
            [sectionIndexes addObject:@(idx)];
        }
    }];
    
    if (inTouchItems.count > 0) {
        if (_handleBlock) {
            _handleBlock(self, sectionIndexes, inTouchItems, inTouchCircles);
        } else {
            [self showMenuForItems:inTouchItems targetCircles:inTouchCircles];
        }
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
