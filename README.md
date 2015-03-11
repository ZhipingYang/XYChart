UUChartView
===========

Line and Bar charts. You can mark the range of values you want, and show the max or min values in linechart.

![Flipboard playing multiple GIFs](https://github.com/ZhipingYang/UUChartView/raw/master/UUChartViewTests/UUChartView.gif)

## Introduction
  
 * UUChart
 * UULineChart
 * UUBarChart
 * UUColor
 * UUBar
 
## Usage

### init

    -(id)initwithUUChartDataFrame:(CGRect)rect 
                       withSource:(id<UUChartDataSource>)dataSource 
                        withStyle:(UUChartStyle)style;

#### Select from two styles for UUChartView:

    UUChartLineStyle
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

####Additional options available for UUChartLineStyle

    //Mark the range of values with grayColor if you need
    - (CGRange)UUChartMarkRangeInLineChart:(UUChart *)chart;

    //You can choose horizonLine which you want to show
    - (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index;

    // Show the label on the max and min values with their colors.
    - (BOOL)UUChart:(UUChart *)chart ShowMaxMinAtIndex:(NSInteger)index;

#### UUChart, based on kevinzhow's [PNChart](https://github.com/kevinzhow/PNChart), was created on 2014-7-24, although UUChart is now very different from PNChart.


### Demo

    chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, 150)
                                              withSource:self
                                               withStyle:indexPath.section==1?UUChartBarStyle:UUChartLineStyle];
    [chartView showInView:self.contentView];

//Horizontal Axis Label

    - (NSArray *)UUChart_xLableArray:(UUChart *)chart
    {
	    if (path.section==0) {
	        switch (path.row) {
	            case 0:
	                return [self getXTitles:5];
	            case 1:
	                return [self getXTitles:11];
	            case 2:
	                return [self getXTitles:7];
	            case 3:
	                return [self getXTitles:7];
	            default:
	                break;
	        }
	    }else{
	        switch (path.row) {
	            case 0:
	                return [self getXTitles:11];
	            case 1:
	                return [self getXTitles:7];
	            default:
	                break;
	        }
	    }
	    return [self getXTitles:20];
    }
    - (NSArray *)getXTitles:(int)num
	{
	    NSMutableArray *xTitles = [NSMutableArray array];
	    for (int i=0; i<num; i++) {
	        NSString * str = [NSString stringWithFormat:@"R-%d",i];
	        [xTitles addObject:str];
	    }
	    return xTitles;
	}	
	
//Creating multiple array values (note the datatype)

    - (NSArray *)UUChart_yValueArray:(UUChart *)chart
    {
	    NSArray *ary = @[@"22",@"44",@"15",@"40",@"42"];
	    NSArray *ary1 = @[@"22",@"54",@"15",@"30",@"42",@"77",@"43"];
	    NSArray *ary2 = @[@"76",@"34",@"54",@"23",@"16",@"32",@"17"];
	    NSArray *ary3 = @[@"3",@"12",@"25",@"55",@"52"];
	    NSArray *ary4 = @[@"23",@"42",@"25",@"15",@"30",@"42",@"32",@"40",@"42",@"25",@"33"];
	
	    if (path.section==0) {
	        switch (path.row) {
	            case 0:
	                return @[ary];
	            case 1:
	                return @[ary4];
	            case 2:
	                return @[ary1,ary2];
	            default:
	                return @[ary1,ary2,ary3];
	        }
	    }else{
	        if (path.row) {
	            return @[ary1,ary2];
	        }else{
	            return @[ary4];
	        }
	    }
    }

//Array of colors

    - (NSArray *)UUChart_ColorArray:(UUChart *)chart
    {
        return @[UUGreen,UURed,UUBrown];
    }

//Choose line chart range

    - (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart
    {
	    if (path.section==0 && (path.row==0|path.row==1)) {
	        return CGRangeMake(60, 10);
	    }
	    if (path.section==1 && path.row==0) {
	        return CGRangeMake(60, 10);
	    }
	    if (path.row==2) {
	        return CGRangeMake(100, 0);
	    }
	    return CGRangeZero;
    }

#### Features only available for line charts

   //Ability to declare line chart range

    - (CGRange)UUChartMarkRangeInLineChart:(UUChart *)chart
    {
       if (path.row==2) {
           return CGRangeMake(25, 75);
        }
      return CGRangeZero;
    }

  //Display horizontal line

    - (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index
    {
        return YES;
    }

  //Determine the minimum and maximum display

    - (BOOL)UUChart:(UUChart *)chart ShowMaxMinAtIndex:(NSInteger)index
    {
        return path.row==2;
    }
