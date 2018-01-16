//
//  AppDelegate.m
//  FQDemo
//
//  Created by xuliusheng on 2017/11/2.
//  Copyright © 2017年 fanqie. All rights reserved.
//

#import "AppDelegate.h"
#import <FQFrameWork/FQApi.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [FQApi registerApp:@"1000002" secret:@"1234567890abcdef"];
    
    /*
      首次搜索将蓝牙的MAC地址保存起来，以后可直接连接
      [FQApi connectWithMAC:@"D4973DFEA21C"];
    */
    

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma 番茄SDK蓝牙回调函数

/**
 搜索到蓝牙(喵喵)设备后触发
 @param peripheral 喵喵硬件
 @param centralManager 蓝牙centralManager(升级用)
 @param RSSI 信号强度
 @param firmVersion 固件版本号
 @param MAC 喵喵MAC地址
 */
- (void)fqFoundPeripheral:(CBPeripheral *)peripheral
           centralManager:(CBCentralManager *)centralManager
                     RSSI:(NSNumber *)RSSI
              firmVersion:(NSString *)firmVersion
                      MAC:(NSString *)MAC{
    
    if ([peripheral.name  isEqualToString:@"miaomiaoA"]) {
        /*
         接厂商SDK升级
         */
        NSLog(@"喵喵蓝牙为BootLoader模式，需强制用户升级");
        return;
    }
    
    ViewController *rootVC = (ViewController *)self.window.rootViewController;
    [rootVC.peripheralDict setObject:peripheral forKey:MAC];
    [rootVC.tableView reloadData];
}

/**
 连接成功回调的方法
 
 @param peripheral 连接中的蓝牙设备
 @param centralManager 蓝牙centralManager
 @param updateDict 升级相关信息
 需更新时 updateDict 包含3对key:value
 例如：
 currentFirmNumber：当前固件版本
 latestFirmNumber：最新固件版本
 firmDowloadUrl：固件下载地址
 {
 currentFirmNumber = 51;
 firmDowloadUrl = "http://dl.fanqies.com/app/06a10a63-c4d4-4ae3-a8a7-cd897df84975.zip";
 latestFirmNumber = 53;
 }
 无需更新时 updateDict == nil
 
 
 */
- (void)fqConnectSuccess:(CBPeripheral *)peripheral
          centralManager:(CBCentralManager *)centralManager
              updateDict:(NSDictionary *)updateDict {
    NSLog(@"连接成功");
}
- (void)fqConnectFailed {
    NSLog(@"连接失败");
}
- (void)fqDisConnected {
    NSLog(@"连接断开");
}

#pragma 番茄SDK 数据回调
- (void)fqResp:(FQBaseResp*)resp{
    
    enum FQRespType type = resp.type;
    NSString *msg = @"";
    switch (type) {
            
        case FQUnAuthed:
            msg = @"SDK未认证";
            break;
        case FQUnStart:
            msg = @"探头未启动";
            break;
        case FQUnRead:
            msg = @"未读到探头";
            break;
        case FQChange:{
            msg = @"是否更换？";
            [self ifChange];
        }
            break;
        case FQExpired:
            msg = @"探头已过期";
            break;
        case FQDamage:
            msg = @"探头已损坏";
            break;
            
        case FQReceived:{
            NSArray *fifteenArr = resp.fifteenMinArr;
            for (CGMObject *obj in fifteenArr) {
                NSLog(@"obj--->%@count-->%ld",obj,obj.count);
            }
            msg = @"获得数据";
        }
            break;
        default:
            break;
    }
    [self showAlertView:msg];
}


- (void)showAlertView:(NSString *)msg{
    //    FQLog(@">>>%@",msg);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self.window.rootViewController presentViewController:alert animated:YES completion:^{
    }];
}

- (void)ifChange{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"是否更换探头" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"更换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [FQApi confirmChange]; //确认更换探头 更换成功后会主动获取新探头的数据
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self.window.rootViewController presentViewController:alert animated:YES completion:^{
    }];
}


@end
