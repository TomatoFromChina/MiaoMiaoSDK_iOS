# MiaoMiaoSDK_iOS
Meow reader iOS access demo and SDK

## Introduction
Meow component SDK base library, currently only supports manual integration. iOS Support Version: 8.0+

## depend on  library
```
libsqlite.tbd
CoreBluetooth
```
## Integrated
- An official application is required for certification ,you will get your appId & your secret
- Extract the .zip file to get the FQFrameWork component
- Xcode File -> ** Add Files to ** "Your project", in the pop-up Panel selected extract the package -> Add . (Note: selected Copy items if needed )
- Add dependent libraries, set the target -> tab in the project General -> Linked Frameworks and Libraries as
follows:

![Import framwork](https://static.oschina.net/uploads/img/201711/02175110_FK4p.png "add Libraries")

- Project using Bluetooth background mode Xcode TARGETS -> ** Capabilties ** -> Background Modes open. as
follows:：

![Open BlueTooth Background](https://static.oschina.net/uploads/img/201711/03144056_WRpF.png "Background Modes")

## SDK Initialization
Here is a list of text in a AppDelegate.m introducing header file associated components and under  ```application:didFinishLaunchingWithOptions:``` add the following code in the method:
```
#import <FQFrameWork/FQApi.h>
#import <CoreBluetooth/CoreBluetooth.h>
```
```
[FQApi registerApp:@"your appId" secret:@"your secret"];
```
The following methods are implemented in AppDelegate.m
```
/**
搜索到蓝牙(喵喵)设备后触发
@param peripheral 喵喵硬件
@param centralManager 蓝牙centralManager(for firmware upload)
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
需更新时 updateDict 包含3对(key:value)
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
NSLog(@"connectSuccess");
}
- (void)fqConnectFailed {
NSLog(@"connectFailed");
}
- (void)fqDisConnected {
NSLog(@"disConnected");
}

#pragma 番茄SDK 数据回调
- (void)fqResp:(FQBaseResp*)resp{
NSLog(@"getData");
}
```
Start searching for Bluetooth devices
```
+(void)startScaning;
```
Connect Bluetooth peripherals based on MAC address
```
+(void)connectWithMAC:(NSString *)MAC;
```
Disconnect peripherals based on MAC address
```
+(void)cancelConnectWithMAC:(NSString *)MAC;
```
## Precautions
1. APP in the development process must first call to```+(void)startScaning```get the MAC address, after the```+(void)connectWithMAC:(NSString *)MAC``` connection. After the MAC address can be directly connected.
2. SDK package Bluetooth reconnection mechanism, Bluetooth due to power outages, signal strength and other reasons will disconnect automatically reconnect, the corresponding state will callback in the APPDelegate.
3. All traffic data```- (void)fqResp:(BaseResp*)resp``` returned, wherein when  ```FQRespType type == FQReceived```return valid service data. See the data format and detailed fields```FQApiObject.h```.
4. When the user changes the probe, the APP needs to give the corresponding interaction. Call to```+(void)confirmChange```confirm replacement, do not confirm will always receive the  ```FQChange``` status. After replacement will return to the new probe data.
5. oneMinArr returns minute data inside the probe (10 newest values ​​returned). The probe will seek an average value every 15 minutes. The average value is returned through the fifteenMinArr array (the number of returns is not fixed. The normal connection of Bluetooth returns five averages every 15 minutes. The Bluetooth long-time disconnection will calculate the return quantity according to the disconnection time). Developers need to do data storage filtering based on the count field CGMObject.
6. When the searched device name is "miaomiaoA", it needs meow to be in BootLoader mode, at this moment, meow meow needs to be forcibly upgraded.
7. ```- (void)fqConnectSuccess:(CBPeripheral *)peripheral updateDict:(NSDictionary *)updateDict``` Which updateDict is used for firmware upgrade, updateDict need to upgrade 3 pairs of key: value
For example:
```
{
currentFirmNumber = 51;//Current Firmware Version Number
latestFirmNumber = 53; //Latest Firmware Version Number
firmDowloadUrl = "http://dl.fanqies.com/app/06a10a63-c4d4-4ae3-a8a7-cd897df84975.zip";//Latest Firmware Download Url
}
```
without upgrade updateDict == nil


## Technical Support
Please leave a message in the Gitter chat room：https://gitter.im/miaomiaoSDK/Lobby
please contact with the tomato development team as soon as possible. Please provide a detailed error log of your appkey and console. The more details you providey the more help to solve your problem!

