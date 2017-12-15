//
//  RegisterViewController.m
//  EasyLink
//
//  Created by 琦琦 on 16/11/1.
//  Copyright © 2016年 fengdian. All rights reserved.
//

#import "RegisterViewController.h"
#import "MZTimerLabel.h" // 计时类
#import "testViewController.h"

@interface RegisterViewController ()<MZTimerLabelDelegate> {
    
    UILabel *timer_show;//倒计时label
    
    NSString *_ServePublicKeyStr; // 服务器的公共RSA公钥
}

@property (nonatomic,copy) MBProgressHUD *HUD;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 布局页面
    [self layoutViews];
}

// 布局页面
- (void) layoutViews {
    
    // 背景图
    UIImageView *backImgView = [[UIImageView alloc] init];
    [self.view addSubview:backImgView];
    [backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(@(W));
        make.height.equalTo(@(0.352 * H));
    }];
    backImgView.image = [UIImage imageNamed:@"注册bg"];
    backImgView.userInteractionEnabled = YES;
    
    // 返回按钮
    UIButton *backBtn = [[UIButton alloc] init];
    [backImgView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImgView).with.offset(20);
        make.left.equalTo(backImgView).with.offset(5);
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
    
    // 手机小图标
    UIImageView *phoneImgView = [[UIImageView alloc] init];
    [self.view addSubview:phoneImgView];
    [phoneImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImgView.mas_bottom).with.offset(H * 0.12 - 22);
        make.left.equalTo(self.view).with.offset(W * 0.178125);
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
        make.width.equalTo(@(0.65625 * W));
        make.height.equalTo(@(1));
    }];
    lbUser.backgroundColor = FUIColorFromRGB(0xd5d5d5);
    // 输入框
    UITextField *userTf = [[UITextField alloc] init];
    [self.view addSubview:userTf];
    [userTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(phoneImgView);
        make.left.equalTo(self.view).with.offset(W * 0.1875 + W * 0.0375 + 5);
        make.width.equalTo(@(W - W * 0.1875 * 2));
        make.height.equalTo(@(W * 0.0375 + 5));
    }];
    userTf.font = [UIFont systemFontOfSize:15];
    userTf.placeholder = @"请输入手机号";
    userTf.tag = 500;
    
    // 验证码图标
    UIImageView *yanzhengImgView = [[UIImageView alloc] init];
    [self.view addSubview:yanzhengImgView];
    [yanzhengImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbUser.mas_bottom).with.offset(H * 0.035);
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
        make.width.equalTo(lbUser);
        make.height.equalTo(@(1));
    }];
    lbYanzheng.backgroundColor = FUIColorFromRGB(0xd5d5d5);
    // 输入框
    UITextField *yanzhengTf = [[UITextField alloc] init];
    [self.view addSubview:yanzhengTf];
    [yanzhengTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(yanzhengImgView);
        make.left.equalTo(self.view).with.offset(W * 0.1875 + W * 0.0375 + 5);
        make.width.equalTo(@(96));
        make.height.equalTo(@(W * 0.0375 + 5));
    }];
    yanzhengTf.font = [UIFont systemFontOfSize:15];
    yanzhengTf.placeholder = @"请输入验证码";
    yanzhengTf.tag = 501;
    
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
    
    // 密码图标
    UIImageView *passImgView = [[UIImageView alloc] init];
    [self.view addSubview:passImgView];
    [passImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbYanzheng.mas_bottom).with.offset(H * 0.035);
        make.left.equalTo(phoneImgView);
        make.width.height.equalTo(phoneImgView.mas_width);
    }];
    passImgView.image = [UIImage imageNamed:@"修改手机号1"];
    // 输入线
    UILabel *lbPass = [[UILabel alloc] init];
    [self.view addSubview:lbPass];
    [lbPass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passImgView.mas_bottom).with.offset(H * 0.0185);
        make.centerX.equalTo(self.view);
        make.width.equalTo(lbUser);
        make.height.equalTo(@(1));
    }];
    lbPass.backgroundColor = FUIColorFromRGB(0xd5d5d5);
    // 输入框
    UITextField *passTf = [[UITextField alloc] init];
    [self.view addSubview:passTf];
    [passTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passImgView);
        make.left.equalTo(self.view).with.offset(W * 0.1875 + W * 0.0375 + 5);
        make.width.equalTo(@(W - W * 0.1875 * 2));
        make.height.equalTo(@(W * 0.0375 + 5));
    }];
    passTf.font = [UIFont systemFontOfSize:15];
    passTf.placeholder = @"请输入密码";
    passTf.tag = 502;
    passTf.secureTextEntry = YES;
    
    // 注册按钮
    UIButton *registerBtn = [[UIButton alloc] init];
    [self.view addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbPass).with.offset(0.072 * H - 10);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(W * 0.65625));
        make.height.equalTo(@(H * 0.047 + 6));
    }];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:FUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [registerBtn setBackgroundColor:FUIColorFromRGB(0x8979ff)];
    registerBtn.clipsToBounds = YES;
    registerBtn.layer.cornerRadius = (H * 0.047 + 6) / 2;
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [registerBtn addTarget:self action:@selector(registerClick:) forControlEvents:UIControlEventTouchUpInside];
}

