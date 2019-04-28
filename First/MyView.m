//
//  MyView.m
//  FIrst
//
//  Created by zb on 2019/1/4.
//  Copyright © 2019 zb. All rights reserved.
//

#import "MyView.h"

@interface MyView()

@property (strong,nonatomic) UIButton *myBtn;
@property (strong,nonatomic) UIButton *btn_change_state;
@property (strong,nonatomic) UIButton *btn_request;
@property (strong,nonatomic) UIButton *btn_image;
@property (strong,nonatomic) UIButton *btn_db;
@property (strong,nonatomic) UIButton *btn_share;
@property (strong,nonatomic) UIButton *btn_statusBar;

@end

@implementation MyView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if(self){
        self.myBtn = [[UIButton alloc] initWithFrame:CGRectMake(140,100,100,50)];
        _myBtn.backgroundColor = [UIColor redColor];
        [self.myBtn setTitle:@"跳转" forState:UIControlStateNormal];
        [_myBtn addTarget:self
                   action:@selector(myBtnClick:)
         forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_myBtn];
        
        self.btn_change_state = [[UIButton alloc] init];
        _btn_change_state.backgroundColor = [UIColor whiteColor];
        self.btn_change_state.frame = CGRectMake(140, 160, 100, 50);
        [_btn_change_state setTitle:@"点击前" forState:UIControlStateNormal];
        [_btn_change_state setTitle:@"点击中" forState:UIControlStateHighlighted];
        [_btn_change_state setTitle:@"已点击" forState:UIControlStateSelected];
        [_btn_change_state setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btn_change_state setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
        [_btn_change_state setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        //        _btn_change_state.selected = YES;
        _btn_change_state.layer.cornerRadius = 10;
        _btn_change_state.layer.borderWidth = 2;
        //边框颜色,注意cgcolor
        _btn_change_state.layer.borderColor = [UIColor orangeColor].CGColor;
        //设置阴影,x,y可以为负值
        _btn_change_state.layer.shadowOffset = CGSizeMake(1, 1);
        _btn_change_state.layer.shadowOpacity = 0.8;
        _btn_change_state.layer.shadowColor = [UIColor blackColor].CGColor;
        [self addSubview:_btn_change_state];
        
        _btn_request = [[UIButton alloc]initWithFrame:CGRectMake(140, 220, 100, 50)];
        _btn_request.backgroundColor = [UIColor grayColor];
        [_btn_request setTitle:@"请求" forState:UIControlStateNormal];
        [_btn_request addTarget:self action:@selector(btnRequestClick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_btn_request];
        
        _btn_image = [[UIButton alloc]initWithFrame:CGRectMake(140, 280, 100, 50)];
        _btn_image.backgroundColor = [UIColor grayColor];
        [_btn_image setTitle:@"加载图片" forState:UIControlStateNormal];
        [_btn_image addTarget:self action:@selector(btnImageClick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_btn_image];
        
        self.imageview = [[UIImageView alloc]initWithFrame:CGRectMake(120, 330, 140, 60)];
        [self addSubview:self.imageview];
        
        _btn_db = [[UIButton alloc]initWithFrame:CGRectMake(140, 400, 100, 50)];
        _btn_db.backgroundColor = [UIColor grayColor];
        [_btn_db setTitle:@"DB" forState:UIControlStateNormal];
        [_btn_db addTarget:self action:@selector(btnDBClick) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_btn_db];
        
        _btn_share = [[UIButton alloc] initWithFrame:CGRectMake(140, 520, 100, 50)];
        _btn_share.backgroundColor = [UIColor grayColor];
        [_btn_share setTitle:@"分享" forState:UIControlStateNormal];
        [_btn_share addTarget:self action:@selector(btnShareClick) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_btn_share];
        
        _btn_statusBar = [[UIButton alloc] initWithFrame:CGRectMake(120,590,140,50)];
        _btn_statusBar.backgroundColor = [UIColor grayColor];
        [_btn_statusBar setTitle:@"改变状态栏颜色" forState:UIControlStateNormal];
        [_btn_statusBar addTarget:self action:@selector(btnStatusBbarClick) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_btn_statusBar];
        
        [self setNeedsDisplay];
    }
    return self;
}


- (void)drawRect:(CGRect)rect{
    //draw cricle
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] set];
    CGContextFillRect(context, rect);
    
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextAddArc(context, 160, 480, 20, 0, 2*M_PI, 0);
    CGContextDrawPath(context, kCGPathStroke);
}

- (void)myBtnClick:(UIButton *)btn{
    //    NSLog(@"Method in view");
    //    if([self.delegate respondsToSelector:@selector(BtnClick:)]){
    //        [self.delegate BtnClick:btn];
    //    } else {
    //        NSLog(@"BtnClick: haven't found in delegate.");
    //    }
    
    self.clickBtn(@"mes in view");
}

- (void)btnRequestClick:(UIButton *)btn{
    self.clickRequestBtn();
}

- (void)btnImageClick:(UIButton *)btn{
    self.clickImageBtn();
}

- (void)btnDBClick{
    self.clickDBBtn();
}

- (void)btnShareClick {
    self.clickShareBtn();
}

- (void)btnStatusBbarClick {
    self.clickStatusBarBtn();
}

@end
