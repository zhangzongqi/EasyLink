//
//  HomeViewController.m
//  EasyLink
//
//  Created by 琦琦 on 16/9/12.
//  Copyright © 2016年 fengdian. All rights reserved.
//

#import "ClassifyViewController.h"
#import "SDCycleScrollView.h" // 滚动图
#import "BannerCollectionReusableView.h" // collectionview的headerView
#import "KindCollectionViewCell.h" // collection的Cell
#import "SearchViewController.h" // 搜索页面
#import "GroupViewController.h" // 首页

#import "JSBadgeView.h" // 小圆点
#import "WZLBadgeImport.h" // 小圆点

#import "AppDelegate.h" // 用于判断侧栏

@interface ClassifyViewController ()<SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource> {
    
    
    NSArray *_arrForZhezhaoText; // 用于保存图片上标题和简介
    
    NSArray *_arrForCategory; // 分类数组
    
    NSArray *imagesURLStrings; // banner图片数组
    
    NSArray *_arrForBanner; // banner数据
}

@property (nonatomic,copy) UICollectionView *collectionView;

@property (nonatomic,copy) UILabel *topLabelInImg; // 滚动图标题

@property (nonatomic,copy) UILabel *summaryLabelInImg; // 滚动图说明

// 滚动图遮罩层
@property (nonatomic,copy) UIView *topView;

@end

@implementation ClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置标题
    UILabel *lbItemTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    lbItemTitle.text = @"全部分类";
    lbItemTitle.textColor = FUIColorFromRGB(0xffffff);
    lbItemTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lbItemTitle;
    
    // 页面背景色
    self.view.backgroundColor = FUIColorFromRGB(0xffffff);
    
    // 透明度，不透明
    self.navigationController.navigationBar.translucent = NO;
    
    // 导航栏左边按钮
    [self createBtnForLeftBarButtonItem];
    
    // 导航栏右侧按钮
    // 暂时不启用本页搜索
//    [self createRightBtnForNav];
    
    // 初始化数组
    [self initDataSource];
    
    // 创建UI
    [self createUI];
    
    // 获取数据
    [self getData];
}

// 初始化数组
- (void) initDataSource {
    
    imagesURLStrings = [NSArray array];
    
    _arrForBanner = [NSArray array];
    
    _arrForCategory = [NSArray array];
    _arrForZhezhaoText = [NSArray array];
}

// 导航栏右侧按钮
- (void) createRightBtnForNav {
    
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 18, 18);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"category_search"] forState:UIControlStateNormal];
    // 暂时不启用本页搜索
    [menuBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加按钮和边距
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
}

