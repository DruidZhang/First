//
//  MyView.h
//  First
//
//  Created by zb on 2019/2/26.
//  Copyright © 2019 IdealCountry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@protocol myBtnDelegate <NSObject>

- (void) BtnClick:(UIButton *) btn;

@end

@interface MyView : UIView

@property (weak,nonatomic) id<myBtnDelegate> delegate;

@property(nonatomic,copy) void(^clickBtn)(NSString *mes);

@property(copy,nonatomic) void(^clickRequestBtn)(void);

@property(copy,nonatomic) void(^clickImageBtn)(void);

@property  UIImageView *imageview;

@property(copy,nonatomic) void(^clickDBBtn)(void);

@property(nonatomic, copy) void (^clickShareBtn)(void);

@property(nonatomic,copy) void(^clickStatusBarBtn)(void);

@end

NS_ASSUME_NONNULL_END
