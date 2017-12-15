//
//  HelpDetailViewController.m
//  EasyLink
//
//  Created by 琦琦 on 2017/5/27.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "HelpDetailViewController.h"

@interface HelpDetailViewController () {
    
    // 保存请求到的数据
    NSDictionary *_dicForDetail;
    
    // 网页
    UIWebView *_webview;
}

@property (nonatomic, copy) UILabel *titleLable;

@end

@implementation HelpDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 返回按钮
    [self createBackBtn];
    
    // 设置导航栏标题
    UILabel *lbItemTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    lbItemTitle.text = @"帮助详情";
    lbItemTitle.textColor = [UIColor whiteColor];
    lbItemTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lbItemTitle;
    
    // 初始化数组
    [self initDataSource];
    
    // 获取数据
    [self initData];
}

// 初始化数组
- (void) initDataSource {
    
    // 网页数据数组初始化
    _dicForDetail = [[NSDictionary alloc] init];
}


// 获取数据
- (void)initData {
    
    // 创建请求对象
    HttpRequest *http = [[HttpRequest alloc] init];
    // 发起请求
    [http GetHelpListDetailWithId:_strId Success:^(id helpDetailDic) {
        
        // 把拿到的数据保存到全局字典
        _dicForDetail = helpDetailDic;
        
        // 布局页面
        [self layoutViews];
        
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
        
        
    }];
    
}

// html内部加载完成方法
- (void) loadData {
    
    NSLog(@"********%@",[_dicForDetail objectForKey:@"content"]);
    
    NSString *str1 = [NSString stringWithFormat:@"showDetail('%@')",[self strReplace:[_dicForDetail objectForKey:@"content"]]];
    NSString *alertJS=str1; //准备执行的js代码
    [self.context evaluateScript:alertJS];//通过oc方法调用js的alert
}

// 布局页面
- (void) layoutViews {
    
    // 标题
    _titleLable = [[UILabel alloc] init];
    [self.view addSubview:_titleLable];
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(25);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@(18));
    }];
    _titleLable.font = [UIFont systemFontOfSize:17];
    _titleLable.textColor = FUIColorFromRGB(0x000000);
    _titleLable.text = [_dicForDetail objectForKey:@"title"];
    
    // 网页加载
    _webview = [[UIWebView alloc] init];
    [self.view addSubview:_webview];
    [_webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLable.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(@(H - 57));
    }];
    
    _webview.delegate = self;
    _webview.backgroundColor = FUIColorFromRGB(0xffffff);
    
}


// 替换字符串中某一段
- (NSString *) strReplace:(NSString *)str {
    
    // 替换字符串
    NSString *str1 = [str stringByReplacingOccurrencesOfString:@"/ueditor/php/upload/image/" withString:@"http://app.huopinb.com/ueditor/php/upload/image/"];
    
    return str1;
    
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
