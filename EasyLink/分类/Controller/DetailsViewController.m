//
//  DetailsViewController.m
//  EasyLink
//
//  Created by 琦琦 on 16/9/13.
//  Copyright © 2016年 fengdian. All rights reserved.
//

#import "DetailsViewController.h"
#import "ListDetailCollectionViewCell.h" // 分类详情
#import "GoodsViewController.h" // 商品页

@interface DetailsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate> {
    
    UICollectionView *_collectionView;
}

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置不透明
    self.navigationController.navigationBar.translucent = NO;
    
    // 获取数据
    [self initData];
    
    // 创建UI
    [self createUI];
}

// 获取数据
- (void)initData {
    
    //
}

// 创建UI
- (void)createUI {
    
    // _collectionView
    // 先给表格创建它的布局对象
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    // 设置间距为0
    flow.minimumInteritemSpacing = 0;
//    flow.minimumLineSpacing = 0;
    
    // 设置该布局的滚动方向
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // 新建_collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, W, H - 64 - 30) collectionViewLayout:flow];
    
    // 背景色
    _collectionView.backgroundColor = FUIColorFromRGB(0xf8f8f8);
    
    // 设置滚动条隐藏
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    // 代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"ListDetailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ListDetailCell"];
    
    // 添加到当前页面
    [self.view addSubview:_collectionView];
}

// 每个分区的cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    // 返回的个数
    return 6;
}

// 绑定数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ListDetailCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ListDetailCell" forIndexPath:indexPath];
    
    NSArray *arrImg1 = @[@"category_list_img1",@"category_list_img2",@"category_list_img3",@"category_list_img4",@"category_list_img5",@"category_list_img6"];
    NSArray *arrImg = @[@"category_list_img6",@"category_list_img5",@"category_list_img4",@"category_list_img3",@"category_list_img2",@"category_list_img1"];
    NSArray *arrIconImg = @[@"category_list_logo1",@"category_list_logo2",@"category_list_logo3",@"category_list_logo4",@"category_list_logo5",@"category_list_logo6"];
    
    if ([_strIndex isEqualToString:@"0"]) {
        
        cell.adImgView.image = [UIImage imageNamed:arrImg[indexPath.row]];
        
    }else if ([_strIndex isEqualToString:@"1"]) {
        
        cell.adImgView.image = [UIImage imageNamed:arrImg1[indexPath.row]];
        
    }else if ([_strIndex isEqualToString:@"2"]) {
        
        cell.adImgView.image = [UIImage imageNamed:arrImg[indexPath.row]];
        
    }else {
        
        cell.adImgView.image = [UIImage imageNamed:arrImg1[indexPath.row]];
    }
    
    
    cell.titleLabel.text = @"[利群]出门在外，你就是最美的焦点";
    cell.guanzhuLB.text = @"1869次浏览";
    cell.liulanLB.text = @"28万关注";
    cell.headImg.image = [UIImage imageNamed:arrIconImg[indexPath.row]];
    
    cell.backgroundColor = FUIColorFromRGB(0xffffff);
    
    return cell;
}

// 每个cell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(W, W/2);
}

// 上左下右距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// collectionview的点击事件
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 点击跳到详情页
    GoodsViewController *goodsVC = [[GoodsViewController alloc] init];
    
    // 隐藏底边栏
    [goodsVC setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:goodsVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
