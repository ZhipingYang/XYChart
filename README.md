<p align="center">

<img align="center" width="150" src ="https://user-images.githubusercontent.com/9360037/43032646-0771fd3c-8cef-11e8-913f-034ca293c625.png"/>
</p>

> **XYChart** is designed by Line and Bar. You can mark the range of values you want, and show the max or min values in linechart.

<!--
<p align="center">
<img src="https://github.com/ZhipingYang/UUChartView/raw/master/UUChartViewTests/UUChartView.gif">
</p>
--> 

#### ChartType
- XYChartTypeLine
- XYChartTypeBar

## Usage

说明：

```objective-c
@interface XYChart : UIView<XYChartContainer>

@property (nonatomic, weak, nullable) id<XYChartDataSource> dataSource;
@property (nonatomic, weak, nullable) id<XYChartDelegate> delegate;

@property (nonatomic, readonly) XYChartType chartType;

- (instancetype)initWithFrame:(CGRect)frame chartType:(XYChartType)chartType NS_DESIGNATED_INITIALIZER;

@end
```

方法1：

```objective-c
_chartView = [[XYChart alloc] initWithFrame:CGRectMake(0, 0, 300, 100)    
                                  chartType:XYChartTypeLine];
_chartView.dataSource = self;
_chartView.delegate = self;
[self.view addSubview:_chartView];
```

方法2：

```objective-c
// ChartGroup is the child of XYChartDataSourceItem
_datasource = [[ChartGroup alloc] initWithStyle:XYChartTypeBar section:2 row:15 width:60];

_chartView = [[XYChart alloc] initWithFrame:CGRectMake(0, 0, 300, 100)    
                                  chartType:XYChartTypeLine];
_chartView.dataSource = _datasource;
[self.view addSubview:_chartView];
```


### XYChartDataSource

```objective-c
@protocol XYChartDataSource

- (NSUInteger)numberOfSectionsInChart:(XYChart *)chart;

- (NSUInteger)numberOfRowsInChart:(XYChart *)chart;

- (NSAttributedString *)chart:(XYChart *)chart titleOfRowAtIndex:(NSUInteger)index;

- (NSAttributedString *)chart:(XYChart *)chart titleOfSectionAtValue:(CGFloat)sectionValue;

- (id<XYChartItem>)chart:(XYChart *)chart itemOfIndex:(NSIndexPath *)index;

- (XYRange)visibleRangeInChart:(XYChart *)chart;

- (NSUInteger)numberOfLevelInChart:(XYChart *)chart;

- (CGFloat)rowWidthOfChart:(XYChart *)chart;

- (BOOL)autoSizingRowInChart:(XYChart *)chart;

@end

```

### XYChartDelegate

```objective-c
@protocol XYChartDelegate

- (BOOL)chart:(XYChart *)chart shouldShowMenu:(NSIndexPath *)index;

- (void)chart:(XYChart *)chart itemDidClick:(id<XYChartItem>)item;

- (CAAnimation *)chart:(XYChart *)chart clickAnimationOfIndex:(NSIndexPath *)index;

@end
```
