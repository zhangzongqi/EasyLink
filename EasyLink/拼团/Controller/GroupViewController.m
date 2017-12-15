//
//  GroupViewController.m
//  EasyLink
//
//  Created by 琦琦 on 17/1/16.
//  Copyright © 2017年 fengdian. All rights reserved.
//  拼团页面

#import "GroupViewController.h"
#import "SpellgroupCollectionViewCell.h" // 拼团列表cell
#import "GroupDetailViewController.h" // 拼团详情页
#import "WZLBadgeImport.h" // 小圆点
#import "AppDelegate.h"
#import "MZTimerLabel.h" // 倒计时库
#import "WaitCollectionViewCell.h" // 等待cell
#import "SelectCityView.h" // 城市选择视图
#import "ZheZhaoView.h" // 遮罩层
#import "HotCityTableViewCell.h" // 热门城市cell
#import "KindBtnViewForPinTuan.h" // 按钮自动换行视图

#import <AMapLocationKit/AMapLocationKit.h>

#import "HomeDataModel.h"
#import "LoginViewController.h" // 登录页面

// 单例
#define USER [NSUserDefaults standardUserDefaults]

// 设置超时时间
#define DefaultLocationTimeout  10
#define DefaultReGeocodeTimeout 4


@interface GroupViewController ()<JSDropDownMenuDataSource,JSDropDownMenuDelegate,UICollectionViewDelegate, UICollectionViewDataSource,MZTimerLabelDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,AMapLocationManagerDelegate> {
    
//    NSInteger pageStart; // 页数
    NSInteger category; // 分类
    NSString *keyword; // 关键词
    NSInteger orderKey; // 排序关键词
    NSInteger orderby; // 排序顺序(默认倒序 0)
    NSInteger pageStart; // 请求数据开始位置
    NSInteger pageSize; // 一页的数量
    
    
    
    
    NSMutableArray *_CollectionViewArr; // 列表的数据
    
    UIButton *_btnTuijian; // 推荐按钮
    
    UIView *_locationUv; // 城市选择视图
    
    NSMutableArray *_cityArr; // 城市数组
    NSMutableArray *_cityHeaderArr; // 城市头部数组
    NSMutableArray *_cityJianSuoArr; // 检索数组
    
    
    NSMutableArray *_data1;
    NSMutableArray *_data2;
    NSMutableArray *_data3;
    
    NSArray *_categoryArr; // 分类数组
    NSArray *_categoryBeforeArr; // 用来保存原始的分类数据
    
    
}

// 定位相关的
@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;
@property (nonatomic, strong) AMapLocationManager *locationManager;


@property (nonatomic, strong) UICollectionView *collectionView;



@property (nonatomic, strong) UIButton *locationBtn;

@property (nonatomic, strong) SelectCityView *selCityView; // 城市选择视图
@property (nonatomic, strong) ZheZhaoView *zhezhaoView;

@property (nonatomic, strong) UILabel *currentCityLb; // 选择城市视图上的当前位置


@property (nonatomic, copy) MBProgressHUD *HUD; // 动画

@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // 判断用户是否登录超时
    [self panduanUserTimeOut];
    
    
    
    // 设置底边栏图片
    [self createTabbarImg];
    
    
    // 创建加载动画
    [self createLoading];
    
    
    
    // 初始化城市定位管理器
    [self createDingweiManager];
    // 初始化block
    [self initCompleteBlock];
    
    
    
    // 导航栏左边按钮
    [self createBtnForLeftBarButtonItem];
    
    // 设置导航条不透明
    self.navigationController.navigationBar.translucent = NO;
    
    // 页面背景色
    self.view.backgroundColor = FUIColorFromRGB(0xffffff);
    
    // 初始化数组
    [self initDataSource];
    
    
    
    // 获取选择栏上的数据
    [self getSelectViewData];
    
    
    
    //进行单次带逆地理定位请求
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
}


// 获取分类项
- (void) getSelectViewData {
    
    // 可变数组1
    _data1 = [NSMutableArray arrayWithObjects:@"推荐", nil];
    
    // 可变数组2
    _data2 = [NSMutableArray arrayWithObjects:@"综合排序",@"创建时间", @"开团时间", @"结束时间", @"最低价格", @"销售量", @"最多收藏", @"最多浏览", nil];
    
    // 创建数据请求
    HttpRequest *http = [[HttpRequest alloc] init];
    [http GetGoodsCategorySuccess:^(id arrForList) {
        
        
        NSLog(@"arrForList:%@",arrForList);
        
        NSArray *arrList = arrForList;
        NSLog(@"================%ld",arrList.count);
        
        _categoryBeforeArr = arrForList;
        
        
        // 全部水果数组
        NSArray *allFruit = @[@"全部"];
        NSMutableArray *dataForCategory =[NSMutableArray arrayWithArray:@[@{@"title":@"全部", @"data":allFruit}]] ;
        
        
        if ([arrForList isKindOfClass:[NSString class]]) {
            
            // 数据请求失败
            // 布局页面
            [self createUI];
            
            // 获取数据
            [self initData];
            
        }else {
            
            
            // 数据请求成功
            for (int i = 0; i < arrList.count; i++) {
                
                NSMutableArray *arrForErji = [NSMutableArray array];
                
                [arrForErji removeAllObjects];
                
                for (int j = 0; j < [[arrForList[i] valueForKey:@"subList"] count]; j++) {

                    NSArray *arr = [arrForList[i] valueForKey:@"subList"];
                    NSString *str = [arr[j] objectForKey:@"title"];
                    [arrForErji addObject:str];
                }
                
                NSDictionary *dic = [[NSDictionary alloc] init];
                dic = @{@"title":[arrForList[i] valueForKey:@"title"],@"data":arrForErji};
                NSLog(@"dic %@",dic);
                
                [dataForCategory insertObject:dic atIndex:i+1];
                NSLog(@"dataForCategory:%@",dataForCategory);
            }
            
            
            
            _categoryArr = dataForCategory;
            
            
            // 布局页面
            [self createUI];
            
            // 获取数据
            [self initData];
            
        }
        
    } failure:^(NSError *error) {
        
        // 数据请求失败
        // 布局页面
        [self createUI];
        
        // 获取数据
        [self initData];
        
    }];
    

    
    
    
    
    
    //    ORDER_BY_SYSTEM = 0; //按照系统（默认）
    //    ORDER_BY_CREATE_TIME = 1; //
    //    ORDER_BY_START_TIME = 2; //
    //    ORDER_BY_END_TIME = 3; //
    //    ORDER_BY_LOW_PRICE = 4; //
    //    ORDER_BY_SALE_NUM = 5; //
    //    ORDER_BY_COLLECTION_NUM = 6; //
    //    ORDER_BY_VIEW_NUM = 7; //
    
    
    
    
    // 可变数组3
//    _data3 = [NSMutableArray arrayWithObjects:@{@"title":@"全部", @"data":allFruit}, @{@"title":@"西瓜", @"data":xiGua},@{@"title":@"苹果", @"data":apple},@{@"title":@"葡萄", @"data":puTao},@{@"title":@"香蕉", @"data":xiangJiao},@{@"title":@"荔枝", @"data":liZhi},@{@"title":@"樱桃", @"data":yingTao}, nil];
    
    
}


