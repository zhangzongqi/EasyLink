//
//  LinkGoodsViewController.m
//  EasyLink
//
//  Created by 琦琦 on 16/11/8.
//  Copyright © 2016年 fengdian. All rights reserved.
//  关联商品

#import "LinkGoodsViewController.h"

// 距离上端的距离
#define topOut 0.1583 * H + 44
#define topCenter 0.140625 * H + 44
#define topBack 0.140625 * H - (0.1583 * H - 0.140625 * H) + 44
#define OutAlpha 1
#define CenterAlpha 0.2
#define BackAlpha 0.3


@interface LinkGoodsViewController () {
    
    UIImageView *_bacImgView; // 底层背景图
    
    NSInteger _count; // 计次
    
    // 4个视图
    UIView *_vc1;
    UIView *_vc2;
    UIView *_vc3;
    UIView *_vc4;
    
    // 4个视图上的图片
    UIImageView *_imgView1;
    UIImageView *_imgView2;
    UIImageView *_imgView3;
    UIImageView *_imgView4;
    // 4个视图上的标题
    UILabel *_titleLb1;
    UILabel *_titleLb2;
    UILabel *_titleLb3;
    UILabel *_titleLb4;
    // 价格
    UILabel *_priceLb1;
    UILabel *_priceLb2;
    UILabel *_priceLb3;
    UILabel *_priceLb4;
    // 购买按钮
    UIButton *_btnBuy1;
    UIButton *_btnBuy2;
    UIButton *_btnBuy3;
    UIButton *_btnBuy4;
    
    // 显示出来的三个视图的宽度
    CGFloat _outW;
    CGFloat _centerW;
    CGFloat _backW;
    
    // 显示出来的三个视图的高度
    CGFloat _outH;
    CGFloat _centerH;
    CGFloat _backH;
    
    // 显示出来的三个视图的中心点
    CGPoint _ptOut;
    CGPoint _ptCenter;
    CGPoint _ptBack;
    
    NSArray *_arrImg; // 图片数组
    NSArray *_arrName; // 名字数组
    NSArray *_arrPrice; // 价格数组

}

@end

@implementation LinkGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 背景色
    self.view.backgroundColor = FUIColorFromRGB(0xffffff);
    
    _count = 0;
    
    _outW = 0.78125 * W;
    _outH = 0.74167 * H - 64;
    
    _centerW = 0.71875 * W;
    _centerH = _outH - (_outW - _centerW) / 2;
    
    _backW = _centerW - (_outW - _centerW);
    _backH = _centerH - (_outW - _centerW) / 2;
    
    
    _arrImg = @[@"discover_linkpro1_01",@"discover_linkpro1_02",@"discover_linkpro1_03",@"discover_linkpro3_01",@"discover_linkpro3_02",@"discover_linkpro3_03",@"discover_linkpro3_04",@"discover_linkpro3_05",@"discover_linkpro3_06"];
    
    _arrName = @[@"THE BEAST/野兽派 幸福的小王子餐盘",@"THE BEAST/野兽派 真丝薄纱丝巾",@"THE BEAST/野兽派 luna系列天然母贝项链",@"掬涵家居:仿真鸢尾花",@"掬涵家居:暮雪仿真树球盆景",@"掬涵家居:日式铁艺烛台",@"掬涵家居:香蕉蜡烛",@"掬涵家居:复古蓝铁皮花筒",@"掬涵家居:屏风篱笆装饰花艺"];
    _arrPrice = @[@"¥1014.00",@"¥64.00",@"¥38.00",@"¥158.60",@"¥116.30",@"¥104.20",@"¥201.00",@"¥33.20",@"¥66.80"];
    
    // 布局UI
    [self createUI];
}

