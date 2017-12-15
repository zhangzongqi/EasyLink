//
//  GroupDetailViewController.m
//  EasyLink
//
//  Created by 琦琦 on 17/2/8.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "GroupDetailViewController.h"
#import "SDCycleScrollView.h" // banner滚动图
#import "MZTimerLabel.h" // 倒计时库
#import "AdressAndNumView.h" // 送至/已选视图
#import "GroupDetailBottomView.h" // 底部视图


#import "EvaluateCollectionViewCell.h" // 评价的cell
#import "PingjiaDetailViewController.h" // 评价详情
#import "SelectGuiGeView.h" // 筛选规格
#import "ZheZhaoView.h" // 遮罩层
#import "MineFocusOnViewController.h" // 我的关注
#import "OrderSureViewController.h" // 确认订单页面

#import "AddressSelectView.h" // 地址选择视图

#import "AllPingJiaTableViewCell.h" // 评价cell

#import "GroupBuyDetailModel.h" // 模型

#import "FastMailView.h" // 物流信息view
#import "peisongWebView.h" // 配送WebView

// 分享的相关库
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface GroupDetailViewController ()<SDCycleScrollViewDelegate,MZTimerLabelDelegate,NSURLSessionDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource> {
    
    // 右按钮
    UIImageView *_menuImgView;
    
    // 右按钮下方视图
    UIView *_menuBottomView;
    
    // 遮罩层
    UIView *_zhezhaoView;
    
    // 底层滚动图
    UIScrollView *_bigScrollView;
    
    // 顶部橱窗滚动图
    SDCycleScrollView *bannerView;
    
    // 商品名
    UILabel *lbGoodsName;
    
    // 开团状态和价格
    UILabel *_lbForStatusPrice;
    
    // 筛选视图
    SelectGuiGeView *_selectGuigevc;
    
    // 筛选遮罩层
    ZheZhaoView *_shaiXuanZhezhao;
    
    // 地址遮罩层
    ZheZhaoView *_dizhiZheZhao;
    
    // 配送详情遮罩层
    ZheZhaoView *_peisongZheZhao;
    
    // 查看全部评价
    UIView *_morePingjiaview;
    
    NSInteger _buyNum;
    
    NSMutableArray *_tableViewArr; // 列表的数据
    
    CGFloat _tableViewHeight; // 列表的高度
    
    // 规格参数列表数组
    NSArray *_specListArr;
    // 组合价格列表数组
    NSArray *_specItemPriceListArr;
    
    // 上部分详情信息
    NSDictionary *_detailDic;
    
    // html数据
    NSString *_strHtml;
    // 网页
    UIWebView *_webview;
    
}


@property (nonatomic, strong) UILabel *lbForss; // 秒
@property (nonatomic, strong) UILabel *lbFormm; // 分
@property (nonatomic, strong) UILabel *lbForHH; // 时
@property (nonatomic, strong) UILabel *maohaoLb1; // 冒号label1
@property (nonatomic, strong) UILabel *maohaoLb2; // 冒号label2
@property (nonatomic, strong) UILabel *lbForWaitDay; // 倒计时天数
@property (nonatomic, strong) UIImageView * progressImgView; // 进度条图片
@property (nonatomic, strong) UILabel *currentPeople; // 当前人数
@property (nonatomic, strong) UILabel *MaxPeopleLb; // 成团人数
@property (nonatomic, strong) UILabel *pingjiaNumLb; // 评价数量Label
@property (nonatomic, strong) UILabel *goodPingjiaLb; // 好评率label



@property (nonatomic, copy) UITableView *tableView; // 列表

@property (nonatomic, copy) GroupDetailBottomView * bottomVC; // 底部视图


// 送至/已选视图
@property (nonatomic, copy) AdressAndNumView *addressAndNumView;
// 地址选择视图
@property (nonatomic, copy) AddressSelectView *addressSelectVc;
@property (nonatomic, strong) FastMailView *fastMailView; // 物流信息视图

@property (nonatomic, strong) peisongWebView *peisongDetailWeb; // 配送详细网页

@end

@implementation GroupDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置导航栏标题
    UILabel *lbItemTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    lbItemTitle.text = @"商品详情";
    lbItemTitle.textColor = FUIColorFromRGB(0x212121);
    lbItemTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lbItemTitle;
    
    // 背景色
    self.view.backgroundColor = FUIColorFromRGB(0xffffff);
    
    _tableViewHeight = 1;
    
    // 添加浏览历史
    [self addHis];
    
    // 初始化数据源
    [self initDataSource];
    
    // 返回按钮
    [self createBackBtn];
    
    // 导航栏右侧按钮
    [self createRightBtn];
    
    // 布局UI
    [self createUI];
    
    // 获取数据
    [self initData];
}

// 添加浏览历史
- (void) addHis {
    
    // 判断是否登录
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
        
        
        // 获取当前时间戳，转换成json类型，并用AES进行加密,并做了base64及urlcode转码处理
        NSDate *senddate = [NSDate date];
        NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
        NSDictionary *cgDic = @{@"requestTime":date2};
        // 最终加密好的cg参数的密文
        NSString *cgMiWenStr = [[MakeJson createJson:cgDic] AES128EncryptWithKey:strAESkey];
        
        // 用户token
        NSString *userToken = [user objectForKey:@"token"];
        
        NSDictionary *dicData = @{@"type":@"11",@"dataId":_goodsId};
        NSString *strDic = [MakeJson createJson:dicData];
        NSString *strData = [strDic AES128EncryptWithKey:strAESkey];
        
        NSDictionary *dataDic = @{@"tk":userToken,@"key":keyMiWenStr,@"cg":cgMiWenStr,@"data":strData};
        
        
        HttpRequest *http = [[HttpRequest alloc] init];
        [http PostAddHisWithDic:dataDic Success:^(id userInfo) {
            
            // 请求成功，添加历史浏览成功
            
        } failure:^(NSError *error) {
            
            // 请求失败
        }];
    }
}

// 初始化数据源
- (void) initDataSource {
    
    // 保存得到的上部分详情信息
    _detailDic = [NSDictionary dictionary];
    
    // 规格参数列表数组
    _specListArr = [NSArray array];
    // 组合价格列表数组
    _specItemPriceListArr = [NSArray array];
    
    // 推荐评价列表数据
    _tableViewArr = [NSMutableArray array];
    
    _buyNum = 1;
}

