//
//  GoodsViewController.m
//  EasyLink
//
//  Created by 琦琦 on 16/9/19.
//  Copyright © 2016年 fengdian. All rights reserved.
//

#import "GoodsViewController.h"
#import "MBProgressHUD.h" // 动画加载

@interface GoodsViewController ()<UIWebViewDelegate,MBProgressHUDDelegate> {
    
    // 底层滚动视图
    UIScrollView *_backScrollView;
    
    // 底端购买视图
    UIView *_bottomVc;
}

@property (nonatomic,copy) MBProgressHUD *HUD;

@end

@implementation GoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 背景色
    self.view.backgroundColor = FUIColorFromRGB(0xffffff);
    
    // 返回按钮
    [self createBackBtn];
    
    // 设置导航栏标题
    UILabel *lbItemTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    lbItemTitle.text = @"子分类名称";
    lbItemTitle.textColor = [UIColor whiteColor];
    lbItemTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lbItemTitle;
    
    // 创建Gif
    [self createGif];
    
    // 创建UI
    [self createUI];
}

// 创建Gif
- (void) createGif {
    
    _HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    _HUD.delegate = self;
    
    // 5秒隐藏动画
    [_HUD hide:YES afterDelay:5];
}


// 创建UI
- (void) createUI{
    
    // 详情网页
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, W, H - 64 - 49)];
    webView.backgroundColor = FUIColorFromRGB(0xffffff);
    [webView setUserInteractionEnabled:YES];//是否支持交互
    webView.delegate=self;
    [webView setOpaque:NO];//opaque是不透明的意思
    [webView setScalesPageToFit:YES];//自动缩放以适应屏幕
    [self.view addSubview:webView];
    
    //加载网页的方式
    //1.创建并加载远程网页
    NSURL *url = [NSURL URLWithString:@"http://app.cnzspr.com/Product_detail"];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    
    // 底边栏视图
    _bottomVc = [[UIView alloc] init];
    [self.view addSubview:_bottomVc];
    [_bottomVc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(@(W));
        make.height.equalTo(@(49));
    }];
    _bottomVc.backgroundColor = FUIColorFromRGB(0xf8f8f8);
    _bottomVc.alpha = 0.9;
    
    // 添加关注按钮
    UIButton *btnAddFocus = [[UIButton alloc] init];
    [_bottomVc addSubview:btnAddFocus];
    [btnAddFocus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomVc);
        make.left.equalTo(_bottomVc);
        make.height.equalTo(_bottomVc);
    }];
    btnAddFocus.imageView.sd_layout
    .centerYEqualToView(btnAddFocus)
    .leftSpaceToView(btnAddFocus,0.046875 * W)
    .widthIs(21.6)
    .heightIs(19.2);
    btnAddFocus.titleLabel.sd_layout
    .centerYEqualToView(btnAddFocus)
    .leftSpaceToView(btnAddFocus.imageView,5)
    .heightIs(16)
    .widthIs(62);
    
    [btnAddFocus setImage:[UIImage imageNamed:@"发现_详情_关注off"] forState:UIControlStateNormal];
    [btnAddFocus setTitleColor:FUIColorFromRGB(0xff5672) forState:UIControlStateNormal];
    [btnAddFocus setTitle:@"添加关注" forState:UIControlStateNormal];
    btnAddFocus.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnAddFocus addTarget:self action:@selector(guanzhubtnClick:) forControlEvents:UIControlEventTouchUpInside];

    // 立即购买按钮
    UIButton *btnBuy = [[UIButton alloc] init];
    [_bottomVc addSubview:btnBuy];
    [btnBuy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bottomVc);
        make.right.equalTo(_bottomVc.mas_right).with.offset( - 0.046875 * W);
        make.height.equalTo(@(32));
        make.width.equalTo(@(0.34375 * W));
    }];
    btnBuy.layer.cornerRadius = 17;
    btnBuy.backgroundColor = FUIColorFromRGB(0x8979ff);
    [btnBuy setTitle:@"立即购买" forState:UIControlStateNormal];
    [btnBuy setTitleColor:FUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    btnBuy.clipsToBounds = YES;
    btnBuy.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnBuy addTarget:self action:@selector(buyClick:) forControlEvents:UIControlEventTouchUpInside];
}

// 网页加载完成
- (void) webViewDidFinishLoad:(UIWebView *)webView {
    
    [_HUD hide:YES];
}

// 关注按钮点击事件
- (void) guanzhubtnClick:(UIButton *)guanzhuBtn {

    if(guanzhuBtn.selected == NO){
        
        guanzhuBtn.selected = YES;
        [guanzhuBtn setImage:[UIImage imageNamed:@"发现_详情_关注on"] forState:UIControlStateNormal];
    }else {
        
        guanzhuBtn.selected = NO;
        [guanzhuBtn setImage:[UIImage imageNamed:@"发现4"] forState:UIControlStateNormal];
    }
    
    alert(@"点击了关注");
}

// 购买按钮点击事件
- (void) buyClick:(UIButton *)btnBuy {
    
    alert(@"点击了购买");
}

// 返回按钮
- (void) createBackBtn {
    
    // 返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 10.4, 18.4);
    
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
        self.navigationItem.leftBarButtonItem = backItem;
    }
    
}

// 返回按钮点击事件
- (void) doBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 页面将要消失
- (void) viewWillDisappear:(BOOL)animated  {
    
    [_HUD hide:YES];
}

// 界面将要进入
- (void) viewWillAppear:(BOOL)animated {
    
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
