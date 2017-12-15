//
//  AccountManageViewController.m
//  EasyLink
//
//  Created by 琦琦 on 16/10/25.
/*
 账户管理页面
 */
//  Copyright © 2016年 fengdian. All rights reserved.
//

#import "AccountManageViewController.h"
#import "MoneyAccountViewController.h" // 提现账户管理
#import "ChangePhoneViewController.h" // 更换手机号
#import "RealNameYanZhengViewController.h" // 实名认证页面
#import "AdressViewController.h" // 收货地址列表
#import "RevisePassViewController.h" // 修改密码
#import "AppDelegate.h" //
#import "LoginViewController.h" // 登录页

@interface AccountManageViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate> {
    
    // 底层滚动图
    UIScrollView *_bacScrollView;
    
    UITextField *tf;
    
    UIImageView *_iconImgView; // 头像
}

@property (nonatomic, copy) UIImage *img;

@end

@implementation AccountManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 返回按钮
    [self createBackBtn];
    
    // 设置导航栏标题
    UILabel *lbItemTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    lbItemTitle.text = @"账户管理";
    lbItemTitle.textColor = [UIColor whiteColor];
    lbItemTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lbItemTitle;
    
    // 导航栏右侧按钮
    [self createRightBtn];
    
    // 布局页面
    [self layoutViews];
    
    // 请求数据
    [self initData];
}

// 请求数据
- (void) initData {
    
    // 创建单例,获取到用户RSAKey
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userRsaPublicKey = [user objectForKey:@"severPublicKey"];
    
    
    
    // 生成一个16位的AES的key,并保存用于解密服务器返回的信息
    NSString *strAESkey = [NSString set32bitString:16];
    [user setObject:strAESkey forKey:@"aesKey"];
    // 最终加密好的key参数的密文
    NSString *keyMiWenStr = [RSAEncryptor encryptString:strAESkey publicKey:userRsaPublicKey];
    
    
    
    // 获取当前时间戳，转换成json类型，并用AES进行加密,并做了base64及urlcode转码处理
    NSDate *senddate = [NSDate date];
    NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    NSDictionary *cgDic = @{@"requestTime":date2};
    // 最终加密好的cg参数的密文
    NSString *cgMiWenStr = [[MakeJson createJson:cgDic] AES128EncryptWithKey:strAESkey];
    
    // 用户token
    NSString *userToken = [user objectForKey:@"token"];
    
    
    NSDictionary *dicForData = @{@"tk":userToken,@"key":keyMiWenStr,@"cg":cgMiWenStr};
    
    // 请求数据获取用户信息
    HttpRequest *http = [[HttpRequest alloc] init];
    [http PostUserInfoWithDic:dicForData Success:^(id userInfo) {
        
        
        NSDictionary *dicForUserInfo = [MakeJson createDictionaryWithJsonString:userInfo];
        
        
        // 头像
        if ([[dicForUserInfo objectForKey:@"icon"] length] < 1) {
            
            // 服务器没拿到，不用管，继续用默认的
            
        }else {
            
            // 修改头像
            [_iconImgView  sd_setImageWithURL:[NSURL URLWithString:[dicForUserInfo objectForKey:@"icon"]] placeholderImage:[UIImage imageNamed:@"账户管理_默认头像"]];
        }
        
        // 资料
        for (int i = 0; i < 7; i++) {
            
            UITextField *tf1 = [self.view viewWithTag:1000+i];
            if (i == 0) {
                if ([[dicForUserInfo objectForKey:@"nickname"] length] < 1) {
                    
                    
                }else {
                    
                    tf1.text = [dicForUserInfo objectForKey:@"nickname"];
                }
            }
            if (i == 1) {
                
                if ([[dicForUserInfo objectForKey:@"sign"] length] < 1) {
                    
                    
                }else {
                    
                    tf1.text = [dicForUserInfo objectForKey:@"sign"];
                }
            }
            if (i == 2) {
                
                if ([[dicForUserInfo objectForKey:@"sex"] length] < 1) {
                    
                    
                }else {
                    
                    if ([[dicForUserInfo objectForKey:@"sex"] integerValue] == 0) {
                        tf1.text = @"男";
                    }else {
                        tf1.text = @"女";
                    }
                }
            }
            if (i == 3) {
                
                if ([[dicForUserInfo objectForKey:@"birth_day"] length] < 1) {
                    
                    
                }else {
                    
                    NSLog(@"birth:%@",[dicForUserInfo objectForKey:@"birth_day"]);
                    
                    // 时间戳转换成时间
                    int dt = [[dicForUserInfo objectForKey:@"birth_day"] intValue];
                    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:dt];
                    HttpRequest *stringForDate = [[HttpRequest alloc] init];
                    NSString *strDate = [stringForDate stringFromDate:confromTimesp];
                    NSString *str = [[strDate componentsSeparatedByString:@" "] objectAtIndex:0];
                    
                    tf1.text = str;
                }
            }
            if (i == 4) {
                
                if ([[dicForUserInfo objectForKey:@"address_path_txt"] length] < 1) {
                    
                    
                }else {
                    
                    tf1.text = [dicForUserInfo objectForKey:@"address_path_txt"];
                }
            }
            if (i == 5) {
                
                if ([[dicForUserInfo objectForKey:@"marriage_state"] length] < 1) {
                    
                    
                }else {
                    
                    if ([[dicForUserInfo objectForKey:@"marriage_state"] integerValue] == 0) {
                        tf1.text = @"单身";
                    }else if([[dicForUserInfo objectForKey:@"marriage_state"] integerValue] == 1){
                        tf1.text = @"热恋中";
                    }else if ([[dicForUserInfo objectForKey:@"marriage_state"] integerValue] == 2) {
                        tf1.text = @"已婚";
                    }else {
                        tf1.text = @"其他";
                    }
                }
            }
            if (i == 6) {
                
                if ([[dicForUserInfo objectForKey:@"hobbies"] length] < 1) {
                    
                    
                }else {
                    
                    tf1.text = [dicForUserInfo objectForKey:@"hobbies"];
                }
            }
            
        }
        
        
    } failure:^(NSError *error) {
        
        // 请求失败
        
    }];

}

