//
//  TableSectionData.h
//  FIrst
//
//  Created by zb on 2019/1/8.
//  Copyright © 2019 zb. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface TableSectionData : NSObject

@property(nonatomic,copy) NSString *header;
@property(nonatomic,copy) NSString *footer;
@property NSMutableArray *rows;

+ (id)initDataWithHeader:(NSString *)header Footer:(NSString *)footer Rows:(NSArray *)rows;

@end

