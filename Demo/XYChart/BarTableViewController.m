//
//  ViewController.m
//  XYChart
//
//  Created by Daniel on 2018/7/22.
//  Copyright © 2018 Daniel. All rights reserved.
//

#import "BarTableViewController.h"
#import "TableViewCell.h"
#import "ChartGroup.h"

@interface BarTableViewController ()

@property (nonatomic, strong) NSArray <ChartGroup *>* dataArray;

@end

@implementation BarTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = @[
                   [[ChartGroup alloc] initWithStyle:XYChartTypeBar section:1 row:5],
                   [[ChartGroup alloc] initWithStyle:XYChartTypeBar section:1 row:12],
                   [[ChartGroup alloc] initWithStyle:XYChartTypeBar section:2 row:5],
                   [[ChartGroup alloc] initWithStyle:XYChartTypeBar section:3 row:5],
                   [[ChartGroup alloc] initWithStyle:XYChartTypeBar section:4 row:6],
                   [[ChartGroup alloc] initWithStyle:XYChartTypeBar section:2 row:15 width:60],
                   [[ChartGroup alloc] initWithStyle:XYChartTypeBar section:4 row:16 width:80],
                   ];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TableViewCell class])];
    cell.group = _dataArray.xy_safeIdx(indexPath.row);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

@end

