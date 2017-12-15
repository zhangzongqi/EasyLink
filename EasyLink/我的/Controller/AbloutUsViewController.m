//
//  AbloutUsViewController.m
//  EasyLink
//
//  Created by 琦琦 on 2017/5/26.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "AbloutUsViewController.h"

@interface AbloutUsViewController ()

@end

@implementation AbloutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置导航栏标题
    UILabel *lbItemTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    lbItemTitle.text = @"关于我们";
    lbItemTitle.textColor = FUIColorFromRGB(0xffffff);
    lbItemTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lbItemTitle;
    
    // 页面背景色
    self.view.backgroundColor = FUIColorFromRGB(0xeeeeee);
    
    // 返回按钮
    [self createBackBtn];
    
    // 创建UI
    [self createUI];
}

// 创建UI
- (void) createUI {
    
    // 图片
    UIImageView *imgView = [[UIImageView alloc] init];
    [self.view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).with.offset(0.07 * H);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@(H * 0.15625));
        make.width.equalTo(@(H * 0.15625));
    }];
    imgView.image = [UIImage imageNamed:@"aboutUs"];
    
    // 文字
    UILabel *lbAboutUs = [[UILabel alloc] init];
    [self.view addSubview:lbAboutUs];
    [lbAboutUs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.mas_bottom).with.offset(0.07 * H);
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).with.offset(20);
        make.width.equalTo(@(W - 40));
    }];
    lbAboutUs.numberOfLines = 0;
    
    NSString *string = @"    青岛峰颠信息传媒有限公司成立于2013年，是一家致力于从事APP项目开发、广告制作以及高端传媒展位推广的互联网科技公司，与北京广播电视台、北京中视鹏润科技有限公司有深度业务合作，拥有丰富的移动化应用开发与运营经验。作为一家创新性科技企业，公司坚持以人为本、重视人才培养的基本原则，团队内部形成了高效率、高创新、高协作的管理理念。利用全新的社交逻辑思维，在互联网领域不断寻求新的突破点，在产品研发及用户服务上进行创新与发展。";
    // 行间距
    lbAboutUs.attributedText = [self getAttributedStringWithString:string lineSpace:5];
    lbAboutUs.textColor = FUIColorFromRGB(0x4e4e4e);
    if (iPhone6SP) {
        lbAboutUs.font = [UIFont systemFontOfSize:17];
    }else if(iPhone6S){
        lbAboutUs.font = [UIFont systemFontOfSize:16];
    }else {
        lbAboutUs.font = [UIFont systemFontOfSize:15];
    }
    
    
    // 公司名
    UILabel *lbCompanyName = [[UILabel alloc] init];
    [self.view addSubview:lbCompanyName];
    [lbCompanyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbAboutUs.mas_bottom).with.offset(50);
        make.centerX.equalTo(self.view);
    }];
    lbCompanyName.text = @"青岛峰颠信息传媒有限公司";
    lbCompanyName.textColor = FUIColorFromRGB(0x999999);
    if (iPhone6SP) {
        lbCompanyName.font = [UIFont systemFontOfSize:17];
    }else if(iPhone6S){
        lbCompanyName.font = [UIFont systemFontOfSize:16];
    }else {
        lbCompanyName.font = [UIFont systemFontOfSize:15];
    }
    
}

//  一个string转换成AttributedString的方法
-(NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace; // 调整行间距
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    return attributedString;
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

// 界面将要进入
- (void) viewWillAppear:(BOOL)animated {
    
    // 设置导航栏背景色(用到了UIImage+GradientColor.h这个类扩展)
    UIColor *topleftColor1 = FUIColorFromRGB(0x9080ff);
    UIColor *bottomColor1 = FUIColorFromRGB(0x7d6dfa);
    UIImage *bgImg1 = [UIImage gradientColorImageFromColors:@[topleftColor1, bottomColor1] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(W, 64)];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:bgImg1]];
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
