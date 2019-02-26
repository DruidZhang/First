//
//  SandboxDetailViewController.m
//  FIrst
//
//  Created by zb on 2019/2/25.
//  Copyright © 2019 zb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SandboxDetailViewController.h"
#import <AVKit/AVKit.h>

@interface SandboxDetailViewController()

@property UIImageView *imageView;
@property UILabel *textView;
@property AVPlayerViewController *avPlayerVC;

@property CGFloat topBarHeight;
@property CGFloat screenWidth;
@property CGFloat screenHeight;

@end

@implementation SandboxDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"文件预览";
    _topBarHeight = [[UIApplication sharedApplication]statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    if(!_filePath || _filePath.length == 0){
        NSLog(@"文件不存在");
        return;
    }
    NSString *path = self.filePath;
    if([path hasSuffix:@".png"] || [path hasSuffix:@".PNG"]
       || [path hasSuffix:@".jpg"] || [path hasSuffix:@".JPG"]
       || [path hasSuffix:@".jpeg"] || [path hasSuffix:@".JPEG"]
       || [path hasSuffix:@".gif"] || [path hasSuffix:@".GIF"]){
        //图片文件
        [self loadImageFile];
    } else if([path hasSuffix:@".strings"] || [path hasSuffix:@".plist"]
              || [path hasSuffix:@".txt"] || [path hasSuffix:@".log"]
              || [path hasSuffix:@".csv"]){
        //文本文件
        if([path hasSuffix:@".strings"] || [path hasSuffix:@".plist"]){
            [self loadTextFile:[[NSDictionary dictionaryWithContentsOfFile:_filePath] description]];
        } else {
            [self loadTextFile:[[NSString alloc]initWithData:[NSData dataWithContentsOfFile:_filePath] encoding:NSUTF8StringEncoding]];
        }
    } else if([path hasSuffix:@".mp4"] || [path hasSuffix:@".MP4"]
              || [path hasSuffix:@".mov"] || [path hasSuffix:@".MOV"]
              || [path hasSuffix:@".mp3"] || [path hasSuffix:@".MP3"]){
        //音视频文件
    } else {
        //其他文件
        [self loadTextFile:@"不支持此文件格式"];
    }
}

- (void)loadImageFile{
    UIImage *image = [UIImage imageWithContentsOfFile:_filePath];
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, _topBarHeight+10,MAX(_screenWidth-40, image.size.width),MAX(_screenHeight-_topBarHeight, image.size.height))];
    _imageView.image = image;
    _imageView.userInteractionEnabled = YES;
    [self.view addSubview:_imageView];
}

- (void)loadTextFile:(NSString *)text{
    _textView = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, _screenWidth-40, _screenHeight-_topBarHeight)];
    _textView.font = [UIFont systemFontOfSize:UIFont.systemFontSize];
    _textView.textColor = [UIColor blackColor];
    _textView.backgroundColor = [UIColor redColor];
    //    _textView.textAlignment = nstextalignment;
    _textView.text = text;
    [self.view addSubview:_textView];
}

- (void)loadAVFile{
    
}

@end
