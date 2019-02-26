//
//  TableViewController.m
//  FIrst
//
//  Created by zb on 2019/1/7.
//  Copyright © 2019 zb. All rights reserved.
//

#import "TableViewController.h"
#import "TableSectionData.h"

@interface TableViewController(){
    NSMutableArray *dataSource;
}
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TableSectionData *data1 = [TableSectionData initDataWithHeader:@"header1" Footer:@"footer1" Rows:@[@"11"]];
    TableSectionData *data2 = [TableSectionData initDataWithHeader:@"header2" Footer:@"footer2" Rows:@[@"21",@"22"]];
    TableSectionData *data3 = [TableSectionData initDataWithHeader:@"header3" Footer:@"footer3" Rows:@[@"31",@"32",@"33"]];
    
    
    NSArray *array = @[data1,data2,data3];
    dataSource = [NSMutableArray arrayWithArray:array];
    self.tableView.allowsSelection = YES;
    //    self.tableView.dataSource = self;
}

#pragma mark - 有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataSource.count;
}

#pragma mark - 第section组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataSource[section] rows].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = [dataSource[indexPath.section] rows] [indexPath.row];
    //    UIColor *color = [[UIColor alloc]initWithRed:1.0 green:0.0 blue:0.0 alpha:1];
    //    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    //    cell.selectedBackgroundView.backgroundColor = color;
    //blue 不起作用
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [dataSource[section] header] ;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return [dataSource[section] footer];
}

#pragma mark - select点击函数
//首先要self.tableView.allowsSelection = YES;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"第%ld组第%ld行选中",indexPath.section+1,indexPath.row+1);
}

#pragma mark - 取消select点击
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"第%ld组第%ld行取消选中",indexPath.section+1,indexPath.row+1);
}

#pragma mark - 左滑删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //    NSMutableArray *datas = dataSource;
    [[dataSource[indexPath.section] rows] removeObjectAtIndex:indexPath.row];
    if([dataSource[indexPath.section] rows].count == 0){
        [dataSource removeObjectAtIndex:indexPath.section];
        [self.tableView deleteSections: [NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationTop];
    } else
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    if(dataSource.count == 0){
        //内容为空出栈
        [self.navigationController popViewControllerAnimated:true];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

@end