// 获取数据
- (void) initData {
    
    // 创建单例
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *strTk = [user objectForKey:@"token"];
    
    // 创建网络请求对象
    HttpRequest *http = [[HttpRequest alloc] init];
    
    
    
    
    // 处理收藏
    if (strTk == nil) {
        
    }else {
        
        // 创建单例,获取到用户RSAKey
        NSString *userRsaPublicKey = [user objectForKey:@"severPublicKey"];
        
        // 生成一个16位的AES的key,并保存用于解密服务器返回的信息
        NSString *strAESkey = [NSString set32bitString:16];
        [user setObject:strAESkey forKey:@"aesKey"];
        // 最终加密好的key参数的密文
        NSString *keyMiWenStr = [RSAEncryptor encryptString:strAESkey publicKey:userRsaPublicKey];
        
        // 获取当前时间戳，转换成json类型，并用AES进行加密,并做了base64及urlcode转码处理
        NSDate *senddate = [NSDate date];
        NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
        NSDictionary *cgDic = @{@"requestTime":date2};
        // 最终加密好的cg参数的密文
        NSString *cgMiWenStr = [[MakeJson createJson:cgDic] AES128EncryptWithKey:strAESkey];
        
        // 用户token
        NSString *userToken = [user objectForKey:@"token"];
        
        
        // 创建要发送的字典
        NSDictionary *dicData = @{@"tk":userToken,@"key":keyMiWenStr,@"cg":cgMiWenStr};
        
        // 拿到全部收藏
        [http PostUserAllFavDic:dicData Success:^(id GetData) {
            
            NSDictionary *dic = @{@"type":@"11",@"data_id":_goodsId};
            
            if ([GetData isKindOfClass:[NSString class]]) {
                
                // status为0  获取全部收藏失败
            }
            if ([GetData isKindOfClass:[NSArray class]]) {
                
                // status不为0,且返回的是数组  获取全部收藏成功，去比对
                if ([GetData containsObject:dic]) {
                    
                    _bottomVC.guanzhuBtn.selected = YES;
                }else {
                    _bottomVC.guanzhuBtn.selected = NO;
                }
            }
            
            
        } failure:^(NSError *error) {
            
            // 获取数据失败
        }];
    }
    
    
    
    
    
    
    
    
    // 请求详情数据
    [http GetGoodsDetailDataForId:_goodsId Success:^(id arrForGoodsData) {
        
        _specItemPriceListArr = [arrForGoodsData objectForKey:@"specItemPriceList"];
        
        // 获取全部分类
        NSMutableArray *arrForSpecList = [arrForGoodsData objectForKey:@"specList"];
        
        NSMutableArray *tempArr = [arrForGoodsData objectForKey:@"specList"];
        
        
        // 剔除没有组合的分类项
        for (int i = 0; i < tempArr.count; i++) {
            
            
            NSArray *tempArr2 = [tempArr[i] objectForKey:@"spec_item_list"];
            
            
            for (int j = 0; j < tempArr2.count; j++) {
                
                NSString *id2 = [NSString stringWithFormat:@"_%@_",[tempArr2[j] objectForKey:@"id"]];
                
                NSMutableArray *arrIdTemp = [[NSMutableArray alloc] init];
                
                for (int k = 0; k < [[arrForGoodsData objectForKey:@"specItemPriceList"] count]; k++) {
                    
                    NSString *strTemp = [NSString stringWithFormat:@"_%@_",[[arrForGoodsData objectForKey:@"specItemPriceList"][k] objectForKey:@"spec_item_ids"]];
                    
                    if ([strTemp containsString:id2]) {
                        
                        [arrIdTemp addObject:id2];
                        
                    }else {
                        
                    }
                    
                }
                
                if ([arrIdTemp containsObject:id2]) {
                    
                    // 包含,不用管
                    
                }else {
                    
                    // 不包含,删除这个小项
                    [[arrForSpecList[i] objectForKey:@"spec_item_list"] removeObject:[tempArr[i] objectForKey:@"spec_item_list"][j]];
                    
                    j--;
                }
            }
            
            
            if ([[arrForSpecList[i] objectForKey:@"spec_item_list"] count] == 0) {
                
                [arrForSpecList removeObject:arrForSpecList[i]];
                
                i--;
            }
        }
        
        // 筛选完没有匹配项之后的list
        _specListArr = tempArr;
        
        NSLog(@"_specListArr%@",_specListArr);
        
        
        // 保存上半部分的信息
        _detailDic = arrForGoodsData;
        
        // 创建规格筛选视图
        [self createGuigeSelectView];
        
        // 商品名
        lbGoodsName.text = [arrForGoodsData objectForKey:@"title"];
        // 成团人数
        _MaxPeopleLb.text = [NSString stringWithFormat:@"%@",[arrForGoodsData objectForKey:@"low_sale_num_limit"]];
        
        // 滚动图图片数组,有图组添加图组;没有,添加图片
        if ([[arrForGoodsData objectForKey:@"img_show"] count] == 0) {
            
            NSDictionary *dic = [arrForGoodsData objectForKey:@"img_multi"];
            NSString *str = [dic objectForKey:@"app_list"];
            
            
            if (str.length == 0) {
                
                // 没图片
                
            }else {
                
                NSArray *arrImg = @[str];
                // 有图片
                bannerView.imageURLStringsGroup = arrImg;
            }
            
            
        }else {
            
            bannerView.imageURLStringsGroup = [arrForGoodsData objectForKey:@"img_show"];
        }
        
        
        
        
        if ([_strStatus isEqualToString:@"1"]) {
            
            // 拼团中
            
            // 价格
            _lbForStatusPrice.text = [NSString stringWithFormat:@"成团价:%@~%@",[_detailDic objectForKey:@"low_price"],[_detailDic objectForKey:@"high_price"]];
            
            
            // 倒计时
            [self timeCount:_lbForWaitDay andTime:[self getDifferForTime:[_detailDic objectForKey:@"end_datetime"]]];
            
//            NSLog(@"kankanshijian a a a a%@",[NSString stringWithFormat:@"%@",[_detailDic objectForKey:@"end_datetime"]]);
//            NSLog(@"%@",_detailDic);
            // 设置进度条长度
            CGFloat progessWidth = [self calculateWidthForMaxNum:[[_detailDic objectForKey:@"low_sale_num_limit"] integerValue] * 3 andCurrentNum:[[_detailDic objectForKey:@"sale_num"] integerValue]];
//            NSLog(@"%f",progessWidth);
            _progressImgView.size = CGSizeMake(progessWidth, 12);
            // 设置背景色(用到了UIImage+GradientColor.h这个类扩展)
            UIColor *leftColor1 = FUIColorFromRGB(0x7766fd);
            UIColor *rightColor1 = FUIColorFromRGB(0xf779ff);
            UIImage *bgImg1 = [UIImage gradientColorImageFromColors:@[leftColor1, rightColor1] gradientType:GradientTypeLeftToRight imgSize:_progressImgView.size];
            _progressImgView.backgroundColor = [UIColor colorWithPatternImage:bgImg1];
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
            _progressImgView.image = image2;
            // 当前人数
            _currentPeople.text = [NSString stringWithFormat:@"%@人",[_detailDic objectForKey:@"sale_num"]];
            
        }else {
            
            // 未开团
            
            // 根据开始时间戳算剩余时间
            NSDateComponents *dateCom = [self getDifferTime:[_detailDic objectForKey:@"start_datetime"]];
            if (dateCom.day >= 1) {
                
                _lbForWaitDay.hidden = NO;
                _lbForHH.hidden = YES;
                _lbForss.hidden = YES;
                _lbFormm.hidden = YES;
                _maohaoLb2.hidden = YES;
                _maohaoLb1.hidden = YES;
                _lbForWaitDay.text = [NSString stringWithFormat:@"%ld天%ld小时%ld分钟",dateCom.day,dateCom.hour,dateCom.minute];
            }else {
                
                // 时分秒
                [self timeCountForWaitForHH:_lbForHH andTime:[self getDifferForTime:[_detailDic objectForKey:@"start_datetime"]]];
                [self timeCountForWaitForMM:_lbFormm andTime:[self getDifferForTime:[_detailDic objectForKey:@"start_datetime"]]];
                [self timeCountForWaitForSS:_lbForss andTime:[self getDifferForTime:[_detailDic objectForKey:@"start_datetime"]]];
            }
        }
        
        
        
        
        
    } failure:^(NSError *error) {
        
        // 数据请求失败
    }];
    
    
    
    // 请求推荐评价
    [http GetTuijianPingjiaDataFromId:[self.pingjiaId integerValue] Success:^(id arrForList) {
            
        if ([arrForList isKindOfClass:[NSString class]]) {
                
            // 获取数据失败
            
            // 删除所有数据
            [_tableViewArr removeAllObjects];
            // 刷新列表
            [_tableView reloadData];
            
            _morePingjiaview.sd_layout
            .topSpaceToView(_tableView, 1)
            .leftEqualToView(self.view)
            .widthIs(W)
            .heightIs(W * 0.09375 + 1);
                
        }else {
            
            // 评价数量
            _pingjiaNumLb.text = [NSString stringWithFormat:@"评价[%ld]",[[arrForList objectForKey:@"count"] integerValue]];
            // 好评率
            if ([[arrForList objectForKey:@"count"] integerValue] == 0) {
                
                NSString *strPrice = [NSString stringWithFormat:@"%@ 好评",@"100%"];
                NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:strPrice];
                NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:@"好评"].location, [[noteStr string] rangeOfString:@"好评"].length);
                //需要设置的位置
                [noteStr addAttribute:NSForegroundColorAttributeName value:FUIColorFromRGB(0x999999) range:redRange];
                [_goodPingjiaLb setAttributedText:noteStr];
            }else {
                NSString *strPrice = [NSString stringWithFormat:@"%f 好评",[[arrForList objectForKey:@"five_star"] floatValue] / [[arrForList objectForKey:@"count"] floatValue]];
                NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:strPrice];
                NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:@"好评"].location, [[noteStr string] rangeOfString:@"好评"].length);
                //需要设置的位置
                [noteStr addAttribute:NSForegroundColorAttributeName value:FUIColorFromRGB(0x999999) range:redRange];
                [_goodPingjiaLb setAttributedText:noteStr];
            }
            
            
            
            
            // 获取数据成功
            [_tableViewArr removeAllObjects];
            
            _tableViewArr = [PingJiaModel arrayOfModelsFromDictionaries:[arrForList objectForKey:@"list"] error:nil];
            
            
            for (int i = 0; i < _tableViewArr.count; i++) {
                
                PingJiaModel *model = _tableViewArr[i];
                
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
                
//                NSLog( @"=============%f",heigeht);
                
                if (model.img_show.count == 0) {
                    
                    _tableViewHeight = _tableViewHeight + heigeht + 0.034375 * W;
                    
                    
                }else {
                    
                    _tableViewHeight = _tableViewHeight + heigeht + W * 0.26875;
                }
            }
            
            _tableView.sd_layout
            .heightIs(_tableViewHeight);
            
            _tableView.scrollEnabled = NO; // 禁止tableview可以滚动
            
            _morePingjiaview.sd_layout
            .topSpaceToView(_tableView, 1)
            .leftEqualToView(self.view)
            .widthIs(W)
            .heightIs(W * 0.09375 + 1);
            
            [_tableView layoutIfNeeded];
            
            // 刷新列表
            [_tableView reloadData];
        }
            
    } failure:^(NSError *error) {
        
        NSLog(@"解析失败");
    }];
    
    
    
    
    // 请求下部分Html数据
    [http GetGoodsDetatilHtmlDataForId:_goodsId Success:^(id goodsHtmlData) {
        
        // 保存html需要的数据
        _strHtml = goodsHtmlData;
        
        // 设置webView的本地路径
        NSString *path = [[[NSBundle mainBundle] bundlePath]  stringByAppendingPathComponent:@"detail.html"];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
        [_webview loadRequest:request];
        
        self.context = [_webview valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        // 打印异常
        self.context.exceptionHandler =
        ^(JSContext *context, JSValue *exceptionValue)
        {
            context.exception = exceptionValue;
            NSLog(@"%@", exceptionValue);
        };
        
        // 以 JSExport 协议关联 obj 的方法
        self.context[@"obj"] = self;
        
    } failure:^(NSError *error) {
        
        // 网络错误,请求失败
    }];
    
}


