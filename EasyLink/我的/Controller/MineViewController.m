//
//  MineViewController.m
//  EasyLink
//
//  Created by 琦琦 on 16/9/12.
//  Copyright © 2016年 fengdian. All rights reserved.
//

#import "MineViewController.h"
#import "FocusFootAddressView.h" // 关注/足记/收货地址/购物券视图
#import "GoodsStatusView.h" // 订单状态视图
#import "SpellgroupCollectionViewCell.h" // collectionview开团状态下的Cell
#import "WaitCollectionViewCell.h" // collectionview未团状态下的Cell
#import "GroupDetailViewController.h" // 详情页面
#import "MZTimerLabel.h"
#import "WMMineOrderViewController.h" // 我的订单详情页
#import "AdressViewController.h" // 收货地址
#import "MineFocusOnViewController.h" // 我的关注
#import "AccountManageViewController.h" // 账户管理页面
#import "FootmarkViewController.h" // 足迹

#import "LoginViewController.h" // 登录页面
#import "HttpRequest.h" // 网络请求
#import "LeftSortsViewController.h" // 左侧栏
#import "GouWuQuanViewController.h" // 购物券


@interface MineViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,MZTimerLabelDelegate> {
    
    NSMutableArray *_goodsImageArr; // 商品图片数组
    NSMutableArray *_titleLabelArr; //标题数组
    NSMutableArray *_timestamp; // 时间戳数组
    NSMutableArray *_priceArr; // 价格数组
    
    NSMutableArray *_CollectionViewArr; // 列表数组
}

@property (nonatomic, strong) UIScrollView *bigScrollView; // 底层滚动视图
@property (nonatomic, strong) UIImageView *touxiangImgView; // 头像
@property (nonatomic, strong) UILabel *nickNameLabel; // 昵称
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) GoodsStatusView *goodsStatusView; // 待付款/待成团/待发货/待收货/待评价

@property (nonatomic, strong) FocusFootAddressView *mineView; // 关注/足记/收货地址/购物券视图

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 导航栏已经在LeftSortsViewController类中隐藏
    
    self.view.backgroundColor = FUIColorFromRGB(0xffffff);
    
    
    // 初始化数据
    [self initDataSource];
    
    // 创建UI
    [self createUI];
    
    
    
    
    // 获取数据
    [self initData];
    
    
    // 获取用户资料数据
    [self initDataWithUserInfo];
}

// 初始化数据
- (void) initDataSource {
    
    _CollectionViewArr = [NSMutableArray array];
}

// 获取用户资料数据
- (void) initDataWithUserInfo {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *strTk = [user objectForKey:@"token"];
    
    if (strTk == nil) {
        
        
    }else {
        
        // 获取到用户RSAKey
        NSString *userRsaPublicKey = [user objectForKey:@"severPublicKey"];
        
        
        // 生成一个16位的AES的key,并保存用于解密服务器返回的信息
        NSString *strAESkey = [NSString set32bitString:16];
        [user setObject:strAESkey forKey:@"aesKey"];
        // 最终加密好的key参数的密文
        NSString *keyMiWenStr = [RSAEncryptor encryptString:strAESkey publicKey:userRsaPublicKey];
        NSLog(@"keyMiWenStr:%@",keyMiWenStr);
        
        
        // 获取当前时间戳，转换成json类型，并用AES进行加密,并做了base64及urlcode转码处理
        NSDate *senddate = [NSDate date];
        NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
        NSDictionary *cgDic = @{@"requestTime":date2};
        // 最终加密好的cg参数的密文
        NSString *cgMiWenStr = [[MakeJson createJson:cgDic] AES128EncryptWithKey:strAESkey];
        
        NSLog(@"cgMiWenStr:%@",cgMiWenStr);
        
        // 用户token
        NSString *userToken = [user objectForKey:@"token"];
        NSLog(@"userToken%@",userToken);
        
        
        NSDictionary *dicForData = @{@"tk":userToken,@"key":keyMiWenStr,@"cg":cgMiWenStr};
        
        HttpRequest *http = [[HttpRequest alloc] init];
        [http PostUserInfoWithDic:dicForData Success:^(id userInfo) {
            
            
            NSDictionary *dicForUserInfo = [MakeJson createDictionaryWithJsonString:userInfo];
            
            // 将用户资料保存本地
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:dicForUserInfo forKey:@"userInfo"];
            // 创建消息中心
            NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
            // 在消息中心发布自己的消息,用于修改侧栏数据
            [notiCenter postNotificationName:@"MakeLeftUserInfo" object:@"5"];
            
            
            // 修改昵称
            _nickNameLabel.text = [NSString stringWithFormat:@"%@",[dicForUserInfo objectForKey:@"nickname"]];
            
            // 修改头像
            [_touxiangImgView sd_setImageWithURL:[NSURL URLWithString:[dicForUserInfo objectForKey:@"icon"]] placeholderImage:[UIImage imageNamed:@"账户管理_默认头像"]];
            
        } failure:^(NSError *error) {
            
            // 请求失败
        }];
        
    }
}


