//
//  ViewController.m
//  XYChart
//
//  Created by Daniel on 2018/7/22.
//  Copyright © 2018 Daniel. All rights reserved.
//

#import "BarTableViewController.h"
#import "RandomChartDataSource.h"
#import "ChartViewCell.h"

@interface BarTableViewController ()

@property (nonatomic, strong) NSArray <RandomChartDataSource *>* dataArray;

@end

@implementation BarTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[ChartViewCell class] forCellReuseIdentifier:barChartReuseIdentifier];
    
    _dataArray = @[
                   [[RandomChartDataSource alloc] initWithStyle:XYChartTypeBar section:1 row:5],
                   [[RandomChartDataSource alloc] initWithStyle:XYChartTypeBar section:1 row:12],
                   [[RandomChartDataSource alloc] initWithStyle:XYChartTypeBar section:2 row:5],
                   [[RandomChartDataSource alloc] initWithStyle:XYChartTypeBar section:3 row:5],
                   [[RandomChartDataSource alloc] initWithStyle:XYChartTypeBar section:4 row:12],
                   [[RandomChartDataSource alloc] initWithStyle:XYChartTypeBar section:2 row:15 width:60],
                   [[RandomChartDataSource alloc] initWithStyle:XYChartTypeBar section:4 row:56 width:80],
                   ];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChartViewCell *cell = [tableView dequeueReusableCellWithIdentifier:barChartReuseIdentifier];
    cell.dataSource = _dataArray.xy_safeIdx(indexPath.row);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

@end

