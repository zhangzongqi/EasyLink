//
//  NewsNoticeViewController.m
//  EasyLink
//
//  Created by 琦琦 on 16/10/25.

/*
 消息通知页面
 */
//  Copyright © 2016年 fengdian. All rights reserved.
//

#import "NewsNoticeViewController.h"
#import "NoticeCollectionViewCell.h"

@interface NewsNoticeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource> {
    
    NSMutableArray *_titleArr; // 标题数组
    
    NSMutableArray *_trueFalseArr; // 是否阅读记录
    
    NSMutableArray *_SelectMutableArr; // 存储是否选中
}

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *bottomView;

@end

@implementation NewsNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 返回按钮
    [self createBackBtn];
    
    // 设置导航栏标题
    UILabel *lbItemTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    lbItemTitle.text = @"消息通知";
    lbItemTitle.textColor = [UIColor whiteColor];
    lbItemTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lbItemTitle;
    
    // 导航栏右侧按钮
    [self createRightBtn];
    
    // 初始化数组
    [self initDataSource];
    
    // 布局页面
    [self layoutViews];
}

// 导航栏右侧按钮和视图
- (void) createRightBtn {
    
    // 右侧按钮
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 28, 15);
    [menuBtn setTitle:@"编辑" forState:UIControlStateNormal];
    menuBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [menuBtn setTitleColor:FUIColorFromRGB(0xded9fe) forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    menuBtn.selected = NO;
    menuBtn.tag = 666;
}

// 导航栏右侧按钮点击事件
- (void)rightBtnClick:(UIButton *)menuBtn {
    
    if (menuBtn.selected == NO) {
        // 进入编辑状态了
        // 禁用手势返回
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        menuBtn.selected = YES;
        [menuBtn setTitle:@"取消" forState:UIControlStateNormal];
        
        // 动画
        [UIView animateWithDuration:0.3f animations:^{
            
            _bottomView.frame = CGRectMake(0, H - 49, W, 49);
            
            _collectionView.frame = CGRectMake(0, 0, W, H - 49);
            
        }];
        
        //设置tableview多选
        _collectionView.allowsMultipleSelection = YES;
        
        [_collectionView reloadData];
        
    }else {
        
        // 恢复正常状态了
        // 开启手势返回
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        menuBtn.selected = NO;
        [menuBtn setTitle:@"编辑" forState:UIControlStateNormal];
        
        //设置tableview多选
        _collectionView.allowsMultipleSelection = NO;
        
        _collectionView.frame = CGRectMake(0, 0, W, H);
        
        [_collectionView reloadData];
        
        // 动画
        [UIView animateWithDuration:0.3f animations:^{
            
            _bottomView.frame = CGRectMake(0, H, W, 49);
            
        } completion:^(BOOL finished) {
            
            // 底端弹出视图恢复
            UIButton *btn = [self.view viewWithTag:110];
            btn.selected = NO;
            [btn setImage:[UIImage imageNamed:@"品类列表_详情_答题off"] forState:UIControlStateNormal];
        }];
        
        [_SelectMutableArr removeAllObjects];
    }
}