// 获取数据
- (void) initData {
    
//    // 商品图片数组
//    _goodsImageArr = [NSMutableArray arrayWithArray:@[@"category_list_img6",@"category_list_img5",@"category_list_img4",@"category_list_img3",@"category_list_img2",@"category_list_img1"]];
//    // 标题数组
//    _titleLabelArr = [NSMutableArray arrayWithArray:@[@"[三只松鼠_碧根果210gx2袋]零食坚果山核桃长寿果干果奶油味",@"滋润养生、打造滋润的蜜光肌",@"原创设计、找到属于你的那一款",@"腔调好货、随时变幻不一样的魅力",@"滋润养生、打造滋润的蜜光肌",@"原创设计、找到属于你的那一款"]];
//    // 时间戳数组
//    _timestamp =[NSMutableArray arrayWithArray:@[@"1488174920",@"1488358800",@"1488358800",@"1487998250",@"1488072170",@"1488082570"]];
//    // 价格数组
//    _priceArr = [NSMutableArray arrayWithArray:@[@"39.9",@"168.88",@"9.99",@"310.30",@"299.90",@"998.00"]];
    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user objectForKey:@"token"] == nil) {
        
        // 用户未登录
        
        HttpRequest *http = [[HttpRequest alloc] init];
        // 进行数据请求
        [http GetHomeDataForCategory:0 andKeyWord:@"" andOrderKey:0 andOrderBy:0 andPageStart:0 andPageSize:10 Success:^(id arrForList) {
            
            
            if ([arrForList isKindOfClass:[NSString class]]) {
                
                // 获取数据失败
                
                // 删除所有数据
                [_CollectionViewArr removeAllObjects];
                // 刷新列表
                [_collectionView reloadData];
                
            }else {
                
                // 获取数据成功
                [_CollectionViewArr removeAllObjects];
                
                _CollectionViewArr = arrForList;
                
                NSLog(@"_CollectionViewArr:%@",_CollectionViewArr);
                
                // 刷新列表
                [_collectionView reloadData];
                
            }
            
        } failure:^(NSError *error) {
            
            NSLog(@"解析失败");
        }];
        
    }else {
        
        // 获取到用户加密等字典
        NSArray *arr = [GetUserJiaMi getUserTokenAndCgAndKey];
        NSDictionary *dicData = @{@"tk":arr[0],@"key":arr[1],@"cg":arr[2]};
        
        HttpRequest *http = [[HttpRequest alloc] init];
        [http PostGetRecommendedListWithDic:dicData Success:^(id RecommendedListDic) {
            
            // 获取到用户加密字典
            
            if ([RecommendedListDic isKindOfClass:[NSMutableArray class]]) {
                
                [_CollectionViewArr removeAllObjects];
                
                _CollectionViewArr = RecommendedListDic;
                
                [_collectionView reloadData];
                
            }else {
                
                // 删除所有数据
                [_CollectionViewArr removeAllObjects];
                // 刷新列表
                [_collectionView reloadData];
            }
            
            
        } failure:^(NSError *error) {
            
            // 请求失败，网络错误
        }];
    }
    
}

// 创建UI
- (void) createUI {
    
//    640*520
    
    // 底层滚动视图
    _bigScrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_bigScrollView];
    [_bigScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.height.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        
    }];
    _bigScrollView.backgroundColor = FUIColorFromRGB(0x444444);
//    _bigScrollView.showsVerticalScrollIndicator = NO;//竖向滚动条
    _bigScrollView.showsHorizontalScrollIndicator = NO; // 横向滚动条
    _bigScrollView.backgroundColor = FUIColorFromRGB(0xeeeeee);
    _bigScrollView.contentSize = CGSizeMake(W, H * 2);
    _bigScrollView.delegate = self;
    
    // 趣味label
//    UILabel *lb = [[UILabel alloc] init];
//    [_bigScrollView addSubview:lb];
//    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).with.offset(50);
//        make.left.equalTo(self.view);
//        make.width.equalTo(self.view);
//        make.height.equalTo(@(20));
//    }];
//    lb.font = [UIFont systemFontOfSize:14];
//    lb.textColor = FUIColorFromRGB(0x999999);
//    lb.text = @"下面什么也没有😂";
//    lb.textAlignment = NSTextAlignmentCenter;
    
    // 趣味label2
