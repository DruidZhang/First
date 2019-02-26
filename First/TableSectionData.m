//
//  TableSectionData.m
//  FIrst
//
//  Created by zb on 2019/1/8.
//  Copyright © 2019 zb. All rights reserved.
//

#import "TableSectionData.h"

@implementation TableSectionData

+ (id) initDataWithHeader:(NSString *)header Footer:(NSString *)footer Rows:(NSArray *)rows{
    TableSectionData *data = [[TableSectionData alloc]init];
    data.header = header;
    data.footer = footer;
    data.rows = [NSMutableArray arrayWithArray:rows];
    return data;
}

@end
