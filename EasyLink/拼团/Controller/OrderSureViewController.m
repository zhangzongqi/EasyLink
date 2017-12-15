//
//  OrderSureViewController.m
//  EasyLink
//
//  Created by 琦琦 on 17/3/8.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "OrderSureViewController.h"
#import "OrderSureAdressView.h" // 地址view
#import "BuyDetailView.h" // 购买详情
#import "SelectPayView.h" // 选择支付方式页面
#import "ZhiFuViewController.h" // 支付页面
#import "AddressSelectView.h" // 地址选择视图
#import "ZheZhaoView.h" // 遮罩层
#import "peisongWebView.h" // 配送价格详情网页
#import "AdressViewController.h" // 收货地址页面

@interface OrderSureViewController () {
    
    NSInteger buyNum;
    
    // 地址遮罩层
    ZheZhaoView *_dizhiZheZhao;
    
    // 配送详情遮罩层
    ZheZhaoView *_peisongZheZhao;
    
    // 最终价格
    NSString *_strEndPrice;
    
    // 支付方式
    NSString *payType;
}

@property (nonatomic, copy) UIScrollView *bigScrollView;
@property (nonatomic, copy) OrderSureAdressView *orderAddressView;
@property (nonatomic, copy) BuyDetailView *buyDetailView;
@property (nonatomic, copy) SelectPayView *selectPayView;
@property (nonatomic, copy) UIButton *tijiaoBuyBtn;
@property (nonatomic, copy) UILabel *tijiaoPriceLabel;

// 地址选择视图
@property (nonatomic, copy) AddressSelectView *addressSelectVc;

@property (nonatomic, strong) peisongWebView *peisongDetailWeb; // 配送详细网页

@end

@implementation OrderSureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = FUIColorFromRGB(0xffffff);
    
    // 设置导航栏标题
    UILabel *lbItemTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    lbItemTitle.text = @"确认订单";
    lbItemTitle.textColor = FUIColorFromRGB(0x212121);
    lbItemTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lbItemTitle;
    
    payType = @"";
    
    // 返回按钮
    [self createBackBtn];
    
    // 初始化数据
    [self initDataSource];
    
    // 布局UI
    [self createUI];
    
    // 获取数据
    [self initData];
}

// 初始化数据
- (void) initDataSource {
    
    buyNum = [_buyNum1 integerValue];
    
    _strEndPrice = @"--";
}

