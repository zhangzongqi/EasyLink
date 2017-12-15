//
//  MineFocusOnViewController.m
//  EasyLink
//
//  Created by 琦琦 on 16/10/24.
/*
     我的关注页面
 */
//  Copyright © 2016年 fengdian. All rights reserved.
//

#import "MineFocusOnViewController.h"
#import "MZTimerLabel.h" // 倒计时库
#import "WaitCollectionViewCell.h" // 等待cell
#import "SpellgroupCollectionViewCell.h" // 拼团列表cell
#import "GroupDetailViewController.h" // 详情页面


@interface MineFocusOnViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,MZTimerLabelDelegate> {
    
    NSMutableArray *_CollectionViewArr; // 列表的数据
    NSInteger pageStart; // 页数
}

// 我的足迹collectionview
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) MBProgressHUD *HUD; // 动画

@end

@implementation MineFocusOnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = FUIColorFromRGB(0xffffff);
    
    
    // 返回按钮
    [self createBackBtn];
    
    // 设置导航栏标题
    UILabel *lbItemTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    lbItemTitle.text = @"我的关注";
    lbItemTitle.textColor = [UIColor whiteColor];
    lbItemTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lbItemTitle;
    
    // 初始化数据
    [self initDataSource];
    
    // 创建加载动画
    [self createLoading];
    
    // 布局页面
    [self layoutViews];
    
    // 获取数据
    [self initData];
}

// 获取数据
- (void) initData {
    
    // 创建网络请求对象
    HttpRequest *http = [[HttpRequest alloc] init];
    
    
    
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
    
    NSDictionary *dicData = @{@"type":@"11",@"pageStart":[NSString stringWithFormat:@"%ld",pageStart],@"pageSize":@"10"};
    NSString *strDic = [MakeJson createJson:dicData];
    NSString *strData = [strDic AES128EncryptWithKey:strAESkey];
    
    NSDictionary *dataDic = @{@"tk":userToken,@"key":keyMiWenStr,@"cg":cgMiWenStr,@"data":strData};
    
    // 第0页
    if (pageStart == 0) {
        
        [http PostUserFavListDic:dataDic Success:^(id arrForList) {
            
            if ([arrForList isKindOfClass:[NSString class]]) {
                
                // 获取数据失败
                
                // 删除所有数据
                [_CollectionViewArr removeAllObjects];
                // 刷新列表
                [_collectionView reloadData];
                
                // 让动画消失
                [_HUD hide:YES];
                
                // 表格刷新完毕,结束上下刷新视图
                [_collectionView.mj_header endRefreshing];
                [_collectionView.mj_footer endRefreshing];
                
            }else {
                
                // 获取数据成功
                [_CollectionViewArr removeAllObjects];
                
                _CollectionViewArr = arrForList;
                
                NSLog(@"_CollectionViewArr:%@",_CollectionViewArr);
                
                // 让动画消失
                [_HUD hide:YES];
                
                // 刷新列表
                [_collectionView reloadData];
                
                // 表格刷新完毕,结束上下刷新视图
                [_collectionView.mj_header endRefreshing];
                [_collectionView.mj_footer endRefreshing];
            }
            
        } failure:^(NSError *error) {
            
            NSLog(@"解析失败");
            
            [_HUD hide:YES];
            
            // 表格刷新完毕,结束上下刷新视图
            [_collectionView.mj_header endRefreshing];
            [_collectionView.mj_footer endRefreshing];
        }];
    }else {
        
        [http PostUserHisWithDic:dataDic Success:^(id arrForList) {
            
            if ([arrForList isKindOfClass:[NSString class]]) {
                
                // 获取数据失败
                
                
                // 刷新列表
                [_collectionView reloadData];
                
                // 让动画消失
                [_HUD hide:YES];
                
                // 表格刷新完毕,结束上下刷新视图
                [_collectionView.mj_header endRefreshing];
                [_collectionView.mj_footer endRefreshing];
                
            }else {
                
                [_CollectionViewArr addObjectsFromArray:arrForList];
                
                // 让动画消失
                [_HUD hide:YES];
                
                [_collectionView reloadData];
                
                // 表格刷新完毕,结束上下刷新视图
                [_collectionView.mj_header endRefreshing];
                [_collectionView.mj_footer endRefreshing];
            }
            
        } failure:^(NSError *error) {
            
            NSLog(@"解析失败");
            
            [_HUD hide:YES];
            
            // 表格刷新完毕,结束上下刷新视图
            [_collectionView.mj_header endRefreshing];
            [_collectionView.mj_footer endRefreshing];
        }];
    }
    
}

