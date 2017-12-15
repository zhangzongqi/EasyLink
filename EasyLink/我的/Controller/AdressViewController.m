//
//  AdressViewController.m
//  EasyLink
//
//  Created by 琦琦 on 17/2/9.
//  Copyright © 2017年 fengdian. All rights reserved.
//  收货地址列表

#import "AdressViewController.h"
#import "AddAddressViewController.h" // 添加地址
#import "AdressTableViewCell.h" // 地址cell
#import "XiuGaiAddressViewController.h" // 修改地址

@interface AdressViewController ()<UITableViewDelegate,UITableViewDataSource> {
    
    NSMutableArray *_arrForUserAddressList; // 用户收货地址信息列表
}

@property (nonatomic, copy) UITableView *tableView; // 列表

@property (nonatomic, copy) UIView *bottomView; // 底边栏

@end

@implementation AdressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 返回按钮
    [self createBackBtn];
    
    // 设置导航栏标题
    UILabel *lbItemTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    lbItemTitle.text = @"收货地址";
    lbItemTitle.textColor = [UIColor whiteColor];
    lbItemTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lbItemTitle;
    
    // 背景色
    self.view.backgroundColor = FUIColorFromRGB(0xffffff);
    
    
    // 初始化数组
    [self initDataSource];
    
    // 布局页面
    [self layoutViews];
    
    // 获取数据
    [self initData];
    
    // 底边栏
    [self createBottomView];
}

// 请求数据
- (void) initData {
    
    NSArray *arr = [GetUserJiaMi getUserTokenAndCgAndKey];
    
    NSDictionary *dicData = @{@"tk":arr[0],@"key":arr[1],@"cg":arr[2]};
    
    // 创建请求对象,发起请求
    HttpRequest *http = [[HttpRequest alloc] init];
    [http PostGetUserAllAddressWithDicData:dicData Success:^(id messageData) {
        
        // 保存地址列表信息
        _arrForUserAddressList = messageData;
        
        // 刷新列表
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
        // 网络错误,获取失败
    }];
}

// 初始化数组
- (void) initDataSource {
    
    // 用户收货地址信息列表
    _arrForUserAddressList = [NSMutableArray array];
    
}


// 创建底边栏
- (void) createBottomView {
    
    // 底边视图
    _bottomView = [[UIView alloc] init];
    [self.view addSubview: _bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@(49));
        make.width.equalTo(@(W));
    }];
    _bottomView.backgroundColor = [FUIColorFromRGB(0xf8f8f8) colorWithAlphaComponent:0.9];
    // 添加点击事件
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo)];
    [_bottomView addGestureRecognizer:tapGesture];
    
    // 添加新地址按钮
    UIButton *addAddressBtn = [[UIButton alloc] init];
    [_bottomView addSubview:addAddressBtn];
    [addAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bottomView);
        make.centerY.equalTo(_bottomView);
    }];
    [addAddressBtn setTitle:@"＋ 添加新地址" forState:UIControlStateNormal];
    addAddressBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [addAddressBtn setTitleColor:FUIColorFromRGB(0x212121) forState:UIControlStateNormal];
    [addAddressBtn addTarget:self action:@selector(addAddressbtnClick) forControlEvents:UIControlEventTouchUpInside];
}

// 添加新地址点击事件
- (void) addAddressbtnClick {
    
    [self Actiondo];
}

// 添加新地址点击事件
- (void) Actiondo {
    
    AddAddressViewController *vc = [[AddAddressViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

// 布局页面
- (void) layoutViews {
    
    // 列表创建
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, W, H - 64 - 49) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    // 用于 让多余的分割线不显示
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // 注册列表
    [_tableView registerClass:[AdressTableViewCell class] forCellReuseIdentifier:@"cell"];
    
}

#pragma mark ---------UITableViewDelegate,UITableViewDataSource--------
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _arrForUserAddressList.count;
    
}

// 绑定数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserAddressModel *model = _arrForUserAddressList[indexPath.row];
    
    AdressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.nameLb.text = model.consignee;
    cell.phoneLb.text = model.phone;
    cell.addressLb.text = [NSString stringWithFormat:@"%@%@%@%@%@",model.province,model.city,model.district,model.town,model.address];
    
    return cell;
}
// 返回高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}
// tableview点击事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 反选
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UserAddressModel *model = _arrForUserAddressList[indexPath.row];
    
    if ([self.orderSure isEqualToString:@"选择地址"]) {
        
        // 添加到单例
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:model.last_region_id forKey:@"getStreetId"];
        [user setObject:model.id1 forKey:@"addressId"];
        [user setObject:model.consignee forKey:@"shouhuoName"];
        [user setObject:model.phone forKey:@"shouhuoPhone"];
        [user setObject:[NSString stringWithFormat:@"%@%@%@%@%@",model.province,model.city,model.district,model.town,model.address] forKey:@"shouhuoAddress"];
        
        // 需要告诉前一个页面去刷新收货地址
        // 创建消息中心
        NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
        // 在消息中心发布自己的消息
        [notiCenter postNotificationName:@"reloadAddress" object:@"10"];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else {
        
        
        NSLog(@"%ld",indexPath.row);
        
        XiuGaiAddressViewController *vc = [[XiuGaiAddressViewController alloc] init];
        vc.strId = model.id1;
        vc.nameStr = model.consignee;
        vc.phoneStr = model.phone;
        vc.shengshiquStr = [NSString stringWithFormat:@"%@%@%@",model.province,model.city,model.district];
        vc.jiedaoStr = model.town;
        vc.detailStr = model.address;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//以下是添加删除功能的代码
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UserAddressModel *model = _arrForUserAddressList[indexPath.row];
        
        // 在这里面请求删除地址接口
        // 创建请求对象
        // 发起删除地址请求
        HttpRequest *http = [[HttpRequest alloc] init];
        
        NSArray *arr = [GetUserJiaMi getUserTokenAndCgAndKey];
        
        NSDictionary *dic = @{@"id":model.id1}; // 这里应换成当前行的地址编号
        NSString *strDic = [[MakeJson createJson:dic] AES128EncryptWithKey:arr[3]];
        
        NSDictionary *dicData = @{@"tk":arr[0],@"key":arr[1],@"cg":arr[2],@"data":strDic};
        
        [http PostDeleteAddressWithDicData:dicData Success:^(id messageData) {
            
            if ([messageData isEqualToString:@"1"]) {
                
                // 请求成功
                [_arrForUserAddressList removeObjectAtIndex:indexPath.row];
                // Delete the row from the data source.
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            
        } failure:^(NSError *error) {
            
            // 网络错误,请求失败
        }];
        
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
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

// 监听处理事件
- (void)listen:(NSNotification *)noti {
    
    NSString *strNoti = noti.object;
    
    // 用户在侧栏进行了退出
    if ([strNoti isEqualToString:@"9"]) {
        
        [self initData];
        
        // 销毁侧栏退出的通知
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadAddressList" object:@"9"];
    }
}


- (void) viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    // 设置导航栏背景色(用到了UIImage+GradientColor.h这个类扩展)
    UIColor *topleftColor = FUIColorFromRGB(0x9080ff);
    UIColor *bottomrightColor = FUIColorFromRGB(0x7765ff);
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor, bottomrightColor] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(W, 64)];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:bgImg]];
    
    
    // 接收消息
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    // 侧栏退出
    [notiCenter addObserver:self selector:@selector(listen:) name:@"reloadAddressList" object:@"9"];
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