// html内部加载完成方法
- (void) loadData {
    
    NSString *str1 = [NSString stringWithFormat:@"showDetail('%@')",[self strReplace:_strHtml]];
    NSString *alertJS=str1; //准备执行的js代码
    [self.context evaluateScript:alertJS];//通过oc方法调用js的alert
}


// 替换字符串中某一段
- (NSString *) strReplace:(NSString *)str {
    
    // 替换字符串
    NSString *str1 = [str stringByReplacingOccurrencesOfString:@"/ueditor/php/upload/image/" withString:@"http://app.huopinb.com/ueditor/php/upload/image/"];
    
    return str1;
    
}


#pragma mark -----WebViewDelegate
- (void) webViewDidFinishLoad:(UIWebView *)webView {
    
    CGFloat sizeHeight = [[_webview stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    
    // 让网页不能滚动
    [(UIScrollView *)[[_webview subviews] objectAtIndex:0] setScrollEnabled:NO];
    
    // 布局网页
    CGSize size = _webview.frame.size;
    size.height = sizeHeight ;
    
    _webview.frame = CGRectMake(0, _morePingjiaview.frame.origin.y + _morePingjiaview.frame.size.height + 1, W, size.height);
    
    // 布局底层滚动图
    _bigScrollView.contentSize = CGSizeMake(W, _webview.frame.size.height + _webview.frame.origin.y + 49);
}





// 导航栏右侧按钮和视图
- (void) createRightBtn {
    
    // 右侧按钮
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 28, 23);
    menuBtn.imageView.sd_layout
    .topSpaceToView(menuBtn,2.5)
    .rightSpaceToView(menuBtn,0)
    .widthIs(5)
    .heightIs(18);
    [menuBtn setImage:[UIImage imageNamed:@"details_combo"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    menuBtn.selected = NO;
    menuBtn.tag = 1;
    
    // 遮罩层
    _zhezhaoView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, W, H-64)];
    [self.navigationController.view addSubview:_zhezhaoView];
    _zhezhaoView.backgroundColor = [UIColor blackColor];
    _zhezhaoView.alpha = 0.5;
    _zhezhaoView.hidden = YES;
    // 遮罩层点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zhezhaoClick)];
    [_zhezhaoView addGestureRecognizer:tap];
    
    // 右侧按钮点击后图片
    _menuImgView = [[UIImageView alloc] init];
//    [self.navigationController.view addSubview:_menuImgView];
    [self.tabBarController.view addSubview:_menuImgView];
    [_menuImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (iPhone6SP) {
            
            // 6SP
            make.right.equalTo(self.navigationController.view).with.offset(- 3.5);
            
        }else if (iPhone6S) {
            
            // 6S
            make.right.equalTo(self.navigationController.view).with.offset(- 1.8);
            
        }else {
            // 5S
            make.right.equalTo(self.navigationController.view).with.offset(- 1);
        }
        make.bottom.equalTo(self.navigationController.view.mas_top).with.offset(64);
        make.width.equalTo(@(120.32));
        make.height.equalTo(@(42.24));
    }];
    _menuImgView.image = [UIImage imageNamed:@"details_combo_background8"];
    _menuImgView.hidden = YES;
    
    // 按钮改变图片
    UIImageView *imgView = [[UIImageView alloc] init];
    [_menuImgView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_menuImgView).with.offset(10.8);
        make.right.equalTo(_menuImgView).with.offset(- 15.75);
        make.width.equalTo(@(5));
        make.height.equalTo(@(18));
    }];
    imgView.image = [UIImage imageNamed:@"details_combo2"];
    
    // menu下面拼接视图
    _menuBottomView = [[UIView alloc] init];
    [self.tabBarController.view addSubview:_menuBottomView];
    [_menuBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_menuImgView.mas_bottom).with.offset(-5);
        make.centerX.equalTo(_menuImgView);
        make.width.equalTo(@(102));
        make.height.equalTo(@(113));
    }];
    _menuBottomView.backgroundColor = [UIColor whiteColor];
    _menuBottomView.hidden = YES;
    _menuBottomView.layer.cornerRadius = 5;
    _menuBottomView.clipsToBounds = YES;
    
    
    NSArray *arrForBtnTitle = @[@"分享",@"我的关注",@"首页"];
    for (int i = 0; i < 3; i++) {
        // 按钮
        UIButton *btn = [[UIButton alloc] init];
        [_menuBottomView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_menuBottomView).with.offset(37.5 * i);
            make.centerX.equalTo(_menuBottomView);
            make.height.equalTo(@(37.5));
            make.width.equalTo(_menuBottomView);
        }];
        btn.titleLabel.sd_layout
        .centerXEqualToView(btn)
        .centerYEqualToView(btn);
        [btn setTitle:arrForBtnTitle[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:77/255.0 green:78/255.0 blue:79/255.0 alpha:1.0] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 10+i;
        
        // 分隔线
        if (i < 2) {
            UILabel *lbFenge = [[UILabel alloc] init];
            [_menuBottomView addSubview:lbFenge];
            [lbFenge mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_menuBottomView).with.offset(37.5 * (i+1));
                make.centerX.equalTo(_menuBottomView);
                make.width.equalTo(@(71.6));
                make.height.equalTo(@(1));
            }];
            lbFenge.backgroundColor = FUIColorFromRGB(0xeeeeee);
        }
    }
}

// 选择按钮的点击事件
- (void) selectBtnClick:(UIButton *) btn {
    
    
    UIButton *rightBtn = [self.navigationController.view viewWithTag:1];
    
    switch (btn.tag) {
        case 10: {
            
            // 分享
            
            // 关闭弹出视图和遮罩层
            // 调用右侧按钮点击事件
            [self rightBtnClick:rightBtn];
            
            // 分享方法调用
            [self shareClick:rightBtn];
        }
            break;
        case 11: {
            
            // 我的关注
            NSLog(@"关注");
//            alert(@"关注");
            // 关闭弹出视图和遮罩层
            // 调用右侧按钮点击事件
            [self rightBtnClick:rightBtn];
            
            MineFocusOnViewController *vc = [[MineFocusOnViewController alloc] init];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 12: {
            
            // 首页
            NSLog(@"首页");
//            alert(@"首页");
            // 关闭弹出视图和遮罩层
            // 调用右侧按钮点击事件
            [self rightBtnClick:rightBtn];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}

// 遮罩层点击事件
- (void) zhezhaoClick {
    
    // 调用右侧按钮点击
    UIButton *btn = [self.navigationController.view viewWithTag:1];
    [self rightBtnClick:btn];
}

// 右侧按钮点击事件
- (void) rightBtnClick:(UIButton *)menuBtn {
    
    if (menuBtn.selected == NO) {
        
        // 未选中、改为选中状态
        menuBtn.selected = YES;
        
        _zhezhaoView.hidden = NO;
        _menuImgView.hidden = NO;
        _menuBottomView.hidden = NO;
        
    }else {
        
        // 选中了、改为未选中状态
        menuBtn.selected = NO;
        
        _zhezhaoView.hidden = YES;
        _menuImgView.hidden = YES;
        _menuBottomView.hidden = YES;
    }
}


// 布局UI
- (void) createUI {
    
    // 导航栏下面的黑线
    UILabel *navBarShadow = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, W, 1)];
    navBarShadow.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:239/255.0 alpha:1.0];
    [self.view addSubview:navBarShadow];
    
    // 底层滚动图
    _bigScrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_bigScrollView];
    [_bigScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(1);
        make.left.equalTo(self.view);
        make.width.equalTo(@(W));
        make.height.equalTo(@(H - 64 - 1));
    }];
    
    bannerView = [[SDCycleScrollView alloc] init];
    [_bigScrollView addSubview:bannerView];
    [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bigScrollView);
        make.left.equalTo(_bigScrollView);
        make.width.equalTo(@(W));
        make.height.equalTo(@(W * 0.578125));
    }];
    NSArray *imagesURLStrings = nil;
    
    bannerView.imageURLStringsGroup = imagesURLStrings;
    bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    bannerView.delegate = self;
    bannerView.currentPageDotColor = [UIColor redColor]; // 自定义分页控件小圆标颜色
