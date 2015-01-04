UUChartView
===========

Line and Bar of Chart

![Flipboard playing multiple GIFs](https://github.com/ZhipingYang/UUChartView/raw/master/UUChartViewTests/UUChartView.gif)

## Usage

### init

    -(id)initwithUUChartDataFrame:(CGRect)rect 
                       withSource:(id<UUChartDataSource>)dataSource 
                        withStyle:(UUChartStyle)style;

#### UUChartView have two style to select:

    UUChartLineStyle,
    UUChartBarStyle

## UUChartDataSource

 required

    - (NSArray *)UUChart_xLableArray:(UUChart *)chart;
    //The target array's object's class is equal to NSArray
    - (NSArray *)UUChart_yValueArray:(UUChart *)chart;

 optional

    - (NSArray *)UUChart_ColorArray:(UUChart *)chart;
    
    //CGRange CGRangeMake(CGFloat max, CGFloat min);
    - (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart;

Only apply in lineChart

    - (CGRange)UUChartMarkRangeInLineChart:(UUChart *)chart;
    - (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index;
    - (BOOL)UUChart:(UUChart *)chart ShowMaxMinAtIndex:(NSInteger)index;