// 布局UI
- (void) createUI {
    
    // 背景图
    _bacImgView = [[UIImageView alloc] init];
    [self.view addSubview:_bacImgView];
    [_bacImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.height.equalTo(self.view);
        make.width.equalTo(self.view);
    }];
    _bacImgView.image = [UIImage imageNamed:@"关联商品bg"];
    _bacImgView.userInteractionEnabled = YES;
    
    // 返回按钮和标题
    [self createBackBtn];
    
    // 4个视图
    _vc1 = [[UIView alloc] initWithFrame:CGRectMake(0, topOut, _outW, _outH)];
    CGPoint pt1 = _vc1.center;
    pt1.x = self.view.frame.size.width / 2;
    _ptOut = pt1;
    _vc1.center = _ptOut;

    _vc2 = [[UIView alloc] initWithFrame:CGRectMake(0, topCenter, _centerW, _centerH)];
    CGPoint pt2 = _vc2.center;
    pt2.x = self.view.frame.size.width / 2;
    _ptCenter = pt2;
    _vc2.center = _ptCenter;
    
    _vc3 = [[UIView alloc] initWithFrame:CGRectMake(0, topBack, _backW, _backH)];
    CGPoint pt3 = _vc3.center;
    pt3.x = self.view.frame.size.width / 2;
    _ptBack = pt3;
    _vc3.center = _ptBack;
    
    _vc4 = [[UIView alloc] initWithFrame:CGRectMake(0, topBack, _backW, _backH)];
    _vc4.center = _ptBack;
    
    [self.view addSubview:_vc4];
    [self.view addSubview:_vc3];
    [self.view addSubview:_vc2];
    [self.view addSubview:_vc1];
    
    // 背景色
    _vc1.backgroundColor = FUIColorFromRGB(0xffffff);
    _vc2.backgroundColor = FUIColorFromRGB(0xffffff);
    _vc3.backgroundColor = FUIColorFromRGB(0xffffff);
    _vc4.backgroundColor = FUIColorFromRGB(0xffffff);
    // 圆角
    _vc1.layer.cornerRadius = 5;
    _vc2.layer.cornerRadius = 5;
    _vc3.layer.cornerRadius = 5;
    _vc4.layer.cornerRadius = 5;
    _vc1.clipsToBounds = YES;
    _vc2.clipsToBounds = YES;
    _vc3.clipsToBounds = YES;
    _vc4.clipsToBounds = YES;
    
    // 透明度
    _vc1.alpha = OutAlpha;
    _vc2.alpha = CenterAlpha;
    _vc3.alpha = BackAlpha;
    _vc4.hidden = YES;
    
    // 4个视图图片 4个视图标题 4个视图价格
    _imgView1 = [[UIImageView alloc] init];
    _imgView2 = [[UIImageView alloc] init];
    _imgView3 = [[UIImageView alloc] init];
    _imgView4 = [[UIImageView alloc] init];
    [_vc1 addSubview:_imgView1];
    [_vc2 addSubview:_imgView2];
    [_vc3 addSubview:_imgView3];
    [_vc4 addSubview:_imgView4];
    _titleLb1 = [[UILabel alloc] init];
    _titleLb2 = [[UILabel alloc] init];
    _titleLb3 = [[UILabel alloc] init];
    _titleLb4 = [[UILabel alloc] init];
    [_vc1 addSubview:_titleLb1];
    [_vc2 addSubview:_titleLb2];
    [_vc3 addSubview:_titleLb3];
    [_vc4 addSubview:_titleLb4];
    _priceLb1 = [[UILabel alloc] init];
    _priceLb2 = [[UILabel alloc] init];
    _priceLb3 = [[UILabel alloc] init];
    _priceLb4 = [[UILabel alloc] init];
    [_vc1 addSubview:_priceLb1];
    [_vc2 addSubview:_priceLb2];
    [_vc3 addSubview:_priceLb3];
    [_vc4 addSubview:_priceLb4];
    _btnBuy1 = [[UIButton alloc] init];
    _btnBuy2 = [[UIButton alloc] init];
    _btnBuy3 = [[UIButton alloc] init];
    _btnBuy4 = [[UIButton alloc] init];
    [_vc1 addSubview:_btnBuy1];
    [_vc2 addSubview:_btnBuy2];
    [_vc3 addSubview:_btnBuy3];
    [_vc4 addSubview:_btnBuy4];
    
    // 布局
    [_imgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_vc1);
        make.left.equalTo(_vc1);
        make.width.equalTo(_vc1);
        make.height.mas_equalTo(_vc1.mas_height).multipliedBy(0.6901408);
    }];
    _imgView1.image = [UIImage imageNamed:_arrImg[_count]];
    [_titleLb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgView1.mas_bottom).with.offset(0.03797 * _vc1.frame.size.height);
        make.left.equalTo(_vc1).with.offset(0.036 * _vc1.frame.size.width);
        make.width.mas_equalTo(_vc1.mas_width).multipliedBy(0.928);
        make.height.mas_equalTo(_vc1.mas_height).multipliedBy(0.029535);
    }];
    _titleLb1.text = _arrName[_count];
    [_priceLb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_vc1.mas_bottom).with.offset(- 0.0493 *_vc1.frame.size.height);
        make.left.equalTo(_titleLb1);
        make.height.equalTo(_titleLb1);
    }];
    // 设置文字
    [self textFrom:_priceLb1 andData:_arrPrice[_count]];
    [_btnBuy1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_priceLb1);
        make.right.equalTo(_vc1.mas_right).with.offset(- 0.036 * _vc1.frame.size.width);
        make.width.mas_equalTo(_vc1.mas_width).multipliedBy(0.36);
        make.height.mas_equalTo(_vc1.mas_height).multipliedBy(0.06479);
    }];
    _btnBuy1.layer.cornerRadius = _vc1.frame.size.height * 0.06479 / 2;
    _btnBuy1.backgroundColor = FUIColorFromRGB(0xff5672);
    [_btnBuy1 setTitle:@"立即购买" forState:UIControlStateNormal];
    [_btnBuy1 setTitleColor:FUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    
    
    // 字体颜色
    _titleLb1.textColor = FUIColorFromRGB(0x212121);
    _titleLb2.textColor = FUIColorFromRGB(0x212121);
    _titleLb3.textColor = FUIColorFromRGB(0x212121);
    _titleLb4.textColor = FUIColorFromRGB(0x212121);
    _priceLb1.textColor = FUIColorFromRGB(0xff5672);
    _priceLb2.textColor = FUIColorFromRGB(0xff5672);
    _priceLb3.textColor = FUIColorFromRGB(0xff5672);
    _priceLb4.textColor = FUIColorFromRGB(0xff5672);
    if (iPhone6SP) {
        _titleLb1.font = [UIFont systemFontOfSize:15];
        _titleLb2.font = [UIFont systemFontOfSize:15];
        _titleLb3.font = [UIFont systemFontOfSize:15];
        _titleLb4.font = [UIFont systemFontOfSize:15];
        _btnBuy1.titleLabel.font = [UIFont systemFontOfSize:15];
        _btnBuy2.titleLabel.font = [UIFont systemFontOfSize:15];
        _btnBuy3.titleLabel.font = [UIFont systemFontOfSize:15];
        _btnBuy4.titleLabel.font = [UIFont systemFontOfSize:15];
    }else if (iPhone6S) {
        _titleLb1.font = [UIFont systemFontOfSize:14];
        _titleLb2.font = [UIFont systemFontOfSize:14];
        _titleLb3.font = [UIFont systemFontOfSize:14];
        _titleLb4.font = [UIFont systemFontOfSize:14];
        _btnBuy1.titleLabel.font = [UIFont systemFontOfSize:14];
        _btnBuy2.titleLabel.font = [UIFont systemFontOfSize:14];
        _btnBuy3.titleLabel.font = [UIFont systemFontOfSize:14];
        _btnBuy4.titleLabel.font = [UIFont systemFontOfSize:14];
    }else if (iPhone4S) {
        _titleLb1.font = [UIFont systemFontOfSize:12];
        _titleLb2.font = [UIFont systemFontOfSize:12];
        _titleLb3.font = [UIFont systemFontOfSize:12];
        _titleLb4.font = [UIFont systemFontOfSize:12];
        _btnBuy1.titleLabel.font = [UIFont systemFontOfSize:12];
        _btnBuy2.titleLabel.font = [UIFont systemFontOfSize:12];
        _btnBuy3.titleLabel.font = [UIFont systemFontOfSize:12];
        _btnBuy4.titleLabel.font = [UIFont systemFontOfSize:12];
    }else {
        _titleLb1.font = [UIFont systemFontOfSize:13];
        _titleLb2.font = [UIFont systemFontOfSize:13];
        _titleLb3.font = [UIFont systemFontOfSize:13];
        _titleLb4.font = [UIFont systemFontOfSize:13];
        _btnBuy1.titleLabel.font = [UIFont systemFontOfSize:13];
        _btnBuy2.titleLabel.font = [UIFont systemFontOfSize:13];
        _btnBuy3.titleLabel.font = [UIFont systemFontOfSize:13];
        _btnBuy4.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    

    [_imgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_vc2);
        make.left.equalTo(_vc2);
        make.width.equalTo(_vc2);
        make.height.mas_equalTo(_vc2.mas_height).multipliedBy(0.6901408);
    }];
    [_titleLb2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgView2.mas_bottom).with.offset(0.03797 * _vc2.frame.size.height);
        make.left.equalTo(_vc2).with.offset(0.036 * _vc2.frame.size.width);
        make.width.mas_equalTo(_vc2.mas_width).multipliedBy(0.928);
        make.height.mas_equalTo(_vc2.mas_height).multipliedBy(0.029535);
    }];
    [_priceLb2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_vc2.mas_bottom).with.offset(- 0.0493 *_vc2.frame.size.height);
        make.left.equalTo(_titleLb2);
        make.height.equalTo(_titleLb2);
    }];
    [_btnBuy2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_priceLb2);
        make.right.equalTo(_vc2.mas_right).with.offset(- 0.036 * _vc2.frame.size.width);
        make.width.mas_equalTo(_vc2.mas_width).multipliedBy(0.36);
        make.height.mas_equalTo(_vc2.mas_height).multipliedBy(0.06479);
    }];
    _btnBuy2.layer.cornerRadius = _vc1.frame.size.height * 0.06479 / 2;
    _btnBuy2.backgroundColor = FUIColorFromRGB(0xff5672);
    [_btnBuy2 setTitle:@"立即购买" forState:UIControlStateNormal];
    [_btnBuy2 setTitleColor:FUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    
    [_imgView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_vc3);
        make.left.equalTo(_vc3);
        make.width.equalTo(_vc3);
        make.height.mas_equalTo(_vc3.mas_height).multipliedBy(0.6901408);
    }];
    [_titleLb3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgView3.mas_bottom).with.offset(0.03797 * _vc3.frame.size.height);
        make.left.equalTo(_vc3).with.offset(0.036 * _vc3.frame.size.width);
        make.width.mas_equalTo(_vc3.mas_width).multipliedBy(0.928);
        make.height.mas_equalTo(_vc3.mas_height).multipliedBy(0.029535);
    }];
    [_priceLb3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_vc3.mas_bottom).with.offset(- 0.0493 *_vc3.frame.size.height);
        make.left.equalTo(_titleLb3);
        make.height.equalTo(_titleLb3);
    }];
    [_btnBuy3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_priceLb3);
        make.right.equalTo(_vc3.mas_right).with.offset(- 0.036 * _vc3.frame.size.width);
        make.width.mas_equalTo(_vc3.mas_width).multipliedBy(0.36);
        make.height.mas_equalTo(_vc3.mas_height).multipliedBy(0.06479);
    }];
    _btnBuy3.layer.cornerRadius = _vc1.frame.size.height * 0.06479 / 2;
    _btnBuy3.backgroundColor = FUIColorFromRGB(0xff5672);
    [_btnBuy3 setTitle:@"立即购买" forState:UIControlStateNormal];
    [_btnBuy3 setTitleColor:FUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    
    [_imgView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_vc4);
        make.left.equalTo(_vc4);
        make.width.equalTo(_vc4);
        make.height.mas_equalTo(_vc4.mas_height).multipliedBy(0.6901408); // 固定高度是卡片视图高度的多少倍
    }];
    [_titleLb4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgView4.mas_bottom).with.offset(0.03797 * _vc4.frame.size.height);
        make.left.equalTo(_vc4).with.offset(0.036 * _vc4.frame.size.width);
        make.width.mas_equalTo(_vc4.mas_width).multipliedBy(0.928);
        make.height.mas_equalTo(_vc4.mas_height).multipliedBy(0.029535);
    }];
    [_priceLb4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_vc4.mas_bottom).with.offset(- 0.0493 *_vc4.frame.size.height);
        make.left.equalTo(_titleLb4);
        make.height.equalTo(_titleLb4);
    }];
    [_btnBuy4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_priceLb4);
        make.right.equalTo(_vc4.mas_right).with.offset(- 0.036 * _vc1.frame.size.width);
        make.width.mas_equalTo(_vc4.mas_width).multipliedBy(0.36);
        make.height.mas_equalTo(_vc4.mas_height).multipliedBy(0.06479);
    }];
    _btnBuy4.layer.cornerRadius = _vc1.frame.size.height * 0.06479 / 2;
    _btnBuy4.backgroundColor = FUIColorFromRGB(0xff5672);
    [_btnBuy4 setTitle:@"立即购买" forState:UIControlStateNormal];
    [_btnBuy4 setTitleColor:FUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    
    // 拖拽手势
    UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(doHandlePanAction:)];
    [_vc1 addGestureRecognizer:panGestureRecognizer];
    
    
    // 拖拽手势
    UIPanGestureRecognizer * panGestureRecognizer2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(doHandlePanAction2:)];
    [_vc2 addGestureRecognizer:panGestureRecognizer2];
    
    // 拖拽手势
    UIPanGestureRecognizer * panGestureRecognizer3 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(doHandlePanAction3:)];
    [_vc3 addGestureRecognizer:panGestureRecognizer3];
    
    // 拖拽手势
    UIPanGestureRecognizer * panGestureRecognizer4 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(doHandlePanAction4:)];
    [_vc4 addGestureRecognizer:panGestureRecognizer4];
    
    
    // 用户交互开关
    _vc1.userInteractionEnabled = YES;
    _vc2.userInteractionEnabled = NO;
    _vc3.userInteractionEnabled = NO;
    _vc4.userInteractionEnabled = NO;
    
}