//    bannerView.pageDotColor = FUIColorFromRGB(0xeeeeee);
    bannerView.placeholderImage = [UIImage imageNamed:@"placeholder"];
    
    // 商品名
    lbGoodsName = [[UILabel alloc] init];
    [_bigScrollView addSubview:lbGoodsName];
    [lbGoodsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bannerView.mas_bottom).with.offset(W * 0.028125);
        make.left.equalTo(self.view).with.offset(0.03125 * W);
        make.right.equalTo(self.view).with.offset(-0.03125 * W);
        make.height.equalTo(@(16));
    }];
    lbGoodsName.font = [UIFont systemFontOfSize:16];
    lbGoodsName.textColor = FUIColorFromRGB(0x212121);
    
    // 拼团价格和进度/(即将开团敬请期待)
    UIView *viewForTimeandProgress = [[UIView alloc] init];
    [_bigScrollView addSubview:viewForTimeandProgress];
    [viewForTimeandProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbGoodsName.mas_bottom);
        make.left.equalTo(_bigScrollView);
        make.width.equalTo(@(W));
        make.height.equalTo(@(W * 0.215625));
    }];
    // 136
    if ([_strStatus isEqualToString:@"1"]) {
        
        // 拼团中
        
        // 提示语(成团价格)
        if (!_lbForStatusPrice) {
            _lbForStatusPrice = [[UILabel alloc] init];
        }
        [viewForTimeandProgress addSubview:_lbForStatusPrice];
        [_lbForStatusPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(viewForTimeandProgress).with.offset(W * 0.215625 * 0.220588);
            make.left.equalTo(lbGoodsName);
            make.height.equalTo(@(14));
        }];
        _lbForStatusPrice.font = [UIFont systemFontOfSize:14];
        _lbForStatusPrice.textColor = FUIColorFromRGB(0xff5571);
        
        // 倒计时视图
        UIView *viewForTime = [[UIView alloc] init];
        [viewForTimeandProgress addSubview:viewForTime];
        [viewForTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_lbForStatusPrice);
            make.height.equalTo(@(W * 0.215625 * 0.44));
            make.width.equalTo(@(W * 0.25));
            make.right.equalTo(self.view).with.offset(- 0.03125 * W);
        }];
        
        
        // 倒计时天数
        _lbForWaitDay = [[UILabel alloc] init];
        [viewForTime addSubview:_lbForWaitDay];
        [_lbForWaitDay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(viewForTime);
            make.right.equalTo(self.view).with.offset(- 0.03125 * W);
            make.height.equalTo(@(12));
        }];
        _lbForWaitDay.font = [UIFont systemFontOfSize:12];
        _lbForWaitDay.textColor = FUIColorFromRGB(0x8e7eff);
        
        // 提示开团倒计时
        UILabel *lbTip = [[UILabel alloc] init];
        [viewForTimeandProgress addSubview:lbTip];
        [lbTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(viewForTime);
            make.right.equalTo(viewForTime.mas_left);
            make.height.equalTo(@(12));
            
        }];
        lbTip.textColor = FUIColorFromRGB(0x999999);
        lbTip.text = @"活动倒计时";
        lbTip.font = [UIFont systemFontOfSize:12];
        
        // 进度条底层颜色
        UILabel *progressBgLb = [[UILabel alloc] init];
        [viewForTimeandProgress addSubview:progressBgLb];
        [progressBgLb mas_makeConstraints:^(MASConstraintMaker *make) {
            if (iPhone6SP) {
                make.top.equalTo(viewForTime.mas_bottom).with.offset(5);
            }else if (iPhone6S) {
                make.top.equalTo(viewForTime.mas_bottom).with.offset(3);
            }else {
                make.top.equalTo(viewForTime.mas_bottom).with.offset(1);
            }
            make.left.equalTo(lbGoodsName);
            make.right.equalTo(lbGoodsName);
            make.height.equalTo(@(12));
        }];
        progressBgLb.backgroundColor = FUIColorFromRGB(0xe9e9e9);
        progressBgLb.layer.cornerRadius = 6;
        progressBgLb.clipsToBounds = YES;
        
        // 进度条图片
        _progressImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 12)];
        [progressBgLb addSubview:_progressImgView];
        
        // 当前人数
        _currentPeople = [[UILabel alloc] init];
        [_progressImgView addSubview:_currentPeople];
        [_currentPeople mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_progressImgView);
            make.right.equalTo(_progressImgView);
            make.height.equalTo(@(12));
        }];
        _currentPeople.textColor = FUIColorFromRGB(0xffffff);
        _currentPeople.font = [UIFont systemFontOfSize:12];
        
        // 单个小人图片(不用动)
        UIImageView *smallImgView = [[UIImageView alloc] init];
        [viewForTimeandProgress addSubview:smallImgView];
        [smallImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(progressBgLb);
            if (iPhone6SP) {
                make.height.equalTo(@(12));
                make.width.equalTo(@(12));
                make.top.equalTo(progressBgLb.mas_bottom).with.offset(7);
            }else if (iPhone6S) {
                make.height.equalTo(@(11));
                make.width.equalTo(@(11));
                make.top.equalTo(progressBgLb.mas_bottom).with.offset(6);
            }else {
                make.height.equalTo(@(10));
                make.width.equalTo(@(10));
                make.top.equalTo(progressBgLb.mas_bottom).with.offset(5);
            }
        }];
        smallImgView.image = [UIImage imageNamed:@"home_user1"];
        // 0人label
        UILabel *lbZero = [[UILabel alloc] init];
        [viewForTimeandProgress addSubview:lbZero];
        [lbZero mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(smallImgView);
            if (iPhone6SP) {
                make.left.equalTo(smallImgView.mas_right).with.offset(4);
                make.height.equalTo(@(12));
                lbZero.font = [UIFont systemFontOfSize:12];
            }else if (iPhone6S) {
                make.left.equalTo(smallImgView.mas_right).with.offset(3);
                make.height.equalTo(@(11));
                lbZero.font = [UIFont systemFontOfSize:11];
            }else {
                make.left.equalTo(smallImgView.mas_right).with.offset(2);
                make.height.equalTo(@(10));
                lbZero.font = [UIFont systemFontOfSize:10];
            }
        }];
        lbZero.textColor = FUIColorFromRGB(0x999999);
        lbZero.text = @"0";
        
        
        // 成团人数
        _MaxPeopleLb = [[UILabel alloc] init];
        [viewForTimeandProgress addSubview:_MaxPeopleLb];
        [_MaxPeopleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(lbZero);
            make.right.equalTo(progressBgLb);
            if (iPhone6SP) {
                make.height.equalTo(@(12));
                _MaxPeopleLb.font = [UIFont systemFontOfSize:12];
            }else if (iPhone6S) {
                make.height.equalTo(@(11));
                _MaxPeopleLb.font = [UIFont systemFontOfSize:11];
            }else {
                make.height.equalTo(@(10));
                _MaxPeopleLb.font = [UIFont systemFontOfSize:10];
            }
        }];
        _MaxPeopleLb.textColor = FUIColorFromRGB(0x999999);
        
        // 多人小图片(不用动)
        UIImageView *smallMorePeople = [[UIImageView alloc] init];
        [viewForTimeandProgress addSubview:smallMorePeople];
        [smallMorePeople mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(smallImgView);
            if (iPhone6SP) {
                make.right.equalTo(_MaxPeopleLb.mas_left).with.offset(-4);
                make.height.equalTo(@(12));
                make.width.equalTo(@(12 * 1.3846));
            }else if (iPhone6S) {
                make.right.equalTo(_MaxPeopleLb.mas_left).with.offset(-3);
                make.height.equalTo(@(11));
                make.width.equalTo(@(11 * 1.3846));
            }else {
                make.right.equalTo(_MaxPeopleLb.mas_left).with.offset(-2);
                make.height.equalTo(@(10));
                make.width.equalTo(@(10 * 1.3846));
            }
        }];
        smallMorePeople.image = [UIImage imageNamed:@"home_user2"];
        
    }else {
        
        // 未开团
        
        // 提示语(成团价格)
        if (!_lbForStatusPrice) {
            _lbForStatusPrice = [[UILabel alloc] init];
        }
        [viewForTimeandProgress addSubview:_lbForStatusPrice];
        [_lbForStatusPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(viewForTimeandProgress).with.offset(W * 0.215625 * 0.220588);
            make.left.equalTo(lbGoodsName);
            make.height.equalTo(@(14));
        }];
        _lbForStatusPrice.font = [UIFont systemFontOfSize:14];
        _lbForStatusPrice.textColor = FUIColorFromRGB(0xff5571);
        _lbForStatusPrice.text = @"即将开团,敬请期待!";
        
        // 倒计时视图
        UIView *viewForTime = [[UIView alloc] init];
        [viewForTimeandProgress addSubview:viewForTime];
        [viewForTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_lbForStatusPrice);
            make.height.equalTo(@(W * 0.215625 * 0.44));
            make.width.equalTo(@(W * 0.25));
            make.right.equalTo(self.view).with.offset(- 0.03125 * W);
        }];
        // 倒计时天数
        _lbForWaitDay = [[UILabel alloc] init];
        [viewForTime addSubview:_lbForWaitDay];
        [_lbForWaitDay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(viewForTime);
            make.left.equalTo(viewForTime);
            make.height.equalTo(@(13));
        }];
        _lbForWaitDay.font = [UIFont systemFontOfSize:13];
        _lbForWaitDay.textColor = FUIColorFromRGB(0xff5571);
        _lbForWaitDay.hidden = YES;
        // 秒
        self.lbForss = [[UILabel alloc] init];
        [viewForTime addSubview:self.lbForss];
        [_lbForss mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(viewForTime);
            make.right.equalTo(viewForTime);
            make.width.equalTo(@(self.view.frame.size.width * 0.071875));
            make.height.equalTo(@(self.view.frame.size.width * 0.071875));
        }];
        _lbForss.layer.cornerRadius = self.view.frame.size.width * 0.071875 / 2;
        _lbForss.clipsToBounds = YES;
        _lbForss.backgroundColor = FUIColorFromRGB(0xff5571);
        _lbForss.textColor = FUIColorFromRGB(0xffffff);
        
        // 分
        _lbFormm = [[UILabel alloc] init];
        [viewForTime addSubview:_lbFormm];
        [_lbFormm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(viewForTime);
            make.centerX.equalTo(viewForTime);
            make.width.equalTo(@(self.view.frame.size.width * 0.071875));
            make.height.equalTo(@(self.view.frame.size.width * 0.071875));
        }];
        _lbFormm.layer.cornerRadius = self.view.frame.size.width * 0.071875 / 2;;
        _lbFormm.clipsToBounds = YES;
        _lbFormm.backgroundColor = FUIColorFromRGB(0xff5571);
        _lbFormm.textColor = FUIColorFromRGB(0xffffff);
        
        // 冒号label1
        _maohaoLb1 = [[UILabel alloc] init];
        [viewForTime addSubview:_maohaoLb1];
        [_maohaoLb1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_lbForss);
            make.left.equalTo(_lbFormm);
            make.right.equalTo(_lbForss);
            make.height.equalTo(_lbForss);
        }];
        _maohaoLb1.text = @":";
        _maohaoLb1.textColor = FUIColorFromRGB(0xff5571);
        _maohaoLb1.font = [UIFont systemFontOfSize:15];
        _maohaoLb1.textAlignment = NSTextAlignmentCenter;
        
        // 时
        _lbForHH = [[UILabel alloc] init];
        [viewForTime addSubview:self.lbForHH];
        [_lbForHH mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(viewForTime);
            make.left.equalTo(viewForTime);
            make.width.equalTo(@(self.view.frame.size.width * 0.071875));
            make.height.equalTo(@(self.view.frame.size.width * 0.071875));
        }];
        self.lbForHH.layer.cornerRadius = self.view.frame.size.width * 0.071875 / 2;
        self.lbForHH.clipsToBounds = YES;
        self.lbForHH.backgroundColor = FUIColorFromRGB(0xff5571);
        self.lbForHH.textColor = FUIColorFromRGB(0xffffff);
        self.lbForHH.textAlignment = NSTextAlignmentCenter;
        _lbForHH.textColor = FUIColorFromRGB(0xffffff);
        
        // 冒号2
        _maohaoLb2 = [[UILabel alloc] init];
        [viewForTime addSubview:_maohaoLb2];
        [_maohaoLb2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_lbForss);
            make.left.equalTo(self.lbForHH);
            make.right.equalTo(self.lbFormm);
            make.height.equalTo(_lbForss);
        }];
        _maohaoLb2.text = @":";
        _maohaoLb2.textColor = FUIColorFromRGB(0xff5571);
        _maohaoLb2.font = [UIFont systemFontOfSize:15];
        _maohaoLb2.textAlignment = NSTextAlignmentCenter;
        // 设置字体大小
        if (iPhone6SP) {
            _lbForss.font = [UIFont systemFontOfSize:13];
            _lbFormm.font = [UIFont systemFontOfSize:13];
            _lbForHH.font = [UIFont systemFontOfSize:13];
        }else if (iPhone6S) {
            _lbForss.font = [UIFont systemFontOfSize:12];
            _lbFormm.font = [UIFont systemFontOfSize:12];
            _lbForHH.font = [UIFont systemFontOfSize:12];
        }else {
            _lbForss.font = [UIFont systemFontOfSize:11];
            _lbFormm.font = [UIFont systemFontOfSize:11];
            _lbForHH.font = [UIFont systemFontOfSize:11];
        }
        
        // 提示开团倒计时
        UILabel *lbTip = [[UILabel alloc] init];
        [viewForTimeandProgress addSubview:lbTip];
        [lbTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_lbForss);
            make.right.equalTo(viewForTime.mas_left);
            make.height.equalTo(@(13));
        }];
        lbTip.textColor = FUIColorFromRGB(0x999999);
        lbTip.text = @"开团倒计时 ";
        lbTip.font = [UIFont systemFontOfSize:13];
        
        // 进度条底层颜色
        UILabel *progressBgLb = [[UILabel alloc] init];
        [viewForTimeandProgress addSubview:progressBgLb];
        [progressBgLb mas_makeConstraints:^(MASConstraintMaker *make) {
            if (iPhone6SP) {
                make.top.equalTo(viewForTime.mas_bottom).with.offset(5);
            }else if (iPhone6S) {
                make.top.equalTo(viewForTime.mas_bottom).with.offset(3);
            }else {
                make.top.equalTo(viewForTime.mas_bottom).with.offset(1);
            }
            make.left.equalTo(lbGoodsName);
            make.right.equalTo(lbGoodsName);
            make.height.equalTo(@(12));
        }];
        progressBgLb.backgroundColor = FUIColorFromRGB(0xe9e9e9);
        progressBgLb.layer.cornerRadius = 6;
        progressBgLb.clipsToBounds = YES;
        
        // 进度条图片
        _progressImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 12)];
        [progressBgLb addSubview:_progressImgView];
        
        // 当前人数
        _currentPeople = [[UILabel alloc] init];
        [_progressImgView addSubview:_currentPeople];
        [_currentPeople mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_progressImgView);
            make.right.equalTo(_progressImgView);
            make.height.equalTo(@(12));
        }];
        _currentPeople.textColor = FUIColorFromRGB(0xffffff);
        _currentPeople.font = [UIFont systemFontOfSize:12];
        
        // 单个小人图片(不用动)
        UIImageView *smallImgView = [[UIImageView alloc] init];
        [viewForTimeandProgress addSubview:smallImgView];
        [smallImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(progressBgLb);
            if (iPhone6SP) {
                make.height.equalTo(@(12));
                make.width.equalTo(@(12));
                make.top.equalTo(progressBgLb.mas_bottom).with.offset(7);
            }else if (iPhone6S) {
                make.height.equalTo(@(11));
                make.width.equalTo(@(11));
                make.top.equalTo(progressBgLb.mas_bottom).with.offset(6);
            }else {
                make.height.equalTo(@(10));
                make.width.equalTo(@(10));
                make.top.equalTo(progressBgLb.mas_bottom).with.offset(5);
            }
        }];
        smallImgView.image = [UIImage imageNamed:@"home_user1"];
        // 0人label
        UILabel *lbZero = [[UILabel alloc] init];
        [viewForTimeandProgress addSubview:lbZero];
        [lbZero mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(smallImgView);
            if (iPhone6SP) {
                make.left.equalTo(smallImgView.mas_right).with.offset(4);
                make.height.equalTo(@(12));
                lbZero.font = [UIFont systemFontOfSize:12];
            }else if (iPhone6S) {
                make.left.equalTo(smallImgView.mas_right).with.offset(3);
                make.height.equalTo(@(11));
                lbZero.font = [UIFont systemFontOfSize:11];
            }else {
                make.left.equalTo(smallImgView.mas_right).with.offset(2);
                make.height.equalTo(@(10));
                lbZero.font = [UIFont systemFontOfSize:10];
            }
        }];
        lbZero.textColor = FUIColorFromRGB(0x999999);
        lbZero.text = @"0";
        
        // 成团人数
        _MaxPeopleLb = [[UILabel alloc] init];
        [viewForTimeandProgress addSubview:_MaxPeopleLb];
        [_MaxPeopleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(lbZero);
            make.right.equalTo(progressBgLb);
            if (iPhone6SP) {
                make.height.equalTo(@(12));
                _MaxPeopleLb.font = [UIFont systemFontOfSize:12];
            }else if (iPhone6S) {
                make.height.equalTo(@(11));
                _MaxPeopleLb.font = [UIFont systemFontOfSize:11];
            }else {
                make.height.equalTo(@(10));
                _MaxPeopleLb.font = [UIFont systemFontOfSize:10];
            }
        }];
        _MaxPeopleLb.textColor = FUIColorFromRGB(0x999999);
        _MaxPeopleLb.text = @"";
        
        // 多人小图片(不用动)
        UIImageView *smallMorePeople = [[UIImageView alloc] init];
        [viewForTimeandProgress addSubview:smallMorePeople];
        [smallMorePeople mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(smallImgView);
            if (iPhone6SP) {
                make.right.equalTo(_MaxPeopleLb.mas_left).with.offset(-4);
                make.height.equalTo(@(12));
                make.width.equalTo(@(12 * 1.3846));
            }else if (iPhone6S) {
                make.right.equalTo(_MaxPeopleLb.mas_left).with.offset(-3);
                make.height.equalTo(@(11));
                make.width.equalTo(@(11 * 1.3846));
            }else {
                make.right.equalTo(_MaxPeopleLb.mas_left).with.offset(-2);
                make.height.equalTo(@(10));
                make.width.equalTo(@(10 * 1.3846));
            }
        }];
        smallMorePeople.image = [UIImage imageNamed:@"home_user2"];
    }
    
    
    // 分隔线
    UILabel *lbFenge = [[UILabel alloc] init];
    [_bigScrollView addSubview:lbFenge];
    [lbFenge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewForTimeandProgress.mas_bottom);
        make.left.equalTo(self.view);
        make.width.equalTo(@(W));
        make.height.equalTo(@(W * 0.015625));
    }];
    lbFenge.backgroundColor = FUIColorFromRGB(0xeeeeee);
    
    
    // 规格、地址视图
    _addressAndNumView = [[AdressAndNumView alloc] initWithFrame:CGRectMake(0, 0, W, 0.26875 * W)];
    [_bigScrollView addSubview:_addressAndNumView];
    [_addressAndNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbFenge.mas_bottom);
        make.left.equalTo(self.view);
        make.width.equalTo(@(W));
        make.height.equalTo(@(0.26875 * W));
    }];
    // 地址Btn