// 导航栏右侧按钮和视图
- (void) createRightBtn {
    
    // 右侧按钮
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 28, 15);
    [menuBtn setTitle:@"编辑" forState:UIControlStateNormal];
    menuBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [menuBtn setTitleColor:FUIColorFromRGB(0xded9fe) forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    menuBtn.selected = NO;
    menuBtn.tag = 666;
}

// 导航栏右侧按钮点击事件
- (void)rightBtnClick:(UIButton *)menuBtn {
    
    if (menuBtn.selected == NO) {

        menuBtn.selected = YES;
        [menuBtn setTitle:@"保存" forState:UIControlStateNormal];
        for (int i = 0; i < 7; i++) {
            UITextField *tf1 = [self.view viewWithTag:1000 + i];
            tf1.userInteractionEnabled = YES;
            
            if (i == 0) {
                if ([tf1 isFirstResponder] == NO) {
                    [tf1 becomeFirstResponder];
                }
            }
        }
        
        
    }else {
        
        // 创建单例,获取到用户RSAKey
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *userRsaPublicKey = [user objectForKey:@"severPublicKey"];
        
        
        // 生成一个16位的AES的key,并保存用于解密服务器返回的信息
        NSString *strAESkey = [NSString set32bitString:16];
        [user setObject:strAESkey forKey:@"aesKey"];
        // 最终加密好的key参数的密文
        NSString *keyMiWenStr = [RSAEncryptor encryptString:strAESkey publicKey:userRsaPublicKey];
        
        
        // 获取当前时间戳，转换成json类型，并用AES进行加密,并做了base64及urlcode转码处理
        NSDate *senddate = [NSDate date];
        NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
        NSDictionary *cgDic = @{@"requestTime":date2};
        // 最终加密好的cg参数的密文
        NSString *cgMiWenStr = [[MakeJson createJson:cgDic] AES128EncryptWithKey:strAESkey];
        
        // 用户token
        NSString *userToken = [user objectForKey:@"token"];
        
        
        UITextField *tf0 = [self.view viewWithTag:1000 + 0];
        UITextField *tf1 = [self.view viewWithTag:1000 + 1];
        UITextField *tf2 = [self.view viewWithTag:1000 + 2];
        UITextField *tf3 = [self.view viewWithTag:1000 + 3];
        UITextField *tf4 = [self.view viewWithTag:1000 + 4];
        UITextField *tf5 = [self.view viewWithTag:1000 + 5];
        UITextField *tf6 = [self.view viewWithTag:1000 + 6];
        
        
        NSDate *date = [self dateFromString:tf3.text];
        // 时间转时间戳的方法
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (NSInteger)[date timeIntervalSince1970]];
        NSLog(@"timeSp,%@",timeSp);
        
        
        NSString *sexStr = [[NSString alloc] init];
        if ([tf2.text isEqualToString:@"男"]) {
            sexStr = @"0";
        }else {
            sexStr = @"1";
        }
        
        NSString *qingganStr = [[NSString alloc] init];
        if ([tf5.text isEqualToString:@"单身"]) {
            qingganStr = @"0";
        }
        if ([tf5.text isEqualToString:@"热恋中"]) {
            qingganStr = @"1";
        }
        if ([tf5.text isEqualToString:@"已婚"]) {
            qingganStr = @"2";
        }
        if ([tf5.text isEqualToString:@"其他"]) {
            qingganStr = @"3";
        }
        
        NSString *strData = [[NSString alloc] init];
        
        if ([tf1.text isEqualToString:[user objectForKey:@"nickname"]]) {
            
            // 昵称未改变
            
            NSDictionary *dic = @{@"sign":tf1.text,@"sex":sexStr,@"birth_day":timeSp,@"address":tf4.text,@"marriage_state":qingganStr,@"hobbies":tf6.text,@"address_path":tf4.text,@"address":tf4.text};
            NSString *dicStr = [MakeJson createJson:dic];
            // 进行aes加密,并进行base64_encode和urlcode
            strData = [dicStr AES128EncryptWithKey:strAESkey];
        }else {
            
            // 昵称已改变
            
            NSDictionary *dic = @{@"nickname":tf0.text,@"sign":tf1.text,@"sex":sexStr,@"birth_day":timeSp,@"address_path_txt":tf4.text,@"marriage_state":qingganStr,@"hobbies":tf6.text,@"address_path":tf4.text,@"address":tf4.text};
            NSString *dicStr = [MakeJson createJson:dic];
            // 进行aes加密,并进行base64_encode和urlcode
            strData = [dicStr AES128EncryptWithKey:strAESkey];
        }
        
        
        NSDictionary *dicForData = @{@"tk":userToken,@"key":keyMiWenStr,@"cg":cgMiWenStr,@"data":strData};
        
        NSLog(@"dicForData,%@",dicForData);
        

        HttpRequest *http = [[HttpRequest alloc] init];
        [http PostReviseUserInfoWithDic:dicForData Success:^(id userInfo) {
            
            
            if ([userInfo isEqualToString:@"0"]) {
                // 修改失败了
                
            }else {
                
                // 修改成功了
//                // 把返回的信息做一次本地保存
//                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//                [user setObject:[MakeJson createDictionaryWithJsonString:userInfo] forKey:@"userInfo"];
                // 发通知，用于返回我的页面是，修改头像和昵称
                // 创建消息中心
                NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
                // 在消息中心发布自己的消息
                [notiCenter postNotificationName:@"reviseUserInfo" object:@"2"];

                
                
                // 把右上角按钮变回去
                menuBtn.selected = NO;
                [menuBtn setTitle:@"编辑" forState:UIControlStateNormal];
                // 输入框禁用
                for (int i = 0; i < 7; i++) {
                    UITextField *tf1 = [self.view viewWithTag:1000 + i];
                    tf1.userInteractionEnabled = NO;
                }
            }
            
            
            NSLog(@"userInfo:%@",userInfo);
            
            
        } failure:^(NSError *error) {
            
            
            // 请求失败
        }];
    }
}