// 搜索按钮点击事件
- (void) searchBtnClick:(UIButton *)btn {
    
    SearchViewController *vc = [[SearchViewController alloc] init];
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

// 导航栏左边按钮
- (void) createBtnForLeftBarButtonItem {
    
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 18, 18);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"index1"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
    
    // 设置边距
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = - 15 + (0.15 * W - 18)/3;
    
    // 添加按钮和边距
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

// 创建UI
- (void) createUI {
    
    // 创建collectionview
    // 先给表格创建它的布局对象
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    // 设置间距为0
    flow.minimumInteritemSpacing = 1;
    flow.minimumLineSpacing = 1;
    // 设置该布局的滚动方向
    flow.scrollDirection = UICollectionViewScrollDirectionVertical; // 竖向滚动
    // 新建_collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, W, H - 49 - 64) collectionViewLayout:flow];
    // 背景色
    _collectionView.backgroundColor = [UIColor colorWithRed:244/255.0 green:245/255.0 blue:246/255.0 alpha:1.0];
    // 设置滚动条隐藏
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    // 代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    // collectionview的注册
    [_collectionView registerClass:[KindCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    // headerView注册
    [_collectionView registerClass:[BannerCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionHeader"];
    // 添加到当前页面
    [self.view addSubview:_collectionView];
    
    
    // 滚动图上文字
    _topLabelInImg = [[UILabel alloc] init];
    [self.view addSubview:_topLabelInImg];
    [_topLabelInImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(W * 0.4375 / 2 - 25 - 10);
        make.width.equalTo(@(W / 4));
        make.height.equalTo(@(25));
    }];
    _topLabelInImg.layer.cornerRadius = 12.5;
    _topLabelInImg.layer.borderColor = FUIColorFromRGB(0xffffff).CGColor;
    _topLabelInImg.layer.borderWidth = 1.0;
    _topLabelInImg.textColor = FUIColorFromRGB(0xffffff);
    _topLabelInImg.font = [UIFont systemFontOfSize:14];
    _topLabelInImg.textAlignment = NSTextAlignmentCenter;
    
    
    // 滚动图上说明
    _summaryLabelInImg = [[UILabel alloc] init];
    [self.view addSubview:_summaryLabelInImg];
    [_summaryLabelInImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_topLabelInImg.mas_bottom).with.offset(10);
        make.height.equalTo(@(25));
    }];
    _summaryLabelInImg.textColor = FUIColorFromRGB(0xffffff);
    _summaryLabelInImg.font = [UIFont systemFontOfSize:14];
    _summaryLabelInImg.textAlignment = NSTextAlignmentCenter;
    
}


#pragma mark ----------UICollectionViewDataSource/UICollectionViewDelegate
// 返回的分区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
// 每个分区返回的cell数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _arrForCategory.count;
}
// 绑定cell的数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    /**
     *
     *   这里自定义cell,使用xib进行布局.对于如何使用xib创建视图,不明白的,可以看我之前写的一篇文章.
     */
    
    KindCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.lbKindTitle.text = [NSString stringWithFormat:@"%@",[_arrForCategory[indexPath.row] valueForKey:@"title"]];
    
    cell.backgroundColor = FUIColorFromRGB(0xffffff);
    
    return cell;
}

// 头视图/尾视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        BannerCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionHeader" forIndexPath:indexPath];
        /**
         *
         * 注意:虽然这里没有看到明显的initWithFrame方法,但是在获取重用视图的时候,系统会自动调用initWithFrame方法的.所以在initWithFrame里面进行初始化操作,是没有问题的!
         */
        
        headerView.bannerView.delegate = self;
        
        
        [headerView giveArrayToBanner:imagesURLStrings];
        
        reusableview = headerView;
    }
    
    
//    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, reusableview.frame.size.width, reusableview.frame.size.height)];
//    [reusableview addSubview:_topView];
//    _topView.backgroundColor = FUIColorFromRGB(0x212121);
//    _topView.alpha = 0.3;
//    _topView.userInteractionEnabled = YES;
    
    return reusableview;
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
     [super touchesBegan:touches withEvent:event];
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((W - 3) / 4, W / 8);
}

//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);//分别为上、左、下、右
}
//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size= {W ,W * 0.4375};
    return size;
}

// collectionview的点击事件
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 先跳入首页界面
    self.tabBarController.selectedIndex = 0;
    
    [self.navigationController popViewControllerAnimated:YES];
    
    GroupViewController *vc = self.tabBarController.childViewControllers[0].childViewControllers[0];
    [vc.dropDownMenu makemenuIndex:2 andTitle:[NSString stringWithFormat:@"%@",[_arrForCategory[indexPath.row] valueForKey:@"title"]]];
    [vc.dropDownMenu makemenuIndex:1 andTitle:@"综合排序"];

    vc.currentData2Index = 0;
    
    // 清空搜索框关键词
    vc.tfForSearch.text = @"";
    
    // 去首页请求数据
    [vc reloadListWithItem:[[_arrForCategory[indexPath.row] valueForKey:@"id"] integerValue]];
    

    
    