// 判断用户是否登录
- (void) panduanUserTimeOut {
    
    
//    http PostPanduanUserTimeOutWithDic:<#(NSDictionary *)#> Success:<#^(id statusInfo)success#> failure:<#^(NSError *error)failure#>
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    if ([[user objectForKey:@"token"] length] < 1) {
        
        // 未登录
//        LoginViewController *vc = [[LoginViewController alloc] init];
//        [vc setHidesBottomBarWhenPushed:YES];
//        
//        [self.navigationController pushViewController:vc animated:YES];
        
    }else {
        
        // 已登录,判断是否登录超时
        HttpRequest *http = [[HttpRequest alloc] init];
        NSArray *arr = [GetUserJiaMi getUserTokenAndCgAndKey];
        NSDictionary *dic = @{@"tk":arr[0],@"key":arr[1],@"cg":arr[2]};
        
        [http PostPanduanUserTimeOutWithDic:dic Success:^(id statusInfo) {
            
            // 不用执行任何操作
            
        } failure:^(NSError *error) {
            
            // 网络错误，请求失败
        }];
    }
    
}


// 创建加载动画
- (void)createLoading {
    
    // 加载动画
    _HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    // 展示
    [_HUD show:YES];
    
    // 3秒隐藏动画
    [_HUD hide:YES afterDelay:5];
    
}


// 上拉下拉刷新动画
- (void) createLoadingForBtnClick {
    
    // 创建动画
    _HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // 展示
    [_HUD show:YES];
    
    // 3秒隐藏动画
    [_HUD hide:YES afterDelay:3];
}


// 下拉刷新方法
- (void)downRefresh {
    
    pageStart = 0;
    
    // 动画
    [self createLoadingForBtnClick];
    
    // 然后再请求网络
    [self initData];
}

// 上拉刷新方法
- (void)upRefresh {
    
    pageStart = _CollectionViewArr.count;
    
    // 动画
    [self createLoadingForBtnClick];
    
    // 请求数据
    [self initData];
}


// 初始化定位管理器
- (void) createDingweiManager {
    
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
    //设置定位超时时间
    [self.locationManager setLocationTimeout:DefaultLocationTimeout];
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
}


- (void)initCompleteBlock
{
    __weak GroupViewController *weakSelf = self;
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        
        if (error != nil && error.code == AMapLocationErrorLocateFailed)
        {
            //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"定位错误:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
            
        }
        else if (error != nil
                 && (error.code == AMapLocationErrorReGeocodeFailed
                     || error.code == AMapLocationErrorTimeOut
                     || error.code == AMapLocationErrorCannotFindHost
                     || error.code == AMapLocationErrorBadURL
                     || error.code == AMapLocationErrorNotConnectedToInternet
                     || error.code == AMapLocationErrorCannotConnectToHost))
        {
            //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
            NSLog(@"逆地理错误:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        else
        {
            //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
        }
        
        
        //修改label显示内容
        if (regeocode)
        {
//            [weakSelf.displayLabel setText:[NSString stringWithFormat:@"%@ \n %@-%@-%.2fm", regeocode.formattedAddress,regeocode.citycode, regeocode.adcode, location.horizontalAccuracy]];
            
            NSLog(@"======================%@",regeocode);
            
            NSLog(@"%@",[NSString stringWithFormat:@"%@ \n %@-%@-%.2fm", regeocode.formattedAddress,regeocode.citycode, regeocode.adcode, location.horizontalAccuracy]);
            
            NSString *city = regeocode.city;
        
            weakSelf.currentCityLb.text = [NSString stringWithFormat:@"当前:%@",city];
        
            NSString *hisCity = [USER objectForKey:@"cityDingWei"];
        
            if ([city isEqualToString:hisCity] == NO) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"您定位到%@，确定切换城市吗？",city] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf.locationBtn setTitle:city forState:UIControlStateNormal];
                    // 将当前位置添加到单例,用于下次设置
                    [USER setObject:city forKey:@"cityDingWei"];
        
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:okAction];
                [weakSelf presentViewController:alertController animated:YES completion:nil];
            }
            
        }
        else
        {
//            [weakSelf.displayLabel setText:[NSString stringWithFormat:@"lat:%f;lon:%f \n accuracy:%.2fm", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy]];
        }
    };
}


// 初始化数组
- (void) initDataSource {
    
    // 分类数组
    _categoryArr = [NSArray array];
    
    // 初始化请求参数
    category = 0;
    keyword = @"";
    orderKey = 0;
    orderby = 0;
    pageStart = 0;
    pageSize = 10;
    
    
    // 列表数组
    _CollectionViewArr = [[NSMutableArray alloc] init];
    

    _cityArr = [[NSMutableArray alloc] init];
}

// 导航栏左边按钮
- (void) createBtnForLeftBarButtonItem {
    
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 18, 18);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"index1"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    negativeSpacer.width = - 15 + (0.15 * W - 18)/3;
    
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,[[UIBarButtonItem alloc] initWithCustomView:menuBtn]];
    // 消息小圆点
    //    JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:menuBtn alignment:JSBadgeViewAlignmentTopLeft];
    //    badgeView.badgeText = @"2";
    
    // 小圆点
//    [menuBtn showBadgeWithStyle:WBadgeStyleRedDot value:0 animationType:WBadgeAnimTypeNone];
//    menuBtn.badgeBgColor = FUIColorFromRGB(0xfe5f5f);
    
}

// 导航栏按钮点击事件 --打开侧边栏
- (void) openOrCloseLeftList
{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (tempAppDelegate.LeftSlideVC.closed)
    {
        [tempAppDelegate.LeftSlideVC openLeftView];
    }
    else
    {
        [tempAppDelegate.LeftSlideVC closeLeftView];
    }
}

