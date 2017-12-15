//
//  HomeViewController.m
//  EasyLink
//
//  Created by 琦琦 on 16/9/12.
//  Copyright © 2016年 fengdian. All rights reserved.
//

#import "HomeViewController.h"
#import "GYChangeTextView.h" // 实现文字上下滚动
#import "WMDetailViewController.h" //详情页
#import "MoreKindViewController.h" // 全部分类页面


#import "WSPageView.h" // 实现3D滚动轮播
#import "WSIndexBanner.h" // 实现3D滚动轮播

#import "JSBadgeView.h" // 小圆点
#import "WZLBadgeImport.h" // 小圆点

#import "ListCollectionViewCell.h"

#import "HeaderCRView.h"

#import "AppDelegate.h"
#define vBackBarButtonItemName  @"backArrow.png"    //导航条返回默认图片名

@interface HomeViewController ()<GYChangeTextViewDelegate,WSPageViewDelegate,WSPageViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource> {
    
    // 背景滚动视图
    UIScrollView *backContainerView;
    
    NSArray *_arrForBtnName;
}

@property (nonatomic, strong) NSArray *imageArray; // 滚动图数组

@property (nonatomic, strong) GYChangeTextView *tView; // 上下滚动文字视图

@property (nonatomic, strong) WSPageView *scrollViewFor3D; // 3D滚动视图

@property (nonatomic, strong) UIPageControl *pageControl; // 滚动图小圆点

@property (nonatomic, strong) UILabel *lbSeparated; // 导航栏和下部分割线

@property (nonatomic, copy) UIImageView * navImgView; // 首页导航栏标题图片

@property (nonatomic,copy) UICollectionView *collectionView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置底边栏图片
    [self createTabbarImg];
    
    // 设置标题
    _navImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0.14 * W,  0.05 * W)];
    _navImgView.image = [UIImage imageNamed:@"index_logo"];
    _navImgView.center = self.navigationController.navigationBar.center;
    [self.navigationController.view addSubview:_navImgView];
    
    // 设置不偏移64 （tableView）
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 透明度，不透明
    self.navigationController.navigationBar.translucent = NO;
    
    // 导航栏左边按钮
    [self createBtnForLeftBarButtonItem];
    
    // 创建UI
    [self createUI];
    
    // 获取数据
    [self getData];
}

