//
//  AliPayBindingViewController.m
//  EasyLink
//
//  Created by 琦琦 on 16/11/8.
//  Copyright © 2016年 fengdian. All rights reserved.
//  绑定支付宝

#import "AliPayBindingViewController.h"

@interface AliPayBindingViewController () {
    
    UIView *_zhezhaoUv; // 遮罩层
    
    UIView *_tanchuUv; // 弹出框
    
    UIView *_tipTanchuUv; // 提示的弹出视图
    
    NSTimer *_timer; // 定时器
    
    NSInteger i; // 用于定时器执行计次
}

@end

@implementation AliPayBindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 背景色
    self.view.backgroundColor = FUIColorFromRGB(0xffffff);
    
    // 返回按钮
    [self createBackBtn];
    
    // 设置导航栏标题
    UILabel *lbItemTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    lbItemTitle.text = @"绑定支付宝";
    lbItemTitle.textColor = [UIColor whiteColor];
    lbItemTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lbItemTitle;
    
    i = 0;
    
    // 布局页面
    [self layoutViews];
}

// 布局页面
- (void) layoutViews {

    NSArray *lbTitleNameArr = @[@"账户姓名",@"支付宝账号"];
    
    for (int i = 0; i < 2; i++) {
        
        // 类目
        UILabel *lbTitle = [[UILabel alloc] init];
        [self.view addSubview:lbTitle];
        [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(0.0833 * H + 0.064583 * H * i);
            make.left.equalTo(self.view).with.offset(0.09375 * W);
            make.width.equalTo(@(87));
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
                make.width.equalTo(@(self.view.frame.size.width - 0.09375 * W * 2 - 87 - W * 0.028125));
            }];
            tf.font = [UIFont systemFontOfSize:14];
            tf.placeholder = @"请输入支付宝账号";
            tf.clearButtonMode = UITextFieldViewModeWhileEditing;
            tf.tag = 666;
            
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
    
    // 弹出视图
    _tanchuUv = [[UIView alloc] initWithFrame:CGRectMake(0, 0.19123 * _zhezhaoUv.frame.size.height, 0.659375 * W, 0.32 * _zhezhaoUv.frame.size.height)];
    CGPoint pt = _tanchuUv.center;
    pt.x = W/2;
    _tanchuUv.center = pt;
    _tanchuUv.backgroundColor = FUIColorFromRGB(0xffffff);
    [_zhezhaoUv addSubview:_tanchuUv];
    _tanchuUv.layer.cornerRadius = 8;
    _tanchuUv.hidden = YES;
    
    // 弹出视图分割线
    UILabel *lbFengeInAlert = [[UILabel alloc] initWithFrame:CGRectMake(0.05 * _tanchuUv.frame.size.width, 0.26822 * _tanchuUv.frame.size.height, 0.9 * _tanchuUv.frame.size.width, 1)];
    [_tanchuUv addSubview:lbFengeInAlert];
    lbFengeInAlert.backgroundColor = FUIColorFromRGB(0xeeeeee);
    
    // 提示图标
    UIImageView *imgViewInAlert = [[UIImageView alloc] initWithFrame:CGRectMake(0.0952381 * _tanchuUv.frame.size.width, 0, 0.09762 * _tanchuUv.frame.size.width, 0.09762 * _tanchuUv.frame.size.width)];
    CGPoint pt1 = imgViewInAlert.center;
    pt1.y = 0.26822 * _tanchuUv.frame.size.height / 2;
    imgViewInAlert.center = pt1;
    imgViewInAlert.image = [UIImage imageNamed:@"绑定_核对信息_弹窗icon"];
    [_tanchuUv addSubview:imgViewInAlert];
    
    // 提示
    UILabel *lbTip = [[UILabel alloc] init];
    [_tanchuUv addSubview:lbTip];
    [lbTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imgViewInAlert);
        make.left.equalTo(imgViewInAlert.mas_right).with.offset(0.02619 * _tanchuUv.frame.size.width);
        make.height.equalTo(@(17));
    }];
    lbTip.font = [UIFont systemFontOfSize:16];
    lbTip.textColor = FUIColorFromRGB(0x212121);
    lbTip.text = @"核对账户信息";
    
    
    NSArray *titleArr = @[@"账户姓名:",@"支付宝账号:"];
    
    // 内容确认
    for (int i = 0; i < 2; i++) {
        
        UILabel *lbTitle = [[UILabel alloc] init];
        [_tanchuUv addSubview:lbTitle];
        [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lbFengeInAlert.mas_bottom).with.offset(0.12828 * _tanchuUv.frame.size.height + 0.142857 *_tanchuUv.frame.size.height * i);
            make.left.equalTo(imgViewInAlert);
            make.height.equalTo(@(15));
        }];
        lbTitle.font = [UIFont systemFontOfSize:14];
        lbTitle.textColor = FUIColorFromRGB(0x999999);
        lbTitle.text = titleArr[i];
        
        UILabel *lbDetail = [[UILabel alloc] init];
        [_tanchuUv addSubview:lbDetail];
        [lbDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lbTitle);
            make.left.equalTo(lbTitle.mas_right).with.offset(5);
            make.height.equalTo(@(16));
        }];
        lbDetail.font = [UIFont systemFontOfSize:15];
        lbDetail.textColor = FUIColorFromRGB(0x212121);
        lbDetail.tag = 300 + i;
    }
    
    // 确定修改按钮
    for (int i = 0; i < 2; i++) {
        UILabel *lb = [self.view viewWithTag:301];
    
        UIButton *btn = [[UIButton alloc] init];
        [_tanchuUv addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lb.mas_bottom).with.offset(0.1457726 *_tanchuUv.frame.size.height);
            make.left.equalTo(imgViewInAlert).with.offset(0.42857 * _tanchuUv.frame.size.width * i);
            make.width.equalTo(@(0.383886 * _tanchuUv.frame.size.width));
            make.height.equalTo(@(0.14 * _tanchuUv.frame.size.height));
        }];
        if (i == 0) {
            btn.backgroundColor = FUIColorFromRGB(0x8979ff);
            [btn setTitle:@"确定" forState:UIControlStateNormal];
            [btn setTitleColor:FUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
        }else {
            btn.backgroundColor = FUIColorFromRGB(0xff5672);
            [btn setTitle:@"修改" forState:UIControlStateNormal];
            [btn setTitleColor:FUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
        }
        btn.layer.cornerRadius = 0.07 * _tanchuUv.frame.size.height;
        [btn addTarget:self action:@selector(btnSureClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 400 + i;
    }
    
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
    lbTitle.text = @"绑定支付宝";
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
    lbContent.text = @"为了账户资金安全,只能使用您本人的支付宝账户！";
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
    
    if (btn.tag == 400) {
        
        UIButton *btnXiugai = [self.view viewWithTag:401];
        btnXiugai.hidden = YES;
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(btnChangeTitle)  userInfo:nil repeats:YES];
        
        [UIView animateWithDuration:0.5f animations:^{
            
            CGRect frame = btn.frame;
            frame.size = CGSizeMake(_tanchuUv.frame.size.width * 0.8095238, 0.14 * _tanchuUv.frame.size.height);
            btn.frame = frame;
        }];
        
    }else if(btn.tag == 401){
        
        _zhezhaoUv.hidden = YES;
        _tanchuUv.hidden = YES;
        alert(@"点击了修改");
        
    }else if(btn.tag == 402){
        
        _zhezhaoUv.hidden = YES;
        _tipTanchuUv.hidden = YES;
        NSLog(@"点击了我知道了");
    }
}

// 每0.5秒改变label的文字
- (void) btnChangeTitle {
    
    UIButton *btn = [self.view viewWithTag:400];
    // 修改Label的文字
    NSArray *arr = @[@"账户绑定中.",@"账户绑定中..",@"账户绑定中...",@"账户绑定中....",@"账户绑定中.",@"账户绑定中.."];
    
    if (i < 6) {
        
        // 修改label上的文字....
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        
        i++;
        
    }else {
        // 关闭定时器，永久关闭定时器
        [_timer invalidate];
        
        
        // 在这里发送数据请求，数据请求成功后，执行下面的操作
        
        
        
        // 关闭弹出的窗口
        _zhezhaoUv.hidden = YES;
        _tanchuUv.hidden = YES;
        // 改回原始状态
        UIButton *btnXiugai = [self.view viewWithTag:401];
        btnXiugai.hidden = NO;
        CGRect frame = btn.frame;
        frame.size = CGSizeMake(_tanchuUv.frame.size.width * 0.383886, 0.14 * _tanchuUv.frame.size.height);
        btn.frame = frame;
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        
        // 把定时器计次变为初始值
        i = 0;
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
    
    // 释放第一响应者
    UITextField *tf1 = [self.view viewWithTag:666];
    [tf1 resignFirstResponder];
    UILabel *lb = [self.view viewWithTag:300];
    lb.text = @"用户姓名";
    UILabel *lb2 = [self.view viewWithTag:301];
    lb2.text = tf1.text;
    
    _zhezhaoUv.hidden = NO;
    _tanchuUv.hidden = NO;
    
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