// 设置底边栏图片
- (void) createTabbarImg {
    
    
    // 拼团
    UIImage *select0 = [UIImage imageNamed:@"tabbar_icon_on1"];
    [self.tabBarController.childViewControllers[0].tabBarItem  setSelectedImage:[select0 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UIImage *normal0 = [UIImage imageNamed:@"tabbar_icon_off1"];
    [self.tabBarController.childViewControllers[0].tabBarItem  setImage:[normal0 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    // 分类
    UIImage *select1 = [UIImage imageNamed:@"tabbar_icon_on2"];
    [self.tabBarController.childViewControllers[1].tabBarItem  setSelectedImage:[select1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UIImage *normal1 = [UIImage imageNamed:@"tabbar_icon_off2"];
    [self.tabBarController.childViewControllers[1].tabBarItem  setImage:[normal1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    // 我的
    UIImage *select2 = [UIImage imageNamed:@"home_icon_on3"];
    [self.tabBarController.childViewControllers[2].tabBarItem  setSelectedImage:[select2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UIImage *normal2 = [UIImage imageNamed:@"home_icon_off3"];
    [self.tabBarController.childViewControllers[2].tabBarItem  setImage:[normal2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}

// 获取数据
- (void) initData {
    
    // 创建网络请求对象
    HttpRequest *http = [[HttpRequest alloc] init];
    
    // 第0页
    if (pageStart == 0) {
        
        // 进行数据请求
        [http GetHomeDataForCategory:category andKeyWord:keyword andOrderKey:orderKey andOrderBy:orderby andPageStart:pageStart andPageSize:pageSize Success:^(id arrForList) {
            
            
            if ([arrForList isKindOfClass:[NSString class]]) {
                
                // 获取数据失败
                
                // 删除所有数据
                [_CollectionViewArr removeAllObjects];
                // 刷新列表
                [_collectionView reloadData];
                
                // 让动画消失
                [_HUD hide:YES];
                
                // 表格刷新完毕,结束上下刷新视图
                [_collectionView.mj_header endRefreshing];
                [_collectionView.mj_footer endRefreshing];
                
            }else {
                
                // 获取数据成功
                [_CollectionViewArr removeAllObjects];
                
                _CollectionViewArr = arrForList;
                
                NSLog(@"_CollectionViewArr:%@",_CollectionViewArr);
                
                // 让动画消失
                [_HUD hide:YES];
                
                // 刷新列表
                [_collectionView reloadData];
                
                // 表格刷新完毕,结束上下刷新视图
                [_collectionView.mj_header endRefreshing];
                [_collectionView.mj_footer endRefreshing];
            }
            
        } failure:^(NSError *error) {
            
            NSLog(@"解析失败");
            
            [_HUD hide:YES];
            
            // 表格刷新完毕,结束上下刷新视图
            [_collectionView.mj_header endRefreshing];
            [_collectionView.mj_footer endRefreshing];
        }];
    }else {
        
        [http GetHomeDataForCategory:category andKeyWord:keyword andOrderKey:orderKey andOrderBy:orderby andPageStart:pageStart andPageSize:pageSize Success:^(id arrForList) {
            
            if ([arrForList isKindOfClass:[NSString class]]) {
                
                // 获取数据失败
                
                
                // 刷新列表
                [_collectionView reloadData];
                
                // 让动画消失
                [_HUD hide:YES];
                
                // 表格刷新完毕,结束上下刷新视图
                [_collectionView.mj_header endRefreshing];
                [_collectionView.mj_footer endRefreshing];
                
            }else {
            
                [_CollectionViewArr addObjectsFromArray:arrForList];
            
                // 让动画消失
                [_HUD hide:YES];
            
                [_collectionView reloadData];
            
                // 表格刷新完毕,结束上下刷新视图
                [_collectionView.mj_header endRefreshing];
                [_collectionView.mj_footer endRefreshing];
            }
            
        } failure:^(NSError *error) {
            
            NSLog(@"解析失败");
            
            [_HUD hide:YES];
            
            // 表格刷新完毕,结束上下刷新视图
            [_collectionView.mj_header endRefreshing];
            [_collectionView.mj_footer endRefreshing];
        }];
    }
    
    
    
    
    _cityHeaderArr = [NSMutableArray arrayWithArray:@[@"热门城市",@"A",@"B",@"C",@"D",@"S",@"Z"]];
    _cityJianSuoArr = [NSMutableArray arrayWithArray:@[@"热",@"A",@"B",@"C",@"D",@"S",@"Z"]];
    
    // 城市数组
    _cityArr = [NSMutableArray arrayWithArray:@[@[@"北京",@"上海",@"青岛",@"深圳"],@[@"安宁",@"安平",@"安溪",@"安宁",@"安平",@"安溪"],@[@"保定",@"宝鸡",@"宝宝"],@[@"曹县",@"曹县",@"曹县",@"曹县"],@[@"大连",@"大连",@"大连",@"大连"],@[@"上海",@"上海",@"上海",@"上海",@"上海"],@[@"周口",@"周口",@"周口",@"周口",@"周口"]]];
}

// 创建UI
- (void) createUI {
    
    // 创建搜索文本框
    [self createSearchView];
    
    // 创建城市选择视图
    [self createLocationUv];
    
    // 创建定位按钮(导航栏右侧按钮)
    [self createShowLocationBtn];
    
    // 设置下面分类选择器
    [self createSelectMenuView];
    
    // 创建collectionview
    [self createCollectionView];
}

// 获取相差时间 秒
- (NSInteger) getDifferForTime:(NSString *) timestamp {
    
    // 获取当前时间
    NSDate *nowDate = [NSDate date];
    
    
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    
    // 截止时间字符串格式
    NSString *expireDateStr = [dateFomatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timestamp intValue]]];
    // 当前时间字符串格式
    NSString *nowDateStr = [dateFomatter stringFromDate:nowDate];
    // 截止时间data格式
    NSDate *expireDate = [dateFomatter dateFromString:expireDateStr];
    // 当前时间data格式
    nowDate = [dateFomatter dateFromString:nowDateStr];
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:nowDate toDate:expireDate options:0];
    
//    NSLog(@"===========%ld",dateCom.day * 3600 * 24);
    
    return dateCom.second + dateCom.hour * 3600 + dateCom.minute * 60 + dateCom.day * 3600 * 24;
    
    // 原谅把你带走的雨天  在突然醒来的黑夜  发现我终于没有在流泪
    
//    // 伪代码
//    年差额 = dateCom.year, 月差额 = dateCom.month, 日差额 = dateCom.day, 小时差额 = dateCom.hour, 分钟差额 = dateCom.minute, 秒差额 = dateCom.second
}

// 获取相差时间 未开团的
- (NSDateComponents *) getDifferForTimeWait:(NSString *) timestamp {
    
    // 获取当前时间
    NSDate *nowDate = [NSDate date];
    
    
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    
    // 截止时间字符串格式
    NSString *expireDateStr = [dateFomatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timestamp intValue]]];
    // 当前时间字符串格式
    NSString *nowDateStr = [dateFomatter stringFromDate:nowDate];
    // 截止时间data格式
    NSDate *expireDate = [dateFomatter dateFromString:expireDateStr];
    // 当前时间data格式
    nowDate = [dateFomatter dateFromString:nowDateStr];
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:nowDate toDate:expireDate options:0];
    
//    NSLog(@"===========%ld",dateCom.day * 3600 * 24);
    
    return dateCom;
    
    //    // 伪代码
    //    年差额 = dateCom.year, 月差额 = dateCom.month, 日差额 = dateCom.day, 小时差额 = dateCom.hour, 分钟差额 = dateCom.minute, 秒差额 = dateCom.second
}

// 创建城市选择视图
- (void) createLocationUv {
    
    // 遮罩层
    _zhezhaoView = [[ZheZhaoView alloc] initWithFrame:CGRectMake(0, 0, W, H)];
    
    _zhezhaoView.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zhezhaoClick)];
    [_zhezhaoView addGestureRecognizer:tap];
    
    // 城市选择视图
    _selCityView = [[SelectCityView alloc] initWithFrame:CGRectMake(W, 64, W * 0.8125, _zhezhaoView.frame.size.height)];
    [self.navigationController.view addSubview:_selCityView];
    [_selCityView.closeBtn addTarget:self action:@selector(closeSelectView) forControlEvents:UIControlEventTouchUpInside];
    _selCityView.citytableView.delegate = self;
    _selCityView.citytableView.dataSource = self;
    // 设置tableview头部视图
    UIView *CurrentCityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, W * 0.8125, 48)];
    CurrentCityView.backgroundColor = FUIColorFromRGB(0xffffff);
    UIImageView *CurrentCityimgView = [[UIImageView alloc] init];
    [CurrentCityView addSubview:CurrentCityimgView];
    [CurrentCityimgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(CurrentCityView);
        make.left.equalTo(CurrentCityView).with.offset(W * 0.8125 * 0.038);
        make.width.equalTo(@(48 * 0.375 / 1.2));
        make.height.equalTo(@(48 * 0.375));
    }];
    CurrentCityimgView.image = [UIImage imageNamed:@"home_location_icon"];
    
    // 当前位置
    _currentCityLb = [[UILabel alloc] init];
    [CurrentCityView addSubview:_currentCityLb];
    [_currentCityLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(CurrentCityView);
        make.left.equalTo(CurrentCityimgView.mas_right).with.offset(W * 0.8125 * 0.038 / 2);
        if (iPhone6SP) {
            make.height.equalTo(@(17));
            _currentCityLb.font = [UIFont systemFontOfSize:17];
        }else if (iPhone6S) {
            
            make.height.equalTo(@(16));
            _currentCityLb.font = [UIFont systemFontOfSize:16];
        }else {
            
            make.height.equalTo(@(15));
            _currentCityLb.font = [UIFont systemFontOfSize:15];
        }
    }];
    _currentCityLb.textColor = FUIColorFromRGB(0x8e7eff);
    _selCityView.citytableView.tableHeaderView = CurrentCityView;
    // 设置检索的字体颜色
    _selCityView.citytableView.sectionIndexColor = FUIColorFromRGB(0x8e7eff);
    // 设置右侧索引背景色
    _selCityView.citytableView.sectionIndexBackgroundColor =[UIColor clearColor];
    
    // 注册
    [_selCityView.citytableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cityTop"];
    [_selCityView.citytableView registerClass:[HotCityTableViewCell class] forCellReuseIdentifier:@"hotCity"];
    
}

#pragma mark ------UItableViewDelegate/UITableViewDataSource
//显示每组标题索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return _cityJianSuoArr;
}