//    SearchDetailViewController *vc = [[SearchDetailViewController alloc] init];
//    
//    vc.strTitle = [NSString stringWithFormat:@"分类%ld",indexPath.row];
//    
//    [vc setHidesBottomBarWhenPushed:YES];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --------SDCycleScrollViewDelegate---------
// 滚动条点击事件
- (void) cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
//    NSLog(@"点击了第%ld张",index);
}
- (void) cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    
    NSLog(@"滚动到了第%ld张",index);
    
    if ([[_arrForBanner[index] objectForKey:@"multi_txt"] isKindOfClass:[NSString class]]) {
        
        _topLabelInImg.text = @"";
        _summaryLabelInImg.text = @"";
        _topLabelInImg.layer.borderWidth = 0.0;
        
    }else if([[_arrForBanner[index] objectForKey:@"multi_txt"] count] == 1){
        
        _topLabelInImg.text = [_arrForBanner[index] objectForKey:@"multi_txt"][0];
        _summaryLabelInImg.text = @"";
        _topLabelInImg.layer.borderWidth = 1.0;
        
    }else {
        
        _topLabelInImg.text = [_arrForBanner[index] objectForKey:@"multi_txt"][0];
        _summaryLabelInImg.text = [_arrForBanner[index] objectForKey:@"multi_txt"][1];
        _topLabelInImg.layer.borderWidth = 1.0;
    }
    
    

}


// 获取数据
- (void) getData {
    
    // 创建数据请求
    HttpRequest *http = [[HttpRequest alloc] init];
    
    
    // 获取banner
    [http GetBannerListWithPosition:1 Success:^(id bannerList) {
        
        NSMutableArray *arr = [NSMutableArray array];
        
        // for循环
        for (int i = 0; i < [bannerList count]; i++) {
            
            [arr addObject:[bannerList[i] objectForKey:@"img"]];
        }
        
        imagesURLStrings = arr;
        
        _arrForBanner = bannerList;
        
        if (_arrForBanner.count == 0) {
            
            
        }else {
            
            if ([[_arrForBanner[0] objectForKey:@"multi_txt"] isKindOfClass:[NSString class]]) {
                
                _topLabelInImg.layer.borderWidth = 0.0;
                
            }else if([[_arrForBanner[0] objectForKey:@"multi_txt"] count] == 1){
                
                _topLabelInImg.layer.borderWidth = 1.0;
                _topLabelInImg.text = [_arrForBanner[0] objectForKey:@"multi_txt"][0];
            }else {
                
                _topLabelInImg.layer.borderWidth = 1.0;
                _topLabelInImg.text = [_arrForBanner[0] objectForKey:@"multi_txt"][0];
                _summaryLabelInImg.text = [_arrForBanner[0] objectForKey:@"multi_txt"][1];
            }
            
        }
        
        [_collectionView reloadData];
        
    } failure:^(NSError *error) {
        
        // 网络错误,请求失败
        
    }];
    
    
    
    
    // 获取所有分类
    [http GetGoodsCategorySuccess:^(id arrForList) {
        
        if ([arrForList isKindOfClass:[NSString class]] && [arrForList isEqualToString:@"0"]) {
            
            // 请求失败
            
        }else {
            
            NSMutableArray *arrCategory = [[NSMutableArray alloc] init];
            
            // 请求成功
            NSArray *arr = arrForList;
            
            for (int i = 0; i < arr.count ; i++) {
                
                [arrCategory addObject:arr[i]];
                
                NSArray *arr2 = [arr[i] valueForKey:@"subList"];
                
                for (int j = 0; j < arr2.count; j++) {
                    
                    [arrCategory addObject:arr2[j] ];
                }
            }
            
            _arrForCategory = arrCategory;
            
//            NSLog(@"_arrForCategory:%@",_arrForCategory);
            
            [_collectionView reloadData];
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        // 数据请求失败
        
    }];

}

// 页面将要消失
- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
}

// 页面将要显示
- (void)viewWillAppear:(BOOL)animated {
    
    // 设置单例用于判定侧边栏在哪个页面跳转
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@"1" forKey:@"CotrollerIndex"];
    
    // 设置导航栏背景色(用到了UIImage+GradientColor.h这个类扩展)
    UIColor *topleftColor = FUIColorFromRGB(0x9080ff);
    UIColor *bottomrightColor = FUIColorFromRGB(0x7765ff);
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor, bottomrightColor] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(W, 64)];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:bgImg]];
    

    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:YES];
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
