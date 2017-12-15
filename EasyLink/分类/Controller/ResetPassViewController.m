//
//  ResetPassViewController.m
//  EasyLink
//
//  Created by 琦琦 on 16/11/1.
//  Copyright © 2016年 fengdian. All rights reserved.
//  重置密码

#import "ResetPassViewController.h"
#import "LoginViewController.h"

@interface ResetPassViewController () {
    
    NSString *_ServePublicKeyStr; // 服务器的公共RSA公钥
}

@property (nonatomic, copy) MBProgressHUD *HUD;

@end

@implementation ResetPassViewController

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

// 布局页面
- (void) layoutViews {
    
    // 密码图标1
    UIImageView *passImgView1 = [[UIImageView alloc] init];
    [self.view addSubview:passImgView1];
    [passImgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0.176 * H - 64);
        make.left.equalTo(self.view).with.offset(0.12 * W);
        make.width.equalTo(@(W / 28));
        make.height.equalTo(@(W / 28));
    }];
    passImgView1.image = [UIImage imageNamed:@"修改手机号1"];
    // 输入线
    UILabel *lbPass1 = [[UILabel alloc] init];
    [self.view addSubview:lbPass1];
    [lbPass1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passImgView1.mas_bottom).with.offset(H * 0.0185);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(W * 0.8125));
        make.height.equalTo(@(1));
    }];
    lbPass1.backgroundColor = FUIColorFromRGB(0xd5d5d5);
    // 输入框
    UITextField *passTf1 = [[UITextField alloc] init];
    [self.view addSubview:passTf1];
    [passTf1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passImgView1);
        make.left.equalTo(self.view).with.offset(W * 0.12 + W * 0.0375 + 20);
        make.width.equalTo(@(W * 0.8125 - W * 0.12 - W * 0.0375 - 20));
        make.height.equalTo(@(W * 0.0375 + 5));
    }];
    passTf1.font = [UIFont systemFontOfSize:15];
    passTf1.placeholder = @"请输入新密码";
    passTf1.tag = 666;
    passTf1.secureTextEntry = YES;
    
    // 密码图标2
    UIImageView *passImgView2 = [[UIImageView alloc] init];
    [self.view addSubview:passImgView2];
    [passImgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(H * 0.25 - 64);
        make.left.equalTo(passImgView1);
        make.width.height.equalTo(passImgView1.mas_width);
    }];
    passImgView2.image = [UIImage imageNamed:@"修改手机号1"];
    // 输入线
    UILabel *lbPass2 = [[UILabel alloc] init];
    [self.view addSubview:lbPass2];
    [lbPass2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passImgView2.mas_bottom).with.offset(H * 0.0185);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(W * 0.8125));
        make.height.equalTo(@(1));
    }];
    lbPass2.backgroundColor = FUIColorFromRGB(0xd5d5d5);
    // 输入框
    UITextField *passTf2 = [[UITextField alloc] init];
    [self.view addSubview:passTf2];
    [passTf2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passImgView2);
        make.left.equalTo(self.view).with.offset(W * 0.12 + W * 0.0375 + 20);
        make.width.equalTo(@(W * 0.8125 - W * 0.12 - W * 0.0375 - 20));
        make.height.equalTo(@(W * 0.0375 + 5));
    }];
    passTf2.font = [UIFont systemFontOfSize:15];
    passTf2.placeholder = @"请再次输入新密码";
    passTf2.tag = 667;
    passTf2.secureTextEntry = YES;
    
    // 完成按钮
    UIButton *nextBtn = [[UIButton alloc] init];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbPass2).with.offset(0.072 * H);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(W * 0.65625));
        make.height.equalTo(@(H * 0.047 + 10));
    }];
    [nextBtn setTitle:@"完成" forState:UIControlStateNormal];
    [nextBtn setTitleColor:FUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [nextBtn setBackgroundColor:FUIColorFromRGB(0x8979ff)];
    nextBtn.clipsToBounds = YES;
    nextBtn.layer.cornerRadius = (H * 0.047 + 10) / 2;
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [nextBtn addTarget:self action:@selector(okClick:) forControlEvents:UIControlEventTouchUpInside];
}

// 完成按钮点击事件
- (void) okClick:(UIButton *)nextBtn {
    
    NSLog(@"完成");
    
    // 创建动画
    _HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    // 展示动画
    [_HUD show:YES];
    
    // 获取公共RSA公钥，进行网络请求
    HttpRequest *http = [[HttpRequest alloc] init];
    
    // 判断输入框是否为空,不为空，则进行请求
    UITextField *tf0 = [self.view viewWithTag:666];
    UITextField *tf1 = [self.view viewWithTag:667];
    if (tf0.text.length == 0) {
        
        [http GetHttpDefeatAlert:@"请输入新密码"];
        // 结束动画
        [_HUD hide:YES];
    }else if (tf1.text.length == 0) {
        
        [http GetHttpDefeatAlert:@"请再次输入新密码"];
        // 结束动画
        [_HUD hide:YES];
        
    }else if([tf1.text isEqualToString:tf0.text] == NO) {
        
        [http GetHttpDefeatAlert:@"两次输入密码不符,请重新输入"];
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
            NSDictionary *dataDic = @{@"phone":_phone,@"confirmcode":_strCode,@"password":tf0.text};
            // 转换成json并用aes进行加密，并做了base64和urlcode编码处理
            // 最终加密好的data参数的密文
            NSString *dataMiWenStr = [[MakeJson createJson:dataDic] AES128EncryptWithKey:strAESkey];
            
            
            // 创建请求验证码需要post的dic
            NSDictionary *postDataDic = @{@"key":keyMiWenStr,@"cg":cgMiWenStr,@"data":dataMiWenStr};
            
            [http PostResetPassWordWithDic:postDataDic Success:^(id resetMessage) {
                
                
                
                if ([resetMessage isEqualToString:@"0"]) {
                    
                    // 关闭动画
                    [_HUD hide:YES];
                    
                }else {
                    
                    [http GetHttpDefeatAlert:resetMessage];
                    
                    // 结束动画
                    [_HUD hide:YES];
                    
                    // 重置成功，跳转回登录页面
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    [user removeObjectForKey:@"token"];
                    [user removeObjectForKey:@"severPublicKey"];
                    
                    // 返回上一层
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
                
            } failure:^(NSError *error) {
                
                // 重置密码的请求失败
            }];
            
        } failure:^(NSError *error) {
            
        }];
    }

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

// 触发事件
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 释放第一响应者
    UITextField *tf1 = [self.view viewWithTag:666];
    [tf1 resignFirstResponder];
    UITextField *tf2 = [self.view viewWithTag:667];
    [tf2 resignFirstResponder];
}

// 返回按钮点击事件
- (void) doBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 页面将要加载
- (void) viewWillAppear:(BOOL)animated {
    
    // 设置导航栏背景色(用到了UIImage+GradientColor.h这个类扩展)
    UIColor *topleftColor = FUIColorFromRGB(0x9080ff);
    UIColor *bottomrightColor = FUIColorFromRGB(0x7765ff);
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor, bottomrightColor] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(W, 64)];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:bgImg]];
    
//    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    
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