//返回每个索引的内容
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    
//}
//
////响应点击索引时的委托方法
//-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index {
//    
//}

// 分区数
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _cityArr.count;
}
// 每个分区返回的cell数量
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *arr = _cityArr[section];
    
    if (section == 0) {
        return 1;
    }else {
        return arr.count;
    }
    
}
// 绑定数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        
        HotCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotCity" forIndexPath:indexPath];
        
        UIView *HotView = [KindBtnViewForPinTuan creatBtn:_cityArr[indexPath.section]];
        cell.hotCityView.frame = CGRectMake(0, 0, HotView.frame.size.width, HotView.frame.size.height);
        [cell.hotCityView addSubview:HotView];
        
        //遍历这个view，对这个view上btn添加相应的事件
        for (UIButton *btn in HotView.subviews) {
            [btn addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        return cell;
        
    }else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityTop" forIndexPath:indexPath];
        // 设置标题
        cell.textLabel.text = _cityArr[indexPath.section][indexPath.row];
        if (iPhone6SP) {
            cell.textLabel.font = [UIFont systemFontOfSize:17];
        }else if (iPhone6S) {
            cell.textLabel.font = [UIFont systemFontOfSize:16];
        }else {
            cell.textLabel.font = [UIFont systemFontOfSize:15];
        }
        
        return cell;
    }
}

// 热门按钮点击事件
- (void) handleButton:(UIButton *)btn {
    
    // 获取点击的地址
    NSString *strSelcetCity = btn.titleLabel.text;
    
    // 设置地址
    [_locationBtn setTitle:strSelcetCity forState:UIControlStateNormal];
    // 将当前位置添加到单例,用于下次设置
    [USER setObject:strSelcetCity forKey:@"cityDingWei"];
    // 设置完地址，刷新collectionview
    
    [self closeSelectView];
}

// 每行的高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        UIView *vc = [KindBtnViewForPinTuan creatBtn:_cityArr[indexPath.section]];
        
        return vc.frame.size.height;
    
    }else {
        
        return 48;
    }
    
}
// 分区表头高度
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 22;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

// 返回头部title
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    
//    return _cityHeaderArr[section];
//}

// 自定义分区表头和表尾
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, W * 0.8125, 22)];
    
    UILabel *lb = [[UILabel alloc] init];
    [view addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view).with.offset(W * 0.8125 * 0.038);
        make.height.equalTo(@(12));
    }];
    lb.font = [UIFont systemFontOfSize:12];
    lb.textColor = FUIColorFromRGB(0x999999);
    lb.text = _cityHeaderArr[section];
    
    view.backgroundColor = FUIColorFromRGB(0xeeeeee);
    
    return view;
}

// tableView的点击事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }else {
        
        // 获取点击的地址
        NSString *strSelcetCity = _cityArr[indexPath.section][indexPath.row];
        
        // 设置地址
        [_locationBtn setTitle:strSelcetCity forState:UIControlStateNormal];
        // 将当前位置添加到单例,用于下次设置
        [USER setObject:strSelcetCity forKey:@"cityDingWei"];
        // 设置完地址，刷新collectionview
        
        // 关闭城市选择视图
        [self closeSelectView];
    }
}



// 创建定位按钮
- (void) createShowLocationBtn {
    
    _locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _locationBtn.frame = CGRectMake(0, 0, 40, 32);
    
    _locationBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_locationBtn setTitle:[USER objectForKey:@"cityDingWei"] forState:UIControlStateNormal];
    // 先不让定位弹出
//    [_locationBtn addTarget:self action:@selector(openOrCloseLocation) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = - 10;
    
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,[[UIBarButtonItem alloc] initWithCustomView:_locationBtn]];
}



// 遮罩层点击事件
- (void) zhezhaoClick {
    
    // 关闭地理位置选择视图
    [self closeSelectView];
}

// 关闭地理位置选择视图
- (void) closeSelectView {
    
    // 关闭动画
    [UIView animateWithDuration:0.25f animations:^{
        
        _selCityView.frame = CGRectMake(W, 64, W * 0.8125, _zhezhaoView.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        _zhezhaoView.hidden = YES;
        
        // 恢复搜索框的用户操作
        _tfForSearch.userInteractionEnabled = YES;
    }];
}

// 打开地理位置选择视图
- (void) openOrCloseLocation {
    
    [self.view addSubview:_zhezhaoView];
    
    // 禁止搜索框的用户操作
    _tfForSearch.userInteractionEnabled = NO;
    
    _zhezhaoView.hidden = NO;
    
    [UIView animateWithDuration:0.25f animations:^{
        
        _selCityView.frame = CGRectMake(W - W * 0.8125, 64, W * 0.8125, _zhezhaoView.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        
    }];
}

// 创建搜索文本框
- (void) createSearchView {
    
    // 搜索文本框
    _tfForSearch = [[UITextField alloc] init];
    _tfForSearch.frame = CGRectMake(0, 0, W * 0.7, 32);
    self.navigationItem.titleView = _tfForSearch;
    _tfForSearch.placeholder = @"请输入搜索关键词";
    _tfForSearch.backgroundColor = FUIColorFromRGB(0xffffff);
    _tfForSearch.layer.cornerRadius = 16;
    _tfForSearch.font = [UIFont systemFontOfSize:13];
    UIView *leftUv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 28)];
    _tfForSearch.delegate = self;
    _tfForSearch.leftView = leftUv;
    _tfForSearch.leftViewMode = UITextFieldViewModeAlways;
    _tfForSearch.returnKeyType = UIReturnKeySearch; // 设置键盘右下角为搜索
    // 搜索按钮
    UIButton *btnForSearch = [[UIButton alloc] init];
    [_tfForSearch addSubview:btnForSearch];
    [btnForSearch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_tfForSearch);
        make.right.equalTo(_tfForSearch).with.offset(- 15);
        make.width.equalTo(@(15));
        make.height.equalTo(@(15));
    }];
    [btnForSearch setImage:[UIImage imageNamed:@"home_search"] forState:UIControlStateNormal];
}

