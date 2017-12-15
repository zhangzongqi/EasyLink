//
//  WMDetailViewController.m
//  EasyLink
//
//  Created by 琦琦 on 16/9/13.
//  Copyright © 2016年 fengdian. All rights reserved.
//

#import "WMDetailViewController.h"
#import "DetailsViewController.h"
#import "BtnView.h"

@interface WMDetailViewController () {
    
    UIView *_allVc; // 全部视图
    UIView *_blackVc; // 遮罩层
    NSTimer *_timer; // 定时器
    UIView *_zhezhaoWMView; // WM控制器的遮罩层
    
    UIView *_kindView; // 弹出小视图
    UIView *_selectView; // 弹出选择视图
    UIImageView *_smallImgView; // 小圆弧

    UIView *_bigZheZhao; // 全部页面的遮罩层
    
    UIButton *_allBtn; // 展开全部分类按钮
    
    NSArray *_arrForKind; // 小分类
    
    int _indexBtn; // 记录点击的那个Btn
}

@property (nonatomic , strong) UILabel *lbFenGe; // 分割线

@end

@implementation WMDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置导航栏标题
    UILabel *lbItemTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    lbItemTitle.text = _str;
    lbItemTitle.textColor = [UIColor whiteColor];
    lbItemTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lbItemTitle;
    
    // 返回按钮
    [self createBackBtn];
    
    // 导航栏右侧按钮
    [self createRightBtn];
    
    _arrForKind = @[@"爽肤水",@"彩妆套装",@"古龙水",@"眼部护理",@"洁面乳",@"高光棒",@"隔离霜",@"眼霜",@"精华",@"剃须膏",@"彩妆盘",@"清洁面膜",@"淡香水",@"劲能醒肤"];
}

// 导航栏右侧按钮和视图
- (void) createRightBtn {
    
    // 右侧按钮
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 28, 23);
    menuBtn.imageView.sd_layout
    .topSpaceToView(menuBtn,1.5)
    .rightSpaceToView(menuBtn,0)
    .widthIs(5)
    .heightIs(20);
    [menuBtn setImage:[UIImage imageNamed:@"发现1"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    menuBtn.selected = NO;
    menuBtn.tag = 222;
    
    // 弹出小视图
    _kindView = [[UIView alloc] init];
    [self.navigationController.view addSubview:_kindView];
    _kindView.sd_layout
    .topSpaceToView(menuBtn,-5)
    .rightSpaceToView(menuBtn,- 35.5)
    .widthIs(20)
    .heightIs(35)
    ;
    _kindView.backgroundColor = [UIColor whiteColor];
    _kindView.hidden = YES;
    _kindView.layer.cornerRadius = 10;
    _kindView.clipsToBounds = YES;
    // 小视图上按钮
    UIButton *smallImgBtn = [[UIButton alloc] init];
    [_kindView addSubview:smallImgBtn];
    [smallImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_kindView);
        make.centerX.equalTo(_kindView);
        make.width.equalTo(_kindView);
        make.height.equalTo(_kindView);
    }];
    smallImgBtn.imageView.sd_layout
    .topSpaceToView(smallImgBtn,3.5)
    .centerXEqualToView(smallImgBtn)
    .widthIs(5)
    .heightIs(20);
    [smallImgBtn setImage:[UIImage imageNamed:@"品类列表_排序方式"] forState:UIControlStateNormal];
    [smallImgBtn addTarget:self action:@selector(smallBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 弹出筛选视图
    _selectView = [[UIView alloc] init];
    [self.navigationController.view addSubview:_selectView];
    [_selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_kindView.mas_bottom).with.offset(-12);
        make.right.equalTo(_kindView).with.offset(-0.01);
        make.width.equalTo(@(0.20625 * W));
        make.height.equalTo(@(H * 0.155));
    }];
    _selectView.backgroundColor = FUIColorFromRGB(0xffffff);
    _selectView.layer.cornerRadius = 5;
    _selectView.hidden = YES;
    
    NSArray *btnSelectName = @[@"综合",@"关注",@"浏览量"];
    
    for (int i = 0; i < 3; i++) {
        // 选择按钮
        UIButton *btnSelect = [[UIButton alloc] init];
        [_selectView addSubview:btnSelect];
        [btnSelect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_kindView.mas_bottom).with.offset(H * 0.155 / 3 * i + 1 - 10);
            make.right.equalTo(_selectView);
            make.width.equalTo(@(0.20625 * W));
            make.height.equalTo(@(H * 0.155 / 3 - 1));
        }];
        btnSelect.titleLabel.sd_layout
        .centerXEqualToView(btnSelect)
        .centerYEqualToView(btnSelect)
        .heightIs(14);
        [btnSelect setTitle:btnSelectName[i] forState:UIControlStateNormal];
        btnSelect.titleLabel.font = [UIFont systemFontOfSize:13];
        [btnSelect setTitleColor:FUIColorFromRGB(0x999999) forState:UIControlStateNormal];
        btnSelect.tag = 900 + i;
        [btnSelect addTarget:self action:@selector(btnSelectClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i < 2) {
            // 分割线
            UILabel *lbFenge = [[UILabel alloc] init];
            [_selectView addSubview:lbFenge];
            [lbFenge mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(btnSelect.mas_bottom);
                make.centerX.equalTo(btnSelect);
                make.width.equalTo(@(0.1375 * W));
                make.height.equalTo(@(1));
            }];
            lbFenge.backgroundColor = FUIColorFromRGB(0xeeeeee);
        }
    }
    
    // 小圆弧
    _smallImgView = [[UIImageView alloc] init];
    [self.navigationController.view addSubview:_smallImgView];
    [_smallImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_selectView.mas_top).with.offset(0.5);
        make.right.equalTo(_kindView.mas_left).with.offset(0.5);
        make.width.equalTo(@(6));
        make.height.equalTo(@(6));
    }];
    _smallImgView.image = [UIImage imageNamed:@"品类列表_排序方式_弹窗圆弧"];
    _smallImgView.hidden = YES;
    
    
    // 全部遮罩层
    _bigZheZhao = [[UIView alloc] initWithFrame:CGRectMake(0, 2, W, H)];
    [self.view addSubview:_bigZheZhao];
    _bigZheZhao.backgroundColor = [UIColor blackColor];
    _bigZheZhao.alpha = 0.5;
    _bigZheZhao.hidden = YES;
    // 遮罩层点击事件
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bigZheZhaoClick)];
    
    [_bigZheZhao addGestureRecognizer:tapGesture];
}