// 设置价格字体大小
- (void) textFrom:(UILabel *)lb andData:(NSString *)strData {
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strData];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:8] range:NSMakeRange(0, 1)];
    
    if (iPhone4S) {
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(1, str.length - 1)];
    }else if (iPhone6S) {
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(1, str.length - 1)];
    }else if (iPhone6SP) {
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(1, str.length - 1)];
    }else {
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(1, str.length - 1)];
    }
    
    lb.attributedText = str;
}

// 拖拽手势_vc4 视图
- (void) doHandlePanAction4:(UIPanGestureRecognizer *)paramSender {
    
    // 开始拖拽
    if (paramSender.state == UIGestureRecognizerStateBegan) {
        
        NSLog(@"hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh%ld",_count);
        
        if (_count < _arrImg.count-1) {
            
            _count ++;
            
        }else {
            
            _count = 0;
        }
    }
    
    // 0.3秒内完成动画_vc4   _vc4 Out
    [UIView animateWithDuration:0.3f animations:^{
        
        _vc1.frame = CGRectMake(0, topOut, _outW, _outH);
        _vc1.center = _ptOut;
        _vc1.alpha = OutAlpha;
        _imgView1.image = [UIImage imageNamed:_arrImg[_count]];
        _titleLb1.text = _arrName[_count];
        [self textFrom:_priceLb1 andData:_arrPrice[_count]];
    }];
    // 0.3秒内完成动画_vc2   _vc2 Center
    [UIView animateWithDuration:0.3f animations:^{
        
        _vc2.frame = CGRectMake(0, topCenter, _centerW, _centerH);
        _vc2.center = _ptCenter;
        _vc2.alpha = CenterAlpha;
    }];
    // 0.3秒内完成动画_vc3   _vc3 Back
    [UIView animateWithDuration:0.3f animations:^{
        
        _vc3.hidden = NO;
        _vc3.alpha = BackAlpha;
    }];
    
    
    // 完成手势拖拽
    CGPoint point = [paramSender translationInView:self.view];
    NSLog(@"X:%f;Y:%f",point.x,point.y);
    
    paramSender.view.center = CGPointMake(paramSender.view.center.x + point.x, paramSender.view.center.y + point.y);
    
    [paramSender setTranslation:CGPointMake(0, 0) inView:self.view];
    
    
    // 拖拽结束
    if (paramSender.state == UIGestureRecognizerStateEnded) {
        
        // 移动的位置，大于页面总宽度的1/4
        if (fabs((paramSender.view.center.x - self.view.center.x)) > self.view.frame.size.width / 4) {
            
            
            [UIView animateWithDuration:0.3f animations:^{
                
                if (paramSender.view.center.x > self.view.frame.size.width / 2) {
                    
                    // 向右飞出
                    _vc4.frame = CGRectMake(W,topOut -  2 * (topOut - paramSender.view.frame.origin.y), _outW, _outH);
                    
                }else {
                    
                    // 向左飞出
                    _vc4.frame = CGRectMake(-_outW,topOut -  2 * (topOut - paramSender.view.frame.origin.y), _outW, _outH);
                }
                
                
            } completion:^(BOOL finished) {
                // 将视图转移成隐藏的底层
                _vc4.frame = CGRectMake(0, topBack, _backW, _backH);
                _vc4.center = _ptBack;
                [self.view insertSubview:_vc4 belowSubview:_vc3];
                _imgView4.image = [UIImage imageNamed:@"没有图片"];
                _vc4.hidden = YES;
                _vc4.alpha = 0.0;
                
                // 用户交互开关
                _vc1.userInteractionEnabled = YES;
                _vc2.userInteractionEnabled = NO;
                _vc3.userInteractionEnabled = NO;
                _vc4.userInteractionEnabled = NO;
                
            }];
        }else {
            
            if (_count != 0) {
                
                _count--;
                
            }else {
                
                _count = _arrImg.count - 1;
            }
            
            // 0.3秒内完成复原动画
            [UIView animateWithDuration:0.3f animations:^{
                
                _vc4.frame = CGRectMake(0, topOut, _outW, _outH);
                _vc4.center = _ptOut;
            }];
            
            // 0.3秒内完成动画_vc1复原
            [UIView animateWithDuration:0.3f animations:^{
                
                _vc1.frame = CGRectMake(0, topCenter, _centerW, _centerH);
                _vc1.center = _ptCenter;
                _vc1.alpha = CenterAlpha;
                
                // 移除图片
                _imgView1.image = [UIImage imageNamed:@"木有图片"];
                _titleLb1.text = @"";
//                [self textFrom:_priceLb1 andData:_arrPrice[_count]];
                
            } completion:^(BOOL finished) {
                // 移除图片
            }];
            
            // 0.3秒内完成动画_vc2复原
            [UIView animateWithDuration:0.3f animations:^{
                
                _vc2.frame = CGRectMake(0, topBack, _backW, _backH);
                _vc2.center = _ptBack;
                _vc2.alpha = BackAlpha;
            }];
            // 0.3秒内完成动画_vc3复原
            [UIView animateWithDuration:0.3f animations:^{
                
                _vc3.hidden = YES;
                _vc3.alpha = 0.0;
            }];
        }
    }
}