#pragma mark -- UITextFieldDelegate method
// 触发屏幕时
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self resignTextResponder];
}

// 点击搜索触发
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self resignTextResponder];
    
    
    // 点击了搜索
    if (_tfForSearch.text.length == 0) {
        NSLog(@"未输入任何东西");
        // 清空其他条件
        category = 0;
        keyword = @"";
        orderKey = 0;
        orderby = 0;
        pageStart = 0;
        pageSize = 10;
        _currentData2Index = 0;
        _currentData3Index = 0;
        _currentData3SelectedIndex = 0;
        // 改变选择器上面的文字
        [_dropDownMenu makemenuIndex:2 andTitle:@"全部"];
        [_dropDownMenu makemenuIndex:1 andTitle:@"综合"];
        
        // 下拉刷新一下
        [self downRefresh];
        
    }else if([_tfForSearch.text isEqualToString:@"张宗琦"]){
        alert(@"我的天,你认识他?!");
    }else if([_tfForSearch.text isEqualToString:@"张洋"]) {
        alert(@"帅!");
    }else {
        NSLog(@"在这里进行数据请求，然后刷新collectionview");
        // 清空其他条件
        category = 0;
        orderKey = 0;
        orderby = 0;
        pageStart = 0;
        pageSize = 10;
        _currentData2Index = 0;
        _currentData3Index = 0;
        _currentData3SelectedIndex = 0;
        // 改变选择器上面的文字
        [_dropDownMenu makemenuIndex:2 andTitle:@"全部"];
        [_dropDownMenu makemenuIndex:1 andTitle:@"综合"];
        // 修改关键词，并刷新(调用下拉刷新)
        keyword = [_tfForSearch.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"keyWord:%@",keyword);
        [self downRefresh];
    }
    
    return YES;
}

// 释放输入框
- (void)resignTextResponder {
    
    if ([_tfForSearch isFirstResponder]) {
        
        [_tfForSearch resignFirstResponder];
    }
}

// 创建CollectionView
- (void) createCollectionView {
    
    // 先给表格创建它的布局对象
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    // 设置间距为0
    flow.minimumInteritemSpacing = 0;
    flow.minimumLineSpacing = 6;
    
    // 设置该布局的滚动方向
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // 新建_collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 38, W, H -  39) collectionViewLayout:flow];
    
    // 背景色
    _collectionView.backgroundColor = FUIColorFromRGB(0xeeeeee);
    
    // 设置滚动条隐藏
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    // 代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    // collectionview的注册
    [_collectionView registerClass:[SpellgroupCollectionViewCell class] forCellWithReuseIdentifier:@"collection"];
    // collectionview的注册
    [_collectionView registerClass:[WaitCollectionViewCell class] forCellWithReuseIdentifier:@"waitCollection"];
    
    // 添加到当前页面
    [self.view addSubview:_collectionView];
    
    
    
    // 继续配置_tableView;
    // 创建一个下拉刷新的头
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 调用下拉刷新方法
        [self downRefresh];
    }];
    
    header.stateLabel.hidden = YES;
    
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 设置_tableView的顶头
    _collectionView.mj_header = header;
    
    // 设置_tableView的底部
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 调用上拉刷新方法
        [self upRefresh];
    }];
    
}

// 创建分类选择器
- (void) createSelectMenuView {
    
    // 设置选择器的位置和高度
    _dropDownMenu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:38];
    
    // 小箭头颜色
    _dropDownMenu.indicatorColor = FUIColorFromRGB(0xc0b8ff);
    // 边框分割线颜色
    _dropDownMenu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    // 字体颜色
    _dropDownMenu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
//    menu.titleColorNormal = FUIColorFromRGB(0xc0b8ff);
//    menu.titleColorSelected = FUIColorFromRGB(0xffffff);
    // 设置代理，遵从协议，调用方法
    _dropDownMenu.dataSource = self;
    _dropDownMenu.delegate = self;
    
    // 添加选择视图
    [self.view addSubview:_dropDownMenu];
    
    
    // 推荐
    _btnTuijian = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, W / 3 - 1, 38)];
    [_btnTuijian setTitleColor:FUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    _btnTuijian.titleLabel.font = [UIFont systemFontOfSize:14];
    [_btnTuijian setTitle:@"推荐" forState:UIControlStateNormal];
    // 背景色
    UIColor *topColor = FUIColorFromRGB(0x7d6dfa);
    UIColor *bottomColor = FUIColorFromRGB(0x7361f8);
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topColor, bottomColor] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(W / 3 - 1, 38)];
    _btnTuijian.backgroundColor = [UIColor colorWithPatternImage:bgImg];
    [_dropDownMenu addSubview:_btnTuijian];
    // 推荐按钮的点击事件
    [_btnTuijian addTarget:self action:@selector(tuijianClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 分割导航栏和选择器
    UILabel *lbFenge = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, W, 1)];
    [_dropDownMenu addSubview:lbFenge];
    lbFenge.backgroundColor = [UIColor colorWithRed:144/255.0 green:137/255.0 blue:249/255.0 alpha:1.0];
    
}


