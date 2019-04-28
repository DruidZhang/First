//
//  ViewController.m
//  FIrst
//
//  Created by zb on 2018/12/27.
//  Copyright © 2018 zb. All rights reserved.
//

#import "ViewController.h"
#import "MyView.h"
#import "TableViewController.h"
#import "FMDatabaseAdditions.h"
#import "SandboxViewController.h"

@interface ViewController () <myBtnDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btn;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.navigationController.navigationBar setTranslucent:NO];
    self.title = @"VCTitle";
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
    UIBarButtonItem *done =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:nil];
    UIBarButtonItem *imageItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"arrow"] style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.leftBarButtonItems = @[done,imageItem];
    UIBarButtonItem *refresh =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:nil];
    UIBarButtonItem *itemWithText = [[UIBarButtonItem alloc]initWithTitle:@"开始" style:UIBarButtonItemStylePlain target:self action:@selector(selectItem:)];
    self.navigationItem.rightBarButtonItems = @[refresh,itemWithText];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
}

- (void)selectItem:(id)paramSender{
    NSLog(@"选中 item");
}

- (void)loadView{
    MyView *myView = [[MyView alloc] initWithFrame: [[UIScreen mainScreen]bounds] ];
    myView.delegate = self;
    myView.clickBtn = ^(NSString *mes){
        NSLog(@"%@",mes);
        //        TableViewController *tableVC = [[TableViewController alloc]init];
        //        [self.navigationController pushViewController:tableVC animated:true];
        SandboxViewController *sandboxVC = [[SandboxViewController alloc]init];
        [self.navigationController pushViewController:sandboxVC animated:YES];
        //        [self presentViewController:tableVC animated:true completion:nil];
    };
    myView.clickRequestBtn = ^{
        [self doRequset];
    };
    __weak MyView *weakView = myView;
    myView.clickImageBtn = ^{
        [self doImageRequest:weakView.imageview];
    };
    myView.clickDBBtn = ^{
        [self DBClick];
    };
    myView.clickShareBtn = ^{
        [self doShare];
    };
    myView.clickStatusBarBtn = ^{
        [self setStatusBarBackgroundColor:[UIColor redColor]];
    };
    
    self.view = myView;
}

- (void)doShare{
    [self shareFileWithPath:@""];
    
}

- (void)shareFileWithPath:(NSString *)filePath{
    //    NSURL *url = [NSURL fileURLWithPath:filePath];
    //    NSArray *objectsToShare = @[url];
    
    NSString *textToShare = @"testShare";
    NSArray *activityItems = @[textToShare];
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    NSArray *excludedActivities = @[UIActivityTypePostToTwitter, UIActivityTypePostToFacebook,
                                    UIActivityTypePostToWeibo,
                                    UIActivityTypeMessage, UIActivityTypeMail,
                                    UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                                    UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
                                    UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,
                                    UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
    controller.excludedActivityTypes = excludedActivities;
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)doRequset{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"https://api.github.com/users/DruidZhang" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success--%@--%@",[responseObject class],responseObject);
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSLog(@"login: %@",dict[@"login"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"success--%@",error);
    }];
}

- (void)doImageRequest:(UIImageView *) imageview{
    [imageview sd_setImageWithURL: [NSURL URLWithString:@"https://mobappconfig.securities.eastmoney.com/appimg/4f03065f-59e6-4550-b1b0-2ef0822f380c.png"]
                 placeholderImage:[UIImage imageNamed:@"arrow"]
                        completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                            NSLog(@"load image");
                        }];
}