// 设置底边栏图片
- (void) createTabbarImg {
    
    UIImage *select2 = [UIImage imageNamed:@"home_icon_on3"];
    [self.tabBarController.childViewControllers[4].tabBarItem  setSelectedImage:[select2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UIImage *normal2 = [UIImage imageNamed:@"home_icon_off3"];
    [self.tabBarController.childViewControllers[4].tabBarItem  setImage:[normal2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UIImage *select1 = [UIImage imageNamed:@"home_icon_on2"];
    [self.tabBarController.childViewControllers[2].tabBarItem  setSelectedImage:[select1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UIImage *normal1 = [UIImage imageNamed:@"home_icon_off2"];
    [self.tabBarController.childViewControllers[2].tabBarItem  setImage:[normal1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UIImage *select = [UIImage imageNamed:@"home_icon_on1"];
    [self.navigationController.tabBarItem  setSelectedImage:[select imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UIImage *normal = [UIImage imageNamed:@"home_icon_off1"];
    [self.navigationController.tabBarItem  setImage:[normal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}

// 导航栏左边按钮
- (void) createBtnForLeftBarButtonItem {
    
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 0.045 * W, 0.045 * W);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"index1"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    
    
    // 消息小圆点
//    JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:menuBtn alignment:JSBadgeViewAlignmentTopLeft];
//    badgeView.badgeText = @"2";
    
    [menuBtn showBadgeWithStyle:WBadgeStyleRedDot value:0 animationType:WBadgeAnimTypeNone];
    menuBtn.badgeBgColor = FUIColorFromRGB(0xfe5f5f);
    
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
    
    // 创建滚动图
    [self createScrollView];
    
    // 创建广播栏
//    [self createRadio];
    
    // 创建九宫格
    [self createScratchableLatex];
}

// 创建广播栏
- (void) createRadio {
    
    // 上下滚动广播栏
    GYChangeTextView *tView = [[GYChangeTextView alloc] initWithFrame:CGRectMake(36, H / 4 + 1, W - 16, 40)];
    tView.delegate = self;
    [backContainerView addSubview:tView];
    self.tView = tView;
    [self.tView animationWithTexts:[NSArray arrayWithObjects:@"恭喜张宗琦成功提现50元！！！",@"马亚坤获得0.5元阅读奖励！！！",@"恭喜***获得30元购物返利！！！", nil]];
    
    //消息图标
    UIImageView *msgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, H / 4 + 1 + 12.5, 20, 15)];
    msgImageView.image = [UIImage imageNamed:@"information"];
    msgImageView.backgroundColor = [UIColor clearColor];
    [backContainerView addSubview:msgImageView];
}
// 上下广播栏点击事件
- (void)gyChangeTextView:(GYChangeTextView *)textView didTapedAtIndex:(NSInteger)index {
    
    NSLog(@"%ld",(long)index);
}


// 创建九宫格
- (void) createScratchableLatex {
    
    // 九宫格宽度、高度
    CGFloat btnWidth = W / 4;
    
    // 九宫格起始高度位置
    CGFloat btnOriginH = _collectionView.frame.origin.y + _collectionView.frame.size.height;
    
    // 数据
    _arrForBtnName = @[@"女装男装",@"美装洗护",@"鞋类箱包",@"母婴用品",@"零食酒水",@"珠宝配饰",@"日用百货",@"生鲜粮油",@"手机数码",@"家电办公",@"生活服务",@"···"];
    
    // 创建按钮
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 4; j++) {
            
            // 九宫格按钮
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnWidth*j, btnOriginH + btnWidth * i, btnWidth, btnWidth)];
            
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"index_分类%d",j + i*4 + 1]] forState:UIControlStateNormal];
            
            // btn的名字
            [btn setTitle:_arrForBtnName[j + i*4] forState:UIControlStateNormal];
            
            // 更多按钮
            if (i == 2 && j == 3) {
                
                [btn setTitle:@"全部分类" forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:35];
            }
            
            btn.imageView.sd_layout
            .centerXEqualToView(btn)
            .topSpaceToView(btn,btn.frame.size.height/4)
            .widthRatioToView(btn,0.35)
            .heightRatioToView(btn,0.35);
            
            btn.titleLabel.sd_layout
            .topSpaceToView(btn.imageView,btn.frame.size.height/10)
            .leftEqualToView(btn)
            .rightEqualToView(btn)
            .heightRatioToView(btn,0.07);
            
            // 按钮的属性
            btn.titleLabel.font = [UIFont systemFontOfSize:btn.height * 0.1 + 2];
            [btn setTitleColor:FUIColorFromRGB(0x999999) forState:UIControlStateNormal];
            
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            // 将按钮添加到滚动视图
            [backContainerView addSubview:btn];
            
            // btn的点击事件
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            btn.tag = j + i*4;
        }
    }

    // 分割线长度
    CGFloat threadwidth = W/8;
    // 间距
    CGFloat space = W/16;
    
    // 横着分割线
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 4; j++) {
            
            // 横向分割线
            UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(space + threadwidth*j + space*j*2, btnOriginH + btnWidth*(i+1) - 0.5, threadwidth, 1)];
            lb.backgroundColor = FUIColorFromRGB(0xeeeeee);
            [backContainerView addSubview:lb];
        }
    }
    // 竖着分割线
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            
            // 纵向分割线
            UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(btnWidth * (j+1) - 0.5, btnOriginH + space + btnWidth * i, 1, threadwidth)];
            lb.backgroundColor = FUIColorFromRGB(0xeeeeee);
            [backContainerView addSubview:lb];
        }
    }
    
    // 分割小圆点
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 3; j++) {
            
            // 分割小圆点
            UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(btnWidth + btnWidth*j - 1.5, btnOriginH + btnWidth + btnWidth*i - 1.5, 3, 3)];
            lb.backgroundColor = FUIColorFromRGB(0xeeeeee);
            lb.clipsToBounds = YES;
            lb.layer.cornerRadius = 1.5;
            [backContainerView addSubview:lb];
        }
    }
    
    if (iPhone4S) {
        backContainerView.contentSize = CGSizeMake(W, H/3 + W/4 * 3 + 49 + 64);
    }
}

