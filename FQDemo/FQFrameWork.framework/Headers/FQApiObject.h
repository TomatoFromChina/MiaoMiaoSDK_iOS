//
//  FQApiObject.h
//  MiaoMiaoBluetoothDemo
//
//  Created by xuliusheng on 2017/10/26.
//  Copyright © 2017年 fanqie. All rights reserved.
//

#import <Foundation/Foundation.h>

enum  FQErrCode {
    FQSuccess           = 0,    /**< 成功    */
    FQErrCodeCommon     = -1,   /**< 普通错误类型    */
};
enum  FQRespType {
    FQUnAuthed           =  1,    /**未成功认证*/
    FQReceived           =  0,    /**< 收到数据  */
    FQUnRead             = -1,    /**< 未读到探头*/
    FQChange             = -2,    /**< 更换探头  */
    FQExpired            = -3,    /**< 探头已过期 */
    FQUnStart            = -4,    /**< 探头未启动 */
    FQDamage             = -5,    /**< 探头已损坏 */
    FQSetIntervalSuccess = -6,    /**< 设置时间间隔成功 */
    FQSetIntervalFail    = -7,    /**< 设置时间间隔失败 */
};

enum FQTrendType{
    FQUpward            = 0,     /* 0急速上升，    ↑ */
    FQObliqueUpward,            /* 1斜向上 45度， ↗ */
    FQFlat,                     /* 2稳定的血糖 ，  → */
    FQObliqueDown,              /* 3斜向下 45度， ↘ */
    FQDown,                      /* 4直线下降     ↓ */
};


@interface FQApiObject : NSObject

@end

@interface FQBaseResp : NSObject

@property (nonatomic, assign) NSInteger errCode;    /** 错误码 */
@property (nonatomic, assign) enum FQRespType type; /** 响应类型 */
@property (nonatomic, strong) NSString *errStr;     /** 错误提示字符串 */


/*-------------------type == FQReceived 以下字段有效---------------------------*/

@property (nonatomic,assign)  NSInteger counter;          /*探头当期计数 用于剩余时间计算*/
@property (nonatomic, assign) float latestGlycemic;     /**最新血糖值*/
@property (nonatomic, assign) enum  FQTrendType trend;   /** 趋势箭头 */
@property (nonatomic, assign) float rate;               /** 变化速率 */
@property (nonatomic, strong) NSArray *oneMinArr;       /**一分钟血糖数据数组*/
@property (nonatomic, strong) NSArray *fifteenMinArr;    /**十五分钟血糖数据数组*/

@property (nonatomic, assign) NSInteger battery;         /**剩余电量*/
@property (nonatomic, assign) NSInteger frimVersion;     /**固件版本号*/

@property (nonatomic, strong) NSString  *uid;            /**探头ID*/



@end

@interface CGMObject : NSObject
@property (nonatomic,strong)  NSDate * date;
@property (nonatomic,assign)  float glycemic;
@property (nonatomic,assign)  NSInteger count;
@property (nonatomic,copy)    NSString *uid;
@property (nonatomic,strong)  NSString *rawGlycemic;
@end