// 筛选条件点击事件
- (void) btnSelectClick:(UIButton *)btnSelect {
    
    // 关闭遮罩
    UIButton *btn = [self.navigationController.view viewWithTag:222];
    [self rightBtnClick:btn];
    
    if (btnSelect.tag == 900) {
        alert(@"点击了综合");
    }else if (btnSelect.tag == 901) {
        alert(@"点击了关注");
    }else {
        alert(@"点击了浏览量");
    }
}

// 小视图上按钮点击事件
- (void) smallBtnClick {
    // 调用右侧按钮点击事件
    UIButton *btn = [self.navigationController.view viewWithTag:222];
    
    [self rightBtnClick:btn];
}

// 大遮罩视图点击事件
- (void) bigZheZhaoClick {
    
    UIButton *btn = [self.navigationController.view viewWithTag:222];
    
    [self rightBtnClick:btn];
}

// 导航栏右侧按钮点击事件
- (void) rightBtnClick:(UIButton *)btn {
    
    if (btn.selected == NO) {
        
        btn.selected = YES;
        _bigZheZhao.hidden = NO;
        _kindView.hidden = NO;
        _selectView.hidden = NO;
        _smallImgView.hidden = NO;
        
        
    }else {
        btn.selected = NO;
        _kindView.hidden = YES;
        _bigZheZhao.hidden = YES;
        _selectView.hidden = YES;
        _smallImgView.hidden = YES;
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

// 标题们
- (NSArray <NSString *> *)titles {
    
    return @[@"爽肤水",@"彩妆套装",@"古龙水",@"眼部护理",@"洁面乳",@"高光棒",@"隔离霜",@"眼霜",@"精华",@"剃须膏",@"彩妆盘",@"清洁面膜",@"淡香水",@"劲能醒肤"];
}

// 一些属性
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    
    // 已修改MenuView的Frame  具体搜索MenuViewframe
    // 已修改lineWidth 具体搜索LineWidth
    
    self.menuItemWidth = W / 6;
    self.menuViewStyle = WMMenuViewStyleLine;
    self.progressViewBottomSpace = 2;
    self.progressHeight = 1.5;
    self.menuHeight = 32;
    self.titleColorNormal = FUIColorFromRGB(0xc0b8ff);
    self.titleColorSelected = FUIColorFromRGB(0xffffff);
    self.titleSizeNormal = 12;
    self.titleSizeSelected = 14;
    self.showOnNavigationBar = NO;
    
    // 设置导航栏背景色(用到了UIImage+GradientColor.h这个类扩展)
    UIColor *topleftColor1 = FUIColorFromRGB(0x9080ff);
    UIColor *bottomColor1 = FUIColorFromRGB(0x7d6dfa);
    UIImage *bgImg1 = [UIImage gradientColorImageFromColors:@[topleftColor1, bottomColor1] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(W, 64)];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:bgImg1]];
    // 新闻条渐变背景色
    UIColor *topColor = FUIColorFromRGB(0x7d6dfa);
    UIColor *bottomColor = FUIColorFromRGB(0x7361f8);
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topColor, bottomColor] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(W, 32)];
    self.menuBGColor = [UIColor colorWithPatternImage:bgImg];
    
    
    // 全部视图
    [self createAllViews];
    
    return self.titles.count;
}

