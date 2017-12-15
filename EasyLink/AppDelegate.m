//
//  AppDelegate.m
//  EasyLink
//
//  Created by 琦琦 on 16/9/12.
//  Copyright © 2016年 fengdian. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftSortsViewController.h"

#import <AMapFoundationKit/AMapFoundationKit.h>

#import <AlipaySDK/AlipaySDK.h> // 支付宝相关操作

#import "WelcomeViewController.h" // 引导页


// shareSDK
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"


#import <Bugly/Bugly.h> // 检测bug崩溃


@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    
    
    
    // RSA公钥
    NSString *strPublicKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDJx0bbeEcuKaXtJ5YfN79poZmP0XKYGx251mkMMEWsBAi0lTBop4KvibCUn8C48sjj19BJqi5PgdiRp3josUUoLv6r4NplawRLe1WCG/8lR61xtlcGIiV+fTI/0FT5uyn2Ru+5s4kCvKGtnXTfZnIecuP7oeFeTAD/r9v4Sb8DzQIDAQAB";
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:strPublicKey forKey:@"localPublickey"];
    
    
    // 引导页和侧边栏
    [self welcomeVC];
    
    
    // 设置图标上的推送消息个数
//    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
//    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
    
    // 高德地图
    [AMapServices sharedServices].apiKey = @"2c6b9cc9f327baf8e611f78851d0dcc4";
    
    
    // 社会化分享
    [self shareServe];
    
    
    // 微信注册
    [self registerWeixinPay];
    
    // 用于检测崩溃
    [Bugly startWithAppId:@"2f9b6f8041"];
    
    return YES;
    
}

// 注册微信支付
- (void) registerWeixinPay {
    
    [WXApi registerApp:@"wxed4519bf67d2d00f" withDescription:@"huopinba"];
}


// 引导页
- (void)welcomeVC {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];   //设置通用背景颜色
    [self.window makeKeyAndVisible];
    
    // 获取应用程序持久化存储--属性列表中所保存的用户是否已查看过欢迎页
    NSString *strUserPro = [self readFromUserDefaults];
    // 判断该数据是否为空,并且其值为某一标识
    if (strUserPro != nil && [strUserPro isEqualToString:@"read"]) {
        
//        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        
//        UITabBarController *vc = [story instantiateViewControllerWithIdentifier:@"woshishouye"];
//        
//        self.window.rootViewController = vc;
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        // 底边栏
        self.mainTabbarController = [story instantiateViewControllerWithIdentifier:@"mainTabbar"];
        
        LeftSortsViewController *leftVC = [[LeftSortsViewController alloc] init];
        self.LeftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:self.mainTabbarController];
        self.window.rootViewController = self.LeftSlideVC;
        
        // 隐藏导航栏下面的黑线
        //    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        //    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
        
        // 设置导航栏背景色(用到了UIImage+GradientColor.h这个类扩展)
        //    UIColor *topleftColor = FUIColorFromRGB(0x9080ff);
        //    UIColor *bottomrightColor = FUIColorFromRGB(0x7765ff);
        //    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor, bottomrightColor] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(self.window.frame.size.width, 64)];
        //
        //    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithPatternImage:bgImg]];
        
        [UITabBar appearance].translucent = NO;
        
    }else {
        
        // 没看过欢迎页,显示欢迎页
        WelcomeViewController *mainVC = [[WelcomeViewController alloc] init];
        self.window.rootViewController = mainVC;
    }
}

// 从持久化存储中获取是否查看欢迎页
- (NSString *)readFromUserDefaults {
    
    // 先定义变量用于保存获取的数据
    NSString *strReturn = nil;
    // 获取用户配置类的对象 - - 持久化存储中属性列表对象
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 通过实例方法获取存储的数据
    strReturn = [userDefaults stringForKey:@"welcome"];
    return strReturn;
    
}



// 配置支付宝客户端返回url处理方法。
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    
    return YES;
}



// 社会化分享
- (void)shareServe {
    
    [ShareSDK registerApp:@"1e09e1ce9673d"
     
          activePlatforms:@[
//                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeMail),
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)
                            ]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
//             case SSDKPlatformTypeSinaWeibo:
//                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
//                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
//             case SSDKPlatformTypeSinaWeibo:
//                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
//                 [appInfo SSDKSetupSinaWeiboByAppKey:@"363112097"
//                                           appSecret:@"6bdc83737d924b29d3ff6f067828c931"
//                                         redirectUri:@"http://www.xioazhangll.com"
//                                            authType:SSDKAuthTypeBoth];
//                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxed4519bf67d2d00f"
                                       appSecret:@"bdac305a27372819948f2ff96337e1a6"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105697429"
                                      appKey:@"m42PAM8M0L7PBQNb"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