// 字符串转换成NSDate类型
- (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyyMMdd"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}

// 布局页面
- (void) layoutViews {
    
    // 底层滚动视图
    _bacScrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_bacScrollView];
    [_bacScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.left.equalTo(self.view);
        make.width.equalTo(@(W));
        make.height.equalTo(@(H - 64));
    }];
    
    _bacScrollView.backgroundColor = FUIColorFromRGB(0xffffff);
    // 隐藏滚动条
//    _bacScrollView.showsHorizontalScrollIndicator = NO;
//    _bacScrollView.showsVerticalScrollIndicator = NO;
    
    
    // 头像
    _iconImgView = [[UIImageView alloc] init];
    [_bacScrollView addSubview:_iconImgView];
    _iconImgView.userInteractionEnabled = YES;
    [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bacScrollView).with.offset(0.056 * H);
        make.centerX.equalTo(_bacScrollView);
        make.width.height.equalTo(@(W * 7/32));
    }];
    _iconImgView.image = [UIImage imageNamed:@"账户管理_默认头像"];
    _iconImgView.layer.cornerRadius = W * 7/32 / 2;
    _iconImgView.clipsToBounds = YES;
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touxiangClick)];
    [_iconImgView addGestureRecognizer:tapGesture];
    
    UIImageView *smallPhotoImgView = [[UIImageView alloc] init];
    [_bacScrollView addSubview:smallPhotoImgView];
    [smallPhotoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImgView.mas_left).with.offset(W * 7/32 * 0.7);
        make.top.equalTo(_iconImgView).with.offset(1);
        make.width.height.equalTo(@(0.05 * W));
    }];
    smallPhotoImgView.image = [UIImage imageNamed:@"账户管理2"];
    smallPhotoImgView.layer.cornerRadius = W * 0.025;
    smallPhotoImgView.layer.borderWidth = 2;
    smallPhotoImgView.layer.borderColor = FUIColorFromRGB(0xffffff).CGColor;
    
    // 实名认证
