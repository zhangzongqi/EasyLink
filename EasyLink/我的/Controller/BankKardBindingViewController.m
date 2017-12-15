//
//  BankKardBindingViewController.m
//  EasyLink
//
//  Created by 琦琦 on 16/11/9.
//  Copyright © 2016年 fengdian. All rights reserved.
//

#import "BankKardBindingViewController.h"

@interface BankKardBindingViewController () {
    
    // 遮罩层
    UIView *_zhezhaoUv;
    
    // 提示弹出视图
    UIView *_tipTanchuUv;
}

@end

@implementation BankKardBindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 背景色
    self.view.backgroundColor = FUIColorFromRGB(0xffffff);
    
    // 返回按钮
    [self createBackBtn];
    
    // 设置导航栏标题
    UILabel *lbItemTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    lbItemTitle.text = @"绑定银行卡";
    lbItemTitle.textColor = [UIColor whiteColor];
    lbItemTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lbItemTitle;
    
    // 布局页面
    [self layoutViews];
    
}

// 布局页面
- (void) layoutViews {
    
    NSArray *lbTitleNameArr = @[@"户名",@"账号",@"银行"];
    
    for (int i = 0; i < 3; i++) {
        
        // 类目
        UILabel *lbTitle = [[UILabel alloc] init];
        [self.view addSubview:lbTitle];
        [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(0.0833 * H + 0.064583 * H * i);
            make.left.equalTo(self.view).with.offset(0.09375 * W);
            make.width.equalTo(@(34));
            make.height.equalTo(@(16));
        }];
        lbTitle.text = lbTitleNameArr[i];
        lbTitle.font = [UIFont systemFontOfSize:16];
        lbTitle.textColor = FUIColorFromRGB(0x4e4e4e);
        
        // 分隔线
        UILabel *lbFenge = [[UILabel alloc] init];
        [self.view addSubview:lbFenge];
        [lbFenge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lbTitle.mas_bottom).with.offset(0.01875 * H);
            make.left.equalTo(lbTitle);
            make.width.equalTo(@(self.view.frame.size.width - 0.09375 * W * 2));
            make.height.equalTo(@(1));
        }];
        lbFenge.backgroundColor = FUIColorFromRGB(0xeeeeee);
        
        if (i == 1) {
            UILabel *lbName = [[UILabel alloc] init];
            [self.view addSubview:lbName];
            [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).with.offset(0.0833 * H);
                make.left.equalTo(lbTitle.mas_right).with.offset(W * 0.028125);
                make.height.equalTo(lbTitle);
            }];
            lbName.textColor = FUIColorFromRGB(0x999999);
            lbName.text = @"用户姓名";
            lbName.font = [UIFont systemFontOfSize:15];
            
            // 提示按钮
            UIButton *tipBtn = [[UIButton alloc] init];
            [self.view addSubview:tipBtn];
            [tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).with.offset(0.0833 * H - 5);
                make.right.equalTo(lbFenge);
                make.width.equalTo(@(0.0375 * self.view.frame.size.width + 10));
                make.height.equalTo(@(0.0375 * self.view.frame.size.width + 10));
            }];
            tipBtn.imageView.sd_layout
            .centerXEqualToView(tipBtn)
            .centerYEqualToView(tipBtn)
            .widthIs(0.0375 * self.view.frame.size.width)
            .heightIs(0.0375 * self.view.frame.size.width);
            [tipBtn setImage:[UIImage imageNamed:@"绑定银行卡_提示icon"] forState:UIControlStateNormal];
            [tipBtn addTarget:self action:@selector(tipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UITextField *tf = [[UITextField alloc] init];
            [self.view addSubview:tf];
            [tf mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lbTitle);
                make.left.equalTo(lbName);
                make.height.equalTo(lbName);
                make.width.equalTo(@(self.view.frame.size.width - 0.09375 * W * 2 - 34 - W * 0.028125));
            }];
            tf.font = [UIFont systemFontOfSize:14];
            tf.placeholder = @"请输入银行卡号";
            tf.clearButtonMode = UITextFieldViewModeWhileEditing;
            tf.tag = 666;
        }
        
        if (i == 2) {
            
            // 选择银行按钮
            UIButton *btnSelectBank = [[UIButton alloc] init];
            [self.view addSubview:btnSelectBank];
            [btnSelectBank mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lbTitle);
                make.left.equalTo(lbTitle.mas_right).with.offset(W * 0.028125);
                make.height.equalTo(lbTitle);
                make.width.equalTo(@(self.view.frame.size.width - 0.09375 * W * 2 - 34 - W * 0.028125));
            }];
            btnSelectBank.titleLabel.sd_layout
            .centerYEqualToView(btnSelectBank)
            .leftEqualToView(btnSelectBank)
            .heightRatioToView(btnSelectBank,1);
            btnSelectBank.imageView.sd_layout
            .rightSpaceToView(btnSelectBank, 8.15)
            .topSpaceToView(btnSelectBank,0)
            .widthIs(9.15)
            .heightIs(16);
            btnSelectBank.titleLabel.font = [UIFont systemFontOfSize:14];
            [btnSelectBank setTitleColor:FUIColorFromRGB(0x212121) forState:UIControlStateNormal];
            [btnSelectBank setImage:[UIImage imageNamed:@"绑定银行卡_点击选择"] forState:UIControlStateNormal];
            
            
            // 提交绑定按钮
            UIButton *bindingBtn = [[UIButton alloc] init];
            [self.view addSubview:bindingBtn];
            [bindingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lbFenge).with.offset(0.071875 * H);
                make.centerX.equalTo(self.view);
                make.width.equalTo(@(0.65625 * W));
                make.height.equalTo(@(0.05625 * H));
            }];
            bindingBtn.titleLabel.sd_layout
            .centerYEqualToView(bindingBtn)
            .centerXEqualToView(bindingBtn)
            .heightIs(0.05625 * H);
            [bindingBtn setTitle:@"立即绑定" forState:UIControlStateNormal];
            [bindingBtn setTitleColor:FUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            bindingBtn.backgroundColor = FUIColorFromRGB(0x8979ff);
            bindingBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            bindingBtn.layer.cornerRadius = 0.05625 * H / 2;
            [bindingBtn addTarget:self action:@selector(bindingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
         }
    }
    
    // 整体遮罩层
    _zhezhaoUv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, W, H)];
    _zhezhaoUv.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    [self.view addSubview:_zhezhaoUv];
    _zhezhaoUv.hidden = YES;

    
    // 提示的弹出视图
    [self tipTanchuView];
}