// 九宫格点击事件
- (void) btnClick:(UIButton *)btn {
    
    if (btn.tag == 11) {
        
        NSLog(@"哈哈哈");
        
        // 全部分类页面
        MoreKindViewController *moreKindVC = [[MoreKindViewController alloc] init];
        
        // 隐藏底边栏
        [moreKindVC setHidesBottomBarWhenPushed:YES];
        
        // 跳转详情页
        [self.navigationController pushViewController:moreKindVC animated:YES];
        
    }else {
        
        // 详情页
        WMDetailViewController *detailVC = [[WMDetailViewController alloc] init];
        
        detailVC.str = _arrForBtnName[btn.tag];
        
        // 隐藏底边栏
        [detailVC setHidesBottomBarWhenPushed:YES];
        
        // 跳转详情页
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

// 创建滚动图、背景滚动图
- (void) createScrollView {
    
    // 页面背景色
    self.view.backgroundColor = FUIColorFromRGB(0xffffff);
    
    // 底层滚动视图
    backContainerView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    backContainerView.contentSize = CGSizeMake(W, H);
    [self.view addSubview:backContainerView];
    
    // 导航栏和滚动图分割线
    if (_lbSeparated == nil) {
        _lbSeparated = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, W, 2)];
        _lbSeparated.backgroundColor = [UIColor colorWithRed:171/255.0 green:164/255.0 blue:251/255.0 alpha:1.0];
        [backContainerView addSubview:_lbSeparated];
    }
    
    // _collectionView
    // 先给表格创建它的布局对象
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    // 设置间距为0
    flow.minimumInteritemSpacing = 0;
    
    // 设置该布局的滚动方向
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // 新建_collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 2, W, H / 3) collectionViewLayout:flow];
    
    // 设置滚动条隐藏
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    // 背景色
    _collectionView.backgroundColor = [UIColor colorWithRed:247/255.0 green:248/255.0 blue:249/255.0 alpha:1.0];
    
    // 代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"ListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"xib"];
    
    //这里的HeaderCRView 是自定义的header类型
    [_collectionView registerClass:[HeaderCRView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    // 添加到当前页面
    [backContainerView addSubview:_collectionView];

}

// 每个分区的cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 0;
}

// 绑定数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ListCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"xib" forIndexPath:indexPath];
    
    return cell;
}

//每个cell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 返回cell的大小
    return CGSizeMake(W, 0);
}

//上左下右距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    // 返回上左下右的距离
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//这个方法是返回 Header的大小 size
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(W, [UIScreen mainScreen].bounds.size.height / 3);
}