//    UIButton *btnRealName = [[UIButton alloc] init];
//    [_bacScrollView addSubview:btnRealName];
//    [btnRealName mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(_bacScrollView);
//        make.top.equalTo(_bacScrollView).with.offset(W * 7/32 + 0.056 * H + 15);
//        make.width.equalTo(@(83));
//        make.height.equalTo(@(20));
//    }];
//    [btnRealName setImage:[UIImage imageNamed:@"账户管理1"] forState:UIControlStateNormal];
//    btnRealName.imageView.sd_layout
//    .leftSpaceToView(btnRealName,7)
//    .topSpaceToView(btnRealName,3.5)
//    .heightIs(13)
//    .widthIs(13);
//    btnRealName.titleLabel.sd_layout
//    .leftSpaceToView(btnRealName.imageView,1)
//    .topSpaceToView(btnRealName,0)
//    .heightIs(20)
//    .widthIs(56);
//    [btnRealName setTitle:@"实名认证" forState:UIControlStateNormal];
//    btnRealName.titleLabel.textAlignment = NSTextAlignmentCenter;
//    btnRealName.titleLabel.font = [UIFont systemFontOfSize:12];
//    [btnRealName setTitleColor:FUIColorFromRGB(0x8979ff) forState:UIControlStateNormal];
//    btnRealName.layer.borderColor = FUIColorFromRGB(0x8979ff).CGColor;
//    btnRealName.layer.cornerRadius = 10;
//    btnRealName.layer.borderWidth = 1.0;
//    [btnRealName addTarget:self action:@selector(btnRealNameClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 个人资料
    UILabel *lbMineMeans = [[UILabel alloc] init];
    [_bacScrollView addSubview:lbMineMeans];
    [lbMineMeans mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImgView.mas_bottom).with.offset(0.02 * H);
        make.left.equalTo(_bacScrollView).with.offset(0.0625 * W);
        make.width.equalTo(@(62));
        make.height.equalTo(@(16));
    }];
    lbMineMeans.text = @"个人资料";
    lbMineMeans.font = [UIFont systemFontOfSize:15];
    lbMineMeans.textColor = FUIColorFromRGB(0x212121);
    // 分割线
    UILabel *lbFenge1 = [[UILabel alloc] init];
    [_bacScrollView addSubview:lbFenge1];
    [lbFenge1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbMineMeans.mas_bottom).with.offset(15);
        make.left.equalTo(lbMineMeans);
        make.right.equalTo(self.view.mas_right).with.offset(- 0.0625 * W);
        make.height.equalTo(@(1));
    }];
    lbFenge1.backgroundColor = FUIColorFromRGB(0xd5d5d5);
    
    NSArray *arrMineInfoName = @[@"昵称",@"个性签名",@"性别",@"生日",@"所在城市",@"情感状态",@"个人喜好",@"更换手机号",@"收货地址",@"更换密码"];
    NSArray *arrPlaceholder = @[@"请输入昵称",@"请输入个性签名",@"请输入性别(男/女)",@"请输入生日,格式示例19960626",@"请输入所在城市",@"请输入情感状态(单身/热恋中/已婚/其他)",@"请输入个人爱好"];
    
    for (int i = 0; i < 7; i++) {
        UILabel *lb = [[UILabel alloc] init];
        [_bacScrollView addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lbFenge1.mas_bottom).with.offset(0.0625 * H + (0.071 * H * i));
            make.left.equalTo(lbFenge1).with.offset(3);
            make.width.equalTo(lbMineMeans);
            make.height.equalTo(lbMineMeans);
        }];
        lb.text = arrMineInfoName[i];
        lb.font = [UIFont systemFontOfSize:14];
        lb.textColor = FUIColorFromRGB(0x4e4e4e);
        
        // 分割线
        UILabel *lbFenge = [[UILabel alloc] init];
        [_bacScrollView addSubview:lbFenge];
        [lbFenge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lb.mas_bottom).with.offset(0.0185 * H);
            make.left.equalTo(lb);
            make.right.equalTo(lbFenge1.mas_right);
            make.height.equalTo(@(1));
        }];
        lbFenge.backgroundColor = FUIColorFromRGB(0xeeeeee);
        
        // 输入框
        tf = [[UITextField alloc] init];
        [_bacScrollView addSubview:tf];
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lbFenge);
            make.left.equalTo(lb.mas_right).with.offset(0.047 * W);
            make.right.equalTo(lbFenge1.mas_right);
            make.height.equalTo(@(0.0185 * H * 2 + 16));
        }];
        tf.placeholder = arrPlaceholder[i];
        tf.font = [UIFont systemFontOfSize:13];
        tf.userInteractionEnabled = NO;
        tf.tag = 1000 + i;
        tf.textColor = FUIColorFromRGB(0x999999);
        
        if (i == 6) {
            // 我的设置
            UILabel *lbMineSet = [[UILabel alloc] init];
            [_bacScrollView addSubview:lbMineSet];
            [lbMineSet mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lbFenge.mas_bottom).with.offset(0.062 * H);
                make.left.equalTo(lbMineMeans);
                make.width.equalTo(lbMineMeans);
                make.height.equalTo(lbMineMeans);
            }];
            lbMineSet.textColor = FUIColorFromRGB(0x212121);
            lbMineSet.text = @"个人设置";
            lbMineSet.font = [UIFont systemFontOfSize:15];
            // 分割线
            UILabel *lbFenge2 = [[UILabel alloc] init];
            [_bacScrollView addSubview:lbFenge2];
            [lbFenge2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lbMineSet.mas_bottom).with.offset(15);
                make.left.equalTo(lbMineMeans);
                make.right.equalTo(self.view.mas_right).with.offset(- 0.0625 * W);
                make.height.equalTo(@(1));
            }];
            lbFenge2.backgroundColor = FUIColorFromRGB(0xd5d5d5);
            // 属性、输入框和下划线
            for (int j = 7; j < 10; j++) {
                UILabel *lbShuxing = [[UILabel alloc] init];
                [_bacScrollView addSubview:lbShuxing];
                [lbShuxing mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lbFenge2.mas_bottom).with.offset(0.0625 * H + (0.071 * H * (j-7)));
                    make.left.equalTo(lbFenge1).with.offset(3);
                    make.width.equalTo(@(88));
                    make.height.equalTo(lbMineMeans);
                }];
                lbShuxing.text = arrMineInfoName[j];
                lbShuxing.font = [UIFont systemFontOfSize:14];
                lbShuxing.textColor = FUIColorFromRGB(0x4e4e4e);
                
                // 分割线
                UILabel *lbFenge0 = [[UILabel alloc] init];
                [_bacScrollView addSubview:lbFenge0];
                [lbFenge0 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lbShuxing.mas_bottom).with.offset(0.0185 * H);
                    make.left.equalTo(lbShuxing);
                    make.right.equalTo(lbFenge1.mas_right);
                    make.height.equalTo(@(1));
                }];
                lbFenge0.backgroundColor = FUIColorFromRGB(0xeeeeee);
                
                UIButton *btnMineSet = [[UIButton alloc] init];
                [_bacScrollView addSubview:btnMineSet];
                [btnMineSet mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lbShuxing);
                    make.left.equalTo(lbShuxing.mas_right).with.offset(0.047 * W);
                    make.right.equalTo(lbFenge1.mas_right);
                    make.height.equalTo(lbShuxing);
                }];
                btnMineSet.titleLabel.sd_layout
                .leftSpaceToView(btnMineSet,0)
                .topSpaceToView(btnMineSet,0)
                .widthIs(100)
                .heightRatioToView(btnMineSet,1);
                btnMineSet.imageView.sd_layout
                .leftSpaceToView(btnMineSet.titleLabel,btnMineSet.frame.size.width - 100 - 9.15)
                .topSpaceToView(btnMineSet,0)
                .widthIs(9.15)
                .heightIs(16);
                if (j == 7) {
                    btnMineSet.titleLabel.font = [UIFont systemFontOfSize:13];
                    [btnMineSet setTitle:@"171******76" forState:UIControlStateNormal];
                    [btnMineSet setTitleColor:FUIColorFromRGB(0x999999) forState:UIControlStateNormal];
                }
                [btnMineSet setImage:[UIImage imageNamed:@"绑定银行卡_点击选择"] forState:UIControlStateNormal];
                btnMineSet.tag = 1000 + j;
                [btnMineSet addTarget:self action:@selector(MineSetClick:) forControlEvents:UIControlEventTouchUpInside];
                
                if (j == 9) {
                    UIButton *exitBtn = [[UIButton alloc] init];
                    [_bacScrollView addSubview:exitBtn];
                    [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(lbFenge0).with.offset(0.0537 * H);
                        make.centerX.equalTo(self.view);
                        make.height.equalTo(@(H * 0.05));
                        make.width.equalTo(@(0.65625 * W));
                    }];
                    
                    [exitBtn setTitle:@"退出该账户" forState:UIControlStateNormal];
                    exitBtn.layer.cornerRadius = 0.025 * H;
                    exitBtn.backgroundColor = FUIColorFromRGB(0x8979ff);
                    exitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
                    exitBtn.titleLabel.textColor = FUIColorFromRGB(0xffffff);
                    [exitBtn addTarget:self action:@selector(exitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                    // 固定layout,获取
                    [_bacScrollView layoutIfNeeded];
                    _bacScrollView.contentSize = CGSizeMake(W, exitBtn.frame.origin.y + exitBtn.frame.size.height + 30);
                }
            }
        }
    }
}

