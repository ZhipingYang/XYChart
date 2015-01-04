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

-(id)initwithUUChartDataFrame:(CGRect)rect withSource:(id<UUChartDataSource>)dataSource withStyle:(UUChartStyle)style{
    self.dataSource = dataSource;
    self.chartStyle = style;
    return [self initWithFrame:rect];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = NO;
    }
    return self;
}

-(void)setUpChart{
	if (self.chartStyle == UUChartLineStyle) {
        if(!_lineChart){
            _lineChart = [[UULineChart alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            [self addSubview:_lineChart];
        }
        //选择标记范围
        if ([self.dataSource respondsToSelector:@selector(UUChartMarkRangeInLineChart:)]) {
            [_lineChart setMarkRange:[self.dataSource UUChartMarkRangeInLineChart:self]];
        }
        //选择显示范围
        if ([self.dataSource respondsToSelector:@selector(UUChartChooseRangeInLineChart:)]) {
            [_lineChart setChooseRange:[self.dataSource UUChartChooseRangeInLineChart:self]];
        }
        //显示颜色
        if ([self.dataSource respondsToSelector:@selector(UUChart_ColorArray:)]) {
            [_lineChart setColors:[self.dataSource UUChart_ColorArray:self]];
        }
        //显示横线
        if ([self.dataSource respondsToSelector:@selector(UUChart:ShowHorizonLineAtIndex:)]) {
            NSMutableArray *showHorizonArray = [[NSMutableArray alloc]init];
            for (int i=0; i<5; i++) {
                if ([self.dataSource UUChart:self ShowHorizonLineAtIndex:i]) {
                    [showHorizonArray addObject:@"1"];
                }else{
                    [showHorizonArray addObject:@"0"];
                }
            }
            [_lineChart setShowHorizonLine:showHorizonArray];

        }
        //判断显示最大最小值
        if ([self.dataSource respondsToSelector:@selector(UUChart:ShowMaxMinAtIndex:)]) {
            NSMutableArray *showMaxMinArray = [[NSMutableArray alloc]init];
            NSArray *y_values = [self.dataSource UUChart_yValueArray:self];
            if (y_values.count>0){
                for (int i=0; i<y_values.count; i++) {
                    if ([self.dataSource UUChart:self ShowMaxMinAtIndex:i]) {
                        [showMaxMinArray addObject:@"1"];
                    }else{
                        [showMaxMinArray addObject:@"0"];
                    }
                }
                _lineChart.ShowMaxMinArray = showMaxMinArray;
            }
        }
        
		[_lineChart setYValues:[self.dataSource UUChart_yValueArray:self]];
		[_lineChart setXLabels:[self.dataSource UUChart_xLableArray:self]];
        
		[_lineChart strokeChart];

	}else if (self.chartStyle == UUChartBarStyle)
	{
        if (!_barChart) {
            _barChart = [[UUBarChart alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            [self addSubview:_barChart];
        }
        if ([self.dataSource respondsToSelector:@selector(UUChartChooseRangeInLineChart:)]) {
            [_barChart setChooseRange:[self.dataSource UUChartChooseRangeInLineChart:self]];
        }
        if ([self.dataSource respondsToSelector:@selector(UUChart_ColorArray:)]) {
            [_barChart setColors:[self.dataSource UUChart_ColorArray:self]];
        }
		[_barChart setYValues:[self.dataSource UUChart_yValueArray:self]];
		[_barChart setXLabels:[self.dataSource UUChart_xLableArray:self]];
        
        [_barChart strokeChart];
	}
}

- (void)showInView:(UIView *)view
{
    [self setUpChart];
    [view addSubview:self];
}

-(void)strokeChart
{
	[self setUpChart];
	
}



@end
