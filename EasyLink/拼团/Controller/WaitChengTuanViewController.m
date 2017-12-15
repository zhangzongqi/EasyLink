//
//  WaitChengTuanViewController.m
//  EasyLink
//
//  Created by 琦琦 on 17/3/12.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "WaitChengTuanViewController.h"
#import "DingDanBianhaoAndStatus.h" // 订单号和状态
#import "OrderSureAdressView.h" // 地址
#import "DDXQBuyDetailView.h" // 订单详情
#import "DDXQCollectionViewCell.h" // collectionviewCell
#import "DaojishiView.h" // 活动倒计时

@interface WaitChengTuanViewController ()<UICollectionViewDataSource,UICollectionViewDelegate> {
    
    NSArray *_titleLabelArr;
    NSArray *_infoArr;
}

@property (nonatomic, copy) UIScrollView *bigScrollView;
@property (nonatomic, copy) DingDanBianhaoAndStatus *numAndstatusVc;
@property (nonatomic, copy) DaojishiView *daojishiVc;
@property (nonatomic, copy) OrderSureAdressView *addressVc;
@property (nonatomic, copy) DDXQBuyDetailView *buyDetailView;

@property (nonatomic, copy) UICollectionView *collectionView;

@end

@implementation WaitChengTuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = FUIColorFromRGB(0xffffff);
    
    // 设置导航栏标题
    UILabel *lbItemTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    lbItemTitle.text = @"订单详情";
    lbItemTitle.textColor = FUIColorFromRGB(0xffffff);
    lbItemTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lbItemTitle;
    
    // 返回按钮
    [self createBackBtn];
    
    // 获取数据
    [self initData];
    
    // 布局UI
    [self createUI];
}

// 获取数据
- (void) initData {
    
    _titleLabelArr = @[@"支付方式",@"下单时间",@"成团时间",@"发货时间"];
    _infoArr = @[@"微信支付",@"17-02-17 10:48:45",@"17-02-20 20:48:45",@"17-02-21 08:00:00"];
}

