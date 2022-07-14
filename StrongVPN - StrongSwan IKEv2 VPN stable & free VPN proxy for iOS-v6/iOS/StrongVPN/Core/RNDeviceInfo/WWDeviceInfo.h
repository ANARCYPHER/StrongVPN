//
//  WWDeviceInfo.h
//  strongvpn
//
//  Created by witworkapp on 12/17/20.
//  Copyright © 2020 witworkapp. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <sys/utsname.h>

@protocol WWDeviceInfoProtocol <NSObject>
-(void)wwDeviceInfoBatteryLevelDidChange:(CGFloat)level;
-(void)wwDeviceInfoBatteryLevelIsLow:(CGFloat)level;
-(void)wwDeviceInfoPowerStateDidChange:(NSDictionary*)info;
-(void)wwDeviceInfoHeadphoneConnectionDidChange:(BOOL)isConnected;
@end

@interface WWDeviceInfo: NSObject
@property (nonatomic) float lowBatteryThreshold;
@property (nonatomic, copy) id <WWDeviceInfoProtocol> delegate;

-(NSDictionary*)constantsToExport;
@end