// 提示的弹出视图
- (void) tipTanchuView {
    
    // 提示的弹出视图
    _tipTanchuUv = [[UIView alloc] initWithFrame:CGRectMake(0, 0.19123 * _zhezhaoUv.frame.size.height, 0.659375 * W, 0.4 * _zhezhaoUv.frame.size.height)];
    CGPoint pt = _tipTanchuUv.center;
    pt.x = W/2;
    _tipTanchuUv.center = pt;
    _tipTanchuUv.backgroundColor = FUIColorFromRGB(0xffffff);
    [_zhezhaoUv addSubview:_tipTanchuUv];
    _tipTanchuUv.layer.cornerRadius = 8;
    _tipTanchuUv.hidden = YES;
    
    // 提示感叹号图片
    UIImageView *imgView = [[UIImageView alloc] init];
    [_tipTanchuUv addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tipTanchuUv).with.offset(0.1 * _tipTanchuUv.frame.size.height);
        make.centerX.equalTo(_tipTanchuUv);
        make.width.equalTo(_tipTanchuUv).multipliedBy(0.327);
        make.height.equalTo(_tipTanchuUv.mas_width).multipliedBy(0.327);
    }];
    imgView.image = [UIImage imageNamed:@"绑定成功_弹窗_提示"];
    
    // 提示标题
    UILabel *lbTitle = [[UILabel alloc] init];
    [_tipTanchuUv addSubview:lbTitle];
    [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(imgView.mas_bottom).with.offset(0.1 * _tipTanchuUv.frame.size.height);
        make.centerX.equalTo(_tipTanchuUv);
    }];
    lbTitle.text = @"绑定银行卡";
    lbTitle.font = [UIFont systemFontOfSize:16];
    lbTitle.textColor = FUIColorFromRGB(0x212121);
    
    // 提示内容
    UILabel *lbContent = [[UILabel alloc] init];
    [_tipTanchuUv addSubview:lbContent];
    [lbContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbTitle.mas_bottom).with.offset(0.033 * _tipTanchuUv.frame.size.height);
        make.centerX.equalTo(_tipTanchuUv);
        make.height.equalTo(@(0.12 * _tipTanchuUv.frame.size.height));
        make.width.equalTo(@(0.681 * _tipTanchuUv.frame.size.width));
    }];
    if (iPhone6SP) {
        lbContent.font = [UIFont systemFontOfSize:14];
    }else if (iPhone6S) {
        lbContent.font = [UIFont systemFontOfSize:13];
    }else if (iPhone4S) {
        lbContent.font = [UIFont systemFontOfSize:10];
    }else {
        lbContent.font = [UIFont systemFontOfSize:11];
    }
    
    lbContent.textColor = FUIColorFromRGB(0x999999);
    lbContent.text = @"为了账户资金安全,只能使用您本人的银行卡账户！";
    lbContent.numberOfLines = 2;
    lbContent.textAlignment = NSTextAlignmentCenter;
    
    // 按钮
    UIButton *btn = [[UIButton alloc] init];
    [_tipTanchuUv addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbContent.mas_bottom).with.offset(0.09 * _tipTanchuUv.frame.size.height);
        make.centerX.equalTo(_tipTanchuUv);
        make.height.equalTo(@(0.114286 * _tipTanchuUv.frame.size.height));
        make.width.equalTo(@(0.481 * _tipTanchuUv.frame.size.width));
    }];
    btn.layer.cornerRadius = 0.114286 * _tipTanchuUv.frame.size.height / 2;
    [btn setTitle:@"我知道了" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    btn.backgroundColor = FUIColorFromRGB(0x8979ff);
    [btn addTarget:self action:@selector(btnSureClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 402;
}

// 确定信息按钮点击事件
- (void) btnSureClick:(UIButton *)btn {
    
    _zhezhaoUv.hidden = YES;
    _tipTanchuUv.hidden = YES;
    
    if (btn.tag == 400) {
        alert(@"点击了确定");
    }else if(btn.tag == 401){
        alert(@"点击了修改");
    }else if(btn.tag == 402){
        NSLog(@"点击了我知道了");
    }
}

// 触发事件
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 释放第一响应者
    UITextField *tf1 = [self.view viewWithTag:666];
    [tf1 resignFirstResponder];
}

// 立即绑定按钮点击事件
- (void) bindingBtnClick:(UIButton *)bindingBtn {
    
    alert(@"点击了立即绑定");
}

// 提示按钮点击
- (void) tipBtnClick:(UIButton *)tipBtn {
    
    // 释放第一响应者
    UITextField *tf1 = [self.view viewWithTag:666];
    [tf1 resignFirstResponder];
    
    _zhezhaoUv.hidden = NO;
    _tipTanchuUv.hidden = NO;
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