// 头像点击事件
- (void) touxiangClick {
    
    UIAlertController *actionController = [UIAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            // 实现照相功能
            // 类型Camera
            [self loadImageWithType:UIImagePickerControllerSourceTypeCamera];
            
        }else {
            
            NSLog(@"抱歉,暂时不能照相");
            // 给用户提示
            [self showMessage:@"不支持照相功能"];
        }
        
        
    }];
    [actionController addAction:action1];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // 相册取照片 和照相相似  只需修改类型  类型为PhotoLabrary
        [self loadImageWithType:UIImagePickerControllerSourceTypePhotoLibrary];
        
    }];
    [actionController addAction:action2];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    
    [actionController addAction:action3];
    
    [self presentViewController:actionController animated:YES completion:nil];
}

- (void)loadImageWithType:(UIImagePickerControllerSourceType)type {
    
    // 创建UIImagePickerController对象
    UIImagePickerController *imagePC = [[UIImagePickerController alloc] init];
    // 设置资源类型
    imagePC.sourceType = type;
    // 设置是否可以后续操作
    imagePC.allowsEditing = YES;
    // 设置代理
    imagePC.delegate = self;
    
    // 一般都采用模态视图跳转方式
    [self presentViewController:imagePC animated:YES completion:^{
        
        NSLog(@"跳转完成");
    }];
}
// 提示框
- (void)showMessage:(NSString *)message {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alert show];
}

