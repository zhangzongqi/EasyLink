//
//  InOutDetailViewController.m
//  EasyLink
//
//  Created by 琦琦 on 16/11/2.
//  Copyright © 2016年 fengdian. All rights reserved.
// 收支明细
//

#import "InOutDetailViewController.h"

@interface InOutDetailViewController () {
    
    // 弹出视图
    UIView *vc;
    UIView *tanchuVC;
    UIImageView *circleVc;
    UIView *zhezhaoVc; // 遮罩层
}

@end

@implementation InOutDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 页面背景色
    self.view.backgroundColor = FUIColorFromRGB(0xffffff);
    
    // 加入手势返回
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swip)];
    swip.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swip];
    
    // 设置导航栏标题
    UIButton *btnItemTitle = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, 20)];
    
    btnItemTitle.titleLabel.sd_layout
    .topSpaceToView(btnItemTitle,0)
    .leftEqualToView(btnItemTitle)
    .heightRatioToView(btnItemTitle,1)
    .widthIs(62);
    if (iPhone6SP) {
        btnItemTitle.titleLabel.font = [UIFont systemFontOfSize:15];
    }else {
        btnItemTitle.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    
    btnItemTitle.imageView.sd_layout
    .topSpaceToView(btnItemTitle,7)
    .leftSpaceToView(btnItemTitle.titleLabel,3)
    .widthIs(9)
    .heightIs(6);
    
    [btnItemTitle setTitle:@"全部明细" forState:UIControlStateNormal];
    [btnItemTitle setTitleColor:FUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    btnItemTitle.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btnItemTitle setImage:[UIImage imageNamed:@"个人中心_收支明细"] forState:UIControlStateNormal];
    self.navigationItem.titleView = btnItemTitle;
    [btnItemTitle addTarget:self action:@selector(btnItemTitleClick:) forControlEvents:UIControlEventTouchUpInside];
    btnItemTitle.selected = NO;
    btnItemTitle.tag = 100;
    
    
    // 遮罩层
    zhezhaoVc = [[UIView alloc] init];
    [self.navigationController.view addSubview:zhezhaoVc];
    [zhezhaoVc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationController.view).with.offset(64);
        make.left.equalTo(self.navigationController.view);
        make.width.equalTo(@(W));
        make.height.equalTo(@(H - 64));
    }];
    zhezhaoVc.backgroundColor = [UIColor blackColor];
    zhezhaoVc.alpha = 0.5;
    zhezhaoVc.hidden = YES;
    // 遮罩层点击事件
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo)];
    [zhezhaoVc addGestureRecognizer:tapGesture];
    
    // 弹出视图
    vc = [[UIView alloc] init];
    [self.navigationController.view addSubview:vc];
    vc.sd_layout
    .topSpaceToView(btnItemTitle,0)
    .leftSpaceToView(btnItemTitle,-13.5)
    .widthIs(16)
    .heightIs(33)
    ;
    vc.clipsToBounds = YES;
    vc.layer.cornerRadius = 8;
    vc.backgroundColor = [UIColor whiteColor];
    vc.hidden = YES;
    UIImageView *imgView = [[UIImageView alloc] init];
    [vc addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vc).with.offset(7);
        make.centerX.equalTo(vc);
        make.width.equalTo(@(9));
        make.height.equalTo(@(6));
    }];
    imgView.image = [UIImage imageNamed:@"个人中心_收支明细_下拉"];
    
    tanchuVC = [[UIView alloc] init];
    [self.navigationController.view addSubview:tanchuVC];
    tanchuVC.sd_layout
    .topSpaceToView(btnItemTitle,btnItemTitle.frame.size.height + 1)
    .leftSpaceToView(btnItemTitle,- btnItemTitle.frame.size.width - 1)
    .widthIs(btnItemTitle.frame.size.width + 3.5)
    .heightIs(0.206 * H)
    ;
    tanchuVC.clipsToBounds = YES;
    tanchuVC.layer.cornerRadius = 5;
    tanchuVC.backgroundColor = [UIColor whiteColor];
    tanchuVC.hidden = YES;
    // 小圆弧
    circleVc = [[UIImageView alloc] init];
    [self.navigationController.view addSubview:circleVc];
    circleVc.sd_layout
    .topSpaceToView(tanchuVC,-tanchuVC.frame.size.height -4.9)
    .rightSpaceToView(vc, - 0.1)
    .widthIs(5)
    .heightIs(5);
    
    circleVc.image = [UIImage imageNamed:@"品类列表_排序方式_弹窗圆弧"];
    circleVc.hidden = YES;
    
    // 弹出视图上按钮
    [self createBtnFromTanchu];
    
    // 返回按钮
    [self createBackBtn];
    
    // 布局UI
    [self createUI];
}

// 手势返回事件
- (void)swip {
    [self.navigationController popViewControllerAnimated:YES];
}

