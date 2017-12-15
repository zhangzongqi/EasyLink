//
//  MoneyAccountViewController.m
//  EasyLink
//
//  Created by 琦琦 on 16/11/4.
//  Copyright © 2016年 fengdian. All rights reserved.
//  提现账户管理

#import "MoneyAccountViewController.h"
#import "AliPayBindingViewController.h" // 绑定支付宝
#import "BankKardBindingViewController.h" // 绑定银行卡

@interface MoneyAccountViewController () {
    
    UIImageView *_bacImgView; // 背景图
    
    UIView *_zhezhaoVc; // 遮罩层
    UIView *_tanchuVc; // 弹出框
}

@end

@implementation MoneyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 背景色
    self.view.backgroundColor = FUIColorFromRGB(0xffffff);
    
    // 布局页面
    [self layoutViews];
}

// 布局页面
- (void) layoutViews {
    
    // 背景图
    _bacImgView = [[UIImageView alloc] init];
    [self.view addSubview:_bacImgView];
    [_bacImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view);
    }];
    _bacImgView.image = [UIImage imageNamed:@"account_background"];
    _bacImgView.userInteractionEnabled = YES; // 打开用户交互
    
    // 返回按钮、标题、右侧添加按钮
    [self createBackBtn];

}

// 返回按钮、标题、右侧添加按钮
- (void) createBackBtn {
    
    // 返回按钮
    UIButton *backBtn = [[UIButton alloc] init];
    [_bacImgView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bacImgView).with.offset(20);
        make.left.equalTo(_bacImgView).with.offset(5);
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
    }];
    [backBtn.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(backBtn);
        make.width.equalTo(@(10));
        make.height.equalTo(@(18));
    }];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 设置导航栏标题
    UILabel *lbItemTitle = [[UILabel alloc] init];
    [_bacImgView addSubview:lbItemTitle];
    [lbItemTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backBtn).with.offset(11);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@(20));
    }];
    lbItemTitle.font = [UIFont systemFontOfSize:17];
    lbItemTitle.text = @"提现账户管理";
    lbItemTitle.textColor = [UIColor whiteColor];
    lbItemTitle.textAlignment = NSTextAlignmentCenter;
    
    // 右侧按钮
    UIButton *menuBtn = [[UIButton alloc] init];
    [_bacImgView addSubview:menuBtn];
    [menuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(backBtn).with.offset(7);
        make.right.equalTo(self.view.mas_right).offset(- 15);
        make.width.equalTo(@(30));
        make.height.equalTo(@(26));
    }];
    menuBtn.imageView.sd_layout
    .topSpaceToView(menuBtn,5)
    .leftSpaceToView(menuBtn,14)
    .widthIs(16)
    .heightIs(16);
    [menuBtn setImage:[UIImage imageNamed:@"account_add"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    menuBtn.selected = NO;
    menuBtn.tag = 111;
    
    UILabel *lbFenge = [[UILabel alloc] init];
    [_bacImgView addSubview:lbFenge];
    [lbFenge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.equalTo(self.view);
        make.width.equalTo(@(W));
        make.height.equalTo(@(2));
    }];
    lbFenge.backgroundColor = FUIColorFromRGB(0xffffff);
    lbFenge.alpha = 0.2;
    
    // 提示语
    UILabel *lbTip = [[UILabel alloc] init];
    [_bacImgView addSubview:lbTip];
    [lbTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(120);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@(15));
    }];
    NSString *tipStr = @"未绑定提现账户,请立刻绑定";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:tipStr];
    [str addAttribute:NSForegroundColorAttributeName value:FUIColorFromRGB(0xffffff) range:NSMakeRange(0,tipStr.length -4)];
    [str addAttribute:NSForegroundColorAttributeName value:FUIColorFromRGB(0xfefc4b) range:NSMakeRange(tipStr.length -4,4)];
    //下划线
    [str addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(tipStr.length -4,4)];
    lbTip.font = [UIFont systemFontOfSize:14];
    lbTip.attributedText = str;
    lbTip.userInteractionEnabled = YES;
    // 点击事件
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick)];
    [lbTip addGestureRecognizer:labelTapGestureRecognizer];
    
    // 遮罩层和弹出框
    [self createZheZhaoAndAlert];
}

