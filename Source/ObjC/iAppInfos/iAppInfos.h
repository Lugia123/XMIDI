//
//  iAppInfos.h
//  iAppInfos
//
//  Created by Jerome Morissard on 11/21/13.
//  Copyright (c) 2013 Jerome Morissard. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UIDevice+iAppInfos.h"
#import "JMOMobileProvisionning.h"

#define AppVersionManagerKeyTargetedVersion             @"targetedVersion"
#define AppVersionManagerKeyYouriOSVersion              @"currentOSVersion"
#define AppVersionManagerKeyCFBundleVersion             @"appVersion"
#define AppVersionManagerKeyCFBundleShortVersionString  @"buildRevision"
#define AppVersionManagerKeyFreeMemory                  @"freeMemorySpace"
#define AppVersionManagerKeyMemoryUseByApp              @"memoryUsedByApp"
#define AppVersionManagerKeyOperator                    @"operatorName"
#define AppVersionManagerKeyYourDeviceModel             @"deviceModelName"
#define AppVersionManagerKeyYourDeviceType              @"deviceModelType"
#define AppVersionManagerKeyGraphicalPerformance        @"devicePowerInfo"
#define AppVersionManagerKeyCompilationSDK              @"compilationSDK"
#define AppVersionManagerKeyCompilationArchitecture     @"compilationArchitecture"

#define AppVersionManagerKeyFreeDiskSpace               @"freeDiskSpace"
#define AppVersionManagerKeyBatteryLevel                @"batteryLevel"
#define AppVersionManagerKeyMobileProvisionning         @"mobileProvisionning"

#define AppVersionManagerKeyWSConfiguration             @"WSConfiguration"  //From Datasource
#define AppVersionManagerKeyPushToken                   @"PushToken" //From Datasource

@interface iAppInfos : NSObject

@property (strong, readonly, nonatomic) NSString *targetedVersion;
@property (strong, readonly, nonatomic) NSString *currentOSVersion;
@property (strong, readonly, nonatomic) NSString *appVersion;
@property (strong, readonly, nonatomic) NSString *buildRevision;
@property (assign, readonly, nonatomic) NSInteger freeMemorySpace; //in Mo
@property (assign, readonly, nonatomic) NSInteger freeMemorySpacePourcent; //in Pourcent
@property (assign, readonly, nonatomic) NSInteger memoryUsedByApp; //in Mo
@property (strong, readonly, nonatomic) NSString *operatorName;
@property (strong, readonly, nonatomic) NSString *deviceSysInfo;
@property (strong, readonly, nonatomic) NSString *deviceModelName;
@property (assign, readonly, nonatomic) UIDeviceModelType deviceModelType;
@property (strong, readonly, nonatomic) JMODevicePowerInfos *devicePowerInfo;
@property (strong, readonly, nonatomic) NSString *compilationSDK;
@property (strong, readonly, nonatomic) NSString *freeDiskSpace;
@property (assign, readonly, nonatomic) NSInteger batteryLevel; //in pourcent
@property (strong, readonly, nonatomic) JMOMobileProvisionning *mobileProvisionning;
@property (strong, readonly, nonatomic) NSString *compilationArchitecture;

@property (strong, nonatomic) NSArray *filteredKeys;


+ (instancetype)sharedInfo;
- (void)addCustomValue:(NSString *)value forCustomKey:(NSString *)key;
- (id)infoForKey:(NSString *)key;
- (NSString *)htmlDescriptionWithKeys:(NSArray *)keys;

@end