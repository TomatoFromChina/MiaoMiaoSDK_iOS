//
//  ViewController.m
//  FQDemo
//
//  Created by xuliusheng on 2017/11/2.
//  Copyright © 2017年 fanqie. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSIndexPath *_selectIndexPath;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.peripheralDict = [NSMutableDictionary dictionaryWithCapacity:2];
    

}
- (IBAction)startScan:(id)sender {
    //开始扫描
    [FQApi startScaning];
}
//- (IBAction)stopScan:(id)sender {
//    //停止扫描
//    [FQApi stopScaning];
//}
- (IBAction)connectWithMac:(id)sender {
    //通过Mac地址直接连接
    [FQApi connectWithMAC:@"D4973DFEA21C"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -tableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.peripheralDict.allKeys.count;
}


#pragma mark -tableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    //checkmark
    if (indexPath == _selectIndexPath) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    NSString *UUIDString = [self.peripheralDict.allKeys objectAtIndex:indexPath.row];
    cell.textLabel.text = UUIDString;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"设备列表(点击cell连接设备)";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_selectIndexPath == indexPath) {
        NSLog(@"已连接");
        return;
    }
    _selectIndexPath = indexPath;
    [self.tableView reloadData];
    
    NSString *MAC = [self.peripheralDict.allKeys objectAtIndex:indexPath.row];
    //连接选择的设备
    [FQApi connectWithMAC:MAC];
}

@end