#pragma mark - UIImagePickerControllerDelegate -
// 点击choose完成按钮实现的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // 选取资源类型 这里是Media类型
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    // 判断当前的图片是普通图片 public.image
    if ([type isEqualToString:@"public.image"]) {
        // 选取图片 根据类型EditedImage 这个key得到图片image
        
        // 压缩大小
        _img = [self scaleToSize:[info objectForKey:UIImagePickerControllerEditedImage] size:CGSizeMake(200,200)];
        
        // colorWithPatternImage:这个方法理解为  将image转成Color
        [self imageData:_img];
        
        
        // 创建单例,获取到用户RSAKey
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *userRsaPublicKey = [user objectForKey:@"severPublicKey"];
        
        // 生成一个16位的AES的key,并保存用于解密服务器返回的信息
        NSString *strAESkey = [NSString set32bitString:16];
        [user setObject:strAESkey forKey:@"aesKey"];
        // 最终加密好的key参数的密文
        NSString *keyMiWenStr = [RSAEncryptor encryptString:strAESkey publicKey:userRsaPublicKey];
        
        // 获取当前时间戳，转换成json类型，并用AES进行加密,并做了base64及urlcode转码处理
        NSDate *senddate = [NSDate date];
        NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
        NSDictionary *cgDic = @{@"requestTime":date2};
        // 最终加密好的cg参数的密文
        NSString *cgMiWenStr = [[MakeJson createJson:cgDic] AES128EncryptWithKey:strAESkey];
        
        // 用户token
        NSString *userToken = [user objectForKey:@"token"];
        
        
        // 创建要发送的字典
        NSDictionary *dicData = @{@"tk":userToken,@"key":keyMiWenStr,@"cg":cgMiWenStr};
        NSLog(@"%@",dicData);
        
        
        // 进行网络请求
        HttpRequest *http = [[HttpRequest alloc] init];
        [http testUploadImageWithPost:dicData andImg:_img Success:^(id arrForDetail) {
            
            if ([arrForDetail isKindOfClass:[NSString class]] && [arrForDetail isEqualToString:@"0"]) {
                
                // 修改失败
                
            }else {
                
                // 修改头像成功
                
                // 上传头像
                _iconImgView.image = _img;
                
                
                // 发送通知,去修改我的页面的头像
                // 创建消息中心
                NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
                // 在消息中心发布自己的消息
                [notiCenter postNotificationName:@"reviseUserIcon" object:@"6"];
            }
            
        } failure:^(NSError *error) {
            
        }];
        
    }
    // 跳回去  必须要加  否则用户无法跳回应用
    [picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"返回完成");
    }];
    
}