// 推荐按钮的点击事件
- (void) tuijianClick {
    
    // 制空之前已选条件
    category = 0;
    keyword = @"";
    orderKey = 0;
    orderby = 0;
    pageStart = 0;
    pageSize = 10;
    _tfForSearch.text = @"";
    
    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user objectForKey:@"token"] == nil) {
        // 获取数据(执行下拉刷新)
        [self downRefresh];
    }else {
        
        NSArray *arr = [GetUserJiaMi getUserTokenAndCgAndKey];
        NSDictionary *dicData = @{@"tk":arr[0],@"key":arr[1],@"cg":arr[2]};
//        我爱你，有时候我希望你的一生能被拍成一部漫长的电影，我就比你晚出生一百年，一辈子只做一件事，独自坐在房间中，对着墙上的屏幕，用我的一生，把你的一生，慢慢看完
//        NSLog(@"tk:%@,key:%@,cg:%@",arr[0],arr[1],arr[2]);
        
        HttpRequest *http = [[HttpRequest alloc] init];
        [http PostGetRecommendedListWithDic:dicData Success:^(id RecommendedListDic) {
            
            if ([RecommendedListDic isKindOfClass:[NSString class]]) {
                
                // 获取数据失败
                
                // 删除所有数据
                [_CollectionViewArr removeAllObjects];
                // 刷新列表
                [_collectionView reloadData];
                
                // 让动画消失
                [_HUD hide:YES];
                
                // 表格刷新完毕,结束上下刷新视图
                [_collectionView.mj_header endRefreshing];
                [_collectionView.mj_footer endRefreshing];
                
            }else {
                
                // 获取数据成功
                [_CollectionViewArr removeAllObjects];
                
                _CollectionViewArr = RecommendedListDic;
                
                NSLog(@"_CollectionViewArr:%@",_CollectionViewArr);
                
                // 让动画消失
                [_HUD hide:YES];
                
                // 刷新列表
                [_collectionView reloadData];
                
                // 表格刷新完毕,结束上下刷新视图
                [_collectionView.mj_header endRefreshing];
                [_collectionView.mj_footer endRefreshing];
            }
            
        } failure:^(NSError *error) {
            
            // 请求失败，网络错误
        }];
    }
    
    
    
    
    
    
    
    
    
    
    
    // 移除子视图
    [_dropDownMenu removeAllSubviews];
    
    // 先移除
    [_dropDownMenu removeFromSuperview];
    
    
    _currentData2Index = 0;
    _currentData3Index = 0;
    _currentData3SelectedIndex = 0;
    
    
    // 设置选择器的位置和高度  再创建
    _dropDownMenu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:38];
    
    // 小箭头颜色
    _dropDownMenu.indicatorColor = FUIColorFromRGB(0xc0b8ff);
    // 边框分割线颜色
    _dropDownMenu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    // 字体颜色
    _dropDownMenu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    //    menu.titleColorNormal = FUIColorFromRGB(0xc0b8ff);
    //    menu.titleColorSelected = FUIColorFromRGB(0xffffff);
    // 设置代理，遵从协议，调用方法
    _dropDownMenu.dataSource = self;
    _dropDownMenu.delegate = self;
    
    // 添加选择视图
    [self.view addSubview:_dropDownMenu];
    
    // 推荐
    _btnTuijian = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, W / 3 - 1, 38)];
    [_btnTuijian setTitleColor:FUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    _btnTuijian.titleLabel.font = [UIFont systemFontOfSize:14];
    [_btnTuijian setTitle:@"推荐" forState:UIControlStateNormal];
    // 背景色
    UIColor *topColor = FUIColorFromRGB(0x7d6dfa);
    UIColor *bottomColor = FUIColorFromRGB(0x7361f8);
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topColor, bottomColor] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(W / 3 - 1, 38)];
    _btnTuijian.backgroundColor = [UIColor colorWithPatternImage:bgImg];
    [_dropDownMenu addSubview:_btnTuijian];
    // 推荐按钮的点击事件
    [_btnTuijian addTarget:self action:@selector(tuijianClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 分割导航栏和选择器
    UILabel *lbFenge = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, W, 1)];
    [_dropDownMenu addSubview:lbFenge];
    lbFenge.backgroundColor = [UIColor colorWithRed:144/255.0 green:137/255.0 blue:249/255.0 alpha:1.0];
    
    NSLog(@"点击了推荐");
}


#pragma mark ---------UICollectionViewDelgate/UICollectionViewDataSource--------
// 每个分区的cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    // 返回的个数
    return _CollectionViewArr.count;
}

// 绑定数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 获取模型
    HomeDataModel *model = _CollectionViewArr[indexPath.row];
    // 判断是待开团还是已开团,获取当前时间戳进行和活动开始时间进行比对
    // 获取当前时间戳
    NSDate *senddate = [NSDate date];
    NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    if ([model.start_datetime intValue] > [date2 intValue]) {
        
        // 待开团
        WaitCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"waitCollection" forIndexPath:indexPath];
        
//        cell.goodsImgView.image = [UIImage imageNamed:model.img];
        // 设置图片以及等待视图
        [cell.goodsImgView sd_setImageWithURL:[NSURL URLWithString:[model.img_multi objectForKey:@"app_list"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        cell.titleLb.text = model.title;
        
        
        if ([self getDifferForTime:model.start_datetime] > 86400) {
            
            // 防止复用控件上的数据
            for (UIView *subView in cell.lbForHH.subviews) {
                [subView removeFromSuperview];
            }
            for (UIView *subView in cell.lbFormm.subviews) {
                [subView removeFromSuperview];
            }
            for (UIView *subView in cell.lbForss.subviews) {
                [subView removeFromSuperview];
            }
            cell.lbForHH.hidden = YES;
            cell.lbFormm.hidden = YES;
            cell.lbForss.hidden = YES;
            cell.maohaoLb1.hidden = YES;
            cell.maohaoLb2.hidden = YES;
            cell.rightImgView.hidden = YES; // 隐藏
            cell.waitDayLabel.hidden = NO; // 不隐藏
            
            NSDateComponents *dateCom = [self getDifferForTimeWait:model.start_datetime];
            
            cell.waitDayLabel.text = [NSString stringWithFormat:@"%ld天%ld小时%ld分钟", dateCom.day,dateCom.hour,dateCom.minute];
            
            
        }else {
            
            // 防止复用控件上的数据
            for (UIView *subView in cell.lbForHH.subviews) {
                [subView removeFromSuperview];
            }
            for (UIView *subView in cell.lbFormm.subviews) {
                [subView removeFromSuperview];
            }
            for (UIView *subView in cell.lbForss.subviews) {
                [subView removeFromSuperview];
            }
            cell.lbForHH.hidden = NO;
            cell.lbFormm.hidden = NO;
            cell.lbForss.hidden = NO;
            cell.maohaoLb1.hidden = NO;
            cell.maohaoLb2.hidden = NO;
            cell.rightImgView.hidden = NO; // 不隐藏
            cell.waitDayLabel.hidden = YES; // 隐藏
            // 时分秒
            [self timeCountForWaitForHH:cell.lbForHH andTime:[model.start_datetime integerValue]];
            [self timeCountForWaitForMM:cell.lbFormm andTime:[model.start_datetime integerValue]];
            [self timeCountForWaitForSS:cell.lbForss andTime:[model.start_datetime integerValue]];
            
        }
        
        // cell的背景色 白色
        cell.backgroundColor = FUIColorFromRGB(0xffffff);
        
        return cell;
        
    }else {
        
        // 已开团
        SpellgroupCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collection" forIndexPath:indexPath];
        
        // 设置图片以及等待视图
        [cell.goodsImgView sd_setImageWithURL:[NSURL URLWithString:[model.img_multi objectForKey:@"app_list"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        // 设置标题
        cell.titleLb.text = model.title;
        
        // 设置进度条长度
        CGFloat progessWidth = [self calculateWidthForMaxNum:[model.low_sale_num_limit integerValue]*3 andCurrentNum:[model.sale_num integerValue]];
        NSLog(@"%f",progessWidth);
        if (iPhone6SP) {
            cell.progressImgView.size = CGSizeMake(progessWidth, 12);
        }else if (iPhone6S) {
            cell.progressImgView.size = CGSizeMake(progessWidth, 11);
        }else {
            cell.progressImgView.size = CGSizeMake(progessWidth, 10);
        }
        // 设置背景色(用到了UIImage+GradientColor.h这个类扩展)
        UIColor *leftColor1 = FUIColorFromRGB(0x7766fd);
        UIColor *rightColor1 = FUIColorFromRGB(0xf779ff);
        UIImage *bgImg1 = [UIImage gradientColorImageFromColors:@[leftColor1, rightColor1] gradientType:GradientTypeLeftToRight imgSize:cell.progressImgView.size];
        cell.progressImgView.backgroundColor = [UIColor colorWithPatternImage:bgImg1];
        // 设置图片平铺
        UIImage *image2 = [UIImage imageNamed:@"home_progressbar"];
        CGFloat top = 0; // 顶端盖高度
        CGFloat bottom = 0 ; // 底端盖高度
        CGFloat left = 0; // 左端盖宽度
        CGFloat right = 0; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        image2 = [image2 resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeTile];
        //    UIImageResizingModeStretch：拉伸模式，通过拉伸UIEdgeInsets指定的矩形区域来填充图片
        //    UIImageResizingModeTile：平铺模式，通过重复显示UIEdgeInsets指定的矩形区域来填充图片
        cell.progressImgView.image = image2;
        
        // 显示当前人数
        cell.currentNumLb.text = [NSString stringWithFormat:@"%ld人",[model.sale_num integerValue]];
        
        // 成团人数
        cell.maxAndPriceLb.text = model.low_sale_num_limit;
        
        // 成团价格
        NSString *strPrice = [NSString stringWithFormat:@"%@ ¥%@",@"成团价",model.low_price];
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:strPrice];
        NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:@"成团价"].location, [[noteStr string] rangeOfString:@"成团价"].length);
        //需要设置的位置
        [noteStr addAttribute:NSForegroundColorAttributeName value:FUIColorFromRGB(0x999999) range:redRange];
        //设置颜色
        [cell.priceLb setAttributedText:noteStr];
        
        
        // 防止复用控件上的数据
        for (UIView *subView in cell.countDownLabel.subviews) {
            [subView removeFromSuperview];
        }
        [self timeCount:cell.countDownLabel andTime:[self getDifferForTime:model.end_datetime]];
        
        // cell的背景色 白色
        cell.backgroundColor = FUIColorFromRGB(0xffffff);
        
        return cell;
    }
}

// 每个cell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 获取模型
    HomeDataModel *model = _CollectionViewArr[indexPath.row];
    // 判断是待开团还是已开团,获取当前时间戳进行和活动开始时间进行比对
    // 获取当前时间戳
    NSDate *senddate = [NSDate date];
    NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    
    
    if ([model.start_datetime intValue] > [date2 intValue]) {
        
        return CGSizeMake(W, W * 0.54375);
        
    }else {
        
        return CGSizeMake(W, W * 0.59375);
    }
}

