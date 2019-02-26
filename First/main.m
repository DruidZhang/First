//
//  main.m
//  FIrst
//
//  Created by zb on 2018/12/27.
//  Copyright © 2018 zb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "First.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        First* first = [[First alloc]init];
        [first methodNoArg];
        [first methodOneArg: 1];
        [first methodArg1:1 andArg2:2];
        [first methodArg1andArg2:1 :2];
        NSLog(@"iphone: %@",[first iphoneType]);
        NSLog(@"App version: %@",[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"]);
        //        [first permissionTest];
        [first testFun];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}

