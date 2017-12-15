//
//  MineOrdersViewController.m
//  EasyLink
//
//  Created by 琦琦 on 17/3/6.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "MineOrdersViewController.h"
#import "WaitPayOrderCollectionViewCell.h" // collectionView的Cell
#import "PingjiaViewController.h" // 评价页面
#import "ZhiFuViewController.h" // 支付页面
#import "WaitGoodsViewController.h" // 待收货页面
#import "WaitFaHuoViewController.h" // 待发货
#import "AlreadyWanChengViewController.h" // 已完成
#import "WaitChengTuanViewController.h" // 待成团
#import "YiGuanBiViewController.h" // 已关闭


@interface MineOrdersViewController ()<UICollectionViewDelegate,UICollectionViewDataSource> {
    
    NSMutableArray *_arrForStatus;
}

@property (nonatomic, copy) UICollectionView *collectionView;

@end

@implementation MineOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置不透明
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor = FUIColorFromRGB(0x666666);
    
    // 获取数据
    [self initData];
    
    // 布局页面
    [self layoutViews];
}

// 获取数据
- (void) initData {
    
    _arrForStatus = [NSMutableArray arrayWithArray:@[@"待付款",@"已发货",@"已完成",@"待发货",@"已发货",@"待评价"]];
}

// 布局页面
- (void) layoutViews {
    
    // 推荐的collectionview
    // 先给表格创建它的布局对象
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    // 设置间距为0
    flow.minimumInteritemSpacing = 0;
    flow.minimumLineSpacing = 6;
    
    // 设置该布局的滚动方向
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // 新建_collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, W, H - 64 - 32) collectionViewLayout:flow];
    
    // 背景色
    _collectionView.backgroundColor = FUIColorFromRGB(0xeeeeee);
    
    // 设置滚动条隐藏
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    // 代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    // collectionview的注册
    [_collectionView registerClass:[WaitPayOrderCollectionViewCell class] forCellWithReuseIdentifier:@"collection"];
    
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
    
    WaitPayOrderCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collection" forIndexPath:indexPath];
    if ([_strIndex isEqualToString:@"0"]) {
        // 全部
        switch (indexPath.row) {
            case 0:{
                // 待付款
                [cell.btnForPayConfirmDelete setTitle:@"立即支付" forState:UIControlStateNormal];
                [cell.btnForCancleLogistics setTitle:@"取消订单" forState:UIControlStateNormal];
            }
                break;
            case 1: {
                
                // 已发货
                [cell.btnForPayConfirmDelete setTitle:@"确认收货" forState:UIControlStateNormal];
                [cell.btnForCancleLogistics setTitle:@"查看物流" forState:UIControlStateNormal];
            }
                break;
            case 2: {
                
                // 已完成
                [cell.btnForPayConfirmDelete setTitle:@"删除订单" forState:UIControlStateNormal];
                cell.btnForCancleLogistics.hidden = YES;
            }
                break;
            case 3: {
                
                // 待发货
                [cell.btnForPayConfirmDelete setTitle:@"提醒卖家" forState:UIControlStateNormal];
                cell.btnForCancleLogistics.hidden = YES;
            }
                break;
            case 4: {
                
                // 待收货、已发货
                [cell.btnForPayConfirmDelete setTitle:@"确认收货" forState:UIControlStateNormal];
                [cell.btnForCancleLogistics setTitle:@"查看物流" forState:UIControlStateNormal];
            }
                break;
            case 5: {
                
                // 待评价
                [cell.btnForPayConfirmDelete setTitle:@"立即评价" forState:UIControlStateNormal];
                cell.btnForCancleLogistics.hidden = YES;
                
            }
                break;
            default:
                break;
        }
        
        // 订单状态
        cell.statusLb.text = _arrForStatus[indexPath.row];
        
    }else if ([_strIndex isEqualToString:@"1"]) {
        
        // 待付款
        
        [cell.btnForPayConfirmDelete setTitle:@"立即支付" forState:UIControlStateNormal];
        [cell.btnForCancleLogistics setTitle:@"取消订单" forState:UIControlStateNormal];
        cell.statusLb.text = @"待付款";
        
        
    }else if ([_strIndex isEqualToString:@"2"]) {
        
        // 待发货
        
        [cell.btnForPayConfirmDelete setTitle:@"提醒卖家" forState:UIControlStateNormal];
        cell.btnForCancleLogistics.hidden = YES;
        cell.statusLb.text = @"待发货";
        
    }else if ([_strIndex isEqualToString:@"3"]) {
        
        // 待收货
        // 待收货、已发货
        [cell.btnForPayConfirmDelete setTitle:@"确认收货" forState:UIControlStateNormal];
        [cell.btnForCancleLogistics setTitle:@"查看物流" forState:UIControlStateNormal];
        cell.statusLb.text = @"已发货";
        
    }else if ([_strIndex isEqualToString:@"4"]) {
        
        // 待评价
        
        [cell.btnForPayConfirmDelete setTitle:@"立即评价" forState:UIControlStateNormal];
        cell.btnForCancleLogistics.hidden = YES;
        cell.statusLb.text = @"待评价";
    }else if ([_strIndex isEqualToString:@"5"]) {
        
        // 待成团
        [cell.btnForPayConfirmDelete setTitle:@"等待成团" forState:UIControlStateNormal];
        cell.btnForCancleLogistics.hidden = YES;
        cell.statusLb.text = @"待成团";
        
    }else if ([_strIndex isEqualToString:@"6"]) {
        
        // 已关闭
        [cell.btnForPayConfirmDelete setTitle:@"删除订单" forState:UIControlStateNormal];
        cell.btnForCancleLogistics.hidden = YES;
        cell.statusLb.text = @"已关闭";
    }
    
    cell.orderNumLb.text = [NSString stringWithFormat:@"订单编号:%@",@"1234567854"];
    cell.imgView.image = [UIImage imageNamed:@"5"];
    cell.titleLb.text = @"说走咱就走啊,你有我有全都有啊。嘿嘿,全都有啊。";
    cell.priceLb.text = @"¥166.8";
    cell.buyNumLb.text = [NSString stringWithFormat:@"x%@",@"2"];
    cell.orderGuigeLb.text = @"4个 约3kg 10人团";
    
    [cell.btnForPayConfirmDelete addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnForCancleLogistics addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    cell.backgroundColor = FUIColorFromRGB(0xffffff);
    
    
    return cell;
}

// cell上的按钮点击
- (void) cellBtnClick:(UIButton *)btn {
    
    
    
    if ([btn.titleLabel.text isEqualToString:@"立即支付"]) {
        
        alert(btn.titleLabel.text);
        
    }else if ([btn.titleLabel.text isEqualToString:@"取消订单"]) {
        
        alert(btn.titleLabel.text);
        
    }else if ([btn.titleLabel.text isEqualToString:@"确认收货"]) {
        
        alert(btn.titleLabel.text);
        
    }else if ([btn.titleLabel.text isEqualToString:@"查看物流"]) {
        
        alert(btn.titleLabel.text);
        
    }else if ([btn.titleLabel.text isEqualToString:@"删除订单"]) {
        
        alert(btn.titleLabel.text);
        
    }else if ([btn.titleLabel.text isEqualToString:@"提醒卖家"]) {
        
        alert(btn.titleLabel.text);
        
    }else if ([btn.titleLabel.text isEqualToString:@"立即评价"]) {
        PingjiaViewController *vc = [[PingjiaViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

// 每个cell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(W, 0.46875 * W);
}

// 上左下右距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// collectionview的点击事件
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([_strIndex isEqualToString:@"0"]) {
        // 全部
    }else if ([_strIndex isEqualToString:@"1"]) {
        
        // 待付款
        ZhiFuViewController *vc = [[ZhiFuViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([_strIndex isEqualToString:@"2"]) {
        
        // 待发货
        WaitFaHuoViewController *vc = [[WaitFaHuoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([_strIndex isEqualToString:@"3"]) {
        
        // 待收货
        WaitGoodsViewController *vc = [[WaitGoodsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([_strIndex isEqualToString:@"4"]) {
        
        // 待评价
        AlreadyWanChengViewController *vc = [[AlreadyWanChengViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([_strIndex isEqualToString:@"5"]) {
        
        // 待成团
        WaitChengTuanViewController *vc = [[WaitChengTuanViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([_strIndex isEqualToString:@"6"]) {
        
        // 已关闭
        YiGuanBiViewController *vc = [[YiGuanBiViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }

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
