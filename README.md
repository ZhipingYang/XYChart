UUChartView
===========

Line and Bar of Chart, you can mark the range of value you want, and show the max or min values in linechart

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
####required

    - (NSArray *)UUChart_xLableArray:(UUChart *)chart;
    //The target array's object's class is equal to NSArray
    - (NSArray *)UUChart_yValueArray:(UUChart *)chart;
    
####optional

    // the colors for lines and bars.
    - (NSArray *)UUChart_ColorArray:(UUChart *)chart;
    //CGRange CGRangeMake(CGFloat max, CGFloat min);
    - (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart;

####Only apply in lineChart

    //Mark the range of values with grayColor if you need
    - (CGRange)UUChartMarkRangeInLineChart:(UUChart *)chart;
    
    //You can choose horizonLine which you want to show
    - (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index;
    
    // Show the label on the max and min values with their colors.
    - (BOOL)UUChart:(UUChart *)chart ShowMaxMinAtIndex:(NSInteger)index;



### Demo

    chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, 150)
                                              withSource:self
                                               withStyle:indexPath.section==1?UUChartBarStyle:UUChartLineStyle];
    [chartView showInView:self.contentView];


    - (NSArray *)UUChart_xLableArray:(UUChart *)chart
    {
      if (path.row==0 && path.section==0) {
          return @[@"one",@"two",@"three",@"four",@"five"];
      }
       return @[@"one",@"two",@"three",@"four",@"five",@"six",@"seven"];
    }
//数值多重数组

    - (NSArray *)UUChart_yValueArray:(UUChart *)chart
    {
       NSArray *ary = @[@"22",@"44",@"15",@"40",@"42"];
       NSArray *ary1 = @[@"22",@"54",@"15",@"30",@"42",@"77",@"43"];
       NSArray *ary2 = @[@"76",@"34",@"54",@"23",@"16",@"32",@"17"];
       NSArray *ary3 = @[@"3",@"12",@"25",@"55",@"52"];
       return @[ary1,ary2,ary3];
    }
    #pragma mark - @optional
//颜色数组

    - (NSArray *)UUChart_ColorArray:(UUChart *)chart
    {
        return @[UUGreen,UURed,UUBrown];
    }
//显示数值范围

    - (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart
    {
         if (path.row==0) {
            return CGRangeMake(60, 10);
         }
         if (path.row==2) {
              return CGRangeMake(100, 0);
      }
      return CGRangeZero;
    }
#### 折线图专享功能

    //标记数值区域
    - (CGRange)UUChartMarkRangeInLineChart:(UUChart *)chart
    {
       if (path.row==2) {
           return CGRangeMake(25, 75);
        }
      return CGRangeZero;
    }

//判断显示横线条

    - (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index
    {
        return YES;
    }

//判断显示最大最小值

    - (BOOL)UUChart:(UUChart *)chart ShowMaxMinAtIndex:(NSInteger)index
    {
        return path.row==2;
    }