// 遮罩层和弹出框
- (void) createZheZhaoAndAlert {
    
    // 遮罩层
    _zhezhaoVc = [[UIView alloc] init];
    [_bacImgView addSubview:_zhezhaoVc];
    [_zhezhaoVc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(66);//导航栏加分隔线的高度
        make.left.equalTo(self.view);
        make.width.equalTo(@(W));
        make.height.equalTo(@(H - 66));
    }];
    _zhezhaoVc.backgroundColor = [UIColor blackColor];
    _zhezhaoVc.alpha = 0.5;
    _zhezhaoVc.hidden = YES;
    // 遮罩层点击事件
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo)];
    [_zhezhaoVc addGestureRecognizer:tapGesture];
    
    // 弹出视图
    _tanchuVc = [[UIView alloc] init];
    [_bacImgView addSubview:_tanchuVc];
    [_tanchuVc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0.28 * H);
        make.left.equalTo(self.view).with.offset((W - W * 0.6875) / 2);
        make.width.equalTo(@(W * 0.6875));
        make.height.equalTo(@(H * 0.38125));
    }];
    _tanchuVc.backgroundColor = [UIColor whiteColor];
    _tanchuVc.layer.cornerRadius = 5;
    _tanchuVc.hidden = YES;
    // 弹出视图上的标题
    UILabel *lbTitle = [[UILabel alloc] init];
    [_tanchuVc addSubview:lbTitle];
    [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tanchuVc);
        make.left.equalTo(_tanchuVc.mas_left).with.offset(0.136 * W * 0.6875);
        make.height.equalTo(@(0.25 * H * 0.38125));
    }];
    lbTitle.textColor = FUIColorFromRGB(0x212121);
    lbTitle.text = @"绑定提现账户";
    lbTitle.font = [UIFont systemFontOfSize:17];
    
    // 三条分隔线加图标
    for (int i = 0; i < 2; i++) {
        
        // 长分隔线
        UILabel *lbFenge1 = [[UILabel alloc] init];
        [_tanchuVc addSubview:lbFenge1];
        [lbFenge1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lbTitle.mas_bottom).with.offset(0.15625 * H * i);
            make.left.equalTo(_tanchuVc).with.offset(W / 32);
            make.width.equalTo(@(W * 0.6875 - W / 16));
            make.height.equalTo(@(1));
        }];
        lbFenge1.backgroundColor = FUIColorFromRGB(0xd5d5d5);
        if (i == 1) {
            // 确定按钮
            UIButton *sureBtn = [[UIButton alloc] init];
            [_tanchuVc addSubview:sureBtn];
            [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lbFenge1.mas_bottom).with.offset(0.0375 * H);
                make.centerX.equalTo(_tanchuVc);
                make.height.equalTo(@(0.05 * H));
                make.width.equalTo(@(0.375 * W));
            }];
            sureBtn.backgroundColor = FUIColorFromRGB(0x8979ff);
            [sureBtn setTitleColor:FUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
            sureBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            sureBtn.layer.cornerRadius = 0.025 * H;
            [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
        }
        if (i == 0) {
            // 短分隔线
            UILabel *lbFenge2 = [[UILabel alloc] init];
            [_tanchuVc addSubview:lbFenge2];
            [lbFenge2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lbFenge1).with.offset(0.079 * H);
                make.left.equalTo(_tanchuVc).with.offset(0.0625 * W);
                make.height.equalTo(@(1));
                make.width.equalTo(@(W * 0.6875 - 0.125 * W));
            }];
            lbFenge2.backgroundColor = FUIColorFromRGB(0xd5d5d5);
            
            UIImageView *imgViewKind = [[UIImageView alloc] init];
            [_tanchuVc addSubview:imgViewKind];
            [imgViewKind mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lbFenge1.mas_bottom).with.offset((0.079 * H - 0.1 * W)/2);
                make.left.equalTo(_tanchuVc).with.offset(0.0625 * W + W/64);
                make.width.equalTo(@(0.1 * W));
                make.height.equalTo(@(0.1 * W));
            }];
            imgViewKind.image = [UIImage imageNamed:@"account_bank_Alipay"];
            
            UIImageView *imgViewKind1 = [[UIImageView alloc] init];
            [_tanchuVc addSubview:imgViewKind1];
            [imgViewKind1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lbFenge2.mas_bottom).with.offset((0.079 * H - 0.1 * W)/2);
                make.left.equalTo(_tanchuVc).with.offset(0.0625 * W + W/64);
                make.width.equalTo(@(0.1 * W));
                make.height.equalTo(@(0.1 * W));
            }];
            imgViewKind1.image = [UIImage imageNamed:@"提现2"];
            
            UIButton *btnSelect1 = [[UIButton alloc] init];
            [_tanchuVc addSubview:btnSelect1];
            [btnSelect1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(imgViewKind);
                make.left.equalTo(imgViewKind.mas_right).offset(W/64);
                make.width.equalTo(@((W * 0.6875 - 0.125 * W) - 0.1 * W - W/32));
                make.height.equalTo(imgViewKind);
            }];
            btnSelect1.titleLabel.sd_layout
            .centerYEqualToView(btnSelect1)
            .leftSpaceToView(btnSelect1,0)
            .heightIs(14);
            btnSelect1.imageView.sd_layout
            .centerYEqualToView(btnSelect1)
            .rightSpaceToView(btnSelect1,0)
            .heightIs(14)
            .widthIs(15.4);
            [btnSelect1 setTitle:@"支付宝" forState:UIControlStateNormal];
            [btnSelect1 setTitleColor:FUIColorFromRGB(0x4e4e4e) forState:UIControlStateNormal];
            btnSelect1.titleLabel.font = [UIFont systemFontOfSize:13];
            btnSelect1.tag = 801;
            [btnSelect1 addTarget:self action:@selector(btnSelect1Click) forControlEvents:UIControlEventTouchDown];
            
            UIButton *btnSelect2 = [[UIButton alloc] init];
            [_tanchuVc addSubview:btnSelect2];
            [btnSelect2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(imgViewKind1);
                make.left.equalTo(imgViewKind1.mas_right).offset(W/64);
                make.width.equalTo(@((W * 0.6875 - 0.125 * W) - 0.1 * W - W/32));
                make.height.equalTo(imgViewKind);
            }];
            btnSelect2.titleLabel.sd_layout
            .centerYEqualToView(btnSelect2)
            .leftSpaceToView(btnSelect2,0)
            .heightIs(14);
            btnSelect2.imageView.sd_layout
            .centerYEqualToView(btnSelect2)
            .rightSpaceToView(btnSelect2,0)
            .heightIs(14)
            .widthIs(15.4);
            [btnSelect2 setTitle:@"银行卡" forState:UIControlStateNormal];
            [btnSelect2 setTitleColor:FUIColorFromRGB(0x4e4e4e) forState:UIControlStateNormal];
            btnSelect2.titleLabel.font = [UIFont systemFontOfSize:13];
            btnSelect2.tag = 802;
            [btnSelect2 addTarget:self action:@selector(btnSelect2Click) forControlEvents:UIControlEventTouchDown];
        }
    }
}