// 初始化数组
- (void) initDataSource {
    
    _titleArr = [NSMutableArray arrayWithArray:@[@"双十一风暴来袭,手机家电十二期免息！",@"[最后七小时]每月22日，易领客分期,全场免息",@"运动大牌五折起！",@"游戏充值5折！！！",@"感恩大降价,鞋服满300立减100！",@"双十二马上来袭",@"双十一风暴来袭,手机家电十二期免息！",@"[最后七小时]每月22日，易领客分期,全场免息",@"运动大牌五折起！",@"游戏充值5折！！！",@"感恩大降价,鞋服满300立减100！",@"双十二马上来袭"]];
    
    _trueFalseArr = [NSMutableArray arrayWithArray:@[@"0",@"0",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1"]];
    
    _SelectMutableArr = [[NSMutableArray alloc] init];
}

// 布局页面
- (void) layoutViews {
    
    // 先给表格创建它的布局对象
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    // 设置间距为0
    flow.minimumInteritemSpacing = 0;
    flow.minimumLineSpacing = 1;
    
    // 设置该布局的滚动方向
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // 新建_collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, W, H - 64) collectionViewLayout:flow];
    
    // 背景色
    _collectionView.backgroundColor = FUIColorFromRGB(0xeeeeee);
    
    // 设置滚动条隐藏
//    _collectionView.showsVerticalScrollIndicator = NO;
//    _collectionView.showsHorizontalScrollIndicator = NO;
    
    // 代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView registerClass:[NoticeCollectionViewCell class] forCellWithReuseIdentifier:@"collection"];
    
    // 添加到当前页面
    [self.view addSubview:_collectionView];
    
    // 创建底部视图
    [self createBottomView];
}

// 创建底部视图
- (void) createBottomView {
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, H, W, 49)];
    [self.view addSubview: _bottomView];
    _bottomView.backgroundColor = [UIColor redColor];
    _bottomView.backgroundColor = [FUIColorFromRGB(0xf8f8f8) colorWithAlphaComponent:0.9];
    
    UIButton *btnDelete = [[UIButton alloc] init];
    [_bottomView addSubview:btnDelete];
    [btnDelete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bottomView);
        make.right.equalTo(_bottomView.mas_right).with.offset(- 0.053125 * W);
        make.height.equalTo(_bottomView.mas_height).multipliedBy(0.65);
        make.width.equalTo(_bottomView.mas_width).multipliedBy(0.26875);
    }];
    btnDelete.backgroundColor = FUIColorFromRGB(0xfe5f5f);
    [btnDelete setTitle:@"删除" forState:UIControlStateNormal];
    [btnDelete setTitleColor:FUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    btnDelete.titleLabel.font = [UIFont systemFontOfSize:15];
    btnDelete.layer.cornerRadius = 15.925;
    btnDelete.clipsToBounds = YES;
    [btnDelete addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *allSelectBtn = [[UIButton alloc] init];
    [_bottomView addSubview:allSelectBtn];
    [allSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bottomView);
        make.left.equalTo(_bottomView).with.offset(0.053125 * W);
        make.height.equalTo(_bottomView);
    }];
    allSelectBtn.imageView.sd_layout
    .leftSpaceToView(allSelectBtn,0)
    .centerYEqualToView(allSelectBtn)
    .heightIs(15)
    .widthIs(15);
    allSelectBtn.titleLabel.sd_layout
    .leftSpaceToView(allSelectBtn.imageView,5)
    .centerYEqualToView(allSelectBtn)
    .heightIs(15)
    .widthIs(29);
    
    [allSelectBtn setTitle:@"全选" forState:UIControlStateNormal];
    [allSelectBtn setTitleColor:FUIColorFromRGB(0x999999) forState:UIControlStateNormal];
    allSelectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [allSelectBtn setImage:[UIImage imageNamed:@"品类列表_详情_答题off"] forState:UIControlStateNormal];
    [allSelectBtn addTarget:self action:@selector(allSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    allSelectBtn.selected = NO;
    allSelectBtn.tag = 110;
}

// 删除按钮点击事件
- (void) deleteBtnClick:(UIButton *)btnDelete {
    
    NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
    
    for (int i = 0; i < _SelectMutableArr.count; i++) {
        
        [indexSet addIndex:[_SelectMutableArr[i] integerValue]];
    }
    
    [_titleArr removeObjectsAtIndexes:indexSet];
    [_trueFalseArr removeObjectsAtIndexes:indexSet];
    
    [_SelectMutableArr removeAllObjects];
    
    [_collectionView reloadData];
    
    // 全选按钮图标
    UIButton *allSelectBtn = [self.view viewWithTag:110];
    if (allSelectBtn.selected == YES) {
        allSelectBtn.selected = NO;
        [allSelectBtn setImage:[UIImage imageNamed:@"品类列表_详情_答题off"] forState:UIControlStateNormal];
    }
    
    // 右侧按钮
    UIButton *menuBtn = [self.navigationController.view viewWithTag:666];
    if (_titleArr.count == 0) {
        // 导航栏右侧按钮点击事件
        [self rightBtnClick:menuBtn];
    }
}

// 全选按钮点击事件
- (void) allSelectBtnClick:(UIButton *)allSelectBtn {
    
    if (allSelectBtn.selected == NO) {
        // 未全选状态变成全选状态
        allSelectBtn.selected = YES;
        [allSelectBtn setImage:[UIImage imageNamed:@"提现4"] forState:UIControlStateNormal];
        
        for (int i = 0; i < _titleArr.count; i++) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
            [self collectionView:_collectionView didSelectItemAtIndexPath:path];
        }
        
        [_collectionView reloadData];
        
    }else {
        // 全选状态变成未全选状态
        allSelectBtn.selected = NO;
        [allSelectBtn setImage:[UIImage imageNamed:@"品类列表_详情_答题off"] forState:UIControlStateNormal];
        
        for (int i = 0; i < _titleArr.count; i++) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
            [self collectionView:_collectionView didDeselectItemAtIndexPath:path];
        }
        
        // 刷新collectionview
        [_collectionView reloadData];
    }
}

