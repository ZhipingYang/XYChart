//
//  TableViewCell.h
//  UUChartView
//
//  Created by shake on 15/1/4.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RandomChartDataSource.h"

extern NSString *const lineChartReuseIdentifier;
extern NSString *const barChartReuseIdentifier;

@interface ChartViewCell : UITableViewCell

@property (nonatomic, strong) RandomChartDataSource *group;

@end
