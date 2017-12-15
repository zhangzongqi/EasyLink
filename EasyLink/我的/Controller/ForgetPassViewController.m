//
//  ForgetPassViewController.m
//  EasyLink
//
//  Created by 琦琦 on 16/11/1.
//  Copyright © 2016年 fengdian. All rights reserved.
//

#import "ForgetPassViewController.h"
#import "MZTimerLabel.h" // 计时类
#import "ResetPassViewController.h" // 重置密码页面

@interface ForgetPassViewController ()<MZTimerLabelDelegate> {
    
    UILabel *timer_show; // 倒计时label
    
    NSString *_ServePublicKeyStr; // 服务器的公共RSA公钥
}

@property (nonatomic, copy) MBProgressHUD *HUD;

@end

@implementation ForgetPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 页面背景色
    self.view.backgroundColor = FUIColorFromRGB(0xffffff);
    
    // 设置导航栏标题
    UILabel *lbItemTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    lbItemTitle.text = @"忘记密码";
    lbItemTitle.textColor = [UIColor whiteColor];
    lbItemTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lbItemTitle;
    
    // 导航栏左边返回按钮
    [self createBackBtn];
    
    // 布局页面
    [self layoutViews];
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

// 布局页面
- (void) layoutViews {
    
    // 手机图标
    UIImageView *phoneImgView = [[UIImageView alloc] init];
    [self.view addSubview:phoneImgView];
    [phoneImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0.176 * H - 64);
        make.left.equalTo(self.view).with.offset(0.12 * W);
        make.width.equalTo(@(W / 32));
        make.height.equalTo(@(W * 0.0453));
    }];
    phoneImgView.image = [UIImage imageNamed:@"修改手机号2"];
    // 输入线
    UILabel *lbUser = [[UILabel alloc] init];
    [self.view addSubview:lbUser];
    [lbUser mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneImgView.mas_bottom).with.offset(H * 0.0185);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(W * 0.8125));
        make.height.equalTo(@(1));
    }];
    lbUser.backgroundColor = FUIColorFromRGB(0xd5d5d5);
    // 输入框
    UITextField *userTf = [[UITextField alloc] init];
    [self.view addSubview:userTf];
    [userTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(phoneImgView);
        make.left.equalTo(self.view).with.offset(W * 0.12 + W * 0.0375 + 20);
        make.width.equalTo(@(W * 0.8125 - W * 0.12 - W * 0.0375 - 20));
        make.height.equalTo(@(W * 0.0375 + 5));
    }];
    userTf.font = [UIFont systemFontOfSize:15];
    userTf.placeholder = @"请输入手机号";
    userTf.tag = 500;
    
    // 验证码图标
    UIImageView *yanzhengImgView = [[UIImageView alloc] init];
    [self.view addSubview:yanzhengImgView];
    [yanzhengImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(H * 0.25 - 64);
        make.left.equalTo(phoneImgView);
        make.width.height.equalTo(phoneImgView.mas_width);
    }];
    yanzhengImgView.image = [UIImage imageNamed:@"修改手机号3"];
    // 输入线
    UILabel *lbYanzheng = [[UILabel alloc] init];
    [self.view addSubview:lbYanzheng];
    [lbYanzheng mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(yanzhengImgView.mas_bottom).with.offset(H * 0.0185);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(W * 0.8125));
        make.height.equalTo(@(1));
    }];
    lbYanzheng.backgroundColor = FUIColorFromRGB(0xd5d5d5);
    // 输入框
    UITextField *yanzhengTf = [[UITextField alloc] init];
    [self.view addSubview:yanzhengTf];
    [yanzhengTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(yanzhengImgView);
        make.left.equalTo(self.view).with.offset(W * 0.12 + W * 0.0375 + 20);
        make.width.equalTo(@(96));
        make.height.equalTo(@(W * 0.0375 + 5));
    }];
    yanzhengTf.font = [UIFont systemFontOfSize:15];
    yanzhengTf.placeholder = @"请输入验证码";
    yanzhengTf.tag = 667;

    // 倒计时按钮
    UIButton *timeBtn = [[UIButton alloc] init];
    [self.view addSubview:timeBtn];
    [timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(yanzhengImgView);
        make.right.equalTo(lbYanzheng.mas_right);
        make.height.equalTo(yanzhengTf.mas_height);
        make.width.equalTo(@(90));
    }];
    timeBtn.backgroundColor = [UIColor clearColor];
    [timeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [timeBtn setTitleColor:FUIColorFromRGB(0x8e7eff) forState:UIControlStateNormal];
    timeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    timeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [timeBtn addTarget:self action:@selector(getCodeClick) forControlEvents:UIControlEventTouchUpInside];
    timeBtn.tag = 666;
    
    // 分割线
    UILabel *lbFenge = [[UILabel alloc] init];
    [self.view addSubview:lbFenge];
    [lbFenge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeBtn);
        make.right.equalTo(timeBtn.mas_left);
        make.height.equalTo(timeBtn);
        make.width.equalTo(@(1));
    }];
    lbFenge.backgroundColor = FUIColorFromRGB(0xd5d5d5);
    
    // 下一步按钮
    UIButton *nextBtn = [[UIButton alloc] init];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbYanzheng).with.offset(0.072 * H);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(W * 0.65625));
        make.height.equalTo(@(H * 0.047 + 10));
    }];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:FUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [nextBtn setBackgroundColor:FUIColorFromRGB(0x8979ff)];
    nextBtn.clipsToBounds = YES;
    nextBtn.layer.cornerRadius = (H * 0.047 + 10) / 2;
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [nextBtn addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

// 下一步点击事件
- (void)nextClick:(UIButton *)nextBtn {
    
    NSLog(@"下一步");
    
    
    // 创建动画
    _HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    // 展示动画
    [_HUD show:YES];
    
    // 获取公共RSA公钥，进行网络请求
    HttpRequest *http = [[HttpRequest alloc] init];
    
    // 判断输入框是否为空,不为空，则进行请求
    UITextField *tf0 = [self.view viewWithTag:500];
    UITextField *tf1 = [self.view viewWithTag:667];
    if (tf0.text.length == 0) {
        
        [http GetHttpDefeatAlert:@"请输入手机号"];
        // 结束动画
        [_HUD hide:YES];
        
    }else if (tf1.text.length == 0){
        
        [http GetHttpDefeatAlert:@"请输入验证码"];
        // 结束动画
        [_HUD hide:YES];
        
    }else {
        
        // 生成一个16位的AES的key,并保存用于解密服务器返回的信息
        NSString *strAESkey = [NSString set32bitString:16];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:strAESkey forKey:@"aesKey"];
        NSLog(@"straeskey:%@",strAESkey);
        
        // 请求RSA公钥,并把生成的AESKey进行加密
        [http GetRSAPublicKeySuccess:^(id strPublickey) {
            
            _ServePublicKeyStr = [UrlcodeAndBase64 jiemaurlDecodeAndBase64String:strPublickey];
            
            // 最终加密好的key参数的密文
            NSString *keyMiWenStr = [RSAEncryptor encryptString:strAESkey publicKey:_ServePublicKeyStr];
            
            
            // 获取当前时间戳，转换成json类型，并用AES进行加密,并做了base64及urlcode转码处理
            NSDate *senddate = [NSDate date];
            NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
            
            
            NSDictionary *cgDic = @{@"requestTime":date2};
            // 最终加密好的cg参数的密文
            NSString *cgMiWenStr = [[MakeJson createJson:cgDic] AES128EncryptWithKey:strAESkey];
            
            // 用户信息，和获取验证码类型，用于请求验证码
            NSDictionary *dataDic = @{@"phone":tf0.text,@"opt":@"2",@"code":tf1.text};
            // 转换成json并用aes进行加密，并做了base64和urlcode编码处理
            // 最终加密好的data参数的密文
            NSString *dataMiWenStr = [[MakeJson createJson:dataDic] AES128EncryptWithKey:strAESkey];
            
            
            // 创建请求验证码需要post的dic
            NSDictionary *postDataDic = @{@"key":keyMiWenStr,@"cg":cgMiWenStr,@"data":dataMiWenStr};
            [http PostCheckCodeWithDic:postDataDic Success:^(id confirmCode) {
                
                NSLog(@"服务器返回的code:%@",confirmCode);
                
                if ([confirmCode isEqualToString:@"0"]) {
                    
                    // 关闭动画
                    [_HUD hide:YES];
                    
                }else {
                    
                    // 结束动画
                    [_HUD hide:YES];
                    
                    
                    // 跳转到修改密码页面
                    ResetPassViewController *vc = [[ResetPassViewController alloc] init];
                    vc.strCode = confirmCode;
                    vc.phone = tf0.text;
                    
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            } failure:^(NSError *error) {
                
                // 验证失败
            }];
            
        } failure:^(NSError *error) {
            
        }];
    }
    
}

// 获取验证码点击事件
- (void) getCodeClick {
    
    // 创建动画
    _HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    // 展示动画
    [_HUD show:YES];
    
    
    // 获取公共RSA公钥，进行网络请求
    HttpRequest *http = [[HttpRequest alloc] init];
    
    // 判断输入框是否为空,不为空，则进行请求
    UITextField *tf0 = [self.view viewWithTag:500];
    if (tf0.text.length == 0) {
        
        [http GetHttpDefeatAlert:@"请填写手机号"];
        // 结束动画
        [_HUD hide:YES];
        
    }else {
        
        // 获取公共公钥后,生成一个16位的AES的key,并保存用于解密服务器返回的信息
        NSString *strAESkey = [NSString set32bitString:16];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:strAESkey forKey:@"aesKey"];
        
        
        [http GetRSAPublicKeySuccess:^(id strPublickey) {
            
            _ServePublicKeyStr = [UrlcodeAndBase64 jiemaurlDecodeAndBase64String:strPublickey];
            
            // 最终加密好的key参数的密文
            NSString *keyMiWenStr = [RSAEncryptor encryptString:strAESkey publicKey:_ServePublicKeyStr];
            
            
            // 获取当前时间戳，转换成json类型，并用AES进行加密,并做了base64及urlcode转码处理
            NSDate *senddate = [NSDate date];
            NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
            
            
            NSDictionary *cgDic = @{@"requestTime":date2};
            // 最终加密好的cg参数的密文
            NSString *cgMiWenStr = [[MakeJson createJson:cgDic] AES128EncryptWithKey:strAESkey];
            
            
            // 用户信息，和获取验证码类型，用于请求验证码
            NSDictionary *dataDic = @{@"phone":tf0.text,@"opt":@"2"};
            // 转换成json并用aes进行加密，并做了base64和urlcode编码处理
            // 最终加密好的data参数的密文
            NSString *dataMiWenStr = [[MakeJson createJson:dataDic] AES128EncryptWithKey:strAESkey];
            
            
            // 创建请求验证码需要post的dic
            NSDictionary *postDataDic = @{@"key":keyMiWenStr,@"cg":cgMiWenStr,@"data":dataMiWenStr};
            [http PostPhoneCodeWithDic:postDataDic Success:^(id status) {
                
                
                // 请求成功,开始倒计时
                if ([status isEqualToString:@"0"]) {
                    
                    // 结束动画
                    [_HUD hide:YES];
                    
                }else {
                    
                    // 结束动画
                    [_HUD hide:YES];
                    // 倒计时
                    [self timeCount];
                }
                
            } failure:^(NSError *error) {
                
                
            }];
            
        } failure:^(NSError *error) {
            
        }];
    }
    
}