// 每个分区的cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    // 返回的个数
    return _trueFalseArr.count;
}

// 绑定数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NoticeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collection" forIndexPath:indexPath];
    
    // 处于可编辑状态
    if (_collectionView.allowsMultipleSelection == YES) {
        
        [UIView animateWithDuration:0.3f animations:^{
            
            cell.cellMainView.frame = CGRectMake(cell.selectUv.frame.size.width, 0, W, cell.cellMainView.frame.size.height);
            cell.selectUv.frame = CGRectMake(0, 0, cell.selectUv.frame.size.width, cell.selectUv.frame.size.height);
        }];
    }else {
        
        [UIView animateWithDuration:0.3f animations:^{
            
            cell.cellMainView.frame = CGRectMake(0, 0, W, cell.cellMainView.frame.size.height);
            cell.selectUv.frame = CGRectMake(-cell.selectUv.frame.size.width, 0, cell.selectUv.frame.size.width, cell.selectUv.frame.size.height);
        }];
    }
    
    // 设置标题
    cell.titleLb.text = _titleArr[indexPath.row];
    
    // 设置是否已阅读
    if ([_trueFalseArr[indexPath.row] isEqualToString:@"0"]) {
        cell.lbWeiDu.hidden = NO;
    }
    
    if (cell.lbWeiDu.hidden == NO) {
        
        cell.titleLb.frame = CGRectMake(0.03125 * self.view.frame.size.width + 15, 0.2069 * cell.cellMainView.frame.size.height, 0.75 * self.view.frame.size.width - 20, 0.15 * cell.cellMainView.frame.size.height);
    }
    
    cell.detailLb.text = @"简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介";
    
    if ([_SelectMutableArr indexOfObject:[NSString stringWithFormat:@"%ld",indexPath.row]] != NSNotFound) {
        [cell.selectBtn setImage:[UIImage imageNamed:@"提现4"] forState:UIControlStateNormal];
        cell.selectBtn.selected = YES;
    }
    
    [cell.selectBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectBtn.tag = indexPath.row;
    
    return cell;
}


// 每个cell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(W, 0.1276 * H + 10);
}

// 上左下右距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// 按钮选中的点击事件
- (void) btnClick:(UIButton *)selectBtn {
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:selectBtn.tag inSection:0];
    
    if (selectBtn.selected == NO) {
        
        // 未选中状态
        [self collectionView:_collectionView didSelectItemAtIndexPath:path];
        
        NSLog(@"%ld",selectBtn.tag);
        
    }else {
        // 选中状态
        [self collectionView:_collectionView didDeselectItemAtIndexPath:path];
    }
}

// collectionview 的选中事件
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 导航栏右边按钮
    UIButton *menuBtn = [self.navigationController.view viewWithTag:666];
    
    if(menuBtn.selected == YES) {
        [_SelectMutableArr addObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
        
        NoticeCollectionViewCell *cell = (NoticeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        [cell.selectBtn setImage:[UIImage imageNamed:@"提现4"] forState:UIControlStateNormal];
        cell.selectBtn.selected = YES;
        
        NSLog(@"%@",_SelectMutableArr);
    
    }else {
        
        // 没处于修改状态
        
    }
}

// collectionview 的反选事件
- (void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [_SelectMutableArr removeObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
    
    NoticeCollectionViewCell *cell = (NoticeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [cell.selectBtn setImage:[UIImage imageNamed:@"品类列表_详情_答题off"] forState:UIControlStateNormal];
    cell.selectBtn.selected = NO;
    
    NSLog(@"%@",_SelectMutableArr);
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
    
    // 设置右侧按钮状态恢复正常状态
    UIButton *menuBtn = [self.navigationController.view viewWithTag:666];
    [menuBtn setTitle:@"编辑" forState:UIControlStateNormal];
    menuBtn.selected = NO;
}

// 页面将要加载
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
