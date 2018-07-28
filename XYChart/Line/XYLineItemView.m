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
    
    _separatedLine.frame = CGRectMake(0, 0, 1/[UIScreen mainScreen].scale, xy_height(self)-XYChartRowLabelHeight);
    _nameLabel.frame = CGRectMake(0, xy_height(self)-XYChartRowLabelHeight, xy_width(self), XYChartRowLabelHeight);
    
    __weak typeof(self) weakSelf = self;
    [_circles enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat value = weakSelf.chartItems.xy_safeIdx(idx).value.floatValue;
        CGFloat percent = (value - weakSelf.range.min)/(weakSelf.range.max - weakSelf.range.min);
        obj.frame = CGRectMake((xy_width(self)-xy_width(obj))/2.0,
                               (xy_height(self)-XYChartRowLabelHeight)*(1-percent) - xy_height(obj)/2.0,
                               xy_width(obj), xy_height(obj));
    }];
}

- (void)setItems:(NSArray<id<XYChartItem>> *)items range:(XYRange)range
{
    [_circles makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [_circles removeAllObjects];

    _chartItems = items;
    _range = range;
    
    [_chartItems enumerateObjectsUsingBlock:^(id<XYChartItem>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CALayer *circle = [CALayer layer];
        circle.backgroundColor = [UIColor whiteColor].CGColor;
        circle.cornerRadius = XYChartLineWidth*2;
        circle.borderColor = obj.color.CGColor;
        circle.borderWidth = XYChartLineWidth;
        [self.layer addSublayer:circle];
        [self.circles addObject:circle];
    }];
    [self setNeedsLayout];
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
    [_circles enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect rect = obj.frame;
        id <XYChartItem> item = self.chartItems[idx];
        if (xy_width(obj)<=30) {
            rect = CGRectInset(rect, xy_width(obj)-30, xy_width(obj)-30);
        }
        if (CGRectContainsPoint(rect, touchpoint) && item.showName.length>0) {
            [inTouchItems addObject:item];
            [inTouchCircles addObject:obj];
        }
    }];
    
    if (inTouchItems.count > 0) {
        [self becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        NSMutableArray *menus = @[].mutableCopy;
        [inTouchItems enumerateObjectsUsingBlock:^(id<XYChartItem>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:obj.showName action:@selector(showItemName:)];
            [menus addObject:item];
        }];
        menu.menuItems = menus;
        
        [menu setTargetRect:inTouchCircles.lastObject.frame inView:self];
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