// 弹出视图按钮
- (void)createBtnFromTanchu {
    
    NSArray *arrTitle = @[@"全部",@"已收入",@"已提现",@"待入账"];
    
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [[UIButton alloc] init];
        [tanchuVC addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tanchuVC).with.offset(i * tanchuVC.frame.size.height / 4);
            make.left.equalTo(tanchuVC);
            make.height.equalTo(@(tanchuVC.frame.size.height / 4));
            make.width.equalTo(@(tanchuVC.frame.size.width));
        }];
        [btn setTitle:arrTitle[i] forState:UIControlStateNormal];
        [btn setTitleColor:FUIColorFromRGB(0x999999) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.tag = 10 + i;
        [btn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i > 0) {
            UILabel *lbFenge = [[UILabel alloc] init];
            [tanchuVC addSubview:lbFenge];
            [lbFenge mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(tanchuVC).with.offset(i * tanchuVC.frame.size.height / 4 - 0.5);
                make.centerX.equalTo(tanchuVC);
                make.width.equalTo(@(tanchuVC.frame.size.width * 0.65));
                make.height.equalTo(@(1));
            }];
            lbFenge.backgroundColor = FUIColorFromRGB(0xeeeeee);
        }
    }
}

// 选择按钮的点击事件
- (void)selectClick:(UIButton *)btn {
    
    // 按钮点击事件
    if (btn.tag == 10) {
        NSLog(@"全部");
    }else if(btn.tag == 11) {
        NSLog(@"已收入");
    }else if (btn.tag == 12) {
        NSLog(@"已提现");
    }else if (btn.tag == 13) {
        NSLog(@"待入账");
    }
    
    UIButton *btnTitle = [self.navigationController.view viewWithTag:100];
    [self btnItemTitleClick:btnTitle];
}

// 遮罩层点击事件
- (void)Actiondo {
    
    UIButton *btn = [self.navigationController.view viewWithTag:100];
    
    [self btnItemTitleClick:btn];
}

// 头部标题点击事件
- (void) btnItemTitleClick:(UIButton *)btnItemTitle {
    
    if (btnItemTitle.selected == NO) {
        btnItemTitle.selected = YES;
        zhezhaoVc.hidden = NO;
        vc.hidden = NO;
        tanchuVC.hidden = NO;
        circleVc.hidden = NO;
    }else {
        btnItemTitle.selected = NO;
        zhezhaoVc.hidden = YES;
        vc.hidden = YES;
        tanchuVC.hidden = YES;
        circleVc.hidden = YES;
    }
}

// 布局UI
- (void) createUI {
    
    // 暂无收支记录
    UIImageView *nothingImgView = [[UIImageView alloc] init];
    [self.view addSubview:nothingImgView];
    [nothingImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(H * 0.24 - 64);
        make.centerX.equalTo(self.view);
        make.width.height.equalTo(@(0.16875 * W));
    }];
    nothingImgView.image = [UIImage imageNamed:@"个人中心_收支明细_无数据"];
    
    UILabel *lbNothing = [[UILabel alloc] init];
    [self.view addSubview:lbNothing];
    [lbNothing mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nothingImgView.mas_bottom).with.offset(20);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@(15));
    }];
    lbNothing.text = @"暂无收支记录";
    lbNothing.textColor = FUIColorFromRGB(0x999999);
    lbNothing.font = [UIFont systemFontOfSize:14];
}

// 返回按钮
- (void) createBackBtn {
    
    // 返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(20, 0, 10.4, 18.4);
    
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    //    self.navigationItem.leftBarButtonItem = backItem;
    
    if (([[[ UIDevice currentDevice ] systemVersion ] floatValue ]>= 7.0 ? 20 : 0 ))
        
    {
        
        UIBarButtonItem *negativeSpacer = [[ UIBarButtonItem alloc ] initWithBarButtonSystemItem : UIBarButtonSystemItemFixedSpace
                                           
                                                                                          target : nil action : nil ];
        
        negativeSpacer.width = 0 ;//这个数值可以根据情况自由变化
        
        self.navigationItem.leftBarButtonItems = @[ negativeSpacer,  backItem] ;
        
    } else {
        self . navigationItem . leftBarButtonItem = backItem;
    }
    
}

// 返回按钮点击事件
- (void) doBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 页面将要消失
- (void) viewWillDisappear:(BOOL)animated {
    
    zhezhaoVc.hidden = YES;
    vc.hidden = YES;
    tanchuVC.hidden = YES;
    circleVc.hidden = YES;
    
    // 打开手势返回
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

// 页面将要显示
- (void) viewWillAppear:(BOOL)animated {
    
    // 设置导航栏背景色(用到了UIImage+GradientColor.h这个类扩展)
    UIColor *topleftColor = FUIColorFromRGB(0x9080ff);
    UIColor *bottomrightColor = FUIColorFromRGB(0x7765ff);
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor, bottomrightColor] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(W, 64)];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:bgImg]];
    
    self.navigationController.navigationBar.hidden = NO;
    
    // 关闭手势返回
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