// 点击cancel取消按钮时执行的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    NSLog(@"取消");
    [picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"返回完成");
    }];
}


// 压缩图片大小
- (NSData *)imageData:(UIImage *)myimage
{
    NSData *data=UIImageJPEGRepresentation(myimage, 1.0);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(myimage, 0.1);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(myimage, 0.5);
        }else if (data.length>200*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(myimage, 0.9);
        }
    }
    return data;
}

// 压缩图片
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

// 退出点击事件
- (void)exitBtnClick:(UIButton *)exitBtn {
    
    
    // 清空token 且跳转到登录页面
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"token"];
    
    // 清空用户资料
    [user removeObjectForKey:@"userInfo"];
    
    // 发通知,用于清空我的页面的用户资料
    // 创建消息中心
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    // 在消息中心发布自己的消息
    [notiCenter postNotificationName:@"accountManagerExit" object:@"1"];
    // 用于改变清空侧栏数据
    [notiCenter postNotificationName:@"deleteLeftData" object:@"8"];
}

// 个人设置点击事件
- (void)MineSetClick:(UIButton *)btnMineSet {
    
    NSLog(@"%ld",(long)btnMineSet.tag);
    if (btnMineSet.tag == 1007) {
        // 修改手机号
        ChangePhoneViewController *vc = [[ChangePhoneViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (btnMineSet.tag == 1008) {
        // 提现账户管理
//        MoneyAccountViewController *vc = [[MoneyAccountViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
        
        // 收货地址管理
        AdressViewController * vc = [[AdressViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else {
        // 更换密码
        RevisePassViewController *vc = [[RevisePassViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

// 实名认证点击事件
//- (void) btnRealNameClick:(UIButton *)btnRealName {
//    
//    RealNameYanZhengViewController *vc = [[RealNameYanZhengViewController alloc] init];
//    // 隐藏底边栏
//    [vc setHidesBottomBarWhenPushed:YES];
//    [self.navigationController pushViewController:vc animated:YES];
//}

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

// 触发事件
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 释放第一响应者
    for (int i = 0; i < 8; i++) {
        UITextField *tf1 = [self.view viewWithTag:1000 + i];
        [tf1 resignFirstResponder];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    
    UIButton *menuBtn = [self.navigationController.view viewWithTag:666];
    [menuBtn setTitle:@"编辑" forState:UIControlStateNormal];
    menuBtn.selected = NO;
    for (int i = 0; i < 8; i++) {
        UITextField *tf1 = [self.view viewWithTag:1000 + i];
        tf1.userInteractionEnabled = NO;
    }
}

- (void) viewWillAppear:(BOOL)animated {
    
    // 设置导航栏背景色(用到了UIImage+GradientColor.h这个类扩展)
    UIColor *topleftColor = FUIColorFromRGB(0x9080ff);
    UIColor *bottomrightColor = FUIColorFromRGB(0x7765ff);
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor, bottomrightColor] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(W, 64)];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:bgImg]];
    
//    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
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
