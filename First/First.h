//
//  First.h
//  First
//
//  Created by zb on 2019/2/26.
//  Copyright © 2019 IdealCountry. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface First : NSObject
{
    int inta;
    NSInteger nsinta;
    bool boola;
    BOOL boolA;
    float floata;
    char chara;
    NSString *nsstra;
    NSMutableString *mutableStr;
}
@property int intb;
-(void) methodNoArg;
-(void) methodOneArg:(int)arg;
-(void) methodArg1:(int)arg andArg2:(int)arg2;
- (void)methodArg1andArg2: (int)arg : (int)arg2;
- (NSString *)iphoneType;
- (void)testFun;
- (void)permissionTest;
@end

NS_ASSUME_NONNULL_END
