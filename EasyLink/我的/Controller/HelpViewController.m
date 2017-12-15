//
//  HelpViewController.m
//  EasyLink
//  帮助
//  Created by 琦琦 on 16/10/25.
//  Copyright © 2016年 fengdian. All rights reserved.
//

#import "HelpViewController.h"
#import "HelpCollectionViewCell.h"
#import "HelpDetailViewController.h" // 帮助详情页

@interface HelpViewController ()<UICollectionViewDelegate, UICollectionViewDataSource> {
    
    NSArray *_helpListArr; // 帮助数组
}

@property (nonatomic, strong) UICollectionView *collectionView;


@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 返回按钮
    [self createBackBtn];
    
    // 设置导航栏标题
    UILabel *lbItemTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    lbItemTitle.text = @"软件帮助";
    lbItemTitle.textColor = [UIColor whiteColor];
    lbItemTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lbItemTitle;
    
    // 初始化数组
    [self initDataSource];
    
    // 布局页面
    [self layoutViews];
    
    // 获取数据
    [self initData];
}

// 初始化数组
- (void) initDataSource {
    
    // 帮助列表数组
    _helpListArr = [NSArray array];
}


// 获取数据
- (void)initData {
    
    // 创建请求对象
    HttpRequest *http = [[HttpRequest alloc] init];
    // 发起请求
    [http GetHelpListSuccess:^(id helpList) {
        
        _helpListArr = helpList;
        
        // 刷新列表
        [_collectionView reloadData];
        
    } failure:^(NSError *error) {
        
        // 网络错误,请求失败
    }];
}

// 布局页面
- (void) layoutViews {
    
    // 先给表格创建它的布局对象
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    // 设置间距为0
    flow.minimumInteritemSpacing = 0;
    flow.minimumLineSpacing = 1;
    
    // 设置该布局的滚动方向
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // 新建_collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, W, H - 64) collectionViewLayout:flow];
    
    // 背景色
    _collectionView.backgroundColor = FUIColorFromRGB(0xeeeeee);
    
    // 设置滚动条隐藏
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    // 代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView registerClass:[HelpCollectionViewCell class] forCellWithReuseIdentifier:@"collection"];
    
    //设置tableview多选
    _collectionView.allowsMultipleSelection = YES;
    
    // 添加到当前页面
    [self.view addSubview:_collectionView];
}


#pragma mark -------UICollectionViewDelegate/UICollectionViewDataSource
// 每个分区的cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    // 返回的个数
    return _helpListArr.count;
}

// 绑定数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HelpCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collection" forIndexPath:indexPath];
    
    cell.titleLb.text = [_helpListArr[indexPath.row] objectForKey:@"title"];
    
    cell.detailLb.text = [_helpListArr[indexPath.row] objectForKey:@"summary"];
    
    return cell;
}

// 每个cell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    // 计算评价Lb的位置
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, W - (W * 0.1859375), 0)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12];
    label.numberOfLines = 0;//这个属性 一定要设置为0   0表示自动换行   默认是1 不换行
    label.textAlignment = NSTextAlignmentLeft;
    NSString *str = [_helpListArr[indexPath.row] objectForKey:@"summary"];
    //第一种方式
    CGSize size = [str sizeWithFont:label.font constrainedToSize: CGSizeMake(label.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat heigeht = size.height + 0.034375 * W  + 0.046875 * W + 15;
    
    
    
    return CGSizeMake(W, heigeht);
}

// 上左下右距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// collectionview点击事件
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 跳转到对应的详情
    HelpDetailViewController *vc = [[HelpDetailViewController alloc] init];
    vc.strId = [_helpListArr[indexPath.row] objectForKey:@"id"];
    [self.navigationController pushViewController:vc animated:YES];
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

// 页面将要加载
- (void) viewWillAppear:(BOOL)animated {
    
    // 设置导航栏背景色(用到了UIImage+GradientColor.h这个类扩展)
    UIColor *topleftColor = FUIColorFromRGB(0x9080ff);
    UIColor *bottomrightColor = FUIColorFromRGB(0x7765ff);
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor, bottomrightColor] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(W, 64)];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:bgImg]];
    
    self.navigationController.navigationBar.hidden = NO;
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
