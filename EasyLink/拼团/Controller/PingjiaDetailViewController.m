//
//  PingjiaDetailViewController.m
//  EasyLink
//
//  Created by 琦琦 on 17/3/7.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "PingjiaDetailViewController.h"
#import "AllPingJiaTableViewCell.h" // 所有评价tableView的Cell

@interface PingjiaDetailViewController ()<UITableViewDelegate,UITableViewDataSource> {
    
    NSMutableArray *_arrForPingjiaLb;
    
    NSArray *_arrForTupian;
    
    NSArray *_starArr;  // 星星数组
    
    NSInteger pageStart; // 页数
    NSMutableArray *_tableViewArr; // 列表的数据
}

@property (nonatomic, copy) UITableView *tableView; // 列表

@property (nonatomic, copy) MBProgressHUD *HUD; // 动画

@end

@implementation PingjiaDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    pageStart = 0; // 初始化页数
    
    
    self.view.backgroundColor = FUIColorFromRGB(0xffffff);
    
    // 设置导航栏标题
    UILabel *lbItemTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    lbItemTitle.text = @"评价";
    lbItemTitle.textColor = FUIColorFromRGB(0x212121);
    lbItemTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lbItemTitle;
    
    // 返回按钮
    [self createBackBtn];
    
    // 初始化数组
    [self initDataSource];
    
    // 创建加载动画
    [self createLoading];
    
    // 获取数据
    [self initData];
    
    // 布局UI
    [self createUI];
}

// 初始化数组
- (void) initDataSource {
    
    _tableViewArr = [NSMutableArray array];
    
    _arrForPingjiaLb = [NSMutableArray array];
    
    _arrForTupian = [NSMutableArray array];
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
    
    pageStart = _tableViewArr.count;
    
    // 动画
    [self createLoadingForBtnClick];
    
    // 请求数据
    [self initData];
}


// 获取数据
- (void) initData {
    
    
    // 创建网络请求对象
    HttpRequest *http = [[HttpRequest alloc] init];
    
    // 第0页
    if (pageStart == 0) {
        
        [http GetPingjiaDataFromId:[self.goodsId integerValue] andpageStart:pageStart Success:^(id arrForList) {
            
            if ([arrForList isKindOfClass:[NSString class]]) {
                
                // 获取数据失败
                
                // 删除所有数据
                [_tableViewArr removeAllObjects];
                // 刷新列表
                [_tableView reloadData];
                
                // 让动画消失
                [_HUD hide:YES];
                
                // 表格刷新完毕,结束上下刷新视图
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];
                
            }else {
                
                // 获取数据成功
                [_tableViewArr removeAllObjects];
                
                _tableViewArr = arrForList;
                
//                NSLog(@"_CollectionViewArr:%@",_tableViewArr);
                
                // 让动画消失
                [_HUD hide:YES];
                
                // 刷新列表
                [_tableView reloadData];
                
                // 表格刷新完毕,结束上下刷新视图
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];
            }
            
        } failure:^(NSError *error) {
            
            NSLog(@"解析失败");
            
            [_HUD hide:YES];
            
            // 表格刷新完毕,结束上下刷新视图
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
        }];
    }else {
        
        [http GetPingjiaDataFromId:[self.goodsId integerValue] andpageStart:pageStart Success:^(id arrForList) {
            
            if ([arrForList isKindOfClass:[NSString class]]) {
                
                // 获取数据失败
                
                
                // 刷新列表
                [_tableView reloadData];
                
                // 让动画消失
                [_HUD hide:YES];
                
                // 表格刷新完毕,结束上下刷新视图
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];
                
            }else {
                
                [_tableViewArr addObjectsFromArray:arrForList];
                
                // 让动画消失
                [_HUD hide:YES];
                
                [_tableView reloadData];
                
                // 表格刷新完毕,结束上下刷新视图
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];
            }
            
        } failure:^(NSError *error) {
            
            NSLog(@"解析失败");
            
            [_HUD hide:YES];
            
            // 表格刷新完毕,结束上下刷新视图
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
        }];
    }
    
    
    
    
    _arrForPingjiaLb = [NSMutableArray arrayWithArray:@[@"打算发送到发送到发大水发大水发大水发撒的归纳数据库跟你讲阿克苏入围区人情味",@"打算发送到发送到发大水发大水发大水发撒的归纳数据库跟你讲阿克苏入围区人情味打算发送到发送到发大水发大水发大水发撒的归纳数据库跟你讲阿克苏入围区人情味",@"打算发送到发送到发大水发大水发大水发撒的归纳数据库跟你讲阿克苏入围区人情味",@"打算发送到发送到发大水发大水发大水发撒的归纳数据库跟你讲阿克苏入围区人情味打算发送到发送到发大水发大水发大水发撒的归纳数据库跟你讲阿克苏入围区人情味打算发送到发送到发大水发大水发大水发撒的归纳数据库跟你讲阿克苏入围区人情味",@"打算发送到发送到发大水发大水发大水发撒的归纳数据库跟你讲阿克苏入围区人情味",@"打算发送到发送到发大水发大水发大水发撒的归纳数据库跟你讲阿克苏入围区人情味打算发送到发送到发大水发大水发大水发撒的归纳数据库跟你讲阿克苏入围区人情味打算发送到发送到发大水发大水发大水发撒的归纳数据库跟你讲阿克苏入围区人情味打算发送到发送到发大水发大水发大水发撒的归纳数据库跟你讲阿克苏入围区人情味打算发送到发送到发大水发大水发大水发撒的归纳数据库跟你讲阿克苏入围区人情味打算发送到发送到发大水发大水发大水发撒的归纳数据库跟你讲阿克苏入围区人情味打算发送到发送到发大水发大水发大水发撒的归纳数据库跟你讲阿克苏入围区人情味打算发送到发送到发大水发大水发大水发撒的归纳数据库跟你讲阿克苏入围区人情味打算发送到发送到发大水发大水发大水发撒的归纳数据库跟你讲阿克苏入围区人情味打算发送到发送到发大水发大水发大水发撒的归纳数据库跟你讲阿克苏入围区人情味"]];
    
    _arrForTupian = @[@[@"1",@"2",@"3",@"4",@"5",@"6",@"1",@"2",@"3",@"5",@"6"],@[],@[@"5",@"2"],@[@"5",@"7",@"3",@"4",@"5"],@[],@[@"8"]];
    
    _starArr = @[@"1",@"5",@"3",@"4",@"5",@"5"];
}

