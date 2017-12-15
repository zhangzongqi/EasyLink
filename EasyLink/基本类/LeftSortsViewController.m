//
//  LeftSortsViewController.m
//  LGDeckViewController
//
//  Created by jamie on 15/3/31.
//  Copyright (c) 2015年 Jamie-Ling. All rights reserved.
//

#import "LeftSortsViewController.h"
#import "AppDelegate.h"
#import "otherViewController.h"
#import "MineFocusOnViewController.h" // 我的关注页面
//#import "NewsNoticeViewController.h" // 消息通知页面   // 暂时不用
#import "AccountManageViewController.h" // 账户管理页面
#import "HelpViewController.h" // 软件帮助页面
#import "JSBadgeView.h" // 消息小圆点
#import "SheZhiViewController.h" // 设置页面
#import "LoginViewController.h" // 登录页面


@interface LeftSortsViewController () {
    
    // 个性签名
    UILabel *levelLb;
}
//<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, copy) NSArray *btnNameArr;



@end

@implementation LeftSortsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // 背景图
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageview.image = [UIImage imageNamed:@"leftbackiamge.jpg"];
    [self.view addSubview:imageview];
    
    // 初始化数组
    [self initArrs];
    
    // 布局页面
    [self layoutViews];
    
    // 请求用户资料数据
    [self initDataForUserInfo];
    
    
//    UITableView *tableview = [[UITableView alloc] init];
//    self.tableview = tableview;
//    tableview.frame = self.view.bounds;
//    tableview.dataSource = self;
//    tableview.delegate  = self;
//    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.view addSubview:tableview];
    
}

// 请求用户资料数据
- (void) initDataForUserInfo {
    
    // 创建单例,获取到用户RSAKey
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    
    if ([user objectForKey:@"token"] == nil) {
        
    }else {
        
        
        NSString *userRsaPublicKey = [user objectForKey:@"severPublicKey"];
        
        
        // 生成一个16位的AES的key,并保存用于解密服务器返回的信息
        NSString *strAESkey = [NSString set32bitString:16];
        [user setObject:strAESkey forKey:@"aesKey"];
        // 最终加密好的key参数的密文
        NSString *keyMiWenStr = [RSAEncryptor encryptString:strAESkey publicKey:userRsaPublicKey];
        NSLog(@"keyMiWenStr:%@",keyMiWenStr);
        
        
        // 获取当前时间戳，转换成json类型，并用AES进行加密,并做了base64及urlcode转码处理
        NSDate *senddate = [NSDate date];
        NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
        NSDictionary *cgDic = @{@"requestTime":date2};
        // 最终加密好的cg参数的密文
        NSString *cgMiWenStr = [[MakeJson createJson:cgDic] AES128EncryptWithKey:strAESkey];
        
        NSLog(@"cgMiWenStr:%@",cgMiWenStr);
        
        // 用户token
        NSString *userToken = [user objectForKey:@"token"];
        NSLog(@"userToken%@",userToken);
        
        
        NSDictionary *dicForData = @{@"tk":userToken,@"key":keyMiWenStr,@"cg":cgMiWenStr};
        
        
        
        HttpRequest *http = [[HttpRequest alloc] init];
        [http PostUserInfoWithDic:dicForData Success:^(id userInfo) {
            
            
            NSDictionary *dicForUserInfo = [MakeJson createDictionaryWithJsonString:userInfo];
            
            // 将用户资料保存本地
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:dicForUserInfo forKey:@"userInfo"];
            
            // 修改昵称
            _nickNameLb.text = [NSString stringWithFormat:@"%@",[dicForUserInfo objectForKey:@"nickname"]];
            
            
            // 修改头像
            [_headImgView sd_setImageWithURL:[NSURL URLWithString:[dicForUserInfo objectForKey:@"icon"]] placeholderImage:[UIImage imageNamed:@"账户管理_默认头像"]];
            
            
        } failure:^(NSError *error) {
            
            // 请求失败
        }];
    }
    
    
    
    

}



// 初始化数组
- (void)initArrs {
    
//    _btnNameArr = @[@"我的关注",@"消息通知",@"账户管理",@"软件帮助"];
    _btnNameArr = @[@"我的关注",@"账户管理",@"软件帮助"];
}

