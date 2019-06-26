//
//  LineTableViewController.m
//  XYChart
//
//  Created by Daniel on 2018/7/22.
//  Copyright © 2018 Daniel. All rights reserved.
//

#import "LineTableViewController.h"
#import "RandomChartDataSource.h"
#import "ChartViewCell.h"

@interface LineTableViewController ()

@property (nonatomic, strong) NSArray <RandomChartDataSource *>* dataArray;

@end

@implementation LineTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[ChartViewCell class] forCellReuseIdentifier:lineChartReuseIdentifier];

    _dataArray = @[
                   [[RandomChartDataSource alloc] initWithStyle:XYChartTypeLine section:1 row:5],
                   [[RandomChartDataSource alloc] initWithStyle:XYChartTypeLine section:1 row:15],
                   [[RandomChartDataSource alloc] initWithStyle:XYChartTypeLine section:2 row:15],
                   [[RandomChartDataSource alloc] initWithStyle:XYChartTypeLine section:3 row:5],
                   [[RandomChartDataSource alloc] initWithStyle:XYChartTypeLine section:2 row:15 width:60],
                   [[RandomChartDataSource alloc] initWithStyle:XYChartTypeLine section:2 row:33 width:40],
                   ];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChartViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lineChartReuseIdentifier];
    cell.dataSource = _dataArray.xy_safeIdx(indexPath.row);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

@end

