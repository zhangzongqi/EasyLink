//
//  ChangePhoneViewController.m
//  EasyLink
//
//  Created by 琦琦 on 16/11/15.
//  Copyright © 2016年 fengdian. All rights reserved.
//  更换手机号

#import "ChangePhoneViewController.h"
#import "MZTimerLabel.h" // 计时类

@interface ChangePhoneViewController ()<MZTimerLabelDelegate> {
    
    UILabel *timer_show;//倒计时label
    
    NSString *_ServePublicKeyStr; // 服务器的公共RSA公钥
}

@property (nonatomic, copy) MBProgressHUD *HUD;

@end

@implementation ChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 背景色
    self.view.backgroundColor = FUIColorFromRGB(0xffffff);
    
    // 设置导航栏标题
    UILabel *lbItemTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    lbItemTitle.text = @"更换手机号";
    lbItemTitle.textColor = [UIColor whiteColor];
    lbItemTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lbItemTitle;
    
    // 导航栏左边返回按钮
    [self createBackBtn];
    
    // 创建UI
    [self createUI];
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


// 创建UI
- (void) createUI {
    
    NSArray *arrImgName = @[@"修改手机号1",@"修改手机号2",@"修改手机号3"];
    NSArray *placeholderArr = @[@"请输入密码",@"请输入新手机号",@"请输入验证码"];
    
    // 分割线 图标
    for (int i = 0; i < 3; i++) {
        
        // 分隔线
        UILabel *lbFenge = [[UILabel alloc] init];
        [self.view addSubview:lbFenge];
        [lbFenge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(0.0833 * H * i + 0.123 * H);
            make.centerX.equalTo(self.view);
            make.width.equalTo(@(W * 0.8125));
            make.height.equalTo(@(1));
        }];
        lbFenge.backgroundColor = FUIColorFromRGB(0xd5d5d5);
        
        // 图标
        UIImageView *imgView = [[UIImageView alloc] init];
        [self.view addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lbFenge).with.offset(- 0.020833 * H);
            make.left.equalTo(self.view).with.offset(0.12 * W);
            make.width.equalTo(@(W / 32));
            
            if (i==2) {
                make.height.equalTo(imgView.mas_width);
            }else if(i == 1){
                make.height.equalTo(@(W * 0.0453));
            }else {
                make.height.equalTo(@(W / 28));
            }
        }];
        imgView.image = [UIImage imageNamed:arrImgName[i]];
        
        // 输入框
        UITextField *tf = [[UITextField alloc] init];
        [self.view addSubview:tf];
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0 || i == 2) {
                make.bottom.equalTo(lbFenge).with.offset(- 0.020833 * H);
            }else {
                make.centerY.equalTo(imgView);
            }
            make.left.equalTo(imgView.mas_right).with.offset(0.03125 * W);
            make.height.equalTo(@(W / 30));
            make.width.equalTo(@(W / 2));
        }];
        if (iPhone6SP) {
            tf.font = [UIFont systemFontOfSize:14];
        }else if(iPhone6S){
            tf.font = [UIFont systemFontOfSize:13];
        }else {
            tf.font = [UIFont systemFontOfSize:11];
        }
        tf.textAlignment = NSTextAlignmentLeft;
        tf.placeholder = placeholderArr[i];
        tf.tag = 100 + i;
        
        if (i == 2) {
            // 倒计时按钮
            UIButton *timeBtn = [[UIButton alloc] init];
            [self.view addSubview:timeBtn];
            [timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(imgView);
                make.right.equalTo(lbFenge.mas_right);
                make.height.equalTo(tf.mas_height);
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
            [lbFenge mas_makeConstraints:^(MASConstraintMaker *
                make) {
                make.centerY.equalTo(timeBtn);
                make.right.equalTo(timeBtn.mas_left);
                make.height.equalTo(timeBtn);
                make.width.equalTo(@(1));
            }];
            lbFenge.backgroundColor = FUIColorFromRGB(0xd5d5d5);
        
            // 完成按钮
            UIButton *btnFinish = [[UIButton alloc] init];
            [self.view addSubview:btnFinish];
            [btnFinish mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lbFenge).with.offset(0.084375 * H);
                make.centerX.equalTo(self.view);
                make.height.equalTo(@(0.05625 * H));
                make.width.equalTo(@(0.65625 * W));
            }];
            btnFinish.backgroundColor = FUIColorFromRGB(0x8979ff);
            [btnFinish setTitle:@"完成" forState:UIControlStateNormal];
            btnFinish.titleLabel.font = [UIFont systemFontOfSize:15];
            [btnFinish setTitleColor:FUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            btnFinish.layer.cornerRadius = 0.05625 * H / 2;
            btnFinish.clipsToBounds = YES;
            [btnFinish addTarget:self action:@selector(finishClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

// 完成按钮点击事件
- (void) finishClick:(UIButton *)btnFinish {
    
    alert(@"点击了完成");
}

// 触发事件
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 释放第一响应者
    for (int i = 0; i < 3; i++) {
        UITextField *tf = [self.view viewWithTag:100+i];
        [tf resignFirstResponder];
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
                
                // 获取验证码失败
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
    
    UIButton *btn = [self.view viewWithTag:666];
    
    [btn setTitle:@"获取验证码" forState:UIControlStateNormal];//倒计时结束后按钮名称改为"获取验证码"
    [timer_show removeFromSuperview];//移除倒计时模块
    btn.userInteractionEnabled = YES;//按钮可以点击
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
