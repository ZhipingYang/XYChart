//
//  UULineItemView.m
//  UUChartView
//
//  Created by Daniel on 2018/7/21.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import "UULineItemView.h"
#import "UUChartItem.h"

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
        _separatedLine.backgroundColor = [UIColor separatedColor].CGColor;
        [self.layer addSublayer:_separatedLine];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _separatedLine.frame = CGRectMake(0, 0, 1/[UIScreen mainScreen].scale, uu_height(self)-UUChartXLabelHeight);
    
    _nameLabel.frame = CGRectMake(0, uu_height(self)-UUChartXLabelHeight, uu_width(self), UUChartXLabelHeight);
    
    NSLog(@"%@",self);
    
    [_circles enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake((uu_width(self)-uu_width(obj))/2.0,
                               (uu_height(self)-UUChartXLabelHeight)*(1-_chartItems[idx].percent) - uu_height(obj)/2.0,
                               uu_width(obj), uu_height(obj));
        NSLog(@"obj.frame %@",NSStringFromCGRect(obj.frame));
    }];
}

- (void)setChartGroup:(id<UUChartGroup>)chartGroup index:(NSUInteger)index
{
    [_circles makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [_circles removeAllObjects];
    
    _chartGroup = chartGroup;
    _index = index;
    
    _nameLabel.attributedText = _chartGroup.names[index];
    _separatedLine.hidden = index==0;
    
    NSMutableArray <id <UUChartItem>>*array = @[].mutableCopy;
    [_chartGroup.dataList enumerateObjectsUsingBlock:^(NSArray<id<UUChartItem>> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id <UUChartItem>item = obj[index];
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

@end
