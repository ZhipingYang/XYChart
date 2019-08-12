<p align="center">
<img align="center" width="150" src ="https://user-images.githubusercontent.com/9360037/43032646-0771fd3c-8cef-11e8-913f-034ca293c625.png"/>
</p>

<p align="center">
	<a href="http://cocoapods.org/pods/XYChart">
		<image alt="Version" src="https://img.shields.io/cocoapods/v/XYChart.svg?style=flat">
	</a>
	<a href="http://cocoapods.org/pods/XYChart">
		<image alt="License" src="https://img.shields.io/cocoapods/l/XYChart.svg?style=flat">
	</a>
	<a href="http://cocoapods.org/pods/XYChart">
		<image alt="Platform" src="https://img.shields.io/cocoapods/p/XYChart.svg?style=flat">
	</a>
	<a href="https://travis-ci.org/ZhipingYang/XYChart">
		<image alt="CI Status" src="http://img.shields.io/travis/ZhipingYang/XYChart.svg?style=flat">
	</a>
</p>

<br>

> **XYChart** is designed for line & bar of charts which can compare mutiple datas in form styles, and limited the range of values to show, and so on.

| **LineChart** | **BarChart** |
|:-------:|:---------:|
| ![WechatIMG65](https://user-images.githubusercontent.com/9360037/62707044-4671de00-ba23-11e9-9ddc-57509edba0dc.jpeg) | ![WechatIMG66](https://user-images.githubusercontent.com/9360037/62707048-47a30b00-ba23-11e9-90a9-c414a92da2cc.jpeg) |
| single datas in linechart | single datas in linechart |
| ![WechatIMG70](https://user-images.githubusercontent.com/9360037/62711726-20047080-ba2c-11e9-8890-022fe4e58df9.jpeg) | ![click](https://user-images.githubusercontent.com/9360037/62712419-5ee6f600-ba2d-11e9-9605-aeaba3097e9b.gif) |
| **LineDotsClicked:** show all if the dots closed in multi-datas | **BarClicked:** custom click effects in multi-datas |
| ![gif](https://user-images.githubusercontent.com/9360037/62709107-54c1f900-ba27-11e9-8312-8fcec88a58d5.gif) | ![gif](https://user-images.githubusercontent.com/9360037/62709087-48d63700-ba27-11e9-86f3-e92e4e1bd094.gif) |
| scrolling linechart (did set row width) | scrolling barchart (did set row width) |


## Install

> required `iOS >= 8.0` with [Cocoapods](https://cocoapods.org/)
> 
> ```ruby
> pod 'XYChart'
> ```

## Using

<details><summary> Expand for XYChart details </summary>
<br>

```objective-c
@interface XYChart : UIView<XYChartReload>

@property (nonatomic, weak, nullable) id<XYChartDataSource> dataSource;
@property (nonatomic, weak, nullable) id<XYChartDelegate> delegate;

@property (nonatomic, readonly) XYChartType chartType;

- (instancetype)initWithFrame:(CGRect)frame type:(XYChartType)type NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithType:(XYChartType)type;

/**
 更新图标数据
 
 @param dataSource 数据
 @param animation 是否执行动画
 */
- (void)setDataSource:(id<XYChartDataSource>)dataSource animation:(BOOL)animation;

/**
 重载数据
 
 @param animation 是否执行动画
 */
- (void)reloadData:(BOOL)animation;

@end
```

</details>


**Method 1：**

```objective-c
_chartView = [[XYChart alloc] initWithFrame:CGRectMake(0, 0, 300, 100) chartType:XYChartTypeLine];
_chartView.dataSource = self;
_chartView.delegate = self;
[self.view addSubview:_chartView];
```

**Method 2：**

```objective-c
// the obj follow the XYChartDataSource protocol
_datasource = [[XYChartDataSourceItem alloc] init];

_chartView = [[XYChart alloc] initWithType:XYChartTypeLine];
_chartView.dataSource = _datasource;
[self.view addSubview:_chartView];
```


<details open><summary> Expand for <bold>XYChartDelegate</bold> protocol details </summary>
<br>

```objective-c
@protocol XYChartDelegate
@optional

/**
 是否展示UIMenuController
 */
- (BOOL)chart:(XYChart *)chart shouldShowMenu:(NSIndexPath *)index;

/**
 点击后的action，重载一般就不show UIMenuController了
 */
- (void)chart:(XYChart *)chart itemDidClick:(id<XYChartItem>)item;

/**
 line用于展示圆圈，bar用于柱形图的动画
 */
- (CAAnimation *)chart:(XYChart *)chart clickAnimationOfIndex:(NSIndexPath *)index;

@end
```
</details>

<details><summary> Expand for XYChartDataSource protocol details </summary>
<br>

```objective-c
/**
 多套对比数据展示
 */
@protocol XYChartDataSource

/**
 多少条并行对比数据，折线图表现多条线，柱状图表现一列中有几条柱状图
 */
- (NSUInteger)numberOfSectionsInChart:(XYChart *)chart;

/**
 完整的周期内，数据的个数，横向列数
 */
- (NSUInteger)numberOfRowsInChart:(XYChart *)chart;

/**
 x坐标的标题
 */
- (NSAttributedString *)chart:(XYChart *)chart titleOfRowAtIndex:(NSUInteger)index;

/**
 x坐标的标题
 */
- (NSAttributedString *)chart:(XYChart *)chart titleOfSectionAtValue:(CGFloat)sectionValue;

/**
 index下的数据模型
 */
- (id<XYChartItem>)chart:(XYChart *)chart itemOfIndex:(NSIndexPath *)index;

/**
 标记y轴方向高亮区间
 */
- (XYRange)visibleRangeInChart:(XYChart *)chart;

/**
 y轴方向分段，5就分5段
 */
- (NSUInteger)numberOfLevelInChart:(XYChart *)chart;

/**
 横向一栏的宽度
 */
- (CGFloat)rowWidthOfChart:(XYChart *)chart;

/**
 自适应平均分横向栏目的宽度
 */
- (BOOL)autoSizingRowInChart:(XYChart *)chart;

@end
```
</details>



## Author

XcodeYang, xcodeyang@gmail.com

## License

XYChart is available under the MIT license. See the LICENSE file for more info.