//    UILabel *lb2 = [[UILabel alloc] init];
//    [_bigScrollView addSubview:lb2];
//    [lb2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.view);
//        make.left.equalTo(self.view);
//        make.width.equalTo(self.view);
//        make.height.equalTo(@(20));
//    }];
//    lb2.font = [UIFont systemFontOfSize:14];
//    lb2.textColor = FUIColorFromRGB(0x999999);
//    lb2.text = @"你真够无聊的😝";
//    lb2.textAlignment = NSTextAlignmentCenter;
    
    
    // 顶部个人中心背景
    UIImageView *topImgView = [[UIImageView alloc] init];
    [_bigScrollView addSubview:topImgView];
    [topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bigScrollView).with.offset(- 20);
        make.left.equalTo(self.view);
        make.width.equalTo(@(W));
        make.height.equalTo(@(W * 0.78125));
    }];
    topImgView.image = [UIImage imageNamed:@"个人中心_无数据"];
    topImgView.userInteractionEnabled = YES;
    topImgView.tag = 9999;
    
    // 我的订单
    UIButton *MineDingDanbtn = [[UIButton alloc] init];
    [topImgView addSubview:MineDingDanbtn];
    [MineDingDanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgView).with.offset(30);
        make.left.equalTo(topImgView);
        make.width.equalTo(@(11.5 + 4 + 58 + 0.0375 * W));
        make.height.equalTo(@(W * 0.8125 * 0.05 + 0.034375 * W));
    }];
    MineDingDanbtn.imageView.sd_layout
    .leftSpaceToView(MineDingDanbtn, 0.0375 * W)
    .centerYEqualToView(MineDingDanbtn)
    .heightIs(15)
    .widthIs(11.42857);
    MineDingDanbtn.titleLabel.sd_layout
    .leftSpaceToView(MineDingDanbtn.imageView, 4)
    .centerYEqualToView(MineDingDanbtn)
    .heightIs(13)
    .widthIs(58);
    MineDingDanbtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [MineDingDanbtn setImage:[UIImage imageNamed:@"personal_icon1"] forState:UIControlStateNormal];
    [MineDingDanbtn setTitle:@"我的订单" forState:UIControlStateNormal];
    [MineDingDanbtn setTitleColor:FUIColorFromRGB(0xf4f3ff) forState:UIControlStateNormal];
    // 我的订单点击事件
    [MineDingDanbtn addTarget:self action:@selector(MineDingDanClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 编辑按钮
    UIButton *bianjiBtn = [[UIButton alloc] init];
    [topImgView addSubview:bianjiBtn];
    [bianjiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgView).with.offset(30);
        make.right.equalTo(topImgView);
        make.width.equalTo(@(11.5 + 4 + 27 + 0.0375 * W));
        make.height.equalTo(@(W * 0.8125 * 0.05 + 0.034375 * W));
    }];
    bianjiBtn.titleLabel.sd_layout
    .centerYEqualToView(bianjiBtn)
    .rightSpaceToView(bianjiBtn, 0.0375 * W)
    .widthIs(27)
    .heightIs(13);
    bianjiBtn.imageView.sd_layout
    .rightSpaceToView(bianjiBtn.titleLabel,4)
    .centerYEqualToView(bianjiBtn)
    .heightIs(16)
    .widthIs(14.608);
    [bianjiBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [bianjiBtn setTitleColor:FUIColorFromRGB(0xf4f3ff) forState:UIControlStateNormal];
    bianjiBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [bianjiBtn setImage:[UIImage imageNamed:@"personal_icon2"] forState:UIControlStateNormal];
    // 编辑点击事件
    [bianjiBtn addTarget:self action:@selector(BinajiClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 头像
    _touxiangImgView = [[UIImageView alloc] init];
    [_bigScrollView addSubview:_touxiangImgView];
    [_touxiangImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topImgView);
        make.top.equalTo(topImgView).with.offset(0.17 * W * 0.8125 + 20);
        make.width.equalTo(@(W * 0.21875));
        make.height.equalTo(@(W * 0.21875));
    }];
    _touxiangImgView.layer.cornerRadius = W * 0.21875/2;
    _touxiangImgView.clipsToBounds = YES;
    _touxiangImgView.image = [UIImage imageNamed:@"账户管理_默认头像"];
    _touxiangImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touxiangClick)];
    [_touxiangImgView addGestureRecognizer:tap];
    
    // 昵称
    _nickNameLabel = [[UILabel alloc] init];
    [_bigScrollView addSubview:_nickNameLabel];
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_touxiangImgView.mas_bottom).with.offset(0.061538 * W * 0.8125);
        make.centerX.equalTo(_touxiangImgView);
        make.height.equalTo(@(15));
    }];
    _nickNameLabel.font = [UIFont systemFontOfSize:15];
    _nickNameLabel.textColor = FUIColorFromRGB(0xf4f3ff);
    _nickNameLabel.text = @"请点击头像登录";
    
    
    
    // 图片、文字数组
    NSArray *ImgArr1 = @[@"personal_icon3",@"personal_icon4",@"personal_icon5",@"personal_icon6",@"personal_icon7"];
    NSArray *titleArr1 = @[@"待付款",@"待成团",@"待发货",@"待收货",@"待评价"];
    // 待付款/待成团/待发货/待收货/待评价
    _goodsStatusView = [[GoodsStatusView alloc] initWithFrame:CGRectMake(0, 0, W, W * 0.125) andImgArr:ImgArr1 andTitleArr:titleArr1];
    [topImgView addSubview:_goodsStatusView];
    [_goodsStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(topImgView).with.offset(- W * 0.8125 * 0.072);
        make.left.equalTo(topImgView);
        make.width.equalTo(@(W));
        make.height.equalTo(@(W * 0.125));
    }];
    // 添加点击事件
    for (UIButton *btn in _goodsStatusView.subviews) {
        
        [btn addTarget:self action:@selector(mineViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    // 图片、文字数组
    NSArray *ImgArr = @[@"personal_icon8",@"personal_icon9",@"personal_icon10",@"personal_icon11"];
    NSArray *titleArr = @[@"购物券",@"我的关注",@"我的足迹",@"收货地址"];
    // 关注/足记/收货地址/购物券视图
    _mineView = [[FocusFootAddressView alloc] initWithFrame:CGRectMake(0, 0, W, 0.25 * W) andImgArr:ImgArr andTitleArr:titleArr];
    [_bigScrollView addSubview:_mineView];
    [_mineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgView.mas_bottom);
        make.left.equalTo(self.view);
        make.height.equalTo(@(W * 0.25));
        make.width.equalTo(@(W));
    }];
    _mineView.backgroundColor = FUIColorFromRGB(0xffffff);
    // 添加点击事件
    for (UIButton *btn in _mineView.subviews) {
        
        [btn addTarget:self action:@selector(mineViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    
    
    // 推荐
    UIButton *tuiJianBtn = [[UIButton alloc] init];
    [_bigScrollView addSubview:tuiJianBtn];
    [tuiJianBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mineView.mas_bottom);
        make.left.equalTo(self.view);
        make.width.equalTo(@(W));
        make.height.equalTo(@(W * 0.090625));
    }];
    tuiJianBtn.backgroundColor = FUIColorFromRGB(0xeeeeee);
//    personal_icon_recommend
//    19*18
    
    // 横向线条
    UILabel *lbHengxiang1 = [[UILabel alloc] init];
    [tuiJianBtn addSubview:lbHengxiang1];
    [lbHengxiang1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(1));
        make.centerY.equalTo(tuiJianBtn);
        make.right.equalTo(self.view).with.offset(- W / 2 - 0.1375 * W / 2);
        make.width.equalTo(@(W * 0.0828125));
    }];
    lbHengxiang1.backgroundColor = [UIColor colorWithRed:219/255.0 green:219/255.0 blue:220/255.0 alpha:1.0];
    // 横向线条
    UILabel *lbHengxiang2 = [[UILabel alloc] init];
    [tuiJianBtn addSubview:lbHengxiang2];
    [lbHengxiang2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(1));
        make.centerY.equalTo(tuiJianBtn);
        make.left.equalTo(self.view).with.offset(W / 2 + 0.1375 * W / 2);
        make.width.equalTo(@(W * 0.0828125));
    }];
    lbHengxiang2.backgroundColor = [UIColor colorWithRed:219/255.0 green:219/255.0 blue:220/255.0 alpha:1.0];
    // 推荐图片
    UIImageView *tuijianimgView = [[UIImageView alloc] init];
    [tuiJianBtn addSubview:tuijianimgView];
    [tuijianimgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tuiJianBtn);
        make.left.equalTo(lbHengxiang1.mas_right).with.offset(W * 0.02);
        make.width.equalTo(@(0.03125 * W));
        make.height.equalTo(@(0.03125 * W * 18/19));
    }];
    tuijianimgView.image = [UIImage imageNamed:@"personal_icon_recommend"];
    // 推荐文字
    UILabel *tuijianLb = [[UILabel alloc] init];
    [tuiJianBtn addSubview:tuijianLb];
    [tuijianLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tuiJianBtn);
        make.right.equalTo(lbHengxiang2.mas_left).with.offset(- W * 0.02);
        if (iPhone6SP) {
            make.height.equalTo(@(12));
            tuijianLb.font = [UIFont systemFontOfSize:12];
        }else if (iPhone6S) {
            make.height.equalTo(@(11));
            tuijianLb.font = [UIFont systemFontOfSize:11];
        }else {
            make.height.equalTo(@(10));
            tuijianLb.font = [UIFont systemFontOfSize:10];
        }
    }];
    tuijianLb.text = @"推荐";
    tuijianLb.textColor = FUIColorFromRGB(0x999999);
    
    
    
    
    // 固定位置，用于获取frame
    [tuiJianBtn layoutIfNeeded];
    [_bigScrollView layoutIfNeeded];
    
    
    
    // 推荐的collectionview
    // 先给表格创建它的布局对象
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    // 设置间距为0
    flow.minimumInteritemSpacing = 0;
    flow.minimumLineSpacing = 6;
    
    // 设置该布局的滚动方向
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // 新建_collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, tuiJianBtn.frame.size.height + tuiJianBtn.frame.origin.y, W, 0) collectionViewLayout:flow];
    
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
    [_collectionView registerClass:[SpellgroupCollectionViewCell class] forCellWithReuseIdentifier:@"collection"];
    // collectionview的注册
    [_collectionView registerClass:[WaitCollectionViewCell class] forCellWithReuseIdentifier:@"waitCollection"];
    
    // 添加到当前页面
    [_bigScrollView addSubview:_collectionView];
    
    
    // 顶层
    UIView *topNavView = [[UIView alloc] init];
    [_bigScrollView addSubview:topNavView];
    [topNavView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(@(W));
        make.height.equalTo(@(64));
    }];
    UIColor *topleftColor1 = FUIColorFromRGB(0x9080ff);
    UIColor *bottomColor1 = FUIColorFromRGB(0x7d6dfa);
    UIImage *bgImg1 = [UIImage gradientColorImageFromColors:@[topleftColor1, bottomColor1] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(W, 64)];
    topNavView.backgroundColor = [UIColor colorWithPatternImage:bgImg1];
    topNavView.tag = 999999;
    topNavView.alpha = 0.0;
    UILabel *tuijian = [[UILabel alloc] init];
    [topNavView addSubview:tuijian];
    [tuijian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topNavView);
        make.bottom.equalTo(topNavView).with.offset(-15);
        make.height.equalTo(@(17));
    }];
    tuijian.textColor = FUIColorFromRGB(0xffffff);
    tuijian.text = @"诚心推荐";
    tuijian.font = [UIFont systemFontOfSize:17];
    
}

