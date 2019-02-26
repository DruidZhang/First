//
//  First.m
//  FIrst
//
//  Created by zb on 2018/12/29.
//  Copyright © 2018 zb. All rights reserved.
//

#import "First.h"
#import <sys/utsname.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>


@implementation First
-(void) methodNoArg {
    self.intb = 0;
    _intb = 1;
    inta = 2;
    self->inta = 3;
    NSString *stringa = [NSString stringWithFormat:@"%d",inta];
    inta = [@"10" intValue];
    NSLog(@"no arg method inta is %@ intb is %i",stringa,self.intb);
}

-(void) methodOneArg: (int)arg {
    NSLog(@"one arg: %i",arg);
}
-(void) methodArg1:(int) arg andArg2:(int) arg2 {
    NSLog(@"arg1: %i arg2: %i",arg,arg2);
}

- (void)methodArg1andArg2:(int)arg :(int)arg2{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL tokenBool = [defaults boolForKey:@"key2"];
    NSString *tokenString = [defaults objectForKey:@"key1"];
}

- (NSString *)iphoneType{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if([platform isEqualToString:@"iPhone1,1"]) return @"iphone 1G";
    if([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    
    return platform;
}

- (void)testFun{
    NSLog(@"app 沙盒路径:%@",NSHomeDirectory());
    NSLog(@"documents路径:%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]);
    NSLog(@"librarym路径:%@",[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]);
    NSLog(@"library/cache路径:%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]);
    NSLog(@"tmpm路径:%@",NSTemporaryDirectory());
}


- (void)permissionTest{
    NSLog(@"申请权限前:%@",[self checkCammeraPermission]);
    //申请权限 AVMediaTypeVideo:相机权限
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if(granted){
            NSLog(@"申请成功");
        } else {
            NSLog(@"申请失败");
        }
        NSLog(@"申请权限后:%@",[self checkCammeraPermission]);
    }];
    
}
- (NSString *)checkCammeraPermission{
    NSString * result;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:
            result = @"NotDetermined";
            break;
        case AVAuthorizationStatusRestricted:
            result = @"restricted";
            break;
        case AVAuthorizationStatusDenied:
            result = @"denied";
            break;
        case AVAuthorizationStatusAuthorized:
            result = @"authorized";
            break;
        default:
            break;
    }
    return result;
}
@end