// 全部视图
- (void) createAllViews {
    
    // WMView的遮罩层
    _zhezhaoWMView = [[UIView alloc] initWithFrame:CGRectMake(0, 65, W - W/10, 32)];
    UIColor *topColor2 = FUIColorFromRGB(0x7d6dfa);
    UIColor *bottomColor2 = FUIColorFromRGB(0x7361f8);
    UIImage *bgImg2 = [UIImage gradientColorImageFromColors:@[topColor2, bottomColor2] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(W/10, 32)];
    _zhezhaoWMView.backgroundColor = [UIColor colorWithPatternImage:bgImg2];
    [self.navigationController.view addSubview:_zhezhaoWMView];
    _zhezhaoWMView.hidden = YES;
    UILabel *quanbuLb = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, 64, 16)];
    quanbuLb.textColor = [UIColor whiteColor];
    quanbuLb.text = @"全部分类";
    quanbuLb.font = [UIFont systemFontOfSize:15];
    [_zhezhaoWMView addSubview:quanbuLb];
    
    // 查看全部视图
    UIView *rightVc = [[UIView alloc] initWithFrame:CGRectMake(W - W/10, 0, W/10, 32)];
    UIColor *topColor = FUIColorFromRGB(0x7d6dfa);
    UIColor *bottomColor = FUIColorFromRGB(0x7361f8);
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topColor, bottomColor] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(W/10, 32)];
    rightVc.backgroundColor = [UIColor colorWithPatternImage:bgImg];
    [self.view addSubview:rightVc];
    _allBtn = [[UIButton alloc] initWithFrame:CGRectMake(0 , 0, W/10, 32)];
    [_allBtn setImage:[UIImage imageNamed:@"品类列表_未展开"] forState:UIControlStateNormal];
    [rightVc addSubview:_allBtn];
    _allBtn.imageView.sd_layout
    .centerXEqualToView(_allBtn)
    .topSpaceToView(_allBtn,_allBtn.frame.size.height/4)
    .widthIs(16)
    .heightIs(16);
    // 查看全部点击事件
    [_allBtn addTarget:self action:@selector(allbtnClick) forControlEvents:UIControlEventTouchUpInside];
    _allBtn.selected = NO;
    
    // 分割线
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 1, 16)];
    lb.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:253/255.0 alpha:1.0];
    [rightVc addSubview:lb];
    
    // 显示全部的一些事件
    _allVc = [BtnView creatBtn];
    _allVc.frame = CGRectMake(0, 64+32, W, 0);
    [self.navigationController.view addSubview:_allVc];
    _allVc.backgroundColor = [UIColor whiteColor];
    _allVc.hidden = YES;
    
    //遍历这个view，对这个view上btn添加相应的事件
    for (UIButton *btn in _allVc.subviews) {
        [btn addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
        btn.hidden = YES;
    }
    
    CGFloat height = [BtnView creatBtn].frame.size.height;
    
    // 遮罩层
    _blackVc = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 32 + height, W, H - height)];
    [self.navigationController.view addSubview:_blackVc];
    _blackVc.backgroundColor = [UIColor blackColor];
    _blackVc.alpha = 0.5;
    _blackVc.hidden = YES;
    
    // 遮罩层点击事件
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo)];
    
    [_blackVc addGestureRecognizer:tapGesture];
}