// 选择绑定类型点击事件
- (void)btnSelect1Click {
    UIButton *btn1 = [self.view viewWithTag:801];
    UIButton *btn2 = [self.view viewWithTag:802];
    [btn1 setImage:[UIImage imageNamed:@"提现3"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"提现3"] forState:UIControlStateNormal];
    btn1.selected = YES;
    btn1.imageView.hidden = NO;
    btn2.selected = NO;
    btn2.imageView.hidden = YES;
}
- (void)btnSelect2Click {
    
    UIButton *btn1 = [self.view viewWithTag:801];
    UIButton *btn2 = [self.view viewWithTag:802];
    [btn1 setImage:[UIImage imageNamed:@"提现3"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"提现3"] forState:UIControlStateNormal];
    btn1.selected = NO;
    btn1.imageView.hidden = YES;
    btn2.selected = YES;
    btn2.imageView.hidden = NO;
}

// 确定点击事件
- (void)sureClick {
    
    // 调用右侧添加按钮点击事件
    UIButton *btn = [self.view viewWithTag:111];
    [self rightBtnClick:btn];
    
    UIButton *btn1 = [self.view viewWithTag:801];
    UIButton *btn2 = [self.view viewWithTag:802];
    if (btn1.selected == NO && btn2.selected == YES) {
       
        NSLog(@"选中了银行卡绑定");
        BankKardBindingViewController *vc = [[BankKardBindingViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (btn1.selected == YES && btn2.selected == NO) {
        
        NSLog(@"选中了支付宝绑定");
        AliPayBindingViewController *vc = [[AliPayBindingViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

// 右侧按钮点击事件
- (void) rightBtnClick:(UIButton *)menuBtn {
    
    NSLog(@"添加提现账户");
    
    if (menuBtn.selected == NO) {
        // 选中了
        menuBtn.selected = YES;
        
        _zhezhaoVc.hidden = NO;
        _tanchuVc.hidden = NO;
        
    }else {
        // 未选中
        menuBtn.selected = NO;
        
        _zhezhaoVc.hidden = YES;
        _tanchuVc.hidden = YES;
        
    }
}

// label的点击事件
- (void)labelClick {
    // 调用右侧添加按钮点击事件
    UIButton *btn = [self.view viewWithTag:111];
    [self rightBtnClick:btn];
}

// 遮罩层点击事件
- (void)Actiondo {
    // 调用右侧添加按钮点击事件
    UIButton *btn = [self.view viewWithTag:111];
    [self rightBtnClick:btn];
}

// 返回按钮点击事件
- (void) backClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 页面将要消失
- (void) viewWillDisappear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

// 页面将要显示
- (void) viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