// 获取数据
- (void) initData {
    
    
    // 刚进来的时候，不用进行网络请求
    
//    NSArray *arrForJiami = [GetUserJiaMi getUserTokenAndCgAndKey];
//    
//    HttpRequest *http = [[HttpRequest alloc] init];
//    
//    
//    NSDictionary *dic = @{@"id":_id1,@"buyNum":[NSString stringWithFormat:@"%ld",buyNum],@"specItemIds":_specItemIds,@"subOrderId":_subOrderId,@"regionId":_regionId};
//    NSString *dataJimihou = [[MakeJson createJson:dic] AES128EncryptWithKey:arrForJiami[3]];
//    
//    NSDictionary *dataDic = @{@"tk":arrForJiami[0],@"key":arrForJiami[1],@"cg":arrForJiami[2],@"data":dataJimihou};
//    
//    
//    [http PostGetfastMailWithDataDic:dataDic Success:^(id arrForGoodsData) {
//        
//        if ([arrForGoodsData isKindOfClass:[NSString class]]) {
//            
//            // 请求失败,没有可匹配的
//            [_buyDetailView.selectPeisongBtn setTitle:@"您所在的城市暂时不可配送" forState:UIControlStateNormal];
//            
//        }else {
//            
//            
//            _buyDetailView.selectPeisongBtn.userInteractionEnabled = YES;
//            
//            // 有配送信息
//            [_buyDetailView.selectPeisongBtn setTitle:[NSString stringWithFormat:@"%@,运费:%@",[arrForGoodsData[0] objectForKey:@"ship"],[arrForGoodsData[0] objectForKey:@"money"]] forState:UIControlStateNormal];
//            
//            
//            // 判断是否可送达，如果可送达，创建配送信息视图
//            // 配送遮罩层
//            _peisongZheZhao = [[ZheZhaoView alloc] initWithFrame:CGRectMake(0, 0, W, H - 64)];
//            [self.view addSubview:_peisongZheZhao];
//            _peisongZheZhao.hidden = YES;
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(peisongZheZhaoClick)];
//            [_peisongZheZhao addGestureRecognizer:tap];
//            
//            // 配送webView
//            _peisongDetailWeb = [[peisongWebView alloc] initWithFrame:CGRectMake(0, H + 64, W, W) WithWebUrl:[arrForGoodsData[0] objectForKey:@"ship_info"]];
//            [self.view addSubview:_peisongDetailWeb];
//            
//        }
//        
//    } failure:^(NSError *error) {
//        
//        
//    }];
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
    
    // 顶部提示语
    UIView *topTipLbView = [[UIView alloc] init];
    [_bigScrollView addSubview:topTipLbView];
    [topTipLbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bigScrollView);
        make.left.equalTo(_bigScrollView);
        make.width.equalTo(@(W));
        make.height.equalTo(@(H * 0.04));
    }];
    UILabel *topTipLb = [[UILabel alloc] init];
    [topTipLbView addSubview:topTipLb];
    [topTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topTipLbView);
        make.left.equalTo(topTipLbView).with.offset(W * 0.03125);
    }];
    topTipLb.textColor = FUIColorFromRGB(0x999999);
    topTipLb.text = @"全拼成功生成订单后 预计次日送达";
    if (iPhone6SP) {
        topTipLb.font = [UIFont systemFontOfSize:14];
    }else if (iPhone6S) {
        topTipLb.font = [UIFont systemFontOfSize:13];
    }else {
        topTipLb.font = [UIFont systemFontOfSize:12];
    }
    
    // 地址视图
    _orderAddressView = [[OrderSureAdressView alloc] initWithFrame:CGRectMake(0, 0, W, W * 0.225)];
    [_bigScrollView addSubview:_orderAddressView];
    [_orderAddressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bigScrollView);
        make.top.equalTo(topTipLbView.mas_bottom);
        make.width.equalTo(@(W));
        make.height.equalTo(@(W * 0.225));
    }];
    [_orderAddressView.adressBtn addTarget:self action:@selector(adressBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 购买详情视图
    _buyDetailView = [[BuyDetailView alloc] initWithFrame:CGRectMake(0, 0, W, W*0.76875)];
    [_bigScrollView addSubview:_buyDetailView];
    [_buyDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_orderAddressView.mas_bottom).with.offset(W / 64);
        make.left.equalTo(_bigScrollView);
        make.width.equalTo(@(W));
        make.height.equalTo(@(W * 0.76875));
    }];
    _buyDetailView.goodsImgView.image = [UIImage imageNamed:@"7"];
    _buyDetailView.titleLb.text = @"新疆葡萄 快来买啦 又酸又甜";
    _buyDetailView.orderGuigeLb.text = @"1份约3kg,10件团";
    _buyDetailView.buyNumLb.text = [NSString stringWithFormat:@"x%ld",buyNum];
    _buyDetailView.onePriceLb.text = self.onePrice;
    _buyDetailView.buyNumViewTipLb.text = @"限量10件团";
    _buyDetailView.buyNumViewNumLb.text = [NSString stringWithFormat:@"%ld",buyNum];
    [_buyDetailView.addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_buyDetailView.subBtn addTarget:self action:@selector(subBtnClick) forControlEvents:UIControlEventTouchUpInside];
    // 快递Btn
    [_buyDetailView.selectPeisongBtn setTitle:@"请先选择配送地址" forState:UIControlStateNormal];
    [_buyDetailView.selectPeisongBtn addTarget:self action:@selector(selectPeisongBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_buyDetailView.gouwuquanBtn setTitle:@"暂无可用购物券" forState:UIControlStateNormal];
    // label两种颜色字体
    NSString *strPrice = [NSString stringWithFormat:@"实付: %@",_strEndPrice];
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:strPrice];
    NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:@"实付:"].location, [[noteStr string] rangeOfString:@"实付:"].length);
    //需要设置的位置
    [noteStr addAttribute:NSForegroundColorAttributeName value:FUIColorFromRGB(0x999999) range:redRange];
    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:redRange];
    [_buyDetailView.endPriceLb setAttributedText:noteStr];
    
    
    
    // 选择支付方式页面
    _selectPayView = [[SelectPayView alloc] initWithFrame:CGRectMake(0, 0, W, W * 0.315)];
    [_bigScrollView addSubview:_selectPayView];
    [_selectPayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_buyDetailView.mas_bottom).with.offset(W / 64);
        make.left.equalTo(self.view);
        make.width.equalTo(@(W));
        make.height.equalTo(@(W * 0.315));
    }];
    [_selectPayView.btnWeiXin addTarget:self action:@selector(selectPayClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_selectPayView.btnQQ addTarget:self action:@selector(selectPayClick:) forControlEvents:UIControlEventTouchUpInside];
    [_selectPayView.btnAliPay addTarget:self action:@selector(selectPayClick:) forControlEvents:UIControlEventTouchUpInside];

    [_bigScrollView layoutIfNeeded];
    
    _bigScrollView.contentSize = CGSizeMake(W, _selectPayView.frame.origin.y + _selectPayView.frame.size.height + 49);
    
    
    // 创建底边栏
    UIView *bottomVc = [[UIView alloc] init];
    [self.view addSubview:bottomVc];
    [bottomVc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(@(W));
        make.height.equalTo(@(49));
    }];
    bottomVc.backgroundColor = [FUIColorFromRGB(0xf8f8f8) colorWithAlphaComponent:0.9];
    // 提交订单按钮
    _tijiaoBuyBtn = [[UIButton alloc] init];
    [bottomVc addSubview:_tijiaoBuyBtn];
    [_tijiaoBuyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomVc);
        make.right.equalTo(bottomVc);
        make.width.equalTo(bottomVc).multipliedBy(0.296875);
        make.height.equalTo(bottomVc);
    }];
    // 渐变色
    UIColor *topColor = FUIColorFromRGB(0x9080ff);
    UIColor *bottomColor = FUIColorFromRGB(0x7361f8);
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topColor, bottomColor] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(W * 0.296875, 49)];
    _tijiaoBuyBtn.backgroundColor = [UIColor colorWithPatternImage:bgImg];
    [_tijiaoBuyBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [_tijiaoBuyBtn setTitleColor:FUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    _tijiaoBuyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_tijiaoBuyBtn addTarget:self action:@selector(tijiaoBuyBtn:) forControlEvents:UIControlEventTouchUpInside];
    // 价格label
    _tijiaoPriceLabel =[[UILabel alloc] init];
    [bottomVc addSubview:_tijiaoPriceLabel];
    [_tijiaoPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomVc);
        make.right.equalTo(_tijiaoBuyBtn.mas_left).with.offset(- W * 0.025);
        make.height.equalTo(@(16));
    }];
    _tijiaoPriceLabel.textColor = FUIColorFromRGB(0x8979ff);
    _tijiaoPriceLabel.font = [UIFont systemFontOfSize:16];
    // label两种颜色字体
    NSString *strPrice1 = [NSString stringWithFormat:@"实付: %@",_strEndPrice];
    NSMutableAttributedString *noteStr1 = [[NSMutableAttributedString alloc] initWithString:strPrice1];
    NSRange redRange1 = NSMakeRange([[noteStr1 string] rangeOfString:@"实付:"].location, [[noteStr1 string] rangeOfString:@"实付:"].length);
    //需要设置的位置
    [noteStr1 addAttribute:NSForegroundColorAttributeName value:FUIColorFromRGB(0x999999) range:redRange1];
    [noteStr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:redRange1];
    [_tijiaoPriceLabel setAttributedText:noteStr1];
    
}