// 拖拽手势_vc3 视图
- (void) doHandlePanAction3:(UIPanGestureRecognizer *)paramSender {
    
    // 开始拖拽
    if (paramSender.state == UIGestureRecognizerStateBegan) {
        
        NSLog(@"hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh%ld",_count);
        
        if (_count < _arrImg.count-1) {
            
            _count ++;
            
        }else {
            
            _count = 0;
        }
    }
    
    // 0.3秒内完成动画_vc4   _vc4 Out
    [UIView animateWithDuration:0.3f animations:^{
        
        _vc4.frame = CGRectMake(0, topOut, _outW, _outH);
        _vc4.center = _ptOut;
        _vc4.alpha = OutAlpha;
        _imgView4.image = [UIImage imageNamed:_arrImg[_count]];
        _titleLb4.text = _arrName[_count];
        [self textFrom:_priceLb4 andData:_arrPrice[_count]];
    }];
    // 0.3秒内完成动画_vc1   _vc1 Center
    [UIView animateWithDuration:0.3f animations:^{
        
        _vc1.frame = CGRectMake(0, topCenter, _centerW, _centerH);
        _vc1.center = _ptCenter;
        _vc1.alpha = CenterAlpha;
    }];
    // 0.3秒内完成动画_vc2   _vc2 Back
    [UIView animateWithDuration:0.3f animations:^{
        
        _vc2.hidden = NO;
        _vc2.alpha = BackAlpha;
    }];
    
    
    // 完成手势拖拽
    CGPoint point = [paramSender translationInView:self.view];
    NSLog(@"X:%f;Y:%f",point.x,point.y);
    
    paramSender.view.center = CGPointMake(paramSender.view.center.x + point.x, paramSender.view.center.y + point.y);
    
    [paramSender setTranslation:CGPointMake(0, 0) inView:self.view];
    
    
    // 拖拽结束
    if (paramSender.state == UIGestureRecognizerStateEnded) {
        
        // 移动的位置，大于页面总宽度的1/4
        if (fabs((paramSender.view.center.x - self.view.center.x)) > self.view.frame.size.width / 4) {
            
            
            [UIView animateWithDuration:0.3f animations:^{
                
                if (paramSender.view.center.x > self.view.frame.size.width / 2) {
                    
                    // 向右飞出
                    _vc3.frame = CGRectMake(W,topOut -  2 * (topOut - paramSender.view.frame.origin.y), _outW, _outH);
                    
                }else {
                    
                    // 向左飞出
                    _vc3.frame = CGRectMake(-_outW,topOut -  2 * (topOut - paramSender.view.frame.origin.y), _outW, _outH);
                }
                
                
            } completion:^(BOOL finished) {
                // 将视图转移成隐藏的底层
                _vc3.frame = CGRectMake(0, topBack, _backW, _backH);
                _vc3.center = _ptBack;
                [self.view insertSubview:_vc3 belowSubview:_vc2];
                _imgView3.image = [UIImage imageNamed:@"没有图片"];
                _vc3.hidden = YES;
                _vc3.alpha = 0.0;
                
                // 用户交互开关
                _vc1.userInteractionEnabled = NO;
                _vc2.userInteractionEnabled = NO;
                _vc3.userInteractionEnabled = NO;
                _vc4.userInteractionEnabled = YES;
                
            }];
        }else {
            
            if (_count != 0) {
                
                _count--;
                
            }else {
                
                _count = _arrImg.count - 1;
            }
            
            // 0.3秒内完成复原动画
            [UIView animateWithDuration:0.3f animations:^{
                
                _vc3.frame = CGRectMake(0, topOut, _outW, _outH);
                _vc3.center = _ptOut;
            }];
            
            // 0.3秒内完成动画_vc4复原
            [UIView animateWithDuration:0.3f animations:^{
                
                _vc4.frame = CGRectMake(0, topCenter, _centerW, _centerH);
                _vc4.center = _ptCenter;
                _vc4.alpha = CenterAlpha;
                
                // 移除图片
                _imgView4.image = [UIImage imageNamed:@"木有图片"];
                _titleLb4.text = @"";
//                [self textFrom:_priceLb4 andData:@""];
                
            } completion:^(BOOL finished) {
                // 移除图片
            }];
            
            // 0.3秒内完成动画_vc1复原
            [UIView animateWithDuration:0.3f animations:^{
                
                _vc1.frame = CGRectMake(0, topBack, _backW, _backH);
                _vc1.center = _ptBack;
                _vc1.alpha = BackAlpha;
            }];
            // 0.3秒内完成动画_vc2复原
            [UIView animateWithDuration:0.3f animations:^{
                
                _vc2.hidden = YES;
                _vc2.alpha = 0.0;
            }];
        }
    }
}