// 显示全部的点击事件
- (void)handleButton:(UIButton *)button {
    
    NSLog(@"%@",button.titleLabel.text);
    
    for(int i = 0; i< _arrForKind.count; i++) {
        if([_arrForKind[i] isEqualToString:button.titleLabel.text]){
            
            _indexBtn = i;
            
            self.selectIndex = _indexBtn;
            
            [self Actiondo];
        }
    }
}

// 遮罩层点击事件
- (void) Actiondo {
    
    // 调用显示全部按钮
    [self allbtnClick];
}


// 查看全部的点击事件
- (void) allbtnClick {
    
    if (_allBtn.selected == NO) {
        _allBtn.selected = YES;
        // 关闭右侧按钮交互开关
        self.navigationItem.rightBarButtonItem.customView.userInteractionEnabled = NO;
        
        [_allBtn setImage:[UIImage imageNamed:@"品类列表_展开"] forState:UIControlStateNormal];
        
    }else {
        _allBtn.selected = NO;
        
        // 打开右侧按钮交互开关
        self.navigationItem.rightBarButtonItem.customView.userInteractionEnabled = YES;
        [_allBtn setImage:[UIImage imageNamed:@"品类列表_未展开"] forState:UIControlStateNormal];
    }
    
    
    
    if (_allVc.hidden == YES) {
        
        _zhezhaoWMView.hidden = NO;
        
        // 启动定时器
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(zhezhao) userInfo:nil repeats:YES];
    }
    
    if (_allVc.hidden == YES) {
        [UIView animateWithDuration:0.3f animations:^{
            
            _allVc.hidden = NO;
            
            CGFloat height = [BtnView creatBtn].frame.size.height;
            
            _allVc.frame = CGRectMake(0, 32 + 64, W, height);
            
            _allBtn.userInteractionEnabled = NO;
            
        }completion:^(BOOL finished) {
            
            _allBtn.userInteractionEnabled = YES;
        }];
        
    }else {
        
        _zhezhaoWMView.hidden = YES;
        
        [UIView animateWithDuration:0.3f animations:^{
            
            for (UIButton *btn in _allVc.subviews) {
                
                btn.hidden = YES;
            }
            
            // 启动定时器
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(quanbu) userInfo:nil repeats:YES];
            
            _blackVc.hidden = YES;
    
            _allVc.frame = CGRectMake(0, 32 + 64, W, 0);
            
            _allBtn.userInteractionEnabled = NO;
            
        }completion:^(BOOL finished) {
            
            _allBtn.userInteractionEnabled = YES;
        }];
    }
}

- (void) zhezhao {
    
    _blackVc.hidden = NO;
    
    for (UIButton *btn in _allVc.subviews) {
        
        btn.hidden = NO;
    }
    
    // 让定时器停止
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void) quanbu {
    
    if (_blackVc.hidden == YES && _allVc.hidden == NO) {
        
        _allVc.hidden = YES;
        
        // 让定时器停止
        [_timer setFireDate:[NSDate distantFuture]];
    }
    
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    
    return self.titles[index];
}

// page
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    DetailsViewController *detailVC = [[DetailsViewController alloc] init];
    
    // 传入参数，获取到是第几个页面
    detailVC.strIndex = [NSString stringWithFormat:@"%ld",(long)index];
    
    return detailVC;
}

// 视图将要显示
- (void) viewWillAppear:(BOOL)animated {
    
    // 导航栏与下半部分分割线
    _lbFenGe = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, W, 2)];
    _lbFenGe.backgroundColor = FUIColorFromRGB(0xffffff);
    _lbFenGe.alpha = 0.2;
    [self.navigationController.view addSubview:_lbFenGe];
}

// 视图将要消失
- (void) viewWillDisappear:(BOOL)animated {
    
    _kindView.hidden = YES;
    _bigZheZhao.hidden = YES;
    _selectView.hidden = YES;
    _smallImgView.hidden = YES;
    
    // 筛选按钮的选中状态
    UIButton *btn = [self.navigationController.view viewWithTag:222];
    btn.selected = NO;
    
    // 显示全部分类的按钮图标、选中状态
    [_allBtn setImage:[UIImage imageNamed:@"品类列表_未展开"] forState:UIControlStateNormal];
    _allBtn.selected = NO;

    
    _allVc.hidden = YES;
    _blackVc.hidden = YES;
    _zhezhaoWMView.hidden = YES;

    [_lbFenGe removeFromSuperview];
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