// 滚动视图代理事件（用于显示和隐藏topNavView）
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    UIView *topNavView = [self.view viewWithTag:999999];
    
    CGFloat minAlphaOffset = _nickNameLabel.frame.origin.y;
    CGFloat maxAlphaOffset = _mineView.frame.origin.y + _mineView.frame.size.height / 2;
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    topNavView.alpha = alpha;
}


// 头像点击事件
- (void) touxiangClick {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *strTk =  [user objectForKey:@"token"];
    
    if (strTk == nil) {
        
        // 进入登录页
        LoginViewController *vc = [[LoginViewController alloc] init];
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else {
        
        // 进入账户管理页面
        AccountManageViewController *vc = [[AccountManageViewController alloc] init];
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


// 编辑点击事件
- (void) BinajiClick:(UIButton *)btn {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *strTk =  [user objectForKey:@"token"];
    
    if (strTk == nil) {
        
        // 进入登录页
        LoginViewController *vc = [[LoginViewController alloc] init];
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else {
    
        // 进入账户管理页面
        AccountManageViewController *vc = [[AccountManageViewController alloc] init];
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}


// 我的订单点击事件
- (void) MineDingDanClick:(UIButton *)btn {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *strTk =  [user objectForKey:@"token"];
    
    if (strTk == nil) {
        
        // 进入登录页
        LoginViewController *vc = [[LoginViewController alloc] init];
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else {
    
        // 我的订单详情页
        WMMineOrderViewController *OrderVc = [[WMMineOrderViewController alloc] init];
        OrderVc.strSelectIndex = @"0";
        // 隐藏底边栏
        [OrderVc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:OrderVc animated:YES];
    }
    
}

// 关注/足记/收货地址/购物券视图按钮的点击事件
- (void) mineViewBtnClick:(UIButton *)btn {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *strTk =  [user objectForKey:@"token"];
    
    if (strTk == nil) {
        
        // 进入登录页
        LoginViewController *vc = [[LoginViewController alloc] init];
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else {
        
        if ([btn.titleLabel.text isEqualToString:@"待付款"]) {
            
            // 我的订单详情页
            WMMineOrderViewController *OrderVc = [[WMMineOrderViewController alloc] init];
            OrderVc.strSelectIndex = @"1";
            // 隐藏底边栏
            [OrderVc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:OrderVc animated:YES];
            
        } else if ([btn.titleLabel.text isEqualToString:@"待成团"]) {
            // 我的订单详情页
            WMMineOrderViewController *OrderVc = [[WMMineOrderViewController alloc] init];
            OrderVc.strSelectIndex = @"5";
            // 隐藏底边栏
            [OrderVc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:OrderVc animated:YES];
        } else if ([btn.titleLabel.text isEqualToString:@"待发货"]) {
            // 我的订单详情页
            WMMineOrderViewController *OrderVc = [[WMMineOrderViewController alloc] init];
            OrderVc.strSelectIndex = @"2";
            // 隐藏底边栏
            [OrderVc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:OrderVc animated:YES];
        } else if ([btn.titleLabel.text isEqualToString:@"待收货"]) {
            // 我的订单详情页
            WMMineOrderViewController *OrderVc = [[WMMineOrderViewController alloc] init];
            OrderVc.strSelectIndex = @"3";
            // 隐藏底边栏
            [OrderVc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:OrderVc animated:YES];
        }else if ([btn.titleLabel.text isEqualToString:@"待评价"]) {
            // 我的订单详情页
            WMMineOrderViewController *OrderVc = [[WMMineOrderViewController alloc] init];
            OrderVc.strSelectIndex = @"4";
            // 隐藏底边栏
            [OrderVc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:OrderVc animated:YES];
        }else if ([btn.titleLabel.text isEqualToString:@"购物券"]) {
            
            // 购物券视图
            GouWuQuanViewController *vc = [[GouWuQuanViewController alloc] init];
            [vc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if ([btn.titleLabel.text isEqualToString:@"我的关注"]) {
            MineFocusOnViewController * vc = [[MineFocusOnViewController alloc] init];
            // 隐藏底边栏
            [vc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([btn.titleLabel.text isEqualToString:@"我的足迹"]) {
            FootmarkViewController *vc = [[FootmarkViewController alloc] init];
            [vc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([btn.titleLabel.text isEqualToString:@"收货地址"]) {
            AdressViewController *vc = [[AdressViewController alloc] init];
            [vc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            NSLog(@"没有");
        }
        
    }
}


#pragma mark ---------UICollectionViewDelgate/UICollectionViewDataSource--------
// 每个分区的cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    // 获取当前时间戳
    NSDate *senddate = [NSDate date];
    NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    
    NSInteger count = 0;
    for (int i = 0; i < _CollectionViewArr.count ; i++) {
        
        HomeDataModel *model = _CollectionViewArr[i];
        
        if ([model.start_datetime intValue] > [date2 intValue]) {
            count ++;
        }
    }
    
    
    _collectionView.size = CGSizeMake(W ,W * 0.54375 * count + (_CollectionViewArr.count - count) * W * 0.59375);
    _bigScrollView.contentSize = CGSizeMake(W, _collectionView.frame.origin.y + _collectionView.frame.size.height);
    
    // 返回的个数
    return _CollectionViewArr.count;
}

// 绑定数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 获取模型
    HomeDataModel *model = _CollectionViewArr[indexPath.row];
    // 判断是待开团还是已开团,获取当前时间戳进行和活动开始时间进行比对
    // 获取当前时间戳
    NSDate *senddate = [NSDate date];
    NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    if ([model.start_datetime intValue] > [date2 intValue]) {
        
        // 待开团
        WaitCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"waitCollection" forIndexPath:indexPath];
        
        //        cell.goodsImgView.image = [UIImage imageNamed:model.img];
        // 设置图片以及等待视图
        [cell.goodsImgView sd_setImageWithURL:[NSURL URLWithString:[model.img_multi objectForKey:@"app_list"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        cell.titleLb.text = model.title;
        
        
        if ([self getDifferForTime:model.start_datetime] > 86400) {
            
            // 防止复用控件上的数据
            for (UIView *subView in cell.lbForHH.subviews) {
                [subView removeFromSuperview];
            }
            for (UIView *subView in cell.lbFormm.subviews) {
                [subView removeFromSuperview];
            }
            for (UIView *subView in cell.lbForss.subviews) {
                [subView removeFromSuperview];
            }
            cell.lbForHH.hidden = YES;
            cell.lbFormm.hidden = YES;
            cell.lbForss.hidden = YES;
            cell.maohaoLb1.hidden = YES;
            cell.maohaoLb2.hidden = YES;
            cell.rightImgView.hidden = YES; // 隐藏
            cell.waitDayLabel.hidden = NO; // 不隐藏
            
            NSDateComponents *dateCom = [self getDifferForTimeWait:model.start_datetime];
            
            cell.waitDayLabel.text = [NSString stringWithFormat:@"%ld天%ld小时%ld分钟", dateCom.day,dateCom.hour,dateCom.minute];
            
            
        }else {
            
            // 防止复用控件上的数据
            for (UIView *subView in cell.lbForHH.subviews) {
                [subView removeFromSuperview];
            }
            for (UIView *subView in cell.lbFormm.subviews) {
                [subView removeFromSuperview];
            }
            for (UIView *subView in cell.lbForss.subviews) {
                [subView removeFromSuperview];
            }
            cell.lbForHH.hidden = NO;
            cell.lbFormm.hidden = NO;
            cell.lbForss.hidden = NO;
            cell.maohaoLb1.hidden = NO;
            cell.maohaoLb2.hidden = NO;
            cell.rightImgView.hidden = NO; // 不隐藏
            cell.waitDayLabel.hidden = YES; // 隐藏
            // 时分秒
            [self timeCountForWaitForHH:cell.lbForHH andTime:[model.start_datetime integerValue]];
            [self timeCountForWaitForMM:cell.lbFormm andTime:[model.start_datetime integerValue]];
            [self timeCountForWaitForSS:cell.lbForss andTime:[model.start_datetime integerValue]];
            
        }
        
        // cell的背景色 白色
        cell.backgroundColor = FUIColorFromRGB(0xffffff);
        
        return cell;
        
    }else {
        
        // 已开团
        SpellgroupCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collection" forIndexPath:indexPath];
        
        // 设置图片以及等待视图
        [cell.goodsImgView sd_setImageWithURL:[NSURL URLWithString:[model.img_multi objectForKey:@"app_list"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        // 设置标题
        cell.titleLb.text = model.title;
        
        // 设置进度条长度
        CGFloat progessWidth = [self calculateWidthForMaxNum:[model.low_sale_num_limit integerValue]*3 andCurrentNum:[model.sale_num integerValue]];
        NSLog(@"%f",progessWidth);
        if (iPhone6SP) {
            cell.progressImgView.size = CGSizeMake(progessWidth, 12);
        }else if (iPhone6S) {
            cell.progressImgView.size = CGSizeMake(progessWidth, 11);
        }else {
            cell.progressImgView.size = CGSizeMake(progessWidth, 10);
        }
        // 设置背景色(用到了UIImage+GradientColor.h这个类扩展)
        UIColor *leftColor1 = FUIColorFromRGB(0x7766fd);
        UIColor *rightColor1 = FUIColorFromRGB(0xf779ff);
        UIImage *bgImg1 = [UIImage gradientColorImageFromColors:@[leftColor1, rightColor1] gradientType:GradientTypeLeftToRight imgSize:cell.progressImgView.size];
        cell.progressImgView.backgroundColor = [UIColor colorWithPatternImage:bgImg1];
        // 设置图片平铺
        UIImage *image2 = [UIImage imageNamed:@"home_progressbar"];
        CGFloat top = 0; // 顶端盖高度
        CGFloat bottom = 0 ; // 底端盖高度
        CGFloat left = 0; // 左端盖宽度
        CGFloat right = 0; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        image2 = [image2 resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeTile];
        //    UIImageResizingModeStretch：拉伸模式，通过拉伸UIEdgeInsets指定的矩形区域来填充图片
        //    UIImageResizingModeTile：平铺模式，通过重复显示UIEdgeInsets指定的矩形区域来填充图片
        cell.progressImgView.image = image2;
        
        // 显示当前人数
        cell.currentNumLb.text = [NSString stringWithFormat:@"%ld人",[model.sale_num integerValue]];
        
        // 成团人数
        cell.maxAndPriceLb.text = model.low_sale_num_limit;
        
        // 成团价格
        NSString *strPrice = [NSString stringWithFormat:@"%@ ¥%@",@"成团价",model.low_price];
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:strPrice];
        NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:@"成团价"].location, [[noteStr string] rangeOfString:@"成团价"].length);
        //需要设置的位置
        [noteStr addAttribute:NSForegroundColorAttributeName value:FUIColorFromRGB(0x999999) range:redRange];
        //设置颜色
        [cell.priceLb setAttributedText:noteStr];
        
        
        // 防止复用控件上的数据
        for (UIView *subView in cell.countDownLabel.subviews) {
            [subView removeFromSuperview];
        }
        [self timeCount:cell.countDownLabel andTime:[self getDifferForTime:model.end_datetime]];
        
        // cell的背景色 白色
        cell.backgroundColor = FUIColorFromRGB(0xffffff);
        
        return cell;
    }
    
}

// 每个cell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 获取模型
    HomeDataModel *model = _CollectionViewArr[indexPath.row];
    // 判断是待开团还是已开团,获取当前时间戳进行和活动开始时间进行比对
    // 获取当前时间戳
    NSDate *senddate = [NSDate date];
    NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    
    
    if ([model.start_datetime intValue] > [date2 intValue]) {
        
        return CGSizeMake(W, W * 0.54375);
        
    }else {
        
        return CGSizeMake(W, W * 0.59375);
    }
}

// 上左下右距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// collectionview 的选中事件
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 跳转到详情页
    GroupDetailViewController *detailVc = [[GroupDetailViewController alloc] init];
    
    // 获取模型
    HomeDataModel *model = _CollectionViewArr[indexPath.row];
    // 判断是待开团还是已开团,获取当前时间戳进行和活动开始时间进行比对
    // 获取当前时间戳
    NSDate *senddate = [NSDate date];
    NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    if ([model.start_datetime intValue] > [date2 intValue]) {
        detailVc.strStatus = @"0";
        detailVc.goodsId = model.id1;
        detailVc.pingjiaId = model.good_id;
    }else {
        detailVc.strStatus = @"1";
        detailVc.goodsId = model.id1;
        detailVc.pingjiaId = model.good_id;
    }
    
    // 跳转时隐藏底边导航控制器
    [detailVc setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:detailVc animated:YES];
}

// 倒计时方法（未开团） 小时
- (void) timeCountForWaitForHH:(UILabel *)countDownLabel andTime:(NSInteger) overTime {
    
    UILabel * timer_show = [[UILabel alloc] init];
    timer_show.backgroundColor = [UIColor clearColor];// 设置背景色
    [countDownLabel addSubview:timer_show];//把timer_show添加到倒计时按钮上
    [timer_show mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(countDownLabel);
        make.right.equalTo(countDownLabel);
        make.height.equalTo(countDownLabel);
        make.left.equalTo(countDownLabel);
    }];
    MZTimerLabel *timer_cutDown = [[MZTimerLabel alloc] initWithLabel:timer_show andTimerType:MZTimerLabelTypeTimer];//创建MZTimerLabel类的对象timer_cutDown
    [timer_cutDown setCountDownTime:overTime];//倒计时时间
    timer_cutDown.timeFormat = @"HH";
    timer_cutDown.timeLabel.textColor = FUIColorFromRGB(0xffffff);//倒计时字体颜色
    
    if (iPhone6SP) {
        timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:13.0];//倒计时字体大小
    }else if (iPhone6S) {
        timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:12.0];//倒计时字体大小
    }else {
        timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:11.0];//倒计时字体大小
    }
    timer_cutDown.timeLabel.textAlignment = NSTextAlignmentCenter;//居中
    [timer_cutDown start];//开始计时
}

// 倒计时方法（未开团） 分钟
- (void) timeCountForWaitForMM:(UILabel *)countDownLabel andTime:(NSInteger) overTime {
    
    UILabel * timer_show = [[UILabel alloc] init];
    timer_show.backgroundColor = [UIColor clearColor];// 设置背景色
    [countDownLabel addSubview:timer_show];//把timer_show添加到倒计时按钮上
    [timer_show mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(countDownLabel);
        make.right.equalTo(countDownLabel);
        make.height.equalTo(countDownLabel);
        make.left.equalTo(countDownLabel);
    }];
    MZTimerLabel *timer_cutDown = [[MZTimerLabel alloc] initWithLabel:timer_show andTimerType:MZTimerLabelTypeTimer];//创建MZTimerLabel类的对象timer_cutDown
    [timer_cutDown setCountDownTime:overTime]; //设置倒计时时间
    
    timer_cutDown.timeFormat = @"mm";
    //    timer_cutDown.timeFormat = @"活动倒计时 天 HH:mm:ss";//倒计时格式,也可以是@"HH:mm:ss SS"，时，分，秒，毫秒；想用哪个就写哪个
    timer_cutDown.timeLabel.textColor = FUIColorFromRGB(0xffffff);//倒计时字体颜色
    
    if (iPhone6SP) {
        timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:13.0];//倒计时字体大小
    }else if (iPhone6S) {
        timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:12.0];//倒计时字体大小
    }else {
        timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:11.0];//倒计时字体大小
    }
    timer_cutDown.timeLabel.textAlignment = NSTextAlignmentCenter;//居中
    [timer_cutDown start];//开始计时
}

// 倒计时方法（未开团） 秒
- (void) timeCountForWaitForSS:(UILabel *)countDownLabel andTime:(NSInteger) overTime {
    
    UILabel * timer_show = [[UILabel alloc] init];
    timer_show.backgroundColor = [UIColor clearColor];// 设置背景色
    [countDownLabel addSubview:timer_show];//把timer_show添加到倒计时按钮上
    [timer_show mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(countDownLabel);
        make.right.equalTo(countDownLabel);
        make.height.equalTo(countDownLabel);
        make.left.equalTo(countDownLabel);
    }];
    MZTimerLabel *timer_cutDown = [[MZTimerLabel alloc] initWithLabel:timer_show andTimerType:MZTimerLabelTypeTimer];//创建MZTimerLabel类的对象timer_cutDown
    [timer_cutDown setCountDownTime:overTime]; //设置倒计时时间
    
    timer_cutDown.timeFormat = @"ss";
    //    timer_cutDown.timeFormat = @"活动倒计时 天 HH:mm:ss";//倒计时格式,也可以是@"HH:mm:ss SS"，时，分，秒，毫秒；想用哪个就写哪个
    timer_cutDown.timeLabel.textColor = FUIColorFromRGB(0xffffff);//倒计时字体颜色
    
    if (iPhone6SP) {
        timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:13.0];//倒计时字体大小
    }else if (iPhone6S) {
        timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:12.0];//倒计时字体大小
    }else {
        timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:11.0];//倒计时字体大小
    }
    timer_cutDown.timeLabel.textAlignment = NSTextAlignmentCenter;//居中
    [timer_cutDown start];//开始计时
}