// 地址选择点击事件
- (void) adressBtnClick {
    
    AdressViewController *vc = [[AdressViewController alloc] init];
    vc.orderSure = @"选择地址";
    [self.navigationController pushViewController:vc animated:YES];
}

// 配送信息点击事件
- (void) selectPeisongBtnClick {
    
    [UIView animateWithDuration:0.25f animations:^{
        
        _peisongZheZhao.hidden = NO;
        
        _peisongDetailWeb.frame = CGRectMake(0, H + 64 - W, W, W);
        
    } completion:^(BOOL finished) {
        
        
    }];
}


// 配送遮罩层点击事件
- (void) peisongZheZhaoClick {
    
    [UIView animateWithDuration:0.25f animations:^{
        
        _peisongDetailWeb.frame = CGRectMake(0, H + 64, W, W);
        
    } completion:^(BOOL finished) {
        
        _peisongZheZhao.hidden = YES;
    }];
}



// 提交订单点击事件
- (void) tijiaoBuyBtn:(UIButton *)btn {
    
    // 用户单例
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    HttpRequest *http = [[HttpRequest alloc] init];
    
    NSString *strShipId = [user objectForKey:@"shipTplId"];
    
    if ([payType isEqualToString:@""]) {
        
        [http GetHttpDefeatAlert:@"请先选择支付方式"];
    }else {
        
        // 提交订单
        NSArray *arr = [GetUserJiaMi getUserTokenAndCgAndKey];
        NSDictionary *dic = @{@"id":_id1,@"buyNum":[NSString stringWithFormat:@"%ld",buyNum],@"specItemIds":_specItemIds,@"subOrderId":_subOrderId,@"addressId":[user objectForKey:@"addressId"],@"payType":payType,@"shipTplId":strShipId};
        NSString *strDic = [[MakeJson createJson:dic] AES128EncryptWithKey:arr[3]];
        
        NSDictionary *dicData = @{@"tk":arr[0],@"key":arr[1],@"cg":arr[2],@"data":strDic};
        
        // 添加订单
        [http PostMakeOderWithDicData:dicData Success:^(id oderMessage) {
            
//            NSLog(@"**************%@",[oderMessage objectForKey:@"preview_pay_config"]);
            
        } failure:^(NSError *error) {
            
            // 网络错误,请求失败
        }];
    }
    
    
    
    
    
    
    
    
//    ZhiFuViewController *vc = [[ZhiFuViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}

// 选择支付方式点击事件
- (void) selectPayClick:(UIButton *)selectPayBtn {
    
    if ([selectPayBtn.titleLabel.text isEqualToString:@"支付宝支付"]) {
        _selectPayView.btnAliPay.selected = YES;
//        _selectPayView.btnQQ.selected = NO;
        _selectPayView.btnWeiXin.selected = NO;
        // 支付方式
        payType = @"1";
        
    }else if ([selectPayBtn.titleLabel.text isEqualToString:@"微信支付"]) {
        _selectPayView.btnAliPay.selected = NO;
//        _selectPayView.btnQQ.selected = NO;
        _selectPayView.btnWeiXin.selected = YES;
        // 支付方式
        payType = @"2";
    }
//    else if ([selectPayBtn.titleLabel.text isEqualToString:@"QQ钱包支付"]) {
//        _selectPayView.btnAliPay.selected = NO;
////        _selectPayView.btnQQ.selected = YES;
//        _selectPayView.btnWeiXin.selected = NO;
//    }
}

// 加方法
- (void) addBtnClick {
    
    
    if (_regionId == nil) {
        
        // 没选区域
        
        buyNum ++;
        _buyDetailView.buyNumViewNumLb.text = [NSString stringWithFormat:@"%ld",buyNum];
        _buyDetailView.buyNumLb.text = [NSString stringWithFormat:@"x%ld",buyNum];
        
    }else {
        
        // 已选区域
        buyNum ++;
        _buyDetailView.buyNumViewNumLb.text = [NSString stringWithFormat:@"%ld",buyNum];
        _buyDetailView.buyNumLb.text = [NSString stringWithFormat:@"x%ld",buyNum];
        // 先禁用,请求完成之后打开
        _buyDetailView.addBtn.userInteractionEnabled = NO;
        
        
        
        
        NSArray *arrForJiami = [GetUserJiaMi getUserTokenAndCgAndKey];
        
        HttpRequest *http = [[HttpRequest alloc] init];
        
        
        NSDictionary *dic = @{@"id":_id1,@"buyNum":[NSString stringWithFormat:@"%ld",buyNum],@"specItemIds":_specItemIds,@"subOrderId":_subOrderId,@"regionId":_regionId};
        NSString *dataJimihou = [[MakeJson createJson:dic] AES128EncryptWithKey:arrForJiami[3]];
        
        NSDictionary *dataDic = @{@"tk":arrForJiami[0],@"key":arrForJiami[1],@"cg":arrForJiami[2],@"data":dataJimihou};
        
        [http PostGetfastMailWithDataDic:dataDic Success:^(id arrForGoodsData) {
            
            if ([arrForGoodsData isKindOfClass:[NSString class]] && [arrForGoodsData isEqualToString:@"0"]) {
                
                // 请求失败,没有可匹配的
                [_buyDetailView.selectPeisongBtn setTitle:@"您所在的城市暂时不可配送" forState:UIControlStateNormal];
                // 打开按钮
                _buyDetailView.addBtn.userInteractionEnabled = YES;
                
            }else {
                
                // 添加单例
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setObject:[arrForGoodsData[0] objectForKey:@"shipTplId"] forKey:@"shipTplId"];
                
                NSDictionary *dicForFinalPrice = @{@"id":_id1,@"buyNum":[NSString stringWithFormat:@"%ld",buyNum],@"specItemIds":_specItemIds,@"subOrderId":_subOrderId,@"regionId":_regionId,@"shipTplId":[arrForGoodsData[0] objectForKey:@"shipTplId"]};
                NSString *strDataForFinalPrice = [[MakeJson createJson:dicForFinalPrice] AES128EncryptWithKey:arrForJiami[3]];
                
                // 要传的参数
                NSDictionary *dataDicForFinalPrice = @{@"tk":arrForJiami[0],@"key":arrForJiami[1],@"cg":arrForJiami[2],@"data":strDataForFinalPrice};
                
                // 请求数据计算商品最终价格
                [http PostGetGoodsFinalPriceWithDataDic:dataDicForFinalPrice Success:^(id arrForGoodsData) {
                    
                    if ([arrForGoodsData isKindOfClass:[NSString class]] && [arrForGoodsData isEqualToString:@"0"]) {
                        
                        // 请求失败
                        // 打开按钮
                        _buyDetailView.addBtn.userInteractionEnabled = YES;
                        
                    }else {
                        
                        // 请求成功
                        // 打开按钮
                        _buyDetailView.addBtn.userInteractionEnabled = YES;
                        
                        
                        _strEndPrice = [arrForGoodsData objectForKey:@"money_pay"];
                        
                        // label两种颜色字体
                        NSString *strPrice = [NSString stringWithFormat:@"实付: %@",_strEndPrice];
                        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:strPrice];
                        NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:@"实付:"].location, [[noteStr string] rangeOfString:@"实付:"].length);
                        //需要设置的位置
                        [noteStr addAttribute:NSForegroundColorAttributeName value:FUIColorFromRGB(0x999999) range:redRange];
                        [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:redRange];
                        [_buyDetailView.endPriceLb setAttributedText:noteStr];
                        
                        // label两种颜色字体
                        NSString *strPrice1 = [NSString stringWithFormat:@"实付: %@",_strEndPrice];
                        NSMutableAttributedString *noteStr1 = [[NSMutableAttributedString alloc] initWithString:strPrice1];
                        NSRange redRange1 = NSMakeRange([[noteStr1 string] rangeOfString:@"实付:"].location, [[noteStr1 string] rangeOfString:@"实付:"].length);
                        //需要设置的位置
                        [noteStr1 addAttribute:NSForegroundColorAttributeName value:FUIColorFromRGB(0x999999) range:redRange1];
                        [noteStr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:redRange1];
                        [_tijiaoPriceLabel setAttributedText:noteStr1];
                    }
                    
                } failure:^(NSError *error) {
                    
                    // 打开按钮
                    _buyDetailView.addBtn.userInteractionEnabled = YES;
                    
                }];
                
                
                
                _buyDetailView.selectPeisongBtn.userInteractionEnabled = YES;
                
                // 请求成功,有可匹配的
                [_buyDetailView.selectPeisongBtn setTitle:[NSString stringWithFormat:@"%@,运费:%@",[arrForGoodsData[0] objectForKey:@"ship"],[arrForGoodsData[0] objectForKey:@"money"]] forState:UIControlStateNormal];
                
                
                // 判断是否可送达，如果可送达，创建配送信息视图
                // 配送遮罩层
                _peisongZheZhao = [[ZheZhaoView alloc] initWithFrame:CGRectMake(0, 0, W, H - 64)];
                [self.view addSubview:_peisongZheZhao];
                _peisongZheZhao.hidden = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(peisongZheZhaoClick)];
                [_peisongZheZhao addGestureRecognizer:tap];
                
                // 配送webView
                _peisongDetailWeb = [[peisongWebView alloc] initWithFrame:CGRectMake(0, H + 64, W, W) WithWebUrl:[arrForGoodsData[0] objectForKey:@"ship_info"]];
                [self.view addSubview:_peisongDetailWeb];
                
            }
            
        } failure:^(NSError *error) {
            
            // 打开按钮
            _buyDetailView.addBtn.userInteractionEnabled = YES;
        }];
        
    }
}