// 返回按钮
- (void) backClick:(UIButton *)backBtn {
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 注册点击事件
- (void) registerClick:(UIButton *)registerBtn {
    
//    NSLog(@"注册");
    
    // 创建动画
    _HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    // 展示动画
    [_HUD show:YES];
    
    // 获取公共RSA公钥，进行网络请求
    HttpRequest *http = [[HttpRequest alloc] init];
    
    // 判断输入框是否为空,不为空，则进行请求
    UITextField *tf0 = [self.view viewWithTag:500];
    UITextField *tf1 = [self.view viewWithTag:501];
    UITextField *tf2 = [self.view viewWithTag:502];
    if (tf0.text.length == 0) {
        
        [http GetHttpDefeatAlert:@"请填写正确的手机号"];
        // 结束动画
        [_HUD hide:YES];
        
    }else if (tf1.text.length == 0){
            
        [http GetHttpDefeatAlert:@"请填写正确的验证码"];
        // 结束动画
        [_HUD hide:YES];
        
    }else if (tf2.text.length == 0){
        
        [http GetHttpDefeatAlert:@"请填写正确的密码"];
        // 结束动画
        [_HUD hide:YES];
        
    }else {
        
        
        // 生成一个16位的AES的key,并保存用于解密服务器返回的信息
        NSString *strAESkey = [NSString set32bitString:16];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:strAESkey forKey:@"aesKey"];
        
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
            NSDictionary *dataDic = @{@"phone":tf0.text,@"code":tf1.text,@"password":tf2.text,@"rsa_public_key":[user objectForKey:@"localPublickey"]};
            // 转换成json并用aes进行加密，并做了base64和urlcode编码处理
            // 最终加密好的data参数的密文
            NSString *dataMiWenStr = [[MakeJson createJson:dataDic] AES128EncryptWithKey:strAESkey];
            
            
            // 创建请求验证码需要post的dic
            NSDictionary *postDataDic = @{@"key":keyMiWenStr,@"cg":cgMiWenStr,@"data":dataMiWenStr};
            [http PostRegisterWithDic:postDataDic Success:^(id userDataJsonStr) {
                
                NSLog(@"服务器返回的最终data:%@",userDataJsonStr);
                
                if ([userDataJsonStr isEqualToString:@"0"]) {
                    
                    // 关闭动画
                    [_HUD hide:YES];
                }else {
                 
                    // 得到用户的Dic字符串
                    NSDictionary *userDataDic = [MakeJson createDictionaryWithJsonString:userDataJsonStr];
                    // 创建单例,保存token和服务器给的公钥
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    [user setObject:[userDataDic objectForKey:@"rsa_public_key"] forKey:@"severPublicKey"];
                    [user setObject:[userDataDic objectForKey:@"token"] forKey:@"token"];
                    
                    NSLog(@"得到的服务器的公钥:%@",[userDataDic objectForKey:@"rsa_public_key"]);
                    NSLog(@"得到的token:%@",[userDataDic objectForKey:@"token"]);
                    
                    // 结束动画
                    [_HUD hide:YES];
                    
                    // 提醒注册成功即将自动登录
                    HttpRequest *http = [[HttpRequest alloc] init];
                    [http GetHttpDefeatAlert:@"恭喜您,注册成功! 即将自动登录~"];
                    
                    // 发送通知,用于修改我的页面用户资料
                    // 创建消息中心
                    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
                    // 在消息中心发布自己的消息
                    [notiCenter postNotificationName:@"registerSuccess" object:@"4"];
                    
                    // 1秒后，跳转
                    [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(tiaozhuanEvent) userInfo:nil repeats:NO];
                }
                
            } failure:^(NSError *error) {
                
                // 注册失败
            }];
            
        } failure:^(NSError *error) {
            
        }];
    }
    
    // 测试跳转的页面
//    testViewController * vc = [[testViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}

// 注册成功,自动登录事件
- (void) tiaozhuanEvent {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// 触发事件
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 释放第一响应者
    UITextField *tf1 = [self.view viewWithTag:500];
    [tf1 resignFirstResponder];
    UITextField *tf2 = [self.view viewWithTag:501];
    [tf2 resignFirstResponder];
    UITextField *tf3 = [self.view viewWithTag:502];
    [tf3 resignFirstResponder];

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
            NSDictionary *dataDic = @{@"phone":tf0.text,@"opt":@"1"};
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
            
            
//                    NSLog(@"最终加密好的key参数的密文:%@",keyMiWenStr);
//                    NSLog(@"最终加密好的cg参数的密文:%@",cgMiWenStr);
//                    NSLog(@"最终加密好的data参数的密文:%@",dataMiWenStr);
            
            //        NSLog(@"没处理之前请求到的公共公钥:%@",strPublickey);
            //        NSLog(@"经过处理完之后的公钥:%@",_ServePublicKeyStr);
            //        NSLog(@"Key%@",strAESkey);
            
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
    
    UIButton *btn = [self.view viewWithTag:666];
    
    [btn setTitle:@"获取验证码" forState:UIControlStateNormal];//倒计时结束后按钮名称改为"获取验证码"
    [timer_show removeFromSuperview];//移除倒计时模块
    btn.userInteractionEnabled = YES;//按钮可以点击
}

// 页面将要显示
- (void) viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
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