// 倒计时方法
- (void)timeCount:(UILabel *)countDownLabel andTime:(NSInteger) overTime{ //倒计时函数
    
    UILabel * timer_show = [[UILabel alloc] init];
    timer_show.backgroundColor = [UIColor clearColor];// 设置背景色
    [countDownLabel addSubview:timer_show];//把timer_show添加到倒计时按钮上
    [timer_show mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(countDownLabel);
        make.right.equalTo(countDownLabel);
        make.height.equalTo(countDownLabel);
    }];
    MZTimerLabel *timer_cutDown = [[MZTimerLabel alloc] initWithLabel:timer_show andTimerType:MZTimerLabelTypeTimer];//创建MZTimerLabel类的对象timer_cutDown
    [timer_cutDown setCountDownTime:overTime];//倒计时时间60s
    timer_cutDown.timeFormat = @"dd";
    NSString *str = timer_cutDown.timeLabel.text;
    NSLog(@"*********************%@",str);
    NSInteger datInt = [str integerValue] - 1;
    
    timer_cutDown.timeFormat = [NSString stringWithFormat:@"%ld天 %@",datInt,@"HH:mm:ss"];
    //    timer_cutDown.timeFormat = @"活动倒计时 天 HH:mm:ss";//倒计时格式,也可以是@"HH:mm:ss SS"，时，分，秒，毫秒；想用哪个就写哪个
    timer_cutDown.timeLabel.textColor = FUIColorFromRGB(0x8e7eff);//倒计时字体颜色
    
    if (iPhone6SP) {
        timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:13.0];//倒计时字体大小
    }else if (iPhone6S) {
        timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:12.0];//倒计时字体大小
    }else {
        timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:11.0];//倒计时字体大小
    }
    timer_cutDown.timeLabel.textAlignment = NSTextAlignmentCenter;//居中
    timer_cutDown.delegate = self;//设置代理，以便后面倒计时结束时调用代理
    [timer_cutDown start];//开始计时
}