// 布局页面
- (void) layoutViews {
    
    _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.08 * W, 0.1 * H, 0.1 * H, 0.1 * H)];
    _headImgView.clipsToBounds = YES;
    _headImgView.layer.cornerRadius = 0.05 * H;
    _headImgView.image = [UIImage imageNamed:@"账户管理_默认头像"];
    _headImgView.layer.borderColor = [[UIColor colorWithRed:95/255.0 green:66/255.0 blue:241/255.0 alpha:1.0] CGColor];
    _headImgView.layer.borderWidth = 2;
    
    [self.view addSubview:_headImgView];
    
    _nickNameLb = [[UILabel alloc] init];
    [self.view addSubview:_nickNameLb];
    [_nickNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImgView).with.offset(_headImgView.frame.size.height / 5);
        make.left.equalTo(_headImgView.mas_right).with.offset( 0.04 * W );
        
        if (iPhone4S) {
            make.height.equalTo(@(17));
            _nickNameLb.font = [UIFont systemFontOfSize:15];
        }else {
            make.height.equalTo(@(21));
            _nickNameLb.font = [UIFont systemFontOfSize:17];
        }
        
    }];
    _nickNameLb.text = @"请先登录";
    _nickNameLb.textColor = [UIColor whiteColor];
    
    
    NSString * strModel  = [UIDevice currentDevice].model;
    NSLog(@"6666666%@",strModel);
    
    levelLb = [[UILabel alloc] init];
    [self.view addSubview:levelLb];
    [levelLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_headImgView.mas_bottom).with.offset(- _headImgView.frame.size.height * 0.14);
        make.left.equalTo(_nickNameLb);
        
        if (iPhone4S) {
            make.height.equalTo(@(14));
            levelLb.font = [UIFont systemFontOfSize:13];
        }else {
            make.height.equalTo(@(16));
            levelLb.font = [UIFont systemFontOfSize:15];
        }
    }];
    levelLb.textColor = FUIColorFromRGB(0xa492ff);
    levelLb.text = @"个性签名";

    // 分隔线
    for (int i = 0; i < 4; i++) {
        
        UILabel *lb = [[UILabel alloc] init];
        [self.view addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_headImgView).with.offset(0.0265625 * W);
            make.top.equalTo(_headImgView.mas_bottom).with.offset(0.0926 * H + 0.0882 * H * i);
            make.height.equalTo(@(1));
            make.width.equalTo(@(0.06 * W));
        }];
        lb.backgroundColor = FUIColorFromRGB(0x8e77ff);
        
    }
    
    
    // 按钮
    for (int i = 0; i < 3; i++) {
        
        UIButton *btn = [[UIButton alloc] init];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headImgView.mas_bottom).with.offset(0.0926 * H + 0.0882 * H * i + 0.0441 * H - 0.0882 * H / 2);
            make.left.equalTo(_headImgView.mas_left).with.offset(0.055 * W);
            
            make.height.equalTo(@(0.0882 * H));
            
        }];
        
