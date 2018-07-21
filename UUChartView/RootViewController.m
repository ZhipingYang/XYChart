//
//  RootViewController.m
//  UUChartView
//
//  Created by shake on 15/1/4.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import "RootViewController.h"
#import "TableViewCell.h"
#import "UUChartGroup.h"

@interface RootViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *chartTableView;

@property (nonatomic, strong) NSArray <NSArray <UUChartGroup *>*>* dataArray;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"UUChartView";
    
    _dataArray = @[
                   @[
                       [[UUChartGroup alloc] initWithStyle:UUChartStyleLine section:1 row:5],
                       [[UUChartGroup alloc] initWithStyle:UUChartStyleLine section:1 row:15],
                       [[UUChartGroup alloc] initWithStyle:UUChartStyleLine section:2 row:15],
                       [[UUChartGroup alloc] initWithStyle:UUChartStyleLine section:3 row:5],
                       [[UUChartGroup alloc] initWithStyle:UUChartStyleLine section:2 row:15 width:60],
                       [[UUChartGroup alloc] initWithStyle:UUChartStyleLine section:2 row:33 width:40],
                       ],
                   @[
                       [[UUChartGroup alloc] initWithStyle:UUChartStyleBar section:1 row:5],
                       [[UUChartGroup alloc] initWithStyle:UUChartStyleBar section:1 row:12],
                       [[UUChartGroup alloc] initWithStyle:UUChartStyleBar section:2 row:5],
                       [[UUChartGroup alloc] initWithStyle:UUChartStyleBar section:3 row:5],
                       [[UUChartGroup alloc] initWithStyle:UUChartStyleBar section:4 row:6],
                       [[UUChartGroup alloc] initWithStyle:UUChartStyleBar section:2 row:15 width:60],
                       [[UUChartGroup alloc] initWithStyle:UUChartStyleBar section:4 row:6 width:80],
                       ]
                   ];
    
    NSString *cellName = NSStringFromClass([TableViewCell class]);
    [self.chartTableView registerNib:[UINib nibWithNibName:cellName bundle:nil] forCellReuseIdentifier:cellName];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadNewData)];
}

- (void)reloadNewData
{
    _dataArray = @[
                   @[
                       [[UUChartGroup alloc] initWithStyle:UUChartStyleLine section:1 row:5],
                       [[UUChartGroup alloc] initWithStyle:UUChartStyleLine section:1 row:15],
                       [[UUChartGroup alloc] initWithStyle:UUChartStyleLine section:2 row:15],
                       [[UUChartGroup alloc] initWithStyle:UUChartStyleLine section:3 row:5],
                       [[UUChartGroup alloc] initWithStyle:UUChartStyleLine section:2 row:15 width:60],
                       [[UUChartGroup alloc] initWithStyle:UUChartStyleLine section:2 row:33 width:40],
                       ],
                   @[
                       [[UUChartGroup alloc] initWithStyle:UUChartStyleBar section:1 row:5],
                       [[UUChartGroup alloc] initWithStyle:UUChartStyleBar section:1 row:12],
                       [[UUChartGroup alloc] initWithStyle:UUChartStyleBar section:2 row:5],
                       [[UUChartGroup alloc] initWithStyle:UUChartStyleBar section:3 row:5],
                       [[UUChartGroup alloc] initWithStyle:UUChartStyleBar section:4 row:6],
                       [[UUChartGroup alloc] initWithStyle:UUChartStyleBar section:2 row:15 width:60],
                       [[UUChartGroup alloc] initWithStyle:UUChartStyleBar section:4 row:6 width:80],
                       ]
                   ];
    [self.chartTableView reloadData];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.safeIndex(section).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TableViewCell class])];
    cell.group = _dataArray.safeIndex(indexPath.section).safeIndex(indexPath.row);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 40);
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:30];
    label.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
    label.text = section ? @"Bar":@"Line";
    label.textColor = [UIColor colorWithRed:0.257 green:0.650 blue:0.478 alpha:1.000];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