// 减方法
- (void) subBtnClick {
    
    
    
    if (_regionId == nil) {
        
        // 没选区域
        if (buyNum > 1) {
            buyNum --;
            _buyDetailView.buyNumViewNumLb.text = [NSString stringWithFormat:@"%ld",buyNum];
            _buyDetailView.buyNumLb.text = [NSString stringWithFormat:@"x%ld",buyNum];
        }else {
            
            alert(@"不能再少了");
        }
        
        
    }else {
        
        // 已选区域
        if (buyNum > 1) {
            buyNum --;
            _buyDetailView.buyNumViewNumLb.text = [NSString stringWithFormat:@"%ld",buyNum];
            _buyDetailView.buyNumLb.text = [NSString stringWithFormat:@"x%ld",buyNum];
            // 减按钮不可使用
            _buyDetailView.subBtn.userInteractionEnabled = NO;
            
            
            NSArray *arrForJiami = [GetUserJiaMi getUserTokenAndCgAndKey];
            
            HttpRequest *http = [[HttpRequest alloc] init];
            
            NSDictionary *dic = @{@"id":_id1,@"buyNum":[NSString stringWithFormat:@"%ld",buyNum],@"specItemIds":_specItemIds,@"subOrderId":_subOrderId,@"regionId":_regionId};
            NSString *dataJimihou = [[MakeJson createJson:dic] AES128EncryptWithKey:arrForJiami[3]];
            
            NSDictionary *dataDic = @{@"tk":arrForJiami[0],@"key":arrForJiami[1],@"cg":arrForJiami[2],@"data":dataJimihou};
            
            // 获取快递价格
            [http PostGetfastMailWithDataDic:dataDic Success:^(id arrForGoodsData) {
                
                if ([arrForGoodsData isKindOfClass:[NSString class]]) {
                    
                    // 请求失败,没有可匹配的
                    [_buyDetailView.selectPeisongBtn setTitle:@"您所在的城市暂时不可配送" forState:UIControlStateNormal];
                    
                    // 减按钮可使用
                    _buyDetailView.subBtn.userInteractionEnabled = YES;
                    
                }else {
                    
                    
                    // 添加单例
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    [user setObject:[arrForGoodsData[0] objectForKey:@"shipTplId"] forKey:@"shipTplId"];
                    
                    NSDictionary *dicForFinalPrice = @{@"id":_id1,@"buyNum":[NSString stringWithFormat:@"%ld",buyNum],@"specItemIds":_specItemIds,@"subOrderId":_subOrderId,@"regionId":_regionId,@"shipTplId":[arrForGoodsData[0] objectForKey:@"shipTplId"]};
                    NSString *strDataForFinalPrice = [[MakeJson createJson:dicForFinalPrice] AES128EncryptWithKey:arrForJiami[3]];
                    
                    // 要传的参数
                    NSDictionary *dataDicForFinalPrice = @{@"tk":arrForJiami[0],@"key":arrForJiami[1],@"cg":arrForJiami[2],@"data":strDataForFinalPrice};
                    
                    // 请求数据计算商品最终价格
                    [http PostGetGoodsFinalPriceWithDataDic:dataDicForFinalPrice Success:^(id arrForGoodsData) {
                        
                        if ([arrForGoodsData isKindOfClass:[NSString class]] && [arrForGoodsData isEqualToString:@"0"]) {
                            
                            // 请求失败
                            // 减按钮可使用
                            _buyDetailView.subBtn.userInteractionEnabled = YES;
                            
                        }else {
                            
                            // 请求成功
                            // 减按钮可使用
                            _buyDetailView.subBtn.userInteractionEnabled = YES;
                            
                            
                            _strEndPrice = [arrForGoodsData objectForKey:@"money_pay"];
                            
                            // label两种颜色字体
                            NSString *strPrice = [NSString stringWithFormat:@"实付: %@",_strEndPrice];
                            NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:strPrice];
                            NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:@"实付:"].location, [[noteStr string] rangeOfString:@"实付:"].length);
                            //需要设置的位置
                            [noteStr addAttribute:NSForegroundColorAttributeName value:FUIColorFromRGB(0x999999) range:redRange];
                            [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:redRange];
                            [_buyDetailView.endPriceLb setAttributedText:noteStr];
                            
                            // label两种颜色字体
                            NSString *strPrice1 = [NSString stringWithFormat:@"实付: %@",_strEndPrice];
                            NSMutableAttributedString *noteStr1 = [[NSMutableAttributedString alloc] initWithString:strPrice1];
                            NSRange redRange1 = NSMakeRange([[noteStr1 string] rangeOfString:@"实付:"].location, [[noteStr1 string] rangeOfString:@"实付:"].length);
                            //需要设置的位置
                            [noteStr1 addAttribute:NSForegroundColorAttributeName value:FUIColorFromRGB(0x999999) range:redRange1];
                            [noteStr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:redRange1];
                            [_tijiaoPriceLabel setAttributedText:noteStr1];
                        }
                        
                    } failure:^(NSError *error) {
                        
                        // 减按钮可使用
                        _buyDetailView.subBtn.userInteractionEnabled = YES;
                        
                    }];
                    
                    
                    
                    _buyDetailView.selectPeisongBtn.userInteractionEnabled = YES;
                    
                    // 请求成功,有可匹配的
                    [_buyDetailView.selectPeisongBtn setTitle:[NSString stringWithFormat:@"%@,运费:%@",[arrForGoodsData[0] objectForKey:@"ship"],[arrForGoodsData[0] objectForKey:@"money"]] forState:UIControlStateNormal];
                    
                    
                    // 判断是否可送达，如果可送达，创建配送信息视图
                    // 配送遮罩层
                    _peisongZheZhao = [[ZheZhaoView alloc] initWithFrame:CGRectMake(0, 0, W, H - 64)];
                    [self.view addSubview:_peisongZheZhao];
                    _peisongZheZhao.hidden = YES;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(peisongZheZhaoClick)];
                    [_peisongZheZhao addGestureRecognizer:tap];
                    
                    // 配送webView
                    _peisongDetailWeb = [[peisongWebView alloc] initWithFrame:CGRectMake(0, H + 64, W, W) WithWebUrl:[arrForGoodsData[0] objectForKey:@"ship_info"]];
                    [self.view addSubview:_peisongDetailWeb];
                    
                }
                
            } failure:^(NSError *error) {
                
                // 减按钮可使用
                _buyDetailView.subBtn.userInteractionEnabled = YES;
            }];
            
        }else {
            alert(@"不能再少了");
        }
        
    }

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


