//
//  UULineItemView.m
//  UUChartView
//
//  Created by Daniel on 2018/7/21.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import "UULineItemView.h"
#import "XYChartItem.h"

@interface UULineItemView()
{
    CALayer *_separatedLine;
}
@property (nonatomic, strong) id<UUChartGroup> chartGroup;
@property (nonatomic) NSUInteger index;

@property (nonatomic, strong) NSArray <id<UUChartItem>>* chartItems;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) NSMutableArray <CALayer *>* circles;

@end

@implementation UULineItemView

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
    
    _separatedLine.frame = CGRectMake(0, 0, 1/[UIScreen mainScreen].scale, uu_height(self)-UUChartXLabelHeight);
    _nameLabel.frame = CGRectMake(0, uu_height(self)-UUChartXLabelHeight, uu_width(self), UUChartXLabelHeight);
    
    [_circles enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake((uu_width(self)-uu_width(obj))/2.0,
                               (uu_height(self)-UUChartXLabelHeight)*(1-_chartItems.xy_safeIdx(idx).percent) - uu_height(obj)/2.0,
                               uu_width(obj), uu_height(obj));
    }];
}

- (void)setChartGroup:(id<UUChartGroup>)chartGroup index:(NSUInteger)index
{
    [_circles makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [_circles removeAllObjects];
    
    _chartGroup = chartGroup;
    _index = index;
    
    _nameLabel.attributedText = _chartGroup.names.xy_safeIdx(index);
    _separatedLine.hidden = index==0;
    
    NSMutableArray <id <UUChartItem>>*array = @[].mutableCopy;
    [_chartGroup.dataList enumerateObjectsUsingBlock:^(NSArray<id<UUChartItem>> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id <UUChartItem>item = obj.xy_safeIdx(index);
        [array addObject:item];
        
        CALayer *circle = [CALayer layer];
        circle.backgroundColor = [UIColor whiteColor].CGColor;
        circle.frame = CGRectMake(0, 0, UUChartLineWidth*4, UUChartLineWidth*4);
        circle.cornerRadius = UUChartLineWidth*2;
        circle.borderColor = item.color.CGColor;
        circle.borderWidth = UUChartLineWidth;
        [self.layer addSublayer:circle];
        
        [_circles addObject:circle];
    }];
    _chartItems = array;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)handleTap:(UIGestureRecognizer*)recognizer
{
    CGPoint touchpoint = [recognizer locationInView:self];
    NSMutableArray <id<UUChartItem>>* inTouchItems = @[].mutableCopy;
    NSMutableArray <CALayer *>* inTouchCircles = @[].mutableCopy;
    [_circles enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect rect = obj.frame;
        id <UUChartItem> item = _chartItems[idx];
        if (uu_width(obj)<=30) {
            rect = CGRectInset(rect, uu_width(obj)-30, uu_width(obj)-30);
        }
        if (CGRectContainsPoint(rect, touchpoint) && item.name.length>0) {
            [inTouchItems addObject:item];
            [inTouchCircles addObject:obj];
        }
    }];
    
    if (inTouchItems.count > 0) {
        [self becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        NSMutableArray *menus = @[].mutableCopy;
        [inTouchItems enumerateObjectsUsingBlock:^(id<UUChartItem>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:obj.name action:@selector(showItemName:)];
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
