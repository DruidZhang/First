//
//  SandboxModel.h
//  FIrst
//
//  Created by zb on 2019/2/19.
//  Copyright © 2019 zb. All rights reserved.
//

#ifndef SandboxModel_h
#define SandboxModel_h

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger,SandboxFileType){
    SandBoxFileTypeDirectory = 0,//目录
    SandBoxFileTypeFile,//文件
    SandBoxFileTypeBack,//返回
    SandBoxFileTypeRoot,//根目录
};

@interface SandboxModel : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *path;
@property (nonatomic,assign) SandboxFileType type;

@end

#endif /* SandboxModel_h */
