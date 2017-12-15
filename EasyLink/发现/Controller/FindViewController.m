//
//  FindViewController.m
//  EasyLink
//
//  Created by 琦琦 on 16/9/12.
//  Copyright © 2016年 fengdian. All rights reserved.
//

#import "FindViewController.h"
#import "ListCollectionViewCell.h"
#import "DetailViewController.h"
//#import "UILabel+ChangeLineSpaceAndWordSpace.h" // 用于修改文字间距

@interface FindViewController ()<UICollectionViewDelegate,UICollectionViewDataSource> {
    
    // 多行多列表格
    UICollectionView *_collectionView;
}

@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置不透明
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor = [UIColor colorWithRed:247/255.0 green:248/255.0 blue:249/255.0 alpha:1.0];
    
    // 获取数据
    [self initData];
    
    // 创建UI
    [self createUI];
}

// 获取数据
- (void) initData {
    
    //
}

// 创建UI
- (void) createUI {
    
    // _collectionView
    // 先给表格创建它的布局对象
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    // 设置间距为0
    flow.minimumInteritemSpacing = 0;
    
    
    // 设置该布局的滚动方向
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // 新建_collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, W, H - 64 - 49 - 30) collectionViewLayout:flow];
    
    // 设置滚动条隐藏
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    // 背景色
    _collectionView.backgroundColor = [UIColor colorWithRed:247/255.0 green:248/255.0 blue:249/255.0 alpha:1.0];
    
    // 代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"ListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"xib"];
    
    // 添加到当前页面
    [self.view addSubview:_collectionView];
}


// 每个分区的cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 6;
}

// 绑定数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ListCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"xib" forIndexPath:indexPath];
    
    NSArray *arrImg = @[@"discover_list_img1",@"discover_list_img2",@"discover_list_img3",@"discover_list_img4",@"discover_list_img5",@"discover_list_img6"];
    NSArray *arrImg1 = @[@"discover_list_img6",@"discover_list_img5",@"discover_list_img4",@"discover_list_img3",@"discover_list_img2",@"discover_list_img1"];
    
    if ([_strIndex isEqualToString:@"0"]) {
        
        cell.imgView.image = [UIImage imageNamed:arrImg[indexPath.row]];
        
    }else if ([_strIndex isEqualToString:@"1"]) {
        
        cell.imgView.image = [UIImage imageNamed:arrImg1[indexPath.row]];
        
    }else if ([_strIndex isEqualToString:@"2"]) {
        
        cell.imgView.image = [UIImage imageNamed:arrImg[indexPath.row]];
        
    }else {
        
        cell.imgView.image = [UIImage imageNamed:arrImg1[indexPath.row]];
    }
    
    
    cell.goodsName.text = @"两个人的潜台词、一个人的樱花梦——樱の花";
    cell.detailLb.text = @"春天,百花千红,吾独爱樱花,只缘于一句“明年春天陪你一起看樱花”。于是,春天,在我望穿了无数个日日夜夜后,终于,迈着优美的舞姿,踏过冬日里最后一场雪,挥舞一场和煦暖风,飘洒一地缠绵细雨,缓缓而来";
    
//    [UILabel changeLineSpaceForLabel:cell.detailLb WithSpace:5.0];
    
    cell.liulanLb.text = @"282,208次浏览";
    cell.guanzhuLb.text = @"1,869次关注";
    
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

//每个cell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 返回cell的大小
    return CGSizeMake(W, 0.625* W);
}

//上左下右距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    // 返回上左下右的距离
    return UIEdgeInsetsMake(0, 0, 7, 0);
}

// collectionview的点击事件
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *arrTitle = @[@"父亲节",@"情人节",@"儿童",@"出游踏春",@"读书",@"旅游",@"服装",@"限时购",@"一抹新鲜",@"创意生活",@"美食节"];
    
    // 新建详情页
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    
    // 跳转时隐藏底边栏
    [detailVC setHidesBottomBarWhenPushed:YES];
    
    detailVC.strTitleName = arrTitle[[_strIndex intValue]];
    
    // 跳转
    [self.navigationController pushViewController:detailVC animated:YES];
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
