//
//  AddAddressViewController.m
//  EasyLink
//
//  Created by 琦琦 on 17/2/9.
//  Copyright © 2017年 fengdian. All rights reserved.
//  修改地址页面

#import "XiuGaiAddressViewController.h"
#import "AddAddressSelectView.h"
#import "ZheZhaoView.h" // 遮罩层
#import "StreetSelectView.h" // 街道选择

@interface XiuGaiAddressViewController () {
    
    // 地址遮罩层
    ZheZhaoView *_dizhiZheZhao;
}

// 地址选择视图
@property (nonatomic, copy) AddAddressSelectView *addressSelectVc;
// 街道选择视图
@property (nonatomic, copy) StreetSelectView *streetSelectVc;



@end

@implementation XiuGaiAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 返回按钮
    [self createBackBtn];
    
    // 设置导航栏标题
    UILabel *lbItemTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    lbItemTitle.text = @"修改收货地址";
    lbItemTitle.textColor = [UIColor whiteColor];
    lbItemTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lbItemTitle;
    
    self.view.backgroundColor = FUIColorFromRGB(0xffffff);
    
    // 布局页面
    [self layoutViews];
    
    // 创建地址选择视图
    [self createAddressSelectView];
}

// 布局页面
- (void) layoutViews {
    
    // 第一个小分类标题距离顶部的距离
    CGFloat FirsrLbTopHeight = H * 0.067;
    // 两个标题之间距离
    CGFloat LbSpace =  H * 0.075;
    // 标题距左侧距离
    CGFloat lbLeftSpace = W * 0.0921875;
    
    // 标题数组
    NSArray *arrForTitle = @[@"收货人",@"联系电话",@"所在地区",@"所在街道",@"详细地址"];
    NSArray *arrForPlaceholder = @[@"请输入收货人姓名",@"请输入联系电话",@"",@"",@"请填写详细地址"];
    NSArray *arrForBtn = @[@"",@"",@"请选择所在地区",@"请选择所在街道",@""];
    
    NSArray *arrForMoment = @[_nameStr,_phoneStr,_shengshiquStr,_jiedaoStr,_detailStr];
    
    
    for (int i = 0; i < 5; i++) {
        // 标题
        UILabel *lbTitle = [[UILabel alloc] init];
        [self.view addSubview:lbTitle];
        [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(FirsrLbTopHeight + LbSpace * i);
            make.left.equalTo(self.view).with.offset(lbLeftSpace);
            make.height.equalTo(@(15));
            make.width.equalTo(@(62));
        }];
        lbTitle.textColor = FUIColorFromRGB(0x212121);
        lbTitle.font = [UIFont systemFontOfSize:15];
        lbTitle.text = arrForTitle[i];
        
        // 分割线
        UILabel *lbFenge = [[UILabel alloc] init];
        [self.view addSubview:lbFenge];
        [lbFenge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lbTitle.mas_bottom).with.offset(0.0176 * H);
            make.left.equalTo(lbTitle);
            make.right.equalTo(self.view).with.offset(- lbLeftSpace);
            make.height.equalTo(@(1));
        }];
        lbFenge.backgroundColor = FUIColorFromRGB(0xd5d5d5);
        
        // 输入框
        if (i == 0 || i == 1 || i == 4) {
            UITextField *tf = [[UITextField alloc] init];
            [self.view addSubview:tf];
            [tf mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(lbFenge.mas_top);
                make.left.equalTo(lbTitle.mas_right).with.offset(0.0421875 * W);
                make.right.equalTo(self.view).with.offset(- lbLeftSpace);
                make.height.equalTo(@(0.0176 * H * 2 + 15));
            }];
            tf.font = [UIFont systemFontOfSize:14];
            tf.placeholder = arrForPlaceholder[i];
            tf.textAlignment = NSTextAlignmentLeft;
            tf.text = arrForMoment[i];
            tf.tag = 1000 + i;
        }
        
        // 选择地区按钮
        if (i == 2 || i == 3) {
            
            UIButton *btnSeletLocation = [[UIButton alloc] init];
            [self.view addSubview:btnSeletLocation];
            [btnSeletLocation mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(lbFenge.mas_top);
                make.left.equalTo(lbTitle.mas_right).with.offset(0.0421875 * W);
                make.right.equalTo(self.view).with.offset(- lbLeftSpace);
                make.height.equalTo(@(0.0176 * H * 2 + 15));
            }];
            
            btnSeletLocation.titleLabel.sd_layout
            .leftEqualToView(btnSeletLocation)
            .bottomEqualToView(btnSeletLocation)
            .heightRatioToView(btnSeletLocation,1)
            .widthIs((W - W *0.0921875*2) - 16);
            
            btnSeletLocation.imageView.sd_layout
            .rightEqualToView(btnSeletLocation)
            .centerYEqualToView(btnSeletLocation)
            .widthIs(9.15)
            .heightIs(16);
            
            [btnSeletLocation setImage:[UIImage imageNamed:@"绑定银行卡_点击选择"] forState:UIControlStateNormal];
            [btnSeletLocation setTitle:arrForBtn[i] forState:UIControlStateNormal];
            [btnSeletLocation setTitleColor:FUIColorFromRGB(0x212121) forState:UIControlStateNormal];
            btnSeletLocation.titleLabel.font = [UIFont systemFontOfSize:14];
            [btnSeletLocation addTarget:self action:@selector(SelectbtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btnSeletLocation setTitle:arrForMoment[i] forState:UIControlStateNormal];
            btnSeletLocation.tag = 664 + i;
        }
        
        // 保存按钮
        if (i == 4) {
            
            UIButton *saveBtn = [[UIButton alloc] init];
            [self.view addSubview:saveBtn];
            [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lbFenge.mas_bottom).with.offset(0.053 * H);
                make.centerX.equalTo(self.view);
                make.height.equalTo(@(H * 0.05));
                make.width.equalTo(@(0.65625 * W));
            }];
            
            [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
            saveBtn.layer.cornerRadius = 0.025 * H;
            saveBtn.backgroundColor = FUIColorFromRGB(0x8979ff);
            saveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            saveBtn.titleLabel.textColor = FUIColorFromRGB(0xffffff);
            [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
}

// 保存按钮点击事件
- (void) saveBtnClick:(UIButton *)saveBtn {
    
    // 输入框
    UITextField *tf0 = [self.view viewWithTag:1000];
    UITextField *tf1 = [self.view viewWithTag:1001];
    UIButton *btn = [self.view viewWithTag:666];
    UIButton *btn2 = [self.view viewWithTag:667];
    UITextField *tf4 = [self.view viewWithTag:1004];
    
    HttpRequest *http = [[HttpRequest alloc] init];
    
    if (tf0.text == nil) {
        
        [http GetHttpDefeatAlert:@"请填写正确的收货人姓名"];
        
    }else if (tf1.text == nil) {
        
        [http GetHttpDefeatAlert:@"请先输入手机号"];
        
    }else if ([btn.titleLabel.text isEqualToString:@"请选择所在地区"]) {
        
        [http GetHttpDefeatAlert:@"请先选择所在地区"];
        
    }else if ([btn2.titleLabel.text isEqualToString:@"请选择所在街道"]) {
        
        [http GetHttpDefeatAlert:@"请先选择所在街道"];
        
    }else if (tf4.text == nil) {
        
        [http GetHttpDefeatAlert:@"请先填写详细地址"];
        
    }else {

        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *strProvince = [user objectForKey:@"province"];
        NSString *strCity = [user objectForKey:@"city"];
        NSString *strDistrict = [user objectForKey:@"district"];
        NSString *strTown = [user objectForKey:@"town"];
        NSString *strLastId = [user objectForKey:@"last_region_id"];
        
        NSArray *arr = [GetUserJiaMi getUserTokenAndCgAndKey];
        
        NSDictionary *dic = @{@"id":_strId,@"consignee":tf0.text,@"phone":tf1.text,@"province":strProvince,@"city":strCity,@"district":strDistrict,@"town":strTown,@"last_region_id":strLastId,@"address":tf4.text};
        NSString *strDic = [[MakeJson createJson:dic] AES128EncryptWithKey:arr[3]];
        
        NSDictionary *dicData = @{@"tk":arr[0],@"key":arr[1],@"cg":arr[2],@"data":strDic};
        
        // 请求数据，添加地址
        [http PostXiugaiAddressWithDataDic:dicData Success:^(id messageData) {
            
            if ([messageData isEqualToString:@"1"]) {
                
                // 需要告诉前一个页面去刷新收货地址
                // 创建消息中心
                NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
                // 在消息中心发布自己的消息，去刷新收货地址列表
                [notiCenter postNotificationName:@"reloadAddressList" object:@"9"];
                
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } failure:^(NSError *error) {
            
            // 网络错误,请求失败
        }];
        
    }
    
}

// 创建地址选择视图
- (void) createAddressSelectView {
    
    UIButton *btn = [self.view viewWithTag:666];
    UIButton *btn2 = [self.view viewWithTag:667];
    
    // 地址遮罩层
    _dizhiZheZhao = [[ZheZhaoView alloc] initWithFrame:CGRectMake(0, 0, W, H - 64)];
    [self.view addSubview:_dizhiZheZhao];
    _dizhiZheZhao.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dizhiZhezhaoClick)];
    [_dizhiZheZhao addGestureRecognizer:tap];
    
    // 地址选择视图
    _addressSelectVc = [[AddAddressSelectView alloc] initWithFrame:CGRectMake(0, H, W, W * 25/32)];
    [self.view addSubview:_addressSelectVc];
    [_addressSelectVc.closeBtn addTarget:self action:@selector(AddressSelectClose) forControlEvents:UIControlEventTouchUpInside];
    // 关闭
    __weak typeof (self) weakSelf = self;
    _addressSelectVc.chooseFinish = ^{
        [UIView animateWithDuration:0.25 animations:^{
            [btn setTitle:weakSelf.addressSelectVc.address forState:UIControlStateNormal];
            [btn setTitleColor:FUIColorFromRGB(0x212121) forState:UIControlStateNormal];
            [weakSelf AddressSelectClose];
            
            
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSLog(@"getStreetId:%@",[user objectForKey:@"getStreetId"]);
            // 选完了地区后，再创建街道选择视图
            // 街道选择视图
            _streetSelectVc = [[StreetSelectView alloc] initWithFrame:CGRectMake(0, H, W, W * 25/32)];
            [self.view addSubview:_streetSelectVc];
            [_streetSelectVc.closeBtn addTarget:self action:@selector(AddressSelectClose) forControlEvents:UIControlEventTouchUpInside];
            // 关闭
            __weak typeof (self) weakSelf1 = self;
            _streetSelectVc.chooseFinish = ^{
                [UIView animateWithDuration:0.25 animations:^{
                    [btn2 setTitle:weakSelf1.streetSelectVc.address forState:UIControlStateNormal];
                    [btn2 setTitleColor:FUIColorFromRGB(0x212121) forState:UIControlStateNormal];
                    [weakSelf1 AddressSelectClose];
                }];
            };
            
            
        }];
    };
}

