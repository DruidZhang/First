//
//  SandboxViewController.m
//  FIrst
//
//  Created by zb on 2019/2/25.
//  Copyright © 2019 zb. All rights reserved.
//

#import "SandboxViewController.h"

#import <Foundation/Foundation.h>
#import "SandboxViewController.h"
#import "SandboxModel.h"
#import "SandboxDetailViewController.h"

@interface SandboxViewController()

@property (nonatomic,strong) UITableViewCell *cell;
@property (nonatomic,strong) SandboxModel *curDirModel;
@property (nonatomic,copy) NSArray<SandboxModel *> *dataArray;
@property (nonatomic,copy) NSString *rootPath;
@property (nonatomic,assign) NSInteger fileSize;

@end

@implementation SandboxViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadPath:_curDirModel.path];
}

- (void)initUI {
    self.title = @"沙盒浏览器";
    self.tableView.allowsSelection = YES;
}

- (void)initData {
    _dataArray = [[NSArray alloc]init];
    _rootPath = NSHomeDirectory();
}

- (void)loadPath:(NSString *)filePath {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *curPath = filePath;
    SandboxModel *model = [[SandboxModel alloc]init];
    //在根目录(model未初始化就是在根目录)
    if(!curPath || [curPath isEqualToString:_rootPath]){
        curPath = _rootPath;
        model.name = @"根目录";
        model.type = SandBoxFileTypeRoot;
        self.navigationController.navigationBarHidden = YES;
        self.navigationItem.leftBarButtonItems = nil;
    } else {
        //在子目录
        model.name = @"返回上一级";
        model.type = SandBoxFileTypeBack;
        self.navigationController.navigationBarHidden = NO;
        UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonClick)];
        self.navigationItem.leftBarButtonItem = backBarButton;
    }
    model.path = filePath;
    _curDirModel = model;
    
    //显示该目录下的信息
    NSMutableArray<SandboxModel *> *datas = [[NSMutableArray alloc]init];
    NSArray *paths = [fm contentsOfDirectoryAtPath:curPath error:nil];
    for (NSString *path in paths){
        BOOL isDir = NO;
        NSString *fullPath = [[curPath stringByAppendingString:@"/"] stringByAppendingString:path];
        //判断是目录还是文件
        [fm fileExistsAtPath:fullPath isDirectory:&isDir];
        SandboxModel *model = [[SandboxModel alloc]init];
        model.path = fullPath;
        model.name = path;
        if (isDir){
            model.type = SandBoxFileTypeDirectory;
        } else {
            model.type = SandBoxFileTypeFile;
        }
        [datas addObject:model];
    }
    
    _dataArray = datas.copy;
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    SandboxModel *model = _dataArray[indexPath.row];
    //文件名
    if([model.name length]>20){
        NSString *shortName = [[model.name substringToIndex:20] stringByAppendingString:@"..."];
        cell.textLabel.text = shortName;
    } else {
        cell.textLabel.text = model.name;
    }
    cell.textLabel.numberOfLines = 1;
    //是目录的话加个图片
    if(SandBoxFileTypeDirectory == model.type){
        cell.imageView.image = [UIImage imageNamed:@"arrow"];
    } else {
        cell.imageView.image = nil;
    }
    //文件和目录下的文件总大小
    NSInteger fileSize = 0;
    [self getFileSizeWithPath:model.path andSizeis:&fileSize];
    //将文件大小格式化 MB/KB/B
    NSString *fileSizeStr = nil;
    if(fileSize>1024*1024){
        //MB
        fileSizeStr = [NSString stringWithFormat:@"%.2fMB",fileSize / 1024.00f / 1024.00f];
    }else if(fileSize > 1024){
        //KB
        fileSizeStr = [NSString stringWithFormat:@"%.2fKB",fileSize / 1024.00f];
    } else {
        //B
        fileSizeStr = [NSString stringWithFormat:@"%.2fB",fileSize / 1.00f];
    }
    cell.detailTextLabel.text = fileSizeStr;
    [cell.detailTextLabel sizeToFit];
    return cell;
}

- (void)getFileSizeWithPath:(NSString *)path andSizeis:(NSInteger *)fileSize{
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isExist = [fm fileExistsAtPath:path isDirectory:&isDir];
    if(isExist) {
        if(isDir){
            NSArray *dirArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
            NSString *subPath = nil;
            for (NSString *str in dirArray){
                subPath = [[path stringByAppendingString:@"/"]stringByAppendingString:str];
                [self getFileSizeWithPath:subPath andSizeis:fileSize];
            }
        } else {
            NSDictionary *dict = [fm attributesOfItemAtPath:path error:nil];
            NSInteger size = [dict[@"NSFileSize"] integerValue];
            *fileSize += size;
        }
    } else {
        NSLog(@"不存在该文件,path: %@",path);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SandboxModel *model = _dataArray[indexPath.row];
    if(!model){
        NSLog(@"out of bounds");
        return;
    }
    if(SandBoxFileTypeDirectory == model.type){
        [self loadPath:model.path];
    } else if(SandBoxFileTypeFile == model.type){
        //文件类型为文件,显示dialog
        UIAlertController *fileAC = [UIAlertController alertControllerWithTitle:@"请选择操作" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *previewAction = [UIAlertAction actionWithTitle:@"本地预览" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showDetailView:model.path];
        }];
        UIAlertAction *shareAction = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self shareFileWWithPath:model.path];
        }];
        [fileAC addAction:cancelAction];
        [fileAC addAction:previewAction];
        [fileAC addAction:shareAction];
        
        [self presentViewController:fileAC animated:YES completion:nil];
    }
}

- (void)showDetailView:(NSString *)filepath{
    SandboxDetailViewController *detailVC = [[SandboxDetailViewController alloc]init];
    detailVC.filePath = filepath;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *pathToDelete = _dataArray[indexPath.row].path;
    [fm removeItemAtPath:pathToDelete error:nil];
    [self loadPath:[pathToDelete stringByDeletingLastPathComponent]];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)leftBarButtonClick {
    //path中删掉最后一个路径名,效果是返回上一级
    [self loadPath:[_curDirModel.path stringByDeletingLastPathComponent]];
}

//点击分享,调用系统的分享
- (void)shareFileWWithPath:(NSString *)filePath {
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSArray *objectsToShare = @[url];
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
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

@end