//这个也是最重要的方法 获取Header的 方法。
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = @"header";
    //从缓存中获取 Headercell
    HeaderCRView *cell = (HeaderCRView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // 数组
    self.imageArray = [[NSArray alloc] initWithObjects:@"discover_details3_01",@"discover_details3_02",@"discover_details3_03",@"discover_details3_04",@"discover_details3_05",@"discover_details3_06",@"discover_details3_07",@"7",@"discover_details3_08",nil];
    
    // 创建滚动视图
    _scrollViewFor3D = [[WSPageView alloc]initWithFrame:CGRectMake(0, 0, W, [UIScreen mainScreen].bounds.size.height / 3)];
    
    // 渐变色
    UIColor *topleftColor = FUIColorFromRGB(0x988afe);
    UIColor *bottomrightColor = FUIColorFromRGB(0x6a58f2);
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor, bottomrightColor] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(W, [UIScreen mainScreen].bounds.size.height / 3)];
    _scrollViewFor3D.backgroundColor = [UIColor colorWithPatternImage:bgImg];
    
    _scrollViewFor3D.delegate = self;
    _scrollViewFor3D.dataSource = self;
    _scrollViewFor3D.minimumPageAlpha = 0.3;   //非当前页的透明比例
    _scrollViewFor3D.minimumPageScale = 0.9;  //非当前页的缩放比例
    _scrollViewFor3D.orginPageCount = _imageArray.count; //原始页数
    _scrollViewFor3D.autoTime = 3;    //自动切换视图的时间,默认是5.0
    
    //初始化pageControl
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _scrollViewFor3D.frame.size.height - 8 - 10, kScreenWidth, 8)];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    _scrollViewFor3D.pageControl = _pageControl;
    //    [_scrollViewFor3D addSubview:_pageControl];
    [_scrollViewFor3D startTimer];
    [cell addSubview:_scrollViewFor3D];
    
    return cell;
}

#pragma mark NewPagedFlowView Delegate
// 图片大小
- (CGSize)sizeForPageInFlowView:(WSPageView *)flowView {
//    return CGSizeMake(W*5/6 + 8, H/3 + 10);
//    return CGSizeMake( kScreenWidth - 84, kScreenHeight/4);
    float h = _scrollViewFor3D.frame.size.height;
    float w = _scrollViewFor3D.frame.size.width;
    return CGSizeMake(w * 5/6 - 8, h * 6/7);
}

// 点击事件
- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
    
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(WSPageView *)flowView {
    return _imageArray.count;
}

- (UIView *)flowView:(WSPageView *)flowView cellForPageAtIndex:(NSInteger)index{
    WSIndexBanner *bannerView = (WSIndexBanner *)[flowView dequeueReusableCell];
    if (!bannerView) {
        float h = _scrollViewFor3D.frame.size.height;
        float w = _scrollViewFor3D.frame.size.width;
        bannerView = [[WSIndexBanner alloc] initWithFrame:CGRectMake(0, 0 ,w * 5/6 - 8, h * 6/7)];
//        bannerView = [[WSIndexBanner alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 84, kScreenHeight/4)];
        bannerView.layer.cornerRadius = 0;
        bannerView.layer.masksToBounds = YES;
    }
    
    bannerView.mainImageView.image = [UIImage imageNamed:self.imageArray[index]];
//    [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:ImgURLArray[index]]];
    
    return bannerView;
    
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(WSPageView *)flowView {
    
    NSLog(@"滚动到了第%ld页",(long)pageNumber);
}


// 获取数据
- (void) getData {
    
}

// 页面将要消失
- (void)viewWillDisappear:(BOOL)animated
{
    _navImgView.hidden = YES;
    
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
}

// 页面将要显示
- (void)viewWillAppear:(BOOL)animated {
    
    // 设置单例用于判定侧边栏在哪个页面跳转
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@"0" forKey:@"CotrollerIndex"];
    
    // 设置导航栏背景色(用到了UIImage+GradientColor.h这个类扩展)
    UIColor *topleftColor1 = FUIColorFromRGB(0x9e90ff);
    UIColor *bottomrightColor1 = FUIColorFromRGB(0x988afe);
    UIImage *bgImg1 = [UIImage gradientColorImageFromColors:@[topleftColor1, bottomrightColor1] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(W, 64)];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:bgImg1]];
    
    _navImgView.hidden = NO;
    
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