// 上左下右距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// collectionview 的选中事件
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 跳转到详情页
    GroupDetailViewController *detailVc = [[GroupDetailViewController alloc] init];
    
    // 获取模型
    HomeDataModel *model = _CollectionViewArr[indexPath.row];
    // 判断是待开团还是已开团,获取当前时间戳进行和活动开始时间进行比对
    // 获取当前时间戳
    NSDate *senddate = [NSDate date];
    NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    if ([model.start_datetime intValue] > [date2 intValue]) {
        detailVc.strStatus = @"0";
        detailVc.goodsId = model.id1;
        detailVc.pingjiaId = model.good_id;
    }else {
        detailVc.strStatus = @"1";
        detailVc.goodsId = model.id1;
        detailVc.pingjiaId = model.good_id;
    }
    
    // 跳转时隐藏底边导航控制器
    [detailVc setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:detailVc animated:YES];
}

// 倒计时方法（未开团） 小时
- (void) timeCountForWaitForHH:(UILabel *)countDownLabel andTime:(NSInteger) overTime {
    
    UILabel * timer_show = [[UILabel alloc] init];
    timer_show.backgroundColor = [UIColor clearColor];// 设置背景色
    [countDownLabel addSubview:timer_show];//把timer_show添加到倒计时按钮上
    [timer_show mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(countDownLabel);
        make.right.equalTo(countDownLabel);
        make.height.equalTo(countDownLabel);
        make.left.equalTo(countDownLabel);
    }];
    MZTimerLabel *timer_cutDown = [[MZTimerLabel alloc] initWithLabel:timer_show andTimerType:MZTimerLabelTypeTimer];//创建MZTimerLabel类的对象timer_cutDown
    [timer_cutDown setCountDownTime:overTime];//倒计时时间
    timer_cutDown.timeFormat = @"HH";
    timer_cutDown.timeLabel.textColor = FUIColorFromRGB(0xffffff);//倒计时字体颜色
    
    if (iPhone6SP) {
        timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:13.0];//倒计时字体大小
    }else if (iPhone6S) {
        timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:12.0];//倒计时字体大小
    }else {
        timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:11.0];//倒计时字体大小
    }
    timer_cutDown.timeLabel.textAlignment = NSTextAlignmentCenter;//居中
    [timer_cutDown start];//开始计时
}

// 倒计时方法（未开团） 分钟
- (void) timeCountForWaitForMM:(UILabel *)countDownLabel andTime:(NSInteger) overTime {
    
    UILabel * timer_show = [[UILabel alloc] init];
    timer_show.backgroundColor = [UIColor clearColor];// 设置背景色
    [countDownLabel addSubview:timer_show];//把timer_show添加到倒计时按钮上
    [timer_show mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(countDownLabel);
        make.right.equalTo(countDownLabel);
        make.height.equalTo(countDownLabel);
        make.left.equalTo(countDownLabel);
    }];
    MZTimerLabel *timer_cutDown = [[MZTimerLabel alloc] initWithLabel:timer_show andTimerType:MZTimerLabelTypeTimer];//创建MZTimerLabel类的对象timer_cutDown
    [timer_cutDown setCountDownTime:overTime]; //设置倒计时时间
    
    timer_cutDown.timeFormat = @"mm";
    //    timer_cutDown.timeFormat = @"活动倒计时 天 HH:mm:ss";//倒计时格式,也可以是@"HH:mm:ss SS"，时，分，秒，毫秒；想用哪个就写哪个
    timer_cutDown.timeLabel.textColor = FUIColorFromRGB(0xffffff);//倒计时字体颜色
    
    if (iPhone6SP) {
        timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:13.0];//倒计时字体大小
    }else if (iPhone6S) {
        timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:12.0];//倒计时字体大小
    }else {
        timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:11.0];//倒计时字体大小
    }
    timer_cutDown.timeLabel.textAlignment = NSTextAlignmentCenter;//居中
    [timer_cutDown start];//开始计时
}

// 倒计时方法（未开团） 秒
- (void) timeCountForWaitForSS:(UILabel *)countDownLabel andTime:(NSInteger) overTime {
    
    UILabel * timer_show = [[UILabel alloc] init];
    timer_show.backgroundColor = [UIColor clearColor];// 设置背景色
    [countDownLabel addSubview:timer_show];//把timer_show添加到倒计时按钮上
    [timer_show mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(countDownLabel);
        make.right.equalTo(countDownLabel);
        make.height.equalTo(countDownLabel);
        make.left.equalTo(countDownLabel);
    }];
    MZTimerLabel *timer_cutDown = [[MZTimerLabel alloc] initWithLabel:timer_show andTimerType:MZTimerLabelTypeTimer];//创建MZTimerLabel类的对象timer_cutDown
    [timer_cutDown setCountDownTime:overTime]; //设置倒计时时间
    
    timer_cutDown.timeFormat = @"ss";
    //    timer_cutDown.timeFormat = @"活动倒计时 天 HH:mm:ss";//倒计时格式,也可以是@"HH:mm:ss SS"，时，分，秒，毫秒；想用哪个就写哪个
    timer_cutDown.timeLabel.textColor = FUIColorFromRGB(0xffffff);//倒计时字体颜色
    
    if (iPhone6SP) {
        timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:13.0];//倒计时字体大小
    }else if (iPhone6S) {
        timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:12.0];//倒计时字体大小
    }else {
        timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:11.0];//倒计时字体大小
    }
    timer_cutDown.timeLabel.textAlignment = NSTextAlignmentCenter;//居中
    [timer_cutDown start];//开始计时
}