// 拖拽手势_vc2 视图
- (void) doHandlePanAction2:(UIPanGestureRecognizer *)paramSender {
    
    // 开始拖拽
    if (paramSender.state == UIGestureRecognizerStateBegan) {
        
        NSLog(@"hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh%ld",_count);
        
        if (_count < _arrImg.count-1) {
            
            _count ++;
            
        }else {
            
            _count = 0;
        }
    }
    
    // 0.3秒内完成动画_vc3   _vc3 Out
    [UIView animateWithDuration:0.3f animations:^{
        
        _vc3.frame = CGRectMake(0, topOut, _outW, _outH);
        _vc3.center = _ptOut;
        _vc3.alpha = OutAlpha;
        _imgView3.image = [UIImage imageNamed:_arrImg[_count]];
        _titleLb3.text = _arrName[_count];
        [self textFrom:_priceLb3 andData:_arrPrice[_count]];
    }];
    // 0.3秒内完成动画_vc4   _vc4 Center
    [UIView animateWithDuration:0.3f animations:^{
        
        _vc4.frame = CGRectMake(0, topCenter, _centerW, _centerH);
        _vc4.center = _ptCenter;
        _vc4.alpha = CenterAlpha;
    }];
    // 0.3秒内完成动画_vc1   _vc1 Back
    [UIView animateWithDuration:0.3f animations:^{
        
        _vc1.hidden = NO;
        _vc1.alpha = BackAlpha;
    }];
    
    
    // 完成手势拖拽
    CGPoint point = [paramSender translationInView:self.view];
    NSLog(@"X:%f;Y:%f",point.x,point.y);
    
    paramSender.view.center = CGPointMake(paramSender.view.center.x + point.x, paramSender.view.center.y + point.y);
    
    [paramSender setTranslation:CGPointMake(0, 0) inView:self.view];
    
    
    // 拖拽结束
    if (paramSender.state == UIGestureRecognizerStateEnded) {
        
        // 移动的位置，大于页面总宽度的1/4
        if (fabs((paramSender.view.center.x - self.view.center.x)) > self.view.frame.size.width / 4) {
            
            
            [UIView animateWithDuration:0.3f animations:^{
                
                if (paramSender.view.center.x > self.view.frame.size.width / 2) {
                    
                    // 向右飞出
                    _vc2.frame = CGRectMake(W,topOut -  2 * (topOut - paramSender.view.frame.origin.y), _outW, _outH);
                    
                }else {
                    
                    // 向左飞出
                    _vc2.frame = CGRectMake(-_outW,topOut -  2 * (topOut - paramSender.view.frame.origin.y), _outW, _outH);
                }
                
                
            } completion:^(BOOL finished) {
                // 将视图转移成隐藏的底层
                _vc2.frame = CGRectMake(0, topBack, _backW, _backH);
                _vc2.center = _ptBack;
                [self.view insertSubview:_vc2 belowSubview:_vc1];
                _imgView2.image = [UIImage imageNamed:@"没有图片"];
                _vc2.hidden = YES;
                _vc2.alpha = 0.0;
                
                // 用户交互开关
                _vc1.userInteractionEnabled = NO;
                _vc2.userInteractionEnabled = NO;
                _vc3.userInteractionEnabled = YES;
                _vc4.userInteractionEnabled = NO;
                
            }];
        }else {
            
            if (_count != 0) {
                
                _count--;
                
            }else {
                
                _count = _arrImg.count - 1;
            }
            
            // 0.3秒内完成复原动画
            [UIView animateWithDuration:0.3f animations:^{
                
                _vc2.frame = CGRectMake(0, topOut, _outW, _outH);
                _vc2.center = _ptOut;
            }];
            
            // 0.3秒内完成动画_vc3复原
            [UIView animateWithDuration:0.3f animations:^{
                
                _vc3.frame = CGRectMake(0, topCenter, _centerW, _centerH);
                _vc3.center = _ptCenter;
                _vc3.alpha = CenterAlpha;
                
                // 移除图片
                _imgView3.image = [UIImage imageNamed:@"木有图片"];
                _titleLb3.text = @"";
//                [self textFrom:_priceLb3 andData:@""];
                
            } completion:^(BOOL finished) {
                // 移除图片
            }];
            
            // 0.3秒内完成动画_vc4复原
            [UIView animateWithDuration:0.3f animations:^{
                
                _vc4.frame = CGRectMake(0, topBack, _backW, _backH);
                _vc4.center = _ptBack;
                _vc4.alpha = BackAlpha;
            }];
            // 0.3秒内完成动画_vc4复原
            [UIView animateWithDuration:0.3f animations:^{
                
                _vc1.hidden = YES;
                _vc1.alpha = 0.0;
            }];
        }
    }
}