//    [_addressAndNumView.AddressBtn setTitle:@"山东省青岛市市北区辽宁路颐高数码广场4056" forState:UIControlStateNormal];
    // 选择地址的点击事件
    [_addressAndNumView.AddressBtn addTarget:self action:@selector(AddressBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 提示送达日期
    _addressAndNumView.lbTipDate.text = @"预计成团后次日送达";
    // 已选的规格
    [_addressAndNumView.selectSizeBtn setTitle:@"1件" forState:UIControlStateNormal];
    [_addressAndNumView.selectSizeBtn addTarget:self action:@selector(selectSizeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    // 配送信息视图
    _fastMailView = [[FastMailView alloc] initWithFrame:CGRectMake(0, 0, W, 0.26875 * W * 0.36)];
    [self.view addSubview:_fastMailView];
    [_fastMailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressAndNumView.mas_bottom);
        make.left.equalTo(self.view);
        make.width.equalTo(@(W));
        make.height.equalTo(@(0.26875 * W * 0.36));
    }];
    _fastMailView.lookPeisongDetailBtn.userInteractionEnabled = NO;
    [_fastMailView.lookPeisongDetailBtn setTitle:@"请先选择配送地址" forState:UIControlStateNormal];
    // 配送信息视图上的按钮
    [_fastMailView.lookPeisongDetailBtn addTarget:self action:@selector(lookPeisongDetailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    // 配送信息点击事件
    
    
    // 分隔线
    UILabel *lbFenge2 = [[UILabel alloc] init];
    [_bigScrollView addSubview:lbFenge2];
    [lbFenge2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_fastMailView.mas_bottom);
        make.left.equalTo(self.view);
        make.width.equalTo(@(W));
        make.height.equalTo(@(W * 0.015625 - 1));
    }];
    lbFenge2.backgroundColor = FUIColorFromRGB(0xeeeeee);
    
    // 评价表头
    UIView *pingjiaTopView = [[UIView alloc] init];
    [_bigScrollView addSubview:pingjiaTopView];
    [pingjiaTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbFenge2.mas_bottom);
        make.left.equalTo(self.view);
        make.width.equalTo(@(W));
        make.height.equalTo(@(W * 0.109375));
    }];
    // 右侧大于号图片
    UIImageView *rightImgView = [[UIImageView alloc] init];
    [pingjiaTopView addSubview:rightImgView];
    [rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(- W * 0.03125);
        make.centerY.equalTo(pingjiaTopView);
        make.width.equalTo(@(7.42857));
        make.height.equalTo(@(13));
    }];
    rightImgView.image = [UIImage imageNamed:@"account_forward"];
    // 下方分割线
    UILabel *fenge = [[UILabel alloc] init];
    [_bigScrollView addSubview:fenge];
    [fenge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pingjiaTopView.mas_bottom);
        make.left.equalTo(pingjiaTopView).with.offset(W * 0.03125);
        make.width.equalTo(@(W - W * 0.03125));
        make.height.equalTo(@(1));
    }];
    fenge.backgroundColor = FUIColorFromRGB(0xeeeeee);

    
    // 评价数量Label
    _pingjiaNumLb = [[UILabel alloc] init];
    [pingjiaTopView addSubview:_pingjiaNumLb];
    [_pingjiaNumLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(pingjiaTopView);
        make.left.equalTo(pingjiaTopView).with.offset(W * 0.03125);
        if (iPhone6SP) {
            make.height.equalTo(@(14));
            _pingjiaNumLb.font = [UIFont systemFontOfSize:14];
        }else if (iPhone6S) {
            make.height.equalTo(@(13));
            _pingjiaNumLb.font = [UIFont systemFontOfSize:13];
        }else {
            make.height.equalTo(@(12));
            _pingjiaNumLb.font = [UIFont systemFontOfSize:12];
        }
    }];
    _pingjiaNumLb.textColor = FUIColorFromRGB(0x999999);
    
    
    // 好评率Label
    _goodPingjiaLb = [[UILabel alloc] init];
    [pingjiaTopView addSubview:_goodPingjiaLb];
    [_goodPingjiaLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(pingjiaTopView);
        make.right.equalTo(rightImgView.mas_left).with.offset(- W * 0.015625);
        if (iPhone6SP) {
            make.height.equalTo(@(14));
            _goodPingjiaLb.font = [UIFont systemFontOfSize:14];
        }else if (iPhone6S) {
            make.height.equalTo(@(13));
            _goodPingjiaLb.font = [UIFont systemFontOfSize:13];
        }else {
            make.height.equalTo(@(12));
            _goodPingjiaLb.font = [UIFont systemFontOfSize:12];
        }
    }];
    _goodPingjiaLb.textColor = FUIColorFromRGB(0x8979ff);
    
    // 评价列表创建
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, fenge.frame.origin.y + 1, W, _tableViewHeight) style:UITableViewStylePlain];
    [_bigScrollView addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.sd_layout
    .topSpaceToView(fenge, 0)
    .leftEqualToView(self.view)
    .widthIs(W)
    .heightIs(_tableViewHeight);
    
//    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(fenge).with.offset(1);
//        make.left.equalTo(self.view);
//        make.width.equalTo(@(W));
//        make.height.equalTo(@(300));
//    }];
    
    // 注册列表
    [_tableView registerClass:[AllPingJiaTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
    // 查看全部评价视图
    _morePingjiaview = [[UIView alloc] init];
    [_bigScrollView addSubview:_morePingjiaview];
    _morePingjiaview.sd_layout
    .topSpaceToView(_tableView, 0)
    .leftEqualToView(self.view)
    .widthIs(W)
    .heightIs(100);

    // 底部分割线
    UILabel *lbfengeInMoreView = [[UILabel alloc] init];
    [_morePingjiaview addSubview:lbfengeInMoreView];
    [lbfengeInMoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_morePingjiaview);
        make.left.equalTo(_morePingjiaview);
        make.width.equalTo(@(W));
        make.height.equalTo(@(1));
    }];
    lbfengeInMoreView.backgroundColor = FUIColorFromRGB(0xeeeeee);
    // 60
    // 查看全部评价Btn
    UIButton *moreBtn = [[UIButton alloc] init];
    [_morePingjiaview addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_morePingjiaview);
        make.centerX.equalTo(_morePingjiaview);
        make.height.equalTo(@(W * 0.09375 * 7/ 12 ));
        make.width.equalTo(@(W * 0.234375));
    }];
    moreBtn.layer.cornerRadius = W * 0.09375 * 7/ 12/2;
    moreBtn.clipsToBounds = YES;
    moreBtn.layer.borderWidth = 1.0;
    moreBtn.layer.borderColor = FUIColorFromRGB(0x999999).CGColor;
    if (iPhone6SP) {
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }else if (iPhone6S) {
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    }else {
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    }
    [moreBtn setTitle:@"查看全部评价" forState:UIControlStateNormal];
    [moreBtn setTitleColor:FUIColorFromRGB(0x999999) forState:UIControlStateNormal];
    // 点击事件
    [moreBtn addTarget:self action:@selector(MorePingjiaClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 网页加载
    _webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, _morePingjiaview.frame.origin.y, W, 0)];
    [_bigScrollView addSubview:_webview];
    
    _webview.delegate = self;
    _webview.backgroundColor = FUIColorFromRGB(0xffffff);
    
    // 固定位置
    [_webview layoutIfNeeded];
    
    _bigScrollView.contentSize = CGSizeMake(W, _webview.frame.size.height + _webview.frame.origin.y);
    
    