// 布局UI
- (void) createUI {
    
    // 导航栏下面的黑线
    UILabel *navBarShadow = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, W, 1)];
    navBarShadow.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:239/255.0 alpha:1.0];
    [self.view addSubview:navBarShadow];
    
    
    // 列表创建
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, W, H - 65) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    // 用于 让多余的分割线不显示
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // 注册列表
    [_tableView registerClass:[AllPingJiaTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
    // 继续配置_tableView;
    // 创建一个下拉刷新的头
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 调用下拉刷新方法
        [self downRefresh];
    }];
    
    header.stateLabel.hidden = YES;
    
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 设置_tableView的顶头
    _tableView.mj_header = header;
    
    // 设置_tableView的底部
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 调用上拉刷新方法
        [self upRefresh];
    }];
}



#pragma mark ---------UITableViewDelegate,UITableViewDataSource--------
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _tableViewArr.count;
}

// 绑定数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PingJiaModel *model = _tableViewArr[indexPath.row];
    
    AllPingJiaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // 评价
    [cell giveArrForTupian:model.img_show];

    [cell.touxiangImgView sd_setImageWithURL:[NSURL URLWithString:model.user_icon] placeholderImage:[UIImage imageNamed:@"账户管理_默认头像"]];
    cell.nicknameLb.text = model.user_nickname;
    
    // 时间戳转换成时间
    int dt = [model.create_time intValue];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:dt];
    HttpRequest *stringForDate = [[HttpRequest alloc] init];
    NSString *strDate = [stringForDate stringFromDate:confromTimesp];
    NSString *str = [[strDate componentsSeparatedByString:@" "] objectAtIndex:0];
    cell.dateLb.text = str;

    // 评价label
    cell.pingjiaLb.text = model.summary;

    cell.bar.starNumber = [model.star integerValue];
    cell.bar.userInteractionEnabled = NO;
    
    cell.backgroundColor = FUIColorFromRGB(0xffffff);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


// 返回高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PingJiaModel *model = _tableViewArr[indexPath.row];
    
    // 计算评价Lb的位置
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, W - (W * 0.1859375), 0)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12];
    label.numberOfLines = 0;//这个属性 一定要设置为0   0表示自动换行   默认是1 不换行
    label.textAlignment = NSTextAlignmentLeft;
    NSString *str = model.summary;
    //第一种方式
    CGSize size = [str sizeWithFont:label.font constrainedToSize: CGSizeMake(label.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];

    CGFloat heigeht = size.height + 0.034375 * W  + 0.046875 * W + 15;

//    NSLog( @"=============%f",heigeht);

    if (model.img_show.count == 0) {

        return heigeht + 0.034375 * W;

    }else {

        return heigeht + W * 0.26875;
    }
}
// tableview点击事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"%ld",indexPath.row);
}


// 返回按钮
- (void) createBackBtn {
    
    // 返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(20, 0, 10.4, 18.4);
    
    [backBtn setImage:[UIImage imageNamed:@"details_return"] forState:UIControlStateNormal];
    
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

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleDefault;
}

// 返回按钮点击事件
- (void) doBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 页面将要消失
- (void) viewWillDisappear:(BOOL)animated {
    
    // 打开手势返回
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

// 页面将要显示
- (void) viewWillAppear:(BOOL)animated {
    
    // 关闭手势返回
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    //相对于上面的接口，这个接口可以动画的改变statusBar的前景色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
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