- (void)DBClick{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = [path stringByAppendingPathComponent:@"test.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:filePath];
    if(![db open]){
        NSLog(@"db open fail");
        return;
    }
    NSString *sql = @"create table if not exists testtable(id integer primary key,name varchar(7),isOK bool,testDate datetime)";
    if([db executeUpdate:sql]){
        NSLog(@"create table: testtable");
    }
    //    [db executeUpdate:@"delete from testtable where id < 10"];
    //使用?占位符,NSString NSDate 对象不需要用@(),int NSInteger BOOL 测试表明都需要
    BOOL result = [db executeUpdate: @"insert into testtable(id,name,isOK) values(?,?,?)",@(0),@"name1",@(YES)];
    [db executeUpdate: @"insert into testtable(id,name,isOK) values(?,?,?)",@(2),@"name3",@(YES)];
    [db executeUpdate: @"insert into testtable(id,name,isOK) values(?,?,?)",@(1),@"name2",@(NO)];
    //    BOOL result = [db executeUpdateWithFormat: @"insert into testtable1(id,name,isOK) values(%d,%@,%d)",0,@"name1",YES];
    [self varargFun:@"insert into testtable(id,name,isOK) values(?,?,?)",@(3),@"name4",@(NO)];
    NSDate *currentDate = [NSDate date];
    [self varargFun:@"insert into testtable values(?,?,?,?)",@(4),@"name5",@(YES),currentDate];
    [self varargFun:@"insert into testtable values(?,?,?,?)",@(5),@"name6",@(YES),currentDate];
    
    if(result)
        NSLog(@"insert into testtable");
    //    FMResultSet * resultSet = [db executeQuery:@"select * from testtable where id = ?"withArgumentsInArray:@[@0]];
    FMResultSet *countSet = [db executeQuery:@"select count(*) from testtable"];
    //另一种计算count的方法
    //    int count = [db intForQuery:@"select count(*) from testtable1 where isOK = true"];
    //    NSLog(@"db count by sql: %d",count);
    if(countSet.next){
        NSLog(@"db count by sql: %d",[countSet intForColumnIndex:0]);
    }
    NSLog(@"current date: %@",currentDate);
    //    NSDate *today0Date = currentDate se
    FMResultSet * resultSet = [db executeQueryWithFormat:@"select * from testtable where testDate between %@ and %@",[self get0ClockByDate:currentDate],[self get24ClockByDate:currentDate]];
    while([resultSet next]){
        NSLog(@"id: %d",[resultSet intForColumn:@"id"]);
        NSLog(@"name: %@",[resultSet stringForColumn:@"name"]);
        NSLog(@"isOk: %d",[resultSet boolForColumn:@"isOK"]);
        NSLog(@"date: %@",[resultSet dateForColumn:@"testDate"]);
        NSLog(@"------------------------------------------------");
    }
    
    [db close];
}

- (void)setStatusBarBackgroundColor:(UIColor *) color{
    UIView *statusBar = [[UIApplication sharedApplication] valueForKey:@"statusBar"];
    if([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

- (void)varargFun: (NSString *)sql ,...{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = [path stringByAppendingPathComponent:@"test.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:filePath];
    if(![db open]){
        NSLog(@"db open fail");
        return;
    }
    va_list args;
    va_start(args, sql);
    [db executeUpdate:sql withVAList:args];
    va_end(args);
    [db close];
}

- (NSDate *)get0ClockByDate:(NSDate *)date{
    NSCalendar *calender = [NSCalendar currentCalendar];
    //    NSDate *now = [NSDate date];
    //    NSCalendar *calender = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calender components:unitFlags fromDate:date];
    int hour = (int)[dateComponent hour];
    int minute = (int)[dateComponent minute];
    int second = (int)[dateComponent second];
    //当前时分秒:hour,minute,second
    //返回当前时间(hour * 3600 + minute * 60 + second)之前的时间,即为今天凌晨0点
    return [NSDate dateWithTimeInterval:- (hour * 3600 + minute * 60 + second) sinceDate:date];
}

- (NSDate *)get24ClockByDate:(NSDate *)date{
    NSTimeInterval day = 24*60*60;
    return [NSDate dateWithTimeInterval:day sinceDate:[self get0ClockByDate:date]];
}



- (void)BtnClick:(UIButton *)btn{
    NSLog(@"Method in controller.");
    NSLog(@"Button clicked.");
}


- (IBAction)myBtn:(id)sender {
}
@end
