//
//  UUBarChart.m
//  UUChartDemo
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUBarChart.h"
#import "UUChartLabel.h"
#import "UUBar.h"

@interface UUBarChart ()
{
    UIScrollView *myScrollView;
}
@property (nonatomic) float xLabelWidth;
@property (nonatomic) float yValueMax;
@property (nonatomic) float yValueMin;

@end

@implementation UUBarChart {
    NSHashTable *_chartLabelsForX;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(UUYLabelwidth, 0, frame.size.width-UUYLabelwidth, frame.size.height)];
        [self addSubview:myScrollView];
    }
    return self;
}

- (void)setYAxisValues:(NSArray<NSArray<NSString *> *> *)yAxisValues
{
    _yAxisValues = yAxisValues;
    NSInteger max = yAxisValues.firstObject.firstObject.integerValue;
    NSInteger min = max;
    
    for (NSArray *arr in yAxisValues) {
        for (NSString *str in arr) {
            NSInteger value = [str integerValue];
            max = value>max ? value : max;
            min = value<min ? value :min;
        }
    }
    if (max < 5) {
        max = 5;
    }
    _yValueMin = 0;
    _yValueMax = (int)max;
    
    if (_chooseRange.max!=_chooseRange.min) {
        _yValueMax = _chooseRange.max;
        _yValueMin = _chooseRange.min;
    }
    
    float level = (_yValueMax-_yValueMin) /4.0;
    CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
    CGFloat levelHeight = chartCavanHeight /4.0;
    
    for (int i=0; i<5; i++) {
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake(0.0,chartCavanHeight-i*levelHeight+5, UUYLabelwidth, UULabelHeight)];
        label.text = [NSString stringWithFormat:@"%.1f",level * i+_yValueMin];
        [self addSubview:label];
    }
}


- (void)setXAxisTitle:(NSArray<NSString *> *)xAxisTitle
{
    if( !_chartLabelsForX ){
        _chartLabelsForX = [NSHashTable weakObjectsHashTable];
    }
    
    _xAxisTitle = xAxisTitle;
    
    NSInteger num;
    if (xAxisTitle.count>=8) {
        num = 8;
    }else if (xAxisTitle.count<=4){
        num = 4;
    }else{
        num = xAxisTitle.count;
    }
    _xLabelWidth = myScrollView.bounds.size.width/num;
    
    [xAxisTitle enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake((idx *  _xLabelWidth ), self.frame.size.height - UULabelHeight, _xLabelWidth, UULabelHeight)];
        label.text = xAxisTitle[idx];
        [myScrollView addSubview:label];
        [_chartLabelsForX addObject:label];
    }];
    
    float max = ((xAxisTitle.count-1)*_xLabelWidth + chartMargin) + _xLabelWidth;
    if (myScrollView.frame.size.width < max-10) {
        myScrollView.contentSize = CGSizeMake(max, self.frame.size.height);
    }
}

-(void)setColors:(NSArray<UIColor *> *)colors
{
	_colors = colors;
}

- (void)setChooseRange:(CGRange)chooseRange
{
    _chooseRange = chooseRange;
}

- (void)reloadData
{
    [self strokeChart];
}

-(void)strokeChart
{
    CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
	
    for (int i=0; i<_yAxisValues.count; i++) {
        if (i==2)
            return;
        NSArray *childAry = _yAxisValues[i];
        for (int j=0; j<childAry.count; j++) {
            NSString *valueString = childAry[j];
            float value = [valueString floatValue];
            float grade = ((float)value-_yValueMin) / ((float)_yValueMax-_yValueMin);
            
            UUBar * bar = [[UUBar alloc] initWithFrame:CGRectMake((j+(_yAxisValues.count==1?0.1:0.05))*_xLabelWidth +i*_xLabelWidth * 0.47, UULabelHeight, _xLabelWidth * (_yAxisValues.count==1?0.8:0.45), chartCavanHeight)];
            bar.barColor = [_colors objectAtIndex:i];
            bar.gradePercent = grade;
            [myScrollView addSubview:bar];
        }
    }
}

- (NSArray *)chartLabelsForX
{
    return [_chartLabelsForX allObjects];
}

@end
