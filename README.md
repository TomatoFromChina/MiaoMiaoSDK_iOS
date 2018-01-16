# MiaoMiaoSDK_iOS
喵喵读取器iOS接入demo及SDK

## 简介
喵喵组件SDK的基础库，当前只支持手动集成。
iOS支持版本：8.0+

## 依赖库
```
libsqlite.tbd  数据缓存
CoreBluetooth  蓝牙核心库
```
## 集成
- 解压.zip文件得到FQFrameWork组件
- Xcode **File** —> **Add Files to **"Your project" ，在弹出Panel选中解压的组件包－> **Add**。（注：选中 **Copy items if needed**）
- 添加依赖库，在项目设置**target** -> 选项卡 **General**-> **Linked Frameworks and Libraries**
 如下：

![导入番茄framwork](https://static.oschina.net/uploads/img/201711/02175110_FK4p.png "add Libraries")

- 项目使用蓝牙后台模式 Xcode **TARGETS** —> **Capabilties ** -> **Background Modes** 开启。
 如下：

![开启蓝牙后台](https://static.oschina.net/uploads/img/201711/03144056_WRpF.png "Background Modes")

## SDK初始化
这里是列表文本在工程的 **AppDelegate.m** 文件中引入相关组件头文件 ，且在 ```application:didFinishLaunchingWithOptions:``` 方法中添加如下代码：
```
#import <FQFrameWork/FQApi.h>
#import <CoreBluetooth/CoreBluetooth.h>
```
```
[FQApi registerApp:@"your appId" secret:@"your secret"];
```
在AppDelegate.m实现以下方法
```
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
    NSLog(@"返回数据");
}
```
开始搜索蓝牙设备
```
+(void)startScaning;
```
根据MAC地址连接蓝牙外设
```
+(void)connectWithMAC:(NSString *)MAC;
```
根据MAC地址断开连接中的外设
```
+(void)cancelConnectWithMAC:(NSString *)MAC;
```
## 注意事项
1. APP在开发过程中需先调用```+(void)startScaning```获取**MAC**地址，后用```+(void)connectWithMAC:(NSString *)MAC``` 连接。之后可通过**MAC**地址直接连接。
2. SDK封装了蓝牙重连机制，蓝牙因断电，信号强度等原因断开后会自动重连，相应状态也会在APPDelegate中回调。
3. 所有业务数据通过```- (void)fqResp:(BaseResp*)resp``` 返回，其中当 ```FQRespType type == FQReceived```时返回有效的业务数据。数据格式及详细字段参见```FQApiObject.h```。
4. 用户在更换探头时APP需给出对应交互。调用```+(void)confirmChange```确认更换，不确认则会一直收到```FQChange```状态。更换后会返回新探头的数据。
5. oneMinArr用于返回探头内部每分钟的详细数据(每次返回10个最新值)。探头每15min会求一个平均值，平均值通过fifteenMinArr数组返回（返回数量不固定、蓝牙正常连接每15min返回5个平均值，蓝牙长时间断开会根据断开时间计算返回数量）。开发者做数据存储时需根据CGMObject中的count字段做过滤处理。
6. 当搜索到的设备名称为"miaomiaoA"时需喵喵处于BootLoader模式，此时需对喵喵进行强制升级。
7. ```- (void)fqConnectSuccess:(CBPeripheral *)peripheral updateDict:(NSDictionary *)updateDict``` 其中 updateDict 为固件升级时使用，需升级时 updateDict返回3对key:value 
例如：
```
 {
    currentFirmNumber = 51;//当前固件版本
    latestFirmNumber = 53; //最新固件版本
    firmDowloadUrl = "http://dl.fanqies.com/app/06a10a63-c4d4-4ae3-a8a7-cd897df84975.zip";//固件下载地址
 }
```
 无需升级时 updateDict == nil


## 技术支持
请在Gitter聊天室留言：https://gitter.im/miaomiaoSDK/Lobby
有问题请尽快与番茄开发团队联系，请提供您的appkey及console中的详细出错日志，您所提供的内容越详细越有助于我们帮您解决问题！
