<p align="center">

<img align="center" width="150" src ="https://user-images.githubusercontent.com/9360037/43032646-0771fd3c-8cef-11e8-913f-034ca293c625.png"/>
</p>

> **XYChart** is designed for line & bar of charts which can compare mutiple datas in form styles, and limited the range of values to show, and so on.


| **LineChart** | **BarChart** |
|:-------:|:---------:|
| ![WechatIMG65](https://user-images.githubusercontent.com/9360037/62707044-4671de00-ba23-11e9-9ddc-57509edba0dc.jpeg) | ![WechatIMG66](https://user-images.githubusercontent.com/9360037/62707048-47a30b00-ba23-11e9-90a9-c414a92da2cc.jpeg) |
| single datas in linechart | single datas in linechart |
| ![WechatIMG67](https://user-images.githubusercontent.com/9360037/62707045-470a7480-ba23-11e9-87c9-25d8b8df1d7b.jpeg) | ![WechatIMG68](https://user-images.githubusercontent.com/9360037/62707047-470a7480-ba23-11e9-9ea1-687185c04f74.jpeg) |
| mutiple datas in linechart | mutiple datas in linechart |
| ![WechatIMG70](https://user-images.githubusercontent.com/9360037/62711726-20047080-ba2c-11e9-8890-022fe4e58df9.jpeg) | ![click](https://user-images.githubusercontent.com/9360037/62712419-5ee6f600-ba2d-11e9-9605-aeaba3097e9b.gif) |
| **LineDotsClicked:** show all if the dots closed | **BarClicked:** custom click effects |
| ![gif](https://user-images.githubusercontent.com/9360037/62709107-54c1f900-ba27-11e9-8312-8fcec88a58d5.gif) | ![gif](https://user-images.githubusercontent.com/9360037/62709087-48d63700-ba27-11e9-86f3-e92e4e1bd094.gif) |
| scrolling linechart (did set row width) | scrolling barchart (did set row width) |

## Usage


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
_chartView = [[XYChart alloc] initWithFrame:CGRectMake(0, 0, 300, 100) chartType:XYChartTypeLine];
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

// 多少条并行对比数据，折线图表现多条线，柱状图表现一列中有几条柱状图
- (NSUInteger)numberOfSectionsInChart:(XYChart *)chart;

// 完整的周期内，数据的个数，横向列数
- (NSUInteger)numberOfRowsInChart:(XYChart *)chart;

// x坐标的标题
- (NSAttributedString *)chart:(XYChart *)chart titleOfRowAtIndex:(NSUInteger)index;

// y坐标的标题
- (NSAttributedString *)chart:(XYChart *)chart titleOfSectionAtValue:(CGFloat)sectionValue;

// index下的数据模型
- (id<XYChartItem>)chart:(XYChart *)chart itemOfIndex:(NSIndexPath *)index;

// 标记y轴方向高亮区间
- (XYRange)visibleRangeInChart:(XYChart *)chart;

// y轴方向分段，5就分5段
- (NSUInteger)numberOfLevelInChart:(XYChart *)chart;

// 横向一栏的宽度
- (CGFloat)rowWidthOfChart:(XYChart *)chart;

// 自适应平均分横向栏目的宽度
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
