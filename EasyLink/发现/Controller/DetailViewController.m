//
//  DetailViewController.m
//  EasyLink
//
//  Created by 琦琦 on 16/9/19.
//  Copyright © 2016年 fengdian. All rights reserved.
//

#import "DetailViewController.h"
#import "LinkGoodsViewController.h" // 关联商品页面
#import "MBProgressHUD.h" // 动画加载

@interface DetailViewController ()<UIWebViewDelegate,MBProgressHUDDelegate> {
    
    UIView *_bottomVc; // 底边栏视图
    
    UIScrollView *_backScrollView; // 底层滚动图
}

@property (nonatomic,copy) MBProgressHUD *HUD;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 背景色
    self.view.backgroundColor = FUIColorFromRGB(0xffffff);
    
    // 设置导航栏标题
    UILabel *lbItemTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    lbItemTitle.text = _strTitleName;
    lbItemTitle.textColor = [UIColor whiteColor];
    lbItemTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lbItemTitle;
    
    // 创建Gif
    [self createGif];
    
    // 返回按钮
    [self createBackBtn];
    
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
- (void) createUI {
    
//    // 底层滚动视图
//    _backScrollView = [[UIScrollView alloc] init];
//    [self.view addSubview:_backScrollView];
//    [_backScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).with.offset(0);
//        make.left.equalTo(self.view);
//        make.width.equalTo(@(W));
//        make.height.equalTo(@(H - 64));
//    }];
//    _backScrollView.backgroundColor = FUIColorFromRGB(0xffffff);
//    _backScrollView.contentSize = CGSizeMake(W, 2*H);
//    _backScrollView.showsVerticalScrollIndicator = NO;
//    _backScrollView.showsHorizontalScrollIndicator = NO; 
//    
//    // 顶端展示图
//    UIImageView *topImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, W, 0.24 * H)];
//    [_backScrollView addSubview:topImgView];
//    topImgView.image = [UIImage imageNamed:@"category_list_img1"];
//    
//    // 浏览的btn
//    UIButton *liulanBtn = [[UIButton alloc] init];
//    [_backScrollView addSubview:liulanBtn];
//    [liulanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(topImgView.mas_bottom).with.offset((0.125 * W + 10) / 2);
//        make.left.equalTo(_backScrollView).with.offset(0.03 * W);
//        make.height.equalTo(@(14));
//        make.width.equalTo(@(129));
//    }];
//    
//    liulanBtn.imageView.sd_layout
//    .bottomSpaceToView(liulanBtn,2)
//    .leftSpaceToView(liulanBtn,0)
//    .widthIs(16)
//    .heightIs(10);
//    liulanBtn.titleLabel.sd_layout
//    .leftSpaceToView(liulanBtn.imageView,3)
//    .bottomSpaceToView(liulanBtn,0)
//    .widthIs(110)
//    .heightIs(14);
//    [liulanBtn setTitle:@"282,208次浏览" forState:UIControlStateNormal];
//    liulanBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [liulanBtn setTitleColor:FUIColorFromRGB(0x999999) forState:UIControlStateNormal];
//    [liulanBtn setImage:[UIImage imageNamed:@"发现3"] forState:UIControlStateNormal];
//    liulanBtn.userInteractionEnabled = NO;
//    
//    // 关注Btn
//    UIButton *guanzhuBtn = [[UIButton alloc] init];
//    [_backScrollView addSubview:guanzhuBtn];
//    [guanzhuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(topImgView.mas_bottom).with.offset((0.125 * W + 10) / 2);
//        make.right.equalTo(self.view).with.offset(- 0.03 * W);
//        make.height.equalTo(@(14));
//        make.width.equalTo(@(100));
//    }];
//    guanzhuBtn.titleLabel.sd_layout
//    .rightEqualToView(guanzhuBtn)
//    .bottomSpaceToView(guanzhuBtn,0)
//    .heightIs(14);
//    guanzhuBtn.imageView.sd_layout
//    .rightSpaceToView(guanzhuBtn.titleLabel,-2)
//    .bottomSpaceToView(guanzhuBtn,1.5)
//    .widthIs(13)
//    .heightIs(11);
//    [guanzhuBtn setTitleColor:FUIColorFromRGB(0x999999) forState:UIControlStateNormal];
//    [guanzhuBtn setTitle:@"6,869关注" forState:UIControlStateNormal];
//    guanzhuBtn.titleLabel.textAlignment = NSTextAlignmentRight;
//    guanzhuBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [guanzhuBtn setImage:[UIImage imageNamed:@"发现4"] forState:UIControlStateNormal];
//    [guanzhuBtn addTarget:self action:@selector(guanzhubtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    guanzhuBtn.selected = NO;
//    
//    // 分隔线
//    UILabel *lbFenge = [[UILabel alloc] init];
//    [_backScrollView addSubview:lbFenge];
//    [lbFenge mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(guanzhuBtn.mas_bottom).with.offset(0.015845 * H);
//        make.left.equalTo(self.view);
//        make.width.equalTo(@(W));
//        make.height.equalTo(@(2));
//    }];
//    lbFenge.backgroundColor = FUIColorFromRGB(0xeeeeee);
    
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
    NSURL *url = [NSURL URLWithString:@"http://app.cnzspr.com/FindMore_detail"];
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
    _bottomVc.backgroundColor = [FUIColorFromRGB(0xf8f8f8) colorWithAlphaComponent:0.9];
    
    // 添加关注
    UIButton *btnFocus = [[UIButton alloc] init];
    [_bottomVc addSubview:btnFocus];
    [btnFocus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bottomVc);
        make.left.equalTo(self.view);
        make.height.equalTo(@(49));
        make.width.equalTo(@(W/2 - 0.5));
    }];
    btnFocus.imageView.sd_layout
    .leftSpaceToView(btnFocus,0.15 * W)
    .centerYEqualToView(btnFocus)
    .widthIs(18.9)
    .heightIs(16.8);
    btnFocus.titleLabel.sd_layout
    .centerYEqualToView(btnFocus)
    .leftSpaceToView(btnFocus.imageView,8)
    .heightIs(16)
    .widthIs(64);
    [btnFocus setImage:[UIImage imageNamed:@"发现_详情_关注off"] forState:UIControlStateNormal];
    [btnFocus setTitle:@"添加关注" forState:UIControlStateNormal];
    [btnFocus setTitleColor:FUIColorFromRGB(0xff5672) forState:UIControlStateNormal];
    btnFocus.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnFocus addTarget:self action:@selector(guanzhubtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 分隔线
    UILabel *lbFenGe = [[UILabel alloc] init];
    [_bottomVc addSubview:lbFenGe];
    [lbFenGe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnFocus.mas_right);
        make.centerY.equalTo(btnFocus);
        make.width.equalTo(@(1));
        make.height.equalTo(@(btnFocus.frame.size.height / 2));
    }];
    lbFenGe.backgroundColor = FUIColorFromRGB(0xdcdcdc);
    
    // 关联商品
    UIButton *linkGoodBtn = [[UIButton alloc] init];
    [_bottomVc addSubview:linkGoodBtn];
    [linkGoodBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomVc);
        make.left.equalTo(btnFocus.mas_right).with.offset(1);
        make.width.equalTo(btnFocus);
        make.height.equalTo(@(49));
    }];
    linkGoodBtn.imageView.sd_layout
    .leftSpaceToView(linkGoodBtn,0.15 * W)
    .centerYEqualToView(linkGoodBtn)
    .widthIs(18.9)
    .heightIs(16.8);
    linkGoodBtn.titleLabel.sd_layout
    .centerYEqualToView(linkGoodBtn)
    .leftSpaceToView(linkGoodBtn.imageView,8)
    .heightIs(16)
    .widthIs(64);
    [linkGoodBtn setImage:[UIImage imageNamed:@"发现_详情_关联"] forState:UIControlStateNormal];
    [linkGoodBtn setTitleColor:FUIColorFromRGB(0x8979ff) forState:UIControlStateNormal];
    [linkGoodBtn setTitle:@"关联商品" forState:UIControlStateNormal];
    linkGoodBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [linkGoodBtn addTarget:self action:@selector(linkBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

// 网页加载完成
- (void) webViewDidFinishLoad:(UIWebView *)webView {
    
    [_HUD hide:YES];
}

// 关注按钮点击事件
- (void) guanzhubtnClick:(UIButton *)guanzhuBtn {
    
    //    if(guanzhuBtn.selected == NO){
    //
    //        guanzhuBtn.selected = YES;
    //        [guanzhuBtn setImage:[UIImage imageNamed:@"发现_详情_关注on"] forState:UIControlStateNormal];
    //    }else {
    //
    //        guanzhuBtn.selected = NO;
    //        [guanzhuBtn setImage:[UIImage imageNamed:@"发现4"] forState:UIControlStateNormal];
    //    }
    
    alert(@"点击了添加关注");
}

// 关联商品点击事件
- (void) linkBtnClick {
    
    NSLog(@"关联商品");
    LinkGoodsViewController *vc = [[LinkGoodsViewController alloc] init];
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

// 页面将要消失
- (void) viewWillDisappear:(BOOL)animated {
    
    [_HUD hide:YES];
}

// 页面将要加载
- (void) viewWillAppear:(BOOL)animated {
    
    // 隐藏导航栏
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