//    下滑加载更多内容
//    MorePingjiaview
    
    
    // 底部视图
    _bottomVC = [[GroupDetailBottomView alloc] initWithFrame:CGRectMake(0, 0, W, 49) andType:[_strStatus intValue]];
    [self.view addSubview:_bottomVC];
    [_bottomVC.xiaopinBtn addTarget:self action:@selector(bottomViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomVC.quanpinBtn addTarget:self action:@selector(bottomViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomVC.guanzhuBtn addTarget:self action:@selector(guanzhuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomVC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(@(W));
        make.height.equalTo(@(49));
    }];
    
    // 创建地址选择视图
    [self createAddressSelectView];
    
}

// 配送信息点击事件
- (void) lookPeisongDetailBtnClick:(UIButton *)btn {
    
    // 判断是否能送达,能的话，通过地址和商品信息去请求配送信息,然后显示
//    if (<#condition#>) {
//        <#statements#>
//    }
    
    
    [UIView animateWithDuration:0.25f animations:^{
        
        _peisongZheZhao.hidden = NO;
        
        _peisongDetailWeb.frame = CGRectMake(0, H + 64 - W, W, W);
        
    } completion:^(BOOL finished) {
        
        
    }];
    
    
}

// 关注按钮点击事件
- (void) guanzhuBtnClick:(UIButton *)btn {
    
    NSUserDefaults *user = [[NSUserDefaults alloc] init];
    NSString *strTk = [user objectForKey:@"token"];
    
    if (strTk == nil) {
        
        LoginViewController *vc = [[LoginViewController alloc] init];
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else {
        
        if (btn.selected == NO) {
            
            // 此时未关注,去发起添加关注的请求，并修改btn状态
            
            // 创建单例,获取到用户RSAKey
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *userRsaPublicKey = [user objectForKey:@"severPublicKey"];
            
            // 生成一个16位的AES的key,并保存用于解密服务器返回的信息
            NSString *strAESkey = [NSString set32bitString:16];
            [user setObject:strAESkey forKey:@"aesKey"];
            // 最终加密好的key参数的密文
            NSString *keyMiWenStr = [RSAEncryptor encryptString:strAESkey publicKey:userRsaPublicKey];
            
            // 获取当前时间戳，转换成json类型，并用AES进行加密,并做了base64及urlcode转码处理
            NSDate *senddate = [NSDate date];
            NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
            NSDictionary *cgDic = @{@"requestTime":date2};
            // 最终加密好的cg参数的密文
            NSString *cgMiWenStr = [[MakeJson createJson:cgDic] AES128EncryptWithKey:strAESkey];
            
            // 用户token
            NSString *userToken = [user objectForKey:@"token"];
            
            NSDictionary *dicData = @{@"type":@"11",@"dataId":_goodsId};
            NSString *strDic = [MakeJson createJson:dicData];
            NSString *strData = [strDic AES128EncryptWithKey:strAESkey];
            
            NSDictionary *dataDic = @{@"tk":userToken,@"key":keyMiWenStr,@"cg":cgMiWenStr,@"data":strData};
            
            HttpRequest *http = [[HttpRequest alloc] init];
            [http PostAddFavWithDic:dataDic Success:^(id userInfo) {
                
                // 请求成功，添加关注成功
                if ([userInfo length] == 0) {
                    // 添加失败
                    
                }else {
                    
                    btn.selected = YES;
                }
                
            } failure:^(NSError *error) {
                
                // 请求失败
            }];
            
            
        }else {
            
            // 此时已关注,去发起删除关注的请求，并修改btn状态
            
            // 创建单例,获取到用户RSAKey
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *userRsaPublicKey = [user objectForKey:@"severPublicKey"];
            
            // 生成一个16位的AES的key,并保存用于解密服务器返回的信息
            NSString *strAESkey = [NSString set32bitString:16];
            [user setObject:strAESkey forKey:@"aesKey"];
            // 最终加密好的key参数的密文
            NSString *keyMiWenStr = [RSAEncryptor encryptString:strAESkey publicKey:userRsaPublicKey];
            
            // 获取当前时间戳，转换成json类型，并用AES进行加密,并做了base64及urlcode转码处理
            NSDate *senddate = [NSDate date];
            NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
            NSDictionary *cgDic = @{@"requestTime":date2};
            // 最终加密好的cg参数的密文
            NSString *cgMiWenStr = [[MakeJson createJson:cgDic] AES128EncryptWithKey:strAESkey];
            
            // 用户token
            NSString *userToken = [user objectForKey:@"token"];
            
            NSDictionary *dicData = @{@"type":@"11",@"dataId":_goodsId};
            NSString *strDic = [MakeJson createJson:dicData];
            NSString *strData = [strDic AES128EncryptWithKey:strAESkey];
            
            NSDictionary *dataDic = @{@"tk":userToken,@"key":keyMiWenStr,@"cg":cgMiWenStr,@"data":strData};
            
            HttpRequest *http = [[HttpRequest alloc] init];
            [http PostDelFavWithDic:dataDic Success:^(id userInfo) {
                
                // 请求成功，添加关注成功
                if ([userInfo length] == 0) {
                    // 添加失败
                    
                }else {
                    
                    btn.selected = NO;
                }
                
            } failure:^(NSError *error) {
                
                // 请求失败
            }];
            
        }
        
    }
}


// 创建地址选择视图
- (void) createAddressSelectView {
    
    // 地址遮罩层
    _dizhiZheZhao = [[ZheZhaoView alloc] initWithFrame:CGRectMake(0, 0, W, H - 64)];
    [self.view addSubview:_dizhiZheZhao];
    _dizhiZheZhao.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dizhiZhezhaoClick)];
    [_dizhiZheZhao addGestureRecognizer:tap];
    
    // 地址选择视图
    _addressSelectVc = [[AddressSelectView alloc] initWithFrame:CGRectMake(0, H, W, W * 25/32)];
    [self.view addSubview:_addressSelectVc];
    [_addressSelectVc.closeBtn addTarget:self action:@selector(AddressSelectClose) forControlEvents:UIControlEventTouchUpInside];
    // 关闭
    __weak typeof (self) weakSelf = self;
    _addressSelectVc.chooseFinish = ^{
        [UIView animateWithDuration:0.25 animations:^{
            [weakSelf.addressAndNumView.AddressBtn setTitle:weakSelf.addressSelectVc.address forState:UIControlStateNormal];
            [weakSelf AddressSelectClose];
        }];
    };
}