//        if (i == 1) {
//            
//            // 小圆点
//            UILabel *lb = [[UILabel alloc] init];
//            [btn addSubview:lb];
//            [lb mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(btn.mas_centerY).with.offset(-7);
//                make.centerX.equalTo(btn.mas_right);
//                make.height.equalTo(@(8));
//                make.width.equalTo(@(8));
//            }];
//            lb.backgroundColor = FUIColorFromRGB(0xfe5f5f);
//            lb.layer.cornerRadius = 4;
//            lb.clipsToBounds = YES;
//        }
        
        // 按钮名字
        [btn setTitle:_btnNameArr[i] forState:UIControlStateNormal];
            
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = i + 100;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // 设置
    UIButton *btnSet = [[UIButton alloc] init];
    [self.view addSubview:btnSet];
    [btnSet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-0.1 * H);
        make.left.equalTo(_headImgView).with.offset(0.0265625 * W);
        make.height.equalTo(@(40));
    }];
    btnSet.imageView.sd_layout
    .bottomEqualToView(btnSet)
    .leftEqualToView(btnSet)
    .heightIs(0.04375 * W)
    .widthEqualToHeight();
    btnSet.titleLabel.sd_layout
    .centerYEqualToView(btnSet.imageView)
    .leftSpaceToView(btnSet.imageView,6)
    .heightIs(16);
    [btnSet setImage:[UIImage imageNamed:@"index_侧栏_设置"] forState:UIControlStateNormal];
    [btnSet setTitle:@"设置" forState:UIControlStateNormal];
    [btnSet setTitleColor:FUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    btnSet.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnSet addTarget:self action:@selector(btnSetClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 退出该账户
    UIButton *btnExit = [[UIButton alloc] init];
    [self.view addSubview:btnExit];
    [btnExit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-0.1 * H);
        make.right.equalTo(self.view).with.offset(- 0.12 * W - 0.0765625 * W);
        make.height.equalTo(@(40));
        make.width.equalTo(@(95));
    }];
    btnExit.titleLabel.sd_layout
    .bottomEqualToView(btnExit)
    .leftSpaceToView(btnExit,0)
    .widthIs(77.5)
    .heightIs(15);
    btnExit.imageView.sd_layout
    .centerYEqualToView(btnExit.titleLabel)
    .leftSpaceToView(btnExit.titleLabel,4)
    .widthIs(13.2)
    .heightIs(12);
    [btnExit setImage:[UIImage imageNamed:@"index_侧栏_退出"] forState:UIControlStateNormal];
    [btnExit setTitleColor:FUIColorFromRGB(0x8f80fe) forState:UIControlStateNormal];
    [btnExit setTitle:@"退出该账户" forState:UIControlStateNormal];
    btnExit.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnExit addTarget:self action:@selector(btnExitClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

// 设置的点击事件
- (void) btnSetClick:(UIButton *)btnSet {
    
    SheZhiViewController *vc = [[SheZhiViewController alloc] init];
    
    // 跳转到想到的页面
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // 关闭左侧抽屉
    [tempAppDelegate.LeftSlideVC closeLeftView];
    // 隐藏底边栏
    [vc setHidesBottomBarWhenPushed:YES];
    [tempAppDelegate.mainTabbarController.viewControllers[[[user objectForKey:@"CotrollerIndex"] intValue]] pushViewController:vc animated:NO];
}

// 退出该账户点击事件
- (void) btnExitClick:(UIButton *)btnExit {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *strTk = [user objectForKey:@"token"];
    
    if (strTk == nil) {
        
        // 提示
        HttpRequest *http = [[HttpRequest alloc] init];
        [http GetHttpDefeatAlert:@"请先登录"];
        
    }else {
        
        // 清空token 且跳转到登录页面
        [user removeObjectForKey:@"token"];
        
        // 清空用户资料
        [user removeObjectForKey:@"userInfo"];
        
        // 清空当前页信息
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        // 修改头像
        _headImgView.image = [UIImage imageNamed:@"账户管理_默认头像"];
        // 修改昵称
        _nickNameLb.text = @"请先登录";
        // 个性签名
        levelLb.text = [[user objectForKey:@"userInfo"] objectForKey:@"sign"];
        
        
        // 发通知,用于清空我的页面的用户资料
        // 创建消息中心
        NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
        // 在消息中心发布自己的消息
        [notiCenter postNotificationName:@"leftViewExit" object:@"0"];
        
        
        // 跳转到想到的页面
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        // 关闭左侧抽屉
        [tempAppDelegate.LeftSlideVC closeLeftView];
        
        // 返回首页
        tempAppDelegate.mainTabbarController.selectedIndex = 0;
        
        LoginViewController * logVc = [[LoginViewController alloc] init];
        // 隐藏底边栏
        [logVc setHidesBottomBarWhenPushed:YES];
        [tempAppDelegate.mainTabbarController.viewControllers[0] pushViewController:logVc animated:YES];
    }
}


// 按钮的点击事件
- (void) btnClick:(UIButton *)btn {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    if (btn.tag == 100) {
        
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *strTk =  [user objectForKey:@"token"];
        
        if (strTk == nil) {
            
            // 进入登录页
            LoginViewController *vc = [[LoginViewController alloc] init];
            
            AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
            
            // 隐藏底边栏
            [vc setHidesBottomBarWhenPushed:YES];
            
            // 跳转到想到的页面
            [tempAppDelegate.mainTabbarController.viewControllers[[[user objectForKey:@"CotrollerIndex"] intValue]] pushViewController:vc animated:NO];
            
        }else {
            
            // 我的关注
            AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            MineFocusOnViewController *focusVC = [[MineFocusOnViewController alloc] init];
            [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
            
            // 隐藏底边栏
            [focusVC setHidesBottomBarWhenPushed:YES];
            
            // 跳转到想到的页面
            [tempAppDelegate.mainTabbarController.viewControllers[[[user objectForKey:@"CotrollerIndex"] intValue]] pushViewController:focusVC animated:NO];
        }
        
    }else if (btn.tag == 101) {
        
//        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        // 消息通知
//        NewsNoticeViewController *newsNoticeVC = [[NewsNoticeViewController alloc] init];
//        //关闭左侧抽屉
//        [tempAppDelegate.LeftSlideVC closeLeftView];
//        // 隐藏底边栏
//        [newsNoticeVC setHidesBottomBarWhenPushed:YES];
//        // 跳转到想到的页面
//        [tempAppDelegate.mainTabbarController.viewControllers[[[user objectForKey:@"CotrollerIndex"] intValue]] pushViewController:newsNoticeVC animated:NO];
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *strTk =  [user objectForKey:@"token"];
        
        if (strTk == nil) {
            
            // 进入登录页
            LoginViewController *vc = [[LoginViewController alloc] init];
            
            AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            //关闭左侧抽屉
            [tempAppDelegate.LeftSlideVC closeLeftView];
            // 隐藏底边栏
            [vc setHidesBottomBarWhenPushed:YES];
            // 跳转到想到的页面
            [tempAppDelegate.mainTabbarController.viewControllers[[[user objectForKey:@"CotrollerIndex"] intValue]] pushViewController:vc animated:NO];
            
        }else {
            
            AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            // 账户管理
            AccountManageViewController *accManageVC = [[AccountManageViewController alloc] init];
            //关闭左侧抽屉
            [tempAppDelegate.LeftSlideVC closeLeftView];
            // 隐藏底边栏
            [accManageVC setHidesBottomBarWhenPushed:YES];
            // 跳转到想到的页面
            [tempAppDelegate.mainTabbarController.viewControllers[[[user objectForKey:@"CotrollerIndex"] intValue]] pushViewController:accManageVC animated:NO];
            
        }
        
    }else{
        
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        // 软件帮助
        HelpViewController *helpVC = [[HelpViewController alloc] init];
        //关闭左侧抽屉
        [tempAppDelegate.LeftSlideVC closeLeftView];
        // 隐藏底边栏
        [helpVC setHidesBottomBarWhenPushed:YES];
        
        // 跳转到想到的页面
        [tempAppDelegate.mainTabbarController.viewControllers[[[user objectForKey:@"CotrollerIndex"] intValue]] pushViewController:helpVC animated:NO];
    }
}


// 监听处理事件
- (void)listen:(NSNotification *)noti {
    
    NSString *strNoti = noti.object;
    
    // 用户在侧栏进行了退出
    if ([strNoti isEqualToString:@"5"]) {
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        // 修改头像
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:[[user objectForKey:@"userInfo"] objectForKey:@"icon"]] placeholderImage:[UIImage imageNamed:@"账户管理_默认头像"]];
        
        // 修改昵称
        _nickNameLb.text = [[user objectForKey:@"userInfo"] objectForKey:@"nickname"];
        
        // 个性签名
        levelLb.text = [[user objectForKey:@"userInfo"] objectForKey:@"sign"];
        
        // 不销毁通知
    }
    
    
    // 资料页退出后,修改侧栏信息
    if ([strNoti isEqualToString:@"8"]) {
        
        // 修改头像
        _headImgView.image = [UIImage imageNamed:@"账户管理_默认头像"];
        
        // 修改昵称
        _nickNameLb.text = @"请先登录";
        
        // 个性签名
        levelLb.text = @"个性签名";
    }
}