// 监听处理事件
- (void)listen:(NSNotification *)noti {
    
    NSString *strNoti = noti.object;
    
    // 用户在侧栏进行了退出
    if ([strNoti isEqualToString:@"10"]) {
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *strRegionId = [user objectForKey:@"getStreetId"];
        
        self.regionId = strRegionId;
        
        
        [_orderAddressView.adressBtn setTitle:[NSString stringWithFormat:@"%@,%@,%@",[user objectForKey:@"shouhuoName"],[user objectForKey:@"shouhuoPhone"],[user objectForKey:@"shouhuoAddress"]] forState:UIControlStateNormal];
        
    
        // 已选区域

        NSLog(@"_regionId%@",_regionId);

        NSArray *arrForJiami = [GetUserJiaMi getUserTokenAndCgAndKey];

        HttpRequest *http = [[HttpRequest alloc] init];


        NSDictionary *dic = @{@"id":_id1,@"buyNum":[NSString stringWithFormat:@"%ld",buyNum],@"specItemIds":_specItemIds,@"subOrderId":_subOrderId,@"regionId":_regionId};
        NSString *dataJimihou = [[MakeJson createJson:dic] AES128EncryptWithKey:arrForJiami[3]];

        NSDictionary *dataDic = @{@"tk":arrForJiami[0],@"key":arrForJiami[1],@"cg":arrForJiami[2],@"data":dataJimihou};

        [http PostGetfastMailWithDataDic:dataDic Success:^(id arrForGoodsData) {

            if ([arrForGoodsData isKindOfClass:[NSString class]] && [arrForGoodsData isEqualToString:@"0"]) {

                // 请求失败,没有可匹配的
                [_buyDetailView.selectPeisongBtn setTitle:@"您所在的城市暂时不可配送" forState:UIControlStateNormal];

            }else {

                // 添加单例
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setObject:[arrForGoodsData[0] objectForKey:@"shipTplId"] forKey:@"shipTplId"];

                NSDictionary *dicForFinalPrice = @{@"id":_id1,@"buyNum":[NSString stringWithFormat:@"%ld",buyNum],@"specItemIds":_specItemIds,@"subOrderId":_subOrderId,@"regionId":_regionId,@"shipTplId":[arrForGoodsData[0] objectForKey:@"shipTplId"]};
                NSString *strDataForFinalPrice = [[MakeJson createJson:dicForFinalPrice] AES128EncryptWithKey:arrForJiami[3]];

                // 要传的参数
                NSDictionary *dataDicForFinalPrice = @{@"tk":arrForJiami[0],@"key":arrForJiami[1],@"cg":arrForJiami[2],@"data":strDataForFinalPrice};

                // 请求数据计算商品最终价格
                [http PostGetGoodsFinalPriceWithDataDic:dataDicForFinalPrice Success:^(id arrForGoodsData) {

                    if ([arrForGoodsData isKindOfClass:[NSString class]] && [arrForGoodsData isEqualToString:@"0"]) {

                        // 请求失败

                    }else {

                        // 请求成功
                        _strEndPrice = [arrForGoodsData objectForKey:@"money_pay"];

                        // label两种颜色字体
                        NSString *strPrice = [NSString stringWithFormat:@"实付: %@",_strEndPrice];
                        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:strPrice];
                        NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:@"实付:"].location, [[noteStr string] rangeOfString:@"实付:"].length);
                        //需要设置的位置
                        [noteStr addAttribute:NSForegroundColorAttributeName value:FUIColorFromRGB(0x999999) range:redRange];
                        [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:redRange];
                        [_buyDetailView.endPriceLb setAttributedText:noteStr];

                        // label两种颜色字体
                        NSString *strPrice1 = [NSString stringWithFormat:@"实付: %@",_strEndPrice];
                        NSMutableAttributedString *noteStr1 = [[NSMutableAttributedString alloc] initWithString:strPrice1];
                        NSRange redRange1 = NSMakeRange([[noteStr1 string] rangeOfString:@"实付:"].location, [[noteStr1 string] rangeOfString:@"实付:"].length);
                        //需要设置的位置
                        [noteStr1 addAttribute:NSForegroundColorAttributeName value:FUIColorFromRGB(0x999999) range:redRange1];
                        [noteStr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:redRange1];
                        [_tijiaoPriceLabel setAttributedText:noteStr1];
                    }

                } failure:^(NSError *error) {



                }];



                _buyDetailView.selectPeisongBtn.userInteractionEnabled = YES;

                // 请求成功,有可匹配的
                [_buyDetailView.selectPeisongBtn setTitle:[NSString stringWithFormat:@"%@,运费:%@",[arrForGoodsData[0] objectForKey:@"ship"],[arrForGoodsData[0] objectForKey:@"money"]] forState:UIControlStateNormal];
                
                
                // 判断是否可送达，如果可送达，创建配送信息视图
                // 配送遮罩层
                _peisongZheZhao = [[ZheZhaoView alloc] initWithFrame:CGRectMake(0, 0, W, H - 64)];
                [self.view addSubview:_peisongZheZhao];
                _peisongZheZhao.hidden = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(peisongZheZhaoClick)];
                [_peisongZheZhao addGestureRecognizer:tap];
                
                // 配送webView
                _peisongDetailWeb = [[peisongWebView alloc] initWithFrame:CGRectMake(0, H + 64, W, W) WithWebUrl:[arrForGoodsData[0] objectForKey:@"ship_info"]];
                [self.view addSubview:_peisongDetailWeb];
                
            }
            
        } failure:^(NSError *error) {
            
            
        }];
        
        
        // 销毁侧栏退出的通知
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadAddress" object:@"10"];
    }
}

// 界面将要消失
- (void) viewWillDisappear:(BOOL)animated {
    
    
    //这个接口可以动画的改变statusBar的前景色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    // 打开手势返回
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    
    // 清除已选择的地址的相关信息
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"getStreetId"];
    [user removeObjectForKey:@"addressId"];
    [user removeObjectForKey:@"shouhuoName"];
    [user removeObjectForKey:@"shouhuoPhone"];
    [user removeObjectForKey:@"shouhuoAddress"];
    [user removeObjectForKey:@"shipTplId"];
    
}

// 页面将要显示
- (void) viewWillAppear:(BOOL)animated {
    
    // 打开手势返回
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    //相对于上面的接口，这个接口可以动画的改变statusBar的前景色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    // 接收消息
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    // 侧栏退出
    [notiCenter addObserver:self selector:@selector(listen:) name:@"reloadAddress" object:@"10"];
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
