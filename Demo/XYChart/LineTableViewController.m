//
//  LineTableViewController.m
//  XYChart
//
//  Created by Daniel on 2018/7/22.
//  Copyright © 2018 Daniel. All rights reserved.
//

#import "LineTableViewController.h"
#import "TableViewCell.h"
#import "ChartGroup.h"

@interface LineTableViewController ()

@property (nonatomic, strong) NSArray <ChartGroup *>* dataArray;

@end

@implementation LineTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = @[
                   [[ChartGroup alloc] initWithStyle:XYChartTypeLine section:1 row:5],
                   [[ChartGroup alloc] initWithStyle:XYChartTypeLine section:1 row:15],
                   [[ChartGroup alloc] initWithStyle:XYChartTypeLine section:2 row:15],
                   [[ChartGroup alloc] initWithStyle:XYChartTypeLine section:3 row:5],
                   [[ChartGroup alloc] initWithStyle:XYChartTypeLine section:2 row:15 width:60],
                   [[ChartGroup alloc] initWithStyle:XYChartTypeLine section:2 row:33 width:40],
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

