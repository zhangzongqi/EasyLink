//
//  MoreKindViewController.m
//  EasyLink
//
//  Created by 琦琦 on 16/9/19.

/* 全部分类页面*/

//  Copyright © 2016年 fengdian. All rights reserved.
//

#import "MoreKindViewController.h"
#import "AllKindCollectionViewCell.h" // 全部种类视图
#import "KindBtnView.h" // 创建cell上的种类视图
#import "WMDetailViewController.h" // 详情页

@interface MoreKindViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UIGestureRecognizerDelegate> {
    
    // 多行多列表格
    UICollectionView *_collectionView;
    
    // cell图片数组
    NSArray *_arrImg;
    
    // 种类数组
    NSArray *_arrBtnKind;
    
    // 按钮分类名字
    NSArray *_arrBtnName;
    
    // 简单介绍LabelName
    NSArray *_arrSimpleName;
}

@end

@implementation MoreKindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 背景色
    self.view.backgroundColor = FUIColorFromRGB(0xffffff);
    
    // 设置不透明
    self.navigationController.navigationBar.translucent = NO;
    
    // 返回按钮
    [self createBackBtn];
    
    // 设置导航栏标题
    UILabel *lbItemTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    lbItemTitle.text = @"全部分类";
    lbItemTitle.textColor = [UIColor whiteColor];
    lbItemTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lbItemTitle;
    
    // 获取数据
    [self initData];
    
    // 创建UI
    [self createUI];
}

// 获取数据
- (void) initData {
    
    _arrSimpleName = @[@"腔调好货、随时变幻不一样的魅力",@"滋润养生、打造滋润的蜜光肌",@"原创设计、找到属于你的那一款",@"腔调好货、随时变幻不一样的魅力",@"滋润养生、打造滋润的蜜光肌",@"原创设计、找到属于你的那一款"];
    
    _arrBtnName = @[@"女装男装",@"美装洗护",@"鞋类箱包",@"女装男装",@"美装洗护",@"鞋类箱包"];
    
    _arrImg = @[@"category_list_img6",@"category_list_img5",@"category_list_img4",@"category_list_img3",@"category_list_img2",@"category_list_img1"];
    
    _arrBtnKind = @[
  @[@"时尚套装",@"小西裤",@"毛衣"],
  @[@"爽肤水",@"彩妆套装",@"古龙水",@"眼部护理",@"洁面乳",@"高光棒",@"隔离霜",@"眼霜",@"精华",@"剃须膏",@"彩妆盘",@"清洁面膜",@"淡香水",@"劲能醒肤"],
  @[@"时尚套装",@"小西裤",@"毛衣",@"春秋外套",@"春秋外套",@"呢外套",@"牛仔裤",@"运动裤",@"堆堆袜",@"真皮皮衣",@"风衣",@"爽肤水",@"彩妆套装",@"古龙水",@"眼部护理",@"洁面乳",@"高光棒",@"隔离霜",@"时尚套装"],
  @[@"爽肤水",@"彩妆套装",@"古龙水",@"眼部护理",@"洁面乳",@"高光棒",@"隔离霜",@"眼霜",@"精华",@"剃须膏",@"彩妆盘",@"清洁面膜",@"淡香水"],
  @[@"时尚套装",@"小西裤",@"毛衣",@"春秋外套",@"呢外套",@"牛仔裤",@"运动裤",@"时尚套装",@"小西裤"],
  @[@"爽肤水",@"彩妆套装",@"古龙水",@"眼部护理",@"洁面乳",@"高光棒",@"隔离霜",@"眼霜",@"精华",@"剃须膏",@"彩妆盘",@"清洁面膜"]
  ];
}

// 创建UI
- (void) createUI {
    
    // 先给表格创建它的布局对象
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    // 设置间距为0
    flow.minimumInteritemSpacing = 0;
    //    flow.minimumLineSpacing = 0;
    
    // 设置该布局的滚动方向
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // 新建_collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, W, H - 64) collectionViewLayout:flow];
    
    // 背景色
    _collectionView.backgroundColor = FUIColorFromRGB(0xf8f8f8);
    
    // 设置滚动条隐藏
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    // 代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView registerClass:[AllKindCollectionViewCell class] forCellWithReuseIdentifier:@"collection"];
    
    // 添加到当前页面
    [self.view addSubview:_collectionView];
}

// 返回的分组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 6;
}

// 每个分区的cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    // 返回的个数
    return 1;
}

// 绑定数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    
    AllKindCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collection" forIndexPath:indexPath];
    
    // 防止复用控件上的数据
    for (UIView *subView in cell.btnKindUv.subviews) {
        [subView removeFromSuperview];
    }

    cell.KindImgView.image = [UIImage imageNamed:_arrImg[indexPath.section]];
    
    UIView *vc = [KindBtnView creatBtn:_arrBtnKind[indexPath.section]];
    
    cell.btnKindUv.frame = CGRectMake(0, cell.KindImgView.frame.size.height, W, vc.frame.size.height);
    
    [cell.btnKindUv addSubview:vc];
    
    [cell.btnKind setTitle:_arrBtnName[indexPath.section] forState:UIControlStateNormal];
    
    cell.titleLb.text = _arrSimpleName[indexPath.section];
    
    cell.backgroundColor = FUIColorFromRGB(0xffffff);
    
    return cell;
}


// collectionview的点击事件
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 详情页
    WMDetailViewController *detailVC = [[WMDetailViewController alloc] init];
    
    detailVC.str = _arrBtnName[indexPath.section];
    
    // 跳转详情页
    [self.navigationController pushViewController:detailVC animated:YES];
}

// 每个cell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIView *vc = [KindBtnView creatBtn:_arrBtnKind[indexPath.section]];
    
    return CGSizeMake(W, vc.frame.size.height + 0.3625 * W);
}

// 尾部高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeMake(W, 8);
}

// 上左下右距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
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

// 页面将要显示
- (void) viewWillAppear:(BOOL)animated {
    
    // 设置导航栏背景色(用到了UIImage+GradientColor.h这个类扩展)
    UIColor *topleftColor = FUIColorFromRGB(0x9080ff);
    UIColor *bottomrightColor = FUIColorFromRGB(0x7765ff);
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor, bottomrightColor] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(W, 64)];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:bgImg]];
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