// 倒计时方法
- (void)timeCount:(UILabel *)countDownLabel andTime:(NSInteger) overTime{ //倒计时函数
    
    UILabel * timer_show = [[UILabel alloc] init];
    timer_show.backgroundColor = [UIColor clearColor];// 设置背景色
    [countDownLabel addSubview:timer_show];//把timer_show添加到倒计时按钮上
    [timer_show mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(countDownLabel);
        make.right.equalTo(countDownLabel);
        make.height.equalTo(countDownLabel);
    }];
    MZTimerLabel *timer_cutDown = [[MZTimerLabel alloc] initWithLabel:timer_show andTimerType:MZTimerLabelTypeTimer];//创建MZTimerLabel类的对象timer_cutDown
    [timer_cutDown setCountDownTime:overTime];//倒计时时间60s
    timer_cutDown.timeFormat = @"dd";
    NSString *str = timer_cutDown.timeLabel.text;
    NSLog(@"*********************%@",str);
    NSInteger datInt = [str integerValue] - 1;
    
    timer_cutDown.timeFormat = [NSString stringWithFormat:@"%ld天%@",datInt,@"HH:mm:ss"];
//    timer_cutDown.timeFormat = @"活动倒计时 天 HH:mm:ss";//倒计时格式,也可以是@"HH:mm:ss SS"，时，分，秒，毫秒；想用哪个就写哪个
    timer_cutDown.timeLabel.textColor = FUIColorFromRGB(0x8e7eff);//倒计时字体颜色
    
    if (iPhone6SP) {
        timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:13.0];//倒计时字体大小
    }else if (iPhone6S) {
        timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:12.0];//倒计时字体大小
    }else {
        timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:11.0];//倒计时字体大小
    }
    timer_cutDown.timeLabel.textAlignment = NSTextAlignmentCenter;//居中
    timer_cutDown.delegate = self;//设置代理，以便后面倒计时结束时调用代理
    [timer_cutDown start];//开始计时
}

// 倒计时结束后的代理方法
- (void)timerLabel:(MZTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    
    timerLabel.timeFormat = @"拼团已结束~";
    timerLabel.timeLabel.textColor = [UIColor redColor];
}


// 计算progerssImageView的长度
- (CGFloat) calculateWidthForMaxNum:(NSInteger) maxNum andCurrentNum:(NSInteger) currentNum {
    
    if (maxNum == 0) {
        
        return 0;
        
    }else {
        
        CGFloat scale = (CGFloat)currentNum / (CGFloat)maxNum;
        
        if (scale > 1.0) {
            CGFloat ProgressWidth = 1 * (W - (0.03125 * W * 2 + 0.095 * W + 0.2*W*0.59375));
            return ProgressWidth;
        }else {
            CGFloat ProgressWidth = scale * (W - (0.03125 * W * 2 + 0.295 * W));
            return ProgressWidth;
        }
    }
}




// 根据分类页传回数值进行请求列表
- (void) reloadListWithItem:(NSInteger) categoryNum {
    
    // 初始化请求参数
    category = categoryNum;
    keyword = @"";
    orderKey = 0;
    orderby = 0;
    pageStart = 0;
    pageSize = 10;
    
    // 下拉刷新
    [self downRefresh];
}

#pragma mark ------------JSDropDownMenu-----------
// 返回的数量
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 3;
}

// collection的样式
- (BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    
    // 0,1,2
    // 当序号为2时
//    if (column==2) {
//        
//        // 是否返回collection的样式
//        return YES;
//    }
    
    return NO;
}

// 有右侧层tableView
- (BOOL)haveRightTableViewInColumn:(NSInteger)column{
    
    // 当column == 0的时候，返回Yes
    if (column==2) {
        
        return YES;
    }
    return NO;
}

// 当有层级时，最左侧层级所占宽度比例
- (CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
    if (column==2) {
        
        return 0.333;
    }
    
    return 1;
}

// 绑定返回的行数
- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    if (column==0) {
        
        return _data1.count;
        
    } else if (column==1){
        
        return _data2.count;
        
    } else if (column==2){
            
        if (leftOrRight==0) {
                
            return _categoryArr.count;
                
        }else {
                
            NSDictionary *menuDic = [_categoryArr objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] count];
        }
    }
    
    return 0;
}

// 进入时选择器上返回的数据
- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    switch (column) {
        case 0: return _data1[_currentData1Index];
            break;
        case 1: return _data2[_currentData2Index];
            break;
        case 2: return [[_categoryArr[_currentData3Index] objectForKey:@"data"] objectAtIndex:_currentData3SelectedIndex];
                break;
        default:
            return nil;
            break;
    }
}

// 绑定数据，让选择器上的标题成为选中的数据
- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==0) {
        
        return _data1[indexPath.row];
        
    } else if (indexPath.column==1) {
        
        return _data2[indexPath.row];
        
    } else {
        
        
        if (indexPath.leftOrRight==0) {
            NSDictionary *menuDic = [_categoryArr objectAtIndex:indexPath.row];
            return [menuDic objectForKey:@"title"];
        } else{
            NSInteger leftRow = indexPath.leftRow;
            NSDictionary *menuDic = [_categoryArr objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] objectAtIndex:indexPath.row];
        }
    }
}

//  记录下选中的那一栏左边行
- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        
        _currentData1Index = indexPath.row;
        
    } else if(indexPath.column == 1){
        
        _currentData2Index = indexPath.row;
        // 去设置筛选条件
        orderKey = indexPath.row;
        // 请求数据(使用下拉刷新)
        [self downRefresh];
        
    } else{
        
        
        if (indexPath.leftOrRight==0) {
            
            _currentData3Index = indexPath.row;
            
            return;
            
        } else{
            
            NSInteger leftRow = indexPath.leftRow;
            
            if (leftRow == 0) {
                // 改变条件，刷新数据
                category = 0;
                [self downRefresh];
            }else {
                // 获取到点击的右栏的id，去刷新数据
                category = [[[_categoryBeforeArr[leftRow - 1] valueForKey:@"subList"][indexPath.row] valueForKey:@"id"] integerValue];
                [self downRefresh];
            }
        }

    }
}

// 使选中的行做一次记录，第二次打开下拉框返回上次选中的位置
- (NSInteger)currentLeftSelectedRow:(NSInteger)column{
    
    if (column == 0) {
        
        return _currentData1Index;
        
    }
    if (column == 1) {
        
        return _currentData2Index;
    }
    
    return _currentData3Index;
}




// 页面将要消失
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
    
    if (_zhezhaoView.hidden == NO) {
        [self closeSelectView];
    }
}

// 页面将要显示
- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // 设置单例用于判定侧边栏在哪个页面跳转
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@"0" forKey:@"CotrollerIndex"];
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:YES];
    
    // 设置导航栏背景色(用到了UIImage+GradientColor.h这个类扩展)
    UIColor *topleftColor1 = FUIColorFromRGB(0x9080ff);
    UIColor *bottomColor1 = FUIColorFromRGB(0x7d6dfa);
    UIImage *bgImg1 = [UIImage gradientColorImageFromColors:@[topleftColor1, bottomColor1] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(W, 64)];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:bgImg1]];
    
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