// 倒计时结束后的代理方法
- (void)timerLabel:(MZTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    
    timerLabel.timeFormat = @"拼团已结束~";
    timerLabel.timeLabel.textColor = [UIColor redColor];
}


// 计算progerssImageView的长度
- (CGFloat) calculateWidthForMaxNum:(NSInteger) maxNum andCurrentNum:(NSInteger) currentNum {
    
    if (maxNum == 0) {
        
        return 0;
        
    }else {
        
        CGFloat scale = (CGFloat)currentNum / (CGFloat)maxNum;
        
        if (scale > 1.0) {
            CGFloat ProgressWidth = 1 * (W - (0.03125 * W * 2 + 0.095 * W + 0.2*W*0.59375));
            return ProgressWidth;
        }else {
            CGFloat ProgressWidth = scale * (W - (0.03125 * W * 2 + 0.295 * W));
            return ProgressWidth;
        }
    }
}

// 获取相差时间
- (NSInteger) getDifferForTime:(NSString *) timestamp {
    
    // 获取当前时间
    NSDate *nowDate = [NSDate date];
    
    
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    
    // 截止时间字符串格式
    NSString *expireDateStr = [dateFomatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timestamp intValue]]];
    // 当前时间字符串格式
    NSString *nowDateStr = [dateFomatter stringFromDate:nowDate];
    // 截止时间data格式
    NSDate *expireDate = [dateFomatter dateFromString:expireDateStr];
    // 当前时间data格式
    nowDate = [dateFomatter dateFromString:nowDateStr];
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:nowDate toDate:expireDate options:0];
    