- (void) viewWillAppear:(BOOL)animated {
    
    // 接收消息
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    // 登陆成功后修改侧栏信息
    [notiCenter addObserver:self selector:@selector(listen:) name:@"MakeLeftUserInfo" object:@"5"];
    // 资料页退出后,修改侧栏信息
    [notiCenter addObserver:self selector:@selector(listen:) name:@"deleteLeftData" object:@"8"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//// tableView返回的行数
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 4;
//}
//
//// tableView返回的内容
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *Identifier = @"Identifier";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
//    }
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.textLabel.font = [UIFont systemFontOfSize:20.0f];
//    cell.backgroundColor = [UIColor clearColor];
//    cell.textLabel.textColor = [UIColor whiteColor];
//    
//    
//    if (indexPath.row == 0) {
//        cell.textLabel.text = @"我的关注";
//    } else if (indexPath.row == 1) {
//        cell.textLabel.text = @"消息通知";
//    } else if (indexPath.row == 2) {
//        cell.textLabel.text = @"账户管理";
//    } else if (indexPath.row == 3) {
//        cell.textLabel.text = @"软件帮助";
//    }
//    
//    return cell;
//}
//
//// tableView的点击事件
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    otherViewController *vc = [[otherViewController alloc] init];
//    [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
//    
//    // 隐藏底边栏
//    [vc setHidesBottomBarWhenPushed:YES];
//    
//    // 跳转到想到的页面
//    [tempAppDelegate.mainTabbarController.viewControllers[0] pushViewController:vc animated:NO];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 180;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width, 180)];
//    view.backgroundColor = [UIColor clearColor];
//    return view;
//}
@end