// 布局UI
- (void) createUI {
    
    // 导航栏下面的黑线
    UILabel *navBarShadow = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, W, 1)];
    navBarShadow.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:239/255.0 alpha:1.0];
    [self.view addSubview:navBarShadow];
    
    _bigScrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_bigScrollView];
    [_bigScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navBarShadow.mas_bottom);
        make.left.equalTo(self.view);
        make.width.equalTo(@(W));
        make.height.equalTo(@(H - 64 - 1));
    }];
    _bigScrollView.backgroundColor = FUIColorFromRGB(0xeeeeee);
    
    
    // 订单状态和编号
    _numAndstatusVc = [[DingDanBianhaoAndStatus alloc] initWithFrame:CGRectMake(0, 0, W, H * 0.04)];
    [_bigScrollView addSubview:_numAndstatusVc];
    [_numAndstatusVc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bigScrollView);
        make.left.equalTo(self.view);
        make.width.equalTo(@(W));
        make.height.equalTo(@(W * 0.09375));
    }];
    _numAndstatusVc.dingDanNumLb.text = @"订单编号:1719119057";
    _numAndstatusVc.dingdanStatusLb.text = @"待成团";
    
    // 倒计时
    _daojishiVc = [[DaojishiView alloc] initWithFrame:CGRectMake(0, 0, W, W * 19/64)];
    [_bigScrollView addSubview:_daojishiVc];
    [_daojishiVc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_numAndstatusVc.mas_bottom).with.offset(1);
        make.left.equalTo(self.view);
        make.width.equalTo(@(W));
        make.height.equalTo(@(W * 19/64));
    }];
    _daojishiVc.backgroundColor = FUIColorFromRGB(0xffffff);
    _daojishiVc.yipinLb.text = @"活动倒计时 [已拼967件]";
    // 给时间戳,开始倒计时
    [_daojishiVc giveEndTime:@"1490578620"];
    
    // 地址
    _addressVc = [[OrderSureAdressView alloc] initWithFrame:CGRectMake(0, 0, W, W * 0.21875)];
    [_bigScrollView addSubview:_addressVc];
    [_addressVc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_daojishiVc.mas_bottom).with.offset(W / 64);
        make.left.equalTo(self.view);
        make.width.equalTo(@(W));
        make.height.equalTo(@(W * 0.21875));
    }];
    [_addressVc.adressBtn setTitle:@"收货人: 张宗琦 17191190576\r\n山东省青岛市市北区颐高数码广场" forState:UIControlStateNormal];
    _addressVc.adressBtn.userInteractionEnabled = NO; // 此处不能提供选择
    
    // 订单详情
    _buyDetailView = [[DDXQBuyDetailView alloc] initWithFrame:CGRectMake(0, 0, W, W * 0.646875)];
    [_bigScrollView addSubview:_buyDetailView];
    [_buyDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressVc.mas_bottom).with.offset(W / 64);
        make.left.equalTo(self.view);
        make.width.equalTo(@(W));
        make.height.equalTo(@(W * 0.646875));
    }];
    _buyDetailView.goodsImgView.image = [UIImage imageNamed:@"7"];
    _buyDetailView.titleLb.text = @"反对乐天,反对萨德!";
    _buyDetailView.buyNumLb.text = @"x2";
    _buyDetailView.onePriceLb.text = @"¥99.90";
    _buyDetailView.orderGuigeLb.text = @"1份约3kg 10人团";
    _buyDetailView.peiSongLabel.text = @"顺丰速递 免邮";
    _buyDetailView.gouwuquanLabel.text = @"¥10";
    // label两种颜色字体
    NSString *strPrice = [NSString stringWithFormat:@"实付: %@",@"199.80"];
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:strPrice];
    NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:@"实付:"].location, [[noteStr string] rangeOfString:@"实付:"].length);
    //需要设置的位置
    [noteStr addAttribute:NSForegroundColorAttributeName value:FUIColorFromRGB(0x999999) range:redRange];
    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:redRange];
    [_buyDetailView.endPriceLb setAttributedText:noteStr];
    
    
    [_bigScrollView layoutIfNeeded];
    
    
    // 推荐的collectionview
    // 先给表格创建它的布局对象
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    // 设置间距为0
    flow.minimumInteritemSpacing = 0;
    flow.minimumLineSpacing = 1;
    
    // 设置该布局的滚动方向
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // 新建_collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _buyDetailView.frame.size.height + _buyDetailView.frame.origin.y + W / 64, W, 0) collectionViewLayout:flow];
    
    // 背景色
    _collectionView.backgroundColor = FUIColorFromRGB(0xeeeeee);
    
    // 设置滚动条隐藏
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    // 代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = NO;
    
    // collectionview的注册
    [_collectionView registerClass:[DDXQCollectionViewCell class] forCellWithReuseIdentifier:@"collection"];
    
    // 添加到当前页面
    [_bigScrollView addSubview:_collectionView];
    
}

#pragma mark ---------UICollectionViewDelgate/UICollectionViewDataSource--------
// 每个分区的cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    _collectionView.size = CGSizeMake(W ,W * 0.125 * _infoArr.count);
    _bigScrollView.contentSize = CGSizeMake(W, _collectionView.frame.origin.y + _collectionView.frame.size.height);
    
    // 返回的个数
    return _titleLabelArr.count;
}

// 绑定数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DDXQCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collection" forIndexPath:indexPath];
    
    cell.titleLb.text = _titleLabelArr[indexPath.row];
    cell.infoLb.text = _infoArr[indexPath.row];
    
    cell.backgroundColor = FUIColorFromRGB(0xffffff);
    
    return cell;
    
}

// 每个cell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return CGSizeMake(W, W * 0.125);
    
}

// 上左下右距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// collectionview 的选中事件
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
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