// 地址选择视图关闭按钮的点击
- (void) AddressSelectClose {
    
    [self dizhiZhezhaoClick];
}

// 地址遮罩层点击事件
- (void) dizhiZhezhaoClick {
    
    // 城市
    [UIView animateWithDuration:0.25f animations:^{
        
        _addressSelectVc.frame = CGRectMake(0, H, W, W * 25/32);
        
    } completion:^(BOOL finished) {
        
        _dizhiZheZhao.hidden = YES;
    }];
    
    // 街道
    [UIView animateWithDuration:0.25f animations:^{
        
        _streetSelectVc.frame = CGRectMake(0, H, W, W * 25/32);
        
    } completion:^(BOOL finished) {
        
        _dizhiZheZhao.hidden = YES;
    }];
}

// 选择城市点击事件
- (void) SelectbtnClick:(UIButton *)btnSeletLocation {
    
    if (btnSeletLocation.tag == 666) {
        
        [UIView animateWithDuration:0.25f animations:^{
            
            _dizhiZheZhao.hidden = NO;
            
            _addressSelectVc.frame = CGRectMake(0, H - W * 25/32, W, W * 25/32);
            
        } completion:^(BOOL finished) {
            
            
        }];
        
    }else {
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        
        if ([user objectForKey:@"getStreetId"] == nil) {
            
            alert(@"请先选择所在地区");
            
        }else {
            
            [UIView animateWithDuration:0.25f animations:^{
                
                _dizhiZheZhao.hidden = NO;
                
                _streetSelectVc.frame = CGRectMake(0, H - W * 25/32, W, W * 25/32);
                
            } completion:^(BOOL finished) {
                
                
            }];
            
        }
    }
}








// 触发事件
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 释放第一响应者
    for (int i = 0; i < 5; i++) {
        UITextField *tf1 = [self.view viewWithTag:1000 + i];
        [tf1 resignFirstResponder];
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

// 视图已经消失
- (void) viewDidDisappear:(BOOL)animated {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"getStreetId"];
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