// 倒计时方法
- (void)timeCount{//倒计时函数
    
    UIButton *btn = [self.view viewWithTag:666];
    
    [btn setTitle:nil forState:UIControlStateNormal];//把按钮原先的名字消掉
    timer_show = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, btn.frame.size.width, btn.frame.size.height)];//UILabel设置成和UIButton一样的尺寸和位置
    timer_show.backgroundColor = [UIColor clearColor];// 设置背景色
    [btn addSubview:timer_show];//把timer_show添加到_dynamicCode_btn按钮上
    MZTimerLabel *timer_cutDown = [[MZTimerLabel alloc] initWithLabel:timer_show andTimerType:MZTimerLabelTypeTimer];//创建MZTimerLabel类的对象timer_cutDown
    [timer_cutDown setCountDownTime:60];//倒计时时间60s
    timer_cutDown.timeFormat = @"ss 重新获取";//倒计时格式,也可以是@"HH:mm:ss SS"，时，分，秒，毫秒；想用哪个就写哪个
    timer_cutDown.timeLabel.textColor = [UIColor colorWithRed:135/255.0 green:135/255.0 blue:135/255.0 alpha:1.0];//倒计时字体颜色
    timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:13.0];//倒计时字体大小
    timer_cutDown.timeLabel.textAlignment = NSTextAlignmentCenter;//剧中
    timer_cutDown.delegate = self;//设置代理，以便后面倒计时结束时调用代理
    btn.userInteractionEnabled = NO;//按钮禁止点击
    [timer_cutDown start];//开始计时
}

//倒计时结束后的代理方法
- (void)timerLabel:(MZTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    
    // 获取到获取验证码的Button
    UIButton *btn = [self.view viewWithTag:666];
    
    [btn setTitle:@"获取验证码" forState:UIControlStateNormal];//倒计时结束后按钮名称改为"获取验证码"
    [timer_show removeFromSuperview];//移除倒计时模块
    btn.userInteractionEnabled = YES;//按钮可以点击
}

// 触发事件
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 释放第一响应者
    UITextField *tf1 = [self.view viewWithTag:500];
    [tf1 resignFirstResponder];
    UITextField *tf2 = [self.view viewWithTag:667];
    [tf2 resignFirstResponder];
}

// 页面将要加载
- (void) viewWillAppear:(BOOL)animated {
    
    // 设置导航栏背景色(用到了UIImage+GradientColor.h这个类扩展)
    UIColor *topleftColor = FUIColorFromRGB(0x9080ff);
    UIColor *bottomrightColor = FUIColorFromRGB(0x7765ff);
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor, bottomrightColor] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(W, 64)];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:bgImg]];
    
//    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO    animated:NO];
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
