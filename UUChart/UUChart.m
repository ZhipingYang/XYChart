//
//  UUChart.m
//  UUChart
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUChart.h"

@interface UUChart ()

@property (strong, nonatomic) UULineChart * lineChart;

@property (strong, nonatomic) UUBarChart * barChart;

@property (assign, nonatomic) id<UUChartDataSource> dataSource;

@end

@implementation UUChart

- (id)initWithFrame:(CGRect)rect dataSource:(id<UUChartDataSource>)dataSource style:(UUChartStyle)style
{
    self = [self initWithFrame:rect];
    if (self) {
        self.dataSource = dataSource;
        self.chartStyle = style;
        [self setUpChart];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = NO;
        [self setUpChart];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.chartStyle == UUChartStyleLine) {
        self.lineChart.frame = self.bounds;
        [self.lineChart setNeedsLayout];
    } else {
        self.barChart.frame = self.bounds;
        [self.barChart setNeedsLayout];
    }
}

- (UULineChart *)lineChart
{
    if (!_lineChart) {
        _lineChart = [UULineChart new];
        _lineChart.clipsToBounds = YES;
    }
    return _lineChart;
}

- (UUBarChart *)barChart
{
    if (_barChart) {
        _barChart = [[UUBarChart alloc] initWithFrame:CGRectMake(10, 10, 350, 150)];
        _barChart.clipsToBounds = YES;
    }
    return _barChart;
}

-(void)setUpChart
{
	if (self.chartStyle == UUChartStyleLine) {
        if(!_lineChart){
            _lineChart = [[UULineChart alloc] initWithFrame:self.bounds];
            [self addSubview:_lineChart];
        }
        //选择标记范围
        if ([self.dataSource respondsToSelector:@selector(chartHighlightRangeInLine:)]) {
            [_lineChart setMarkRange:[self.dataSource chartHighlightRangeInLine:self]];
        }
        //选择显示范围
        if ([self.dataSource respondsToSelector:@selector(chartRange:)]) {
            [_lineChart setChooseRange:[self.dataSource chartRange:self]];
        }
        //显示颜色
        if ([self.dataSource respondsToSelector:@selector(chartConfigColors:)]) {
            [_lineChart setColors:[self.dataSource chartConfigColors:self]];
        }
        //判断显示最大最小值
        if ([self.dataSource respondsToSelector:@selector(shouldShowMaxMinValue:)]) {
            _lineChart.shouldShowMaxMin = [self.dataSource shouldShowMaxMinValue:self];
        }
        
		[_lineChart setYAxisValues:[self.dataSource chartConfigAxisYValue:self]];
		[_lineChart setXAxisTitles:[self.dataSource chartConfigAxisXTitles:self]];

	} else if (self.chartStyle == UUChartStyleBar) {
        if (!_barChart) {
            _barChart = [[UUBarChart alloc] initWithFrame:CGRectMake(10, 10, 350, 150)];
        }
        [self addSubview:_barChart];
        if ([self.dataSource respondsToSelector:@selector(chartRange:)]) {
            [_barChart setChooseRange:[self.dataSource chartRange:self]];
        }
        if ([self.dataSource respondsToSelector:@selector(chartConfigColors:)]) {
            [_barChart setColors:[self.dataSource chartConfigColors:self]];
        }
		[_barChart setYAxisValues:[self.dataSource chartConfigAxisYValue:self]];
		[_barChart setXAxisTitle:[self.dataSource chartConfigAxisXTitles:self]];
	}
}

- (void)reloadData:(BOOL)animation
{
    if (self.chartStyle == UUChartStyleLine) {
        [self.lineChart reloadData:animation];
    } else {
        [self.barChart reloadData:animation];
    }
}

@end