// 地址选择视图关闭按钮的点击
- (void) AddressSelectClose {
    
    
    // 地址遮罩点击事件
    [self dizhiZhezhaoClick];
    
    
    // 创建请求对象
    HttpRequest *http = [[HttpRequest alloc] init];
    // 发起请求,获取是否可以配送
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *strRegionId = [user objectForKey:@"getStreetId"];
    [http GetGoodsCanDistributionWithId:[_goodsId integerValue] andRegionId:[strRegionId integerValue] Success:^(id arrForGoodsData) {
        
        if ([arrForGoodsData isKindOfClass:[NSString class]]) {
            
            // 请求失败,没有可匹配的
            [_fastMailView.lookPeisongDetailBtn setTitle:@"您所在的城市暂时不可配送" forState:UIControlStateNormal];
            
        }else {
            
            
            
            _fastMailView.lookPeisongDetailBtn.userInteractionEnabled = YES;
            
            // 请求失败,没有可匹配的
            [_fastMailView.lookPeisongDetailBtn setTitle:[arrForGoodsData[0] objectForKey:@"ship"] forState:UIControlStateNormal];
            
            
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
    
}


// 配送遮罩层点击事件
- (void) peisongZheZhaoClick {
    
    [UIView animateWithDuration:0.25f animations:^{
        
        _peisongDetailWeb.frame = CGRectMake(0, H + 64, W, W);
        
    } completion:^(BOOL finished) {
        
        _peisongZheZhao.hidden = YES;
    }];
}

// 选择地址的点击事件
- (void) AddressBtnClick:(UIButton *)AddressBtn {
    
    
    [UIView animateWithDuration:0.25f animations:^{
        
        _dizhiZheZhao.hidden = NO;
        
        _addressSelectVc.frame = CGRectMake(0, H - W * 25/32, W, W * 25/32);
        
    } completion:^(BOOL finished) {
        
        
    }];
}

// 地址遮罩层点击事件
- (void) dizhiZhezhaoClick {
    
    [UIView animateWithDuration:0.25f animations:^{
        
        _addressSelectVc.frame = CGRectMake(0, H, W, W * 25/32);
        
    } completion:^(BOOL finished) {
        
        _dizhiZheZhao.hidden = YES;
    }];
}

// 底部视图按钮的点击事件
- (void) bottomViewBtnClick:(UIButton *) btn {
    
    UIButton *selectBtn = [self.view viewWithTag:50];
    
    [self selectSizeBtnClick:selectBtn];
}

// 创建规格筛选视图
- (void) createGuigeSelectView {
    
    // 遮罩层
    _shaiXuanZhezhao = [[ZheZhaoView alloc] initWithFrame:CGRectMake(0, 0, W, H - 64)];
    [self.view addSubview:_shaiXuanZhezhao];
    _shaiXuanZhezhao.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shaiXuanZhezhaoClick)];
    [_shaiXuanZhezhao addGestureRecognizer:tap];
    

    // 筛选视图
    _selectGuigevc = [[SelectGuiGeView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height + W * 0.20625/2, W, W) WithFenLeiArr:_specListArr andPriceArr:_specItemPriceListArr];
    _selectGuigevc.backgroundColor = FUIColorFromRGB(0xffffff);
//    _selectGuigevc.priceLb.text = @"";
//    _selectGuigevc.goodsNum.text = @"商品编号:";
//    [_selectGuigevc.goodsImgView sd_setImageWithURL:[NSURL URLWithString:[[_detailDic objectForKey:@"img_multi"] objectForKey:@"app_spec_default"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [_selectGuigevc.closeBtn addTarget:self action:@selector(closeSelectVcClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_selectGuigevc];
    // 给规格视图按钮加点击事件
    //遍历这个view，对这个view上btn添加相应的事件

    _selectGuigevc.BuyNumberLb.text = [NSString stringWithFormat:@"%ld",_buyNum];
    [_selectGuigevc.NumAddBtn addTarget:self action:@selector(AddClick) forControlEvents:UIControlEventTouchUpInside];
    [_selectGuigevc.NumSubBtn addTarget:self action:@selector(SubClick) forControlEvents:UIControlEventTouchUpInside];
    //遍历这个view，对这个view上btn添加相应的事件
    for (UIButton *btn in _selectGuigevc.xiaopingouBtnView.subviews) {
        [btn setTitleColor:FUIColorFromRGB(0x4e4e4e) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(xiaopingouViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // 第一次点击完后，设置已选默认规格
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [_addressAndNumView.selectSizeBtn setTitle:[user objectForKey:@"zuheName"] forState:UIControlStateNormal];
    

    // 小拼购点击事件
    [_selectGuigevc.xiaopingouBtn addTarget:self action:@selector(xiaopingouBtnClick) forControlEvents:UIControlEventTouchUpInside];
    // 全拼购点击事件
    [_selectGuigevc.quanpingouBtn addTarget:self action:@selector(quanpingouBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

// 筛选视图小拼购点击事件
- (void) xiaopingouBtnClick {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *strTk =  [user objectForKey:@"token"];
    if (strTk == nil) {
        
        // 用户未登录
        LoginViewController *vc = [[LoginViewController alloc] init];
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else {
        
        // 用户已登录
        
        NSString *strCode = [user objectForKey:@"zuheCode"];
        NSString *strXiaoPinId = [user objectForKey:@"xiaopinId"];
        
        // 跳转到确认订单页面
        OrderSureViewController *vc = [[OrderSureViewController alloc] init];
        vc.id1 = self.goodsId;
        vc.buyNum1 = [NSString stringWithFormat:@"%ld",_buyNum];
        vc.specItemIds = strCode;
        vc.subOrderId = strXiaoPinId;
        vc.onePrice = [user objectForKey:@"price"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

// 筛选视图全拼购点击事件
- (void) quanpingouBtnClick {
    
    // 跳转到确认订单页面
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *strTk =  [user objectForKey:@"token"];
    if (strTk == nil) {
        
        // 用户未登录
        LoginViewController *vc = [[LoginViewController alloc] init];
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else {
        
        
        NSString *strCode = [user objectForKey:@"zuheCode"];
        NSString *strXiaoPinId = [user objectForKey:@"xiaopinId"];
        
        // 跳转到确认订单页面
        OrderSureViewController *vc = [[OrderSureViewController alloc] init];
        vc.id1 = self.goodsId;
        vc.buyNum1 = [NSString stringWithFormat:@"%ld",_buyNum];
        vc.specItemIds = strCode;
        vc.subOrderId = strXiaoPinId;
        vc.onePrice = [user objectForKey:@"price"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

// 加点击事件
- (void) AddClick {
    _buyNum ++;
    _selectGuigevc.BuyNumberLb.text = [NSString stringWithFormat:@"%ld",_buyNum];
}
// 减点击事件
- (void) SubClick {
    
    if (_buyNum > 1) {
        _buyNum --;
        _selectGuigevc.BuyNumberLb.text = [NSString stringWithFormat:@"%ld",_buyNum];
    }else {
        alert(@"不能再少了");
    }
    
}

// 规格视图按钮加点击事件
- (void) guigeViewBtnClick:(UIButton *)btn {
    
//    for (UIButton *btn in _selectGuigevc.GuigeBtnView.subviews) {
//        btn.layer.borderColor = [[UIColor colorWithRed:238/255.0 green:239/255.0 blue:239/255.0 alpha:1.0] CGColor];
//        [btn setTitleColor:FUIColorFromRGB(0x4e4e4e) forState:UIControlStateNormal];
//    }
    
    btn.layer.borderColor = FUIColorFromRGB(0x8979ff).CGColor;
    [btn setTitleColor:FUIColorFromRGB(0x8979ff) forState:UIControlStateNormal];
}

// 小拼购视图按钮点击事件
- (void) xiaopingouViewBtnClick:(UIButton *)btn {
    
    for (UIButton *btn in _selectGuigevc.xiaopingouBtnView.subviews) {
        btn.layer.borderColor = [[UIColor colorWithRed:238/255.0 green:239/255.0 blue:239/255.0 alpha:1.0] CGColor];
        [btn setTitleColor:FUIColorFromRGB(0x4e4e4e) forState:UIControlStateNormal];
    }
    
    btn.layer.borderColor = FUIColorFromRGB(0x8979ff).CGColor;
    [btn setTitleColor:FUIColorFromRGB(0x8979ff) forState:UIControlStateNormal];
}

// 筛选点击事件
- (void) selectSizeBtnClick:(UIButton *)btn {
    
    [UIView animateWithDuration:0.3f animations:^{
        
        _shaiXuanZhezhao.hidden = NO;
        
        _selectGuigevc.frame = CGRectMake(0, self.view.frame.size.height - W, W, W);
        
    } completion:^(BOOL finished) {
        
        
    }];
}

// 筛选视图关闭按钮点击
- (void) closeSelectVcClick {
    
    // 筛选遮罩层的点击事件
    [self shaiXuanZhezhaoClick];
}

// 筛选遮罩层的点击事件
- (void) shaiXuanZhezhaoClick {
    
    [UIView animateWithDuration:0.25f animations:^{
        
        _shaiXuanZhezhao.hidden = YES;
        
        _selectGuigevc.frame = CGRectMake(0, self.view.frame.size.height + W * 0.20625/2, W, W);
        
    } completion:^(BOOL finished) {
        
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [_addressAndNumView.selectSizeBtn setTitle:[user objectForKey:@"zuheName"] forState:UIControlStateNormal];
        NSLog(@"组合名字:%@",[user objectForKey:@"zuheName"]);
        NSLog(@"组合编码:%@",[user objectForKey:@"zuheCode"]);
        NSLog(@"组合价格:%@",[user objectForKey:@"price"]);
        
    }];
}


// 更多评价点击事件
- (void) MorePingjiaClick {
    
    // 评价详情页
    PingjiaDetailViewController *vc = [[PingjiaDetailViewController alloc] init];
    vc.goodsId = _pingjiaId;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark ---------UITableViewDelegate,UITableViewDataSource--------
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _tableViewArr.count;
}

// 绑定数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PingJiaModel *model = _tableViewArr[indexPath.row];
    
    AllPingJiaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    // 评价图片
    [cell giveArrForTupian:model.img_show];

    // 头像
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
    
    // 跳转到评价详情页
    // 评价详情页
    PingjiaDetailViewController *vc = [[PingjiaDetailViewController alloc] init];
    vc.goodsId = _goodsId;
    [self.navigationController pushViewController:vc animated:YES];
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

// 获取相差时间(秒)
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


// 获取相差时间
- (NSDateComponents *) getDifferTime:(NSString *) timestamp {
    
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

// 滚动条点击事件
- (void) cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    NSLog(@"点击了第%ld张",index);
}
// 滚动到了哪一张
- (void) cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    
//    NSLog(@"滚动到了第%ld张",index);
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
    
    // 把保存的规格清空
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"zuheName"];
    [user removeObjectForKey:@"zuheCode"];
    [user removeObjectForKey:@"price"];
    [user removeObjectForKey:@"imgUrl"];
    [user removeObjectForKey:@"xiaopinId"];
    [user removeObjectForKey:@"getStreetId"];
    
    [self.navigationController popViewControllerAnimated:YES];
}


// 分享点击事件
- (void)shareClick:(UIButton *)btn {
    
    NSString *strImgUrl = [[_detailDic objectForKey:@"img_multi"] objectForKey:@"app_share"];
    NSString *strTitle = [_detailDic objectForKey:@"title"];
    NSString *strSummry = [_detailDic objectForKey:@"summary"];
    
    //1、创建分享参数
    NSArray* imageArray = @[[NSString stringWithFormat:@"%@",strImgUrl]];
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:strSummry images:imageArray url:[NSURL URLWithString:[_detailDic objectForKey:@"share_url"]]title:strTitle type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:self
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
}



// 页面已经显示
- (void) viewDidAppear:(BOOL)animated {
    

}


// 页面将要显示
- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    //相对于上面的接口，这个接口可以动画的改变statusBar的前景色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    // 关闭手势返回
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void) viewWillDisappear:(BOOL)animated {
    
    // 打开手势返回
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    //这个接口可以动画的改变statusBar的前景色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    // 调用右侧按钮点击事件
    UIButton *btn = [self.navigationController.view viewWithTag:1];
    if (btn.selected == YES) {
        [self rightBtnClick:btn];
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