//    NSLog(@"===========%ld",dateCom.day * 3600 * 24);
    
    return dateCom.second + dateCom.hour * 3600 + dateCom.minute * 60 + dateCom.day * 3600 * 24;
    
    //    // 伪代码
    //    年差额 = dateCom.year, 月差额 = dateCom.month, 日差额 = dateCom.day, 小时差额 = dateCom.hour, 分钟差额 = dateCom.minute, 秒差额 = dateCom.second
}

// 获取相差时间 未开团的
- (NSDateComponents *) getDifferForTimeWait:(NSString *) timestamp {
    
    // 获取当前时间
    NSDate *nowDate = [NSDate date];
    
    
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    
    // 截止时间字符串格式
    NSString *expireDateStr = [dateFomatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timestamp intValue]]];
    // 当前时间字符串格式
    NSString *nowDateStr = [dateFomatter stringFromDate:nowDate];
    // 截止时间data格式
    NSDate *expireDate = [dateFomatter dateFromString:expireDateStr];
    // 当前时间data格式
    nowDate = [dateFomatter dateFromString:nowDateStr];
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:nowDate toDate:expireDate options:0];
    
//    NSLog(@"===========%ld",dateCom.day * 3600 * 24);
    
    return dateCom;
    
    //    // 伪代码
    //    年差额 = dateCom.year, 月差额 = dateCom.month, 日差额 = dateCom.day, 小时差额 = dateCom.hour, 分钟差额 = dateCom.minute, 秒差额 = dateCom.second
}



