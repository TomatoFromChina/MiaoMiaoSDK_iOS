//
//  ViewController.h
//  FQDemo
//
//  Created by xuliusheng on 2017/11/2.
//  Copyright © 2017年 fanqie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FQFrameWork/FQApi.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableDictionary *peripheralDict;

@end