// 创建加载动画
- (void)createLoading {
    
    // 加载动画
    _HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    // 展示
    [_HUD show:YES];
    
    // 3秒隐藏动画
    [_HUD hide:YES afterDelay:5];
    
}


// 初始化数据
- (void) initDataSource {
    
    _CollectionViewArr = [NSMutableArray array];
    
    pageStart = 0; // 初始化页数
}

// 布局页面
- (void) layoutViews {
    
    
    // 创建collectionview
    [self createCollectionView];
}

// 创建CollectionView
- (void) createCollectionView {
    
    // 先给表格创建它的布局对象
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    // 设置间距为0
    flow.minimumInteritemSpacing = 0;
    flow.minimumLineSpacing = 6;
    
    // 设置该布局的滚动方向
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // 新建_collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, W, H - 64) collectionViewLayout:flow];
    
    // 背景色
    _collectionView.backgroundColor = [UIColor colorWithRed:247/255.0 green:248/255.0 blue:249/255.0 alpha:1.0];
    
    // 设置滚动条隐藏
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    // 代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    // collectionview的注册
    [_collectionView registerClass:[SpellgroupCollectionViewCell class] forCellWithReuseIdentifier:@"collection"];
    // collectionview的注册
    [_collectionView registerClass:[WaitCollectionViewCell class] forCellWithReuseIdentifier:@"waitCollection"];
    
    // 添加到当前页面
    [self.view addSubview:_collectionView];
    
    
    
    // 继续配置_tableView;
    // 创建一个下拉刷新的头
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 调用下拉刷新方法
        [self downRefresh];
    }];
    
    header.stateLabel.hidden = YES;
    
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 设置_tableView的顶头
    _collectionView.mj_header = header;
    
    // 设置_tableView的底部
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 调用上拉刷新方法
        [self upRefresh];
    }];
    
}

// 下拉刷新方法
- (void)downRefresh {
    
    pageStart = 0;
    
    // 动画
    [self createLoadingForBtnClick];
    
    // 然后再请求网络
    [self initData];
}

// 上拉刷新方法
- (void)upRefresh {
    
    pageStart = _CollectionViewArr.count;
    
    // 动画
    [self createLoadingForBtnClick];
    
    // 请求数据
    [self initData];
}


// 上拉下拉刷新动画
- (void) createLoadingForBtnClick {
    
    // 创建动画
    _HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // 展示
    [_HUD show:YES];
    
    // 3秒隐藏动画
    [_HUD hide:YES afterDelay:3];
}




#pragma mark ---------UICollectionViewDelgate/UICollectionViewDataSource--------
// 每个分区的cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
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
        
        //        cell.goodsImgView.image = [UIImage imageNamed:_goodsImageArr[indexPath.row]];
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
    
    timer_cutDown.timeFormat = [NSString stringWithFormat:@"%ld天%@",datInt,@"HH:mm:ss"];
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


// 获取相差时间 秒
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



- (void) viewWillAppear:(BOOL)animated {
    
    // 设置导航栏背景色(用到了UIImage+GradientColor.h这个类扩展)
    UIColor *topleftColor = FUIColorFromRGB(0x9080ff);
    UIColor *bottomrightColor = FUIColorFromRGB(0x7765ff);
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor, bottomrightColor] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(W, 64)];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:bgImg]];
    
    // 显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:NO];
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