// 拖拽手势_vc1 视图
- (void) doHandlePanAction:(UIPanGestureRecognizer *)paramSender {
    
    // 开始拖拽
    if (paramSender.state == UIGestureRecognizerStateBegan) {
        
        if (_count < _arrImg.count-1) {
           
            _count ++;
            
        }else {
            
            _count = 0;
        }
        
        
        // 旋转角度
//        [UIView animateWithDuration:0.3f animations:^{
//            paramSender.view.transform = CGAffineTransformMakeRotation(30 *M_PI / 180.0);
//        }];
    }
    
    // 0.3秒内完成动画_vc2   _vc2 Out
    [UIView animateWithDuration:0.3f animations:^{
    
        _vc2.frame = CGRectMake(0, topOut, _outW, _outH);
        _vc2.center = _ptOut;
        _vc2.alpha = OutAlpha;
        _imgView2.image = [UIImage imageNamed:_arrImg[_count]];
        _titleLb2.text = _arrName[_count];
        [self textFrom:_priceLb2 andData:_arrPrice[_count]];
    }];
    // 0.3秒内完成动画_vc3   _vc3 Center
    [UIView animateWithDuration:0.3f animations:^{
        
        _vc3.frame = CGRectMake(0, topCenter, _centerW, _centerH);
        _vc3.center = _ptCenter;
        _vc3.alpha = CenterAlpha;
    }];
    // 0.3秒内完成动画_vc4   _vc4 Back
    [UIView animateWithDuration:0.3f animations:^{
        
        _vc4.hidden = NO;
        _vc4.alpha = BackAlpha;
    }];
    
    
    // 完成手势拖拽
    CGPoint point = [paramSender translationInView:self.view];
    NSLog(@"X:%f;Y:%f",point.x,point.y);
    
    paramSender.view.center = CGPointMake(paramSender.view.center.x + point.x, paramSender.view.center.y + point.y);
    
    [paramSender setTranslation:CGPointMake(0, 0) inView:self.view];

    
    // 拖拽结束
    if (paramSender.state == UIGestureRecognizerStateEnded) {
        
        // 移动的位置，大于页面总宽度的1/4
        if (fabs((paramSender.view.center.x - self.view.center.x)) > self.view.frame.size.width / 4) {
            
            
            [UIView animateWithDuration:0.3f animations:^{
                
                if (paramSender.view.center.x > self.view.frame.size.width / 2) {
                    
                    // 向右飞出
                    _vc1.frame = CGRectMake(W,topOut -  2 * (topOut - paramSender.view.frame.origin.y), _outW, _outH);
                    
                }else {
                    
                    // 向左飞出
                    _vc1.frame = CGRectMake(-_outW,topOut -  2 * (topOut - paramSender.view.frame.origin.y), _outW, _outH);
                }
                
                
            } completion:^(BOOL finished) {
                // 将视图转移成隐藏的底层
                _vc1.frame = CGRectMake(0, topBack, _backW, _backH);
                _vc1.center = _ptBack;
                [self.view insertSubview:_vc1 belowSubview:_vc4];
                _imgView1.image = [UIImage imageNamed:@"没有图片"];
                _vc1.hidden = YES;
                _vc1.alpha = 0.0;
                
                // 用户交互开关
                _vc1.userInteractionEnabled = NO;
                _vc2.userInteractionEnabled = YES;
                _vc3.userInteractionEnabled = NO;
                _vc4.userInteractionEnabled = NO;
                
            }];
        }else {
            
            if (_count != 0) {
                
                _count--;
                
            }else {
                
                _count = _arrImg.count - 1;
            }
            
            // 0.3秒内完成复原动画
            [UIView animateWithDuration:0.3f animations:^{
                
                _vc1.frame = CGRectMake(0, topOut, _outW, _outH);
                _vc1.center = _ptOut;
                
                // 旋转角度
                //            paramSender.view.transform = CGAffineTransformMakeRotation(- 270 *M_PI / 180.0);
            }];
            
            // 0.3秒内完成动画_vc2复原
            [UIView animateWithDuration:0.3f animations:^{
                
                _vc2.frame = CGRectMake(0, topCenter, _centerW, _centerH);
                _vc2.center = _ptCenter;
                _vc2.alpha = CenterAlpha;
                
                // 移除图片/标题
                _imgView2.image = [UIImage imageNamed:@"木有图片"];
                _titleLb2.text = @"";
//                [self textFrom:_priceLb2 andData:@""];
                
            } completion:^(BOOL finished) {
                // 移除图片
            }];
            
            // 0.3秒内完成动画_vc3复原
            [UIView animateWithDuration:0.3f animations:^{
                
                _vc3.frame = CGRectMake(0, topBack, _backW, _backH);
                _vc3.center = _ptBack;
                _vc3.alpha = BackAlpha;
            }];
            // 0.3秒内完成动画_vc4复原
            [UIView animateWithDuration:0.3f animations:^{
                
                _vc4.hidden = YES;
                _vc4.alpha = 0.0;
            }];
        }
    }
}

// 返回按钮、标题、右侧添加按钮
- (void) createBackBtn {
    
    // 返回按钮
    UIButton *backBtn = [[UIButton alloc] init];
    [_bacImgView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bacImgView).with.offset(20);
        make.left.equalTo(_bacImgView).with.offset(5);
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
    }];
    [backBtn.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(backBtn);
        make.width.equalTo(@(15.4));
        make.height.equalTo(@(14));
    }];
    [backBtn setImage:[UIImage imageNamed:@"关联商品_返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 设置导航栏标题
    UILabel *lbItemTitle = [[UILabel alloc] init];
    [_bacImgView addSubview:lbItemTitle];
    [lbItemTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backBtn).with.offset(11);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@(20));
    }];
    lbItemTitle.font = [UIFont systemFontOfSize:19];
    lbItemTitle.text = @"关联商品";
    lbItemTitle.textColor = [UIColor whiteColor];
    lbItemTitle.textAlignment = NSTextAlignmentCenter;
}

// 返回按钮点击事件
- (void) backClick:(UIButton *)backBtn {
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 页面将要加载
- (void) viewWillAppear:(BOOL)animated {
    
    // 隐藏导航栏
    self.navigationController.navigationBar.hidden = YES;
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
