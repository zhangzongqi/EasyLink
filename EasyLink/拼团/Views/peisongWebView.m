//
//  peisongWebView.m
//  EasyLink
//
//  Created by 琦琦 on 2017/5/21.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "peisongWebView.h"


#define Width self.frame.size.width
#define Height self.frame.size.height

@implementation peisongWebView

// 创建frame
- (id) initWithFrame:(CGRect)frame WithWebUrl:(NSString *)urlStr {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = FUIColorFromRGB(0xffffff);
        
        //        640*640
        
        // 顶部视图
        _topView = [[UIView alloc] init];
        [self addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.width.equalTo(@(Width));
            make.height.equalTo(@(Width * 0.1625));
        }];
        _topView.backgroundColor = FUIColorFromRGB(0xffffff);

        // 配送信息label
        UILabel *lb = [[UILabel alloc] init];
        [_topView addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(_topView);
            make.centerY.equalTo(_topView);
            make.height.equalTo(@(17));
        }];
        lb.font = [UIFont systemFontOfSize:16];
        lb.text = @"配送信息";
        
        // 分割线
        UILabel *lbfenge = [[UILabel alloc] init];
        [self addSubview:lbfenge];
        [lbfenge mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_topView.mas_bottom);
            make.left.equalTo(self);
            make.width.equalTo(@(Width));
            make.height.equalTo(@(1));
        }];
        lbfenge.backgroundColor = FUIColorFromRGB(0xeeeeee);
        
        
        // 网页
        WKWebView *wkWeb = [[WKWebView alloc] init];
        [wkWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
        [self addSubview:wkWeb];
        wkWeb.navigationDelegate = self;
        wkWeb.UIDelegate = self;
        [wkWeb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topView.mas_bottom).with.offset(1);
            make.left.equalTo(self);
            make.width.equalTo(@(Width));
            make.height.equalTo(@(Height - Width * 0.1625 - 1));
        }];
        wkWeb.backgroundColor = FUIColorFromRGB(0xffffff);
    }
    
    
    return self;
}


//
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
