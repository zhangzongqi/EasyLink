//
//  WMMineOrderViewController.m
//  EasyLink
//
//  Created by 琦琦 on 17/3/6.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "WMMineOrderViewController.h"
#import "MineOrdersViewController.h" // 订单页面

@interface WMMineOrderViewController ()

@property (nonatomic , strong) UILabel *lbFenGe; // 分割线

@end

@implementation WMMineOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置导航栏标题
    UILabel *lbItemTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    lbItemTitle.text = @"我的订单";
    lbItemTitle.textColor = [UIColor whiteColor];
    lbItemTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lbItemTitle;
    
    // 返回按钮
    [self createBackBtn];
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


// 标题们
- (NSArray <NSString *> *)titles {
    
    return @[@"全部",@"待付款",@"待发货",@"待收货",@"待评价",@"待成团",@"已关闭"];
}

// 一些属性
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    
    // 已修改MenuView的Frame  具体搜索MenuViewframe
    // 已修改lineWidth 具体搜索LineWidth
    
    self.menuItemWidth = W / 5;
    self.menuViewStyle = WMMenuViewStyleLine;
    self.progressViewBottomSpace = 2;
    self.progressHeight = 1.5;
    self.menuHeight = 32;
    self.titleColorNormal = FUIColorFromRGB(0xc0b8ff);
    self.titleColorSelected = FUIColorFromRGB(0xffffff);
    self.titleSizeNormal = 12;
    self.titleSizeSelected = 14;
    self.showOnNavigationBar = NO;
    
    
    // 新闻条渐变背景色
    UIColor *topColor = FUIColorFromRGB(0x7d6dfa);
    UIColor *bottomColor = FUIColorFromRGB(0x7361f8);
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topColor, bottomColor] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(W, 32)];
    self.menuBGColor = [UIColor colorWithPatternImage:bgImg];

    // 哪一个
    self.selectIndex = [_strSelectIndex intValue];
    
    return self.titles.count;
}


// page
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    MineOrdersViewController *ordersVc = [[MineOrdersViewController alloc] init];
    
    // 传入参数，获取到是第几个页面
    ordersVc.strIndex = [NSString stringWithFormat:@"%ld",(long)index];
    
    return ordersVc;
}

// 页面将要加载
- (void) viewWillAppear:(BOOL)animated {
    
    // 显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    // 设置导航栏背景色(用到了UIImage+GradientColor.h这个类扩展)
    UIColor *topleftColor1 = FUIColorFromRGB(0x9080ff);
    UIColor *bottomColor1 = FUIColorFromRGB(0x7d6dfa);
    UIImage *bgImg1 = [UIImage gradientColorImageFromColors:@[topleftColor1, bottomColor1] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(W, 64)];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:bgImg1]];
    
    // 导航栏与下半部分分割线
    _lbFenGe = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, W, 2)];
    _lbFenGe.backgroundColor = FUIColorFromRGB(0xffffff);
    _lbFenGe.alpha = 0.2;
    [self.navigationController.view addSubview:_lbFenGe];
}

// 页面将要消失
- (void) viewWillDisappear:(BOOL)animated {
    
    // 导航栏和下部分割线，去掉
    [_lbFenGe removeFromSuperview];
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