// 监听处理事件
- (void)listen:(NSNotification *)noti {
    
    NSString *strNoti = noti.object;
    
    // 用户在侧栏进行了退出
    if ([strNoti isEqualToString:@"0"]) {
        
        // 修改头像
        _touxiangImgView.image = [UIImage imageNamed:@"账户管理_默认头像"];
        // 修改昵称
        _nickNameLabel.text = @"点击头像进行登录";
        
        // 销毁侧栏退出的通知
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"leftViewExit" object:@"0"];
    }
    
    // 资料页退出
    if ([strNoti isEqualToString:@"1"]) {
        
        // 修改头像
        _touxiangImgView.image = [UIImage imageNamed:@"账户管理_默认头像"];
        // 修改昵称
        _nickNameLabel.text = @"点击头像进行登录";
        
        // 跳到最外层
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        // 跳转到登录页
        LoginViewController *vc = [[LoginViewController alloc] init];
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:YES];
        
        
        // 销毁资料页退出的通知
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"accountManagerExit" object:@"1"];
    }
    
    // 用户资料修改了，在此修改头像和昵称
    if ([strNoti isEqualToString:@"2"]) {
        
        // 重新获取用户资料数据
        [self initDataWithUserInfo];
        
        // 销毁用户修改了资料的通知
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reviseUserInfo" object:@"2"];
    }
    
    // 登陆成功，在此修改头像和昵称
    if ([strNoti isEqualToString:@"3"]) {
        
        // 重新获取用户资料数据
        [self initDataWithUserInfo];
        
        // 销毁通知
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginSuccess" object:@"3"];
    }
    
    // 注册成功，在此修改头像和昵称
    if ([strNoti isEqualToString:@"4"]) {
        
        // 重新获取用户资料数据
        [self initDataWithUserInfo];
        
        
        // 销毁通知
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"registerSuccess" object:@"4"];
        
    }
    
    // 修改头像成功，在此修改头像和昵称
    if ([strNoti isEqualToString:@"6"]) {
        
        // 重新获取用户资料数据
        [self initDataWithUserInfo];
        
        
        // 销毁通知
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reviseUserIcon" object:@"6"];
        
    }
}



// 界面将要显示
- (void) viewWillAppear:(BOOL)animated {
    
    // 设置navgationController不透明
    self.navigationController.navigationBar.translucent = NO;
    
    // 隐藏导航栏
//    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
    
    // 接收消息
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    // 侧栏退出
    [notiCenter addObserver:self selector:@selector(listen:) name:@"leftViewExit" object:@"0"];
    // 资料页退出
    [notiCenter addObserver:self selector:@selector(listen:) name:@"accountManagerExit" object:@"1"];
    // 修改了用户资料,需要改头像和昵称
    [notiCenter addObserver:self selector:@selector(listen:) name:@"reviseUserInfo" object:@"2"];
    // 登录成功
    [notiCenter addObserver:self selector:@selector(listen:) name:@"loginSuccess" object:@"3"];
    // 注册成功
    [notiCenter addObserver:self selector:@selector(listen:) name:@"registerSuccess" object:@"4"];
    // 修改了头像
    [notiCenter addObserver:self selector:@selector(listen:) name:@"reviseUserIcon" object:@"6"];
    
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
