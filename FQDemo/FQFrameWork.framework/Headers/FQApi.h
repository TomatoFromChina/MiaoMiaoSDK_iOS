//
//  FQApi.h
//  MiaoMiaoBluetoothDemo
//
//  Created by xuliusheng on 2017/10/24.
//  Copyright © 2017年 fanqie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FQApiObject.h"

@interface FQApi : NSObject

/*
 * 需要在每次启动第三方应用程序时调用。
 * @attention 请保证在主线程中调用此函数
 * @param appid 喵喵开发者ID
 */
+(void)registerApp:(NSString *)appid secret:(NSString *)secret;

/**
 开始搜索
 */
+(void)startScaning;
/**
 停止搜索
 */
+(void)stopScaning;

/**
 通过MAC地址连接喵喵
 @param MAC 搜索中返回的MAC地址
 开发过程中可通过搜索获取
 */
+(void)connectWithMAC:(NSString *)MAC;

/**
 通过MAC地址断开于喵喵的连接
 @param MAC  蓝牙MAC地址
 */
+(void)cancelConnectWithMAC:(NSString *)MAC;

/*
 确认更换探头
 */
+(void)confirmChange;



@end
