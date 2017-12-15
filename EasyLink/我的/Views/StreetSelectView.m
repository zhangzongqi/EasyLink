//
//  StreetSelectView.m
//  EasyLink
//
//  Created by 琦琦 on 2017/5/13.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "StreetSelectView.h"
#import "SelectAddressTableViewCell.h" // 选择现有地址Cell
#import "AddressModel.h"

#define Width self.frame.size.width
#define Height self.frame.size.height

@implementation StreetSelectView

- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    SelectIndex = 0;
    
    FirstShengSelect = YES;
    FirstShiSelect = YES;
    FirstXianSelect = YES;
    
    
    _tableViews = [NSMutableArray array];
    _topTabbarItems = [NSMutableArray array];
    
    
    _arrForStreet = [[NSMutableArray alloc] init];
    
    
    //    640 * 500
    
    self.backgroundColor = FUIColorFromRGB(0xffffff);
    
    
    if (self) {
        
        // 配送至label
        UIView *topView = [[UIView alloc] init];
        [self addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.width.equalTo(@(Width));
            make.height.equalTo(@(40));
        }];
        UILabel *tipLb = [[UILabel alloc] init];
        [topView addSubview:tipLb];
        [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(topView);
            make.centerY.equalTo(topView);
            make.height.equalTo(@(15));
        }];
        tipLb.font = [UIFont systemFontOfSize:15];
        tipLb.textColor = FUIColorFromRGB(0x212121);
        tipLb.text = @"请选择街道";
        
        // 关闭按钮
        _closeBtn = [[UIButton alloc] init];
        [topView addSubview:_closeBtn];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView);
            make.right.equalTo(topView);
            make.width.equalTo(@(40));
            make.height.equalTo(topView);
        }];
        _closeBtn.imageView.sd_layout
        .centerXEqualToView(_closeBtn)
        .centerYEqualToView(_closeBtn)
        .widthRatioToView(_closeBtn, 0.35)
        .heightRatioToView(_closeBtn, 0.35);
        [_closeBtn setImage:[UIImage imageNamed:@"home_close"] forState:UIControlStateNormal];
        
        
        // 底部视图
        UIView *bottomView = [[UIView alloc] init];
        [self addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView.mas_bottom);
            make.bottom.equalTo(self);
            make.left.equalTo(self);
            make.width.equalTo(@(Width));
        }];
        bottomView.backgroundColor = FUIColorFromRGB(0xffffff);
        // 分割线
        UILabel *lbFenge = [[UILabel alloc] init];
        [bottomView addSubview:lbFenge];
        [lbFenge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bottomView);
            make.left.equalTo(bottomView);
            make.width.equalTo(@(Width));
            make.height.equalTo(@(1));
        }];
        lbFenge.backgroundColor = FUIColorFromRGB(0xeeeeee);
        
        
        // 省市区地址选择的视图
        _view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, Width, Height - 40)];
        [self addSubview:_view2];
        _view2.backgroundColor = FUIColorFromRGB(0xffffff);
        
        // 按钮视图
        _topBarView = [[AddressView alloc] initWithFrame:CGRectMake(0, 0, Width, 35)];
        [_view2 addSubview:_topBarView];
        _topBarView.backgroundColor = FUIColorFromRGB(0xffffff);
        UILabel *lbFenge2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 34, Width, 1)];
        lbFenge2.backgroundColor = FUIColorFromRGB(0xeeeeeee);
        [_topBarView addSubview:lbFenge2];
        
        // 添加按钮
        [self addTopBarItem];
        [_topBarView layoutIfNeeded];
        
        
        // 滚动条
        UIView * underLine = [[UIView alloc] initWithFrame:CGRectZero];
        [_topBarView addSubview:underLine];
        _underLine = underLine;
        underLine.height = 1.5f;
        UIButton * btn = self.topTabbarItems.lastObject;
        [self changeUnderLineFrame:btn];
        underLine.bottom = lbFenge2.bottom;
        _underLine.backgroundColor = FUIColorFromRGB(0x8979ff);
        
        
        
        _bigScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 35, Width, Height - 40 - 35)];
        [_view2 addSubview:_bigScrollView];
        _bigScrollView.backgroundColor = FUIColorFromRGB(0xffffff);
        _bigScrollView.contentSize = CGSizeMake(Width, Height - topView.frame.size.height);
        _bigScrollView.delegate = self;
        _bigScrollView.pagingEnabled = YES;
        
        
        
        // 网络请求
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        HttpRequest *http = [[HttpRequest alloc] init];
        [http GetAddressWithPid:[user objectForKey:@"getStreetId"] Success:^(id addressMessage) {
            
            _arrForStreet =  addressMessage;
            
            [self addTableView];
            
        } failure:^(NSError *error) {
            
        }];
    }
    
    return self;
}


// 添加tableview
- (void)addTableView{
    
    // 减一，是因为外面直接选择地址时，已经有一个tableview
    UITableView * tabbleView = [[UITableView alloc]initWithFrame:CGRectMake((self.tableViews.count) * Width, 0, Width, _bigScrollView.height)];
    [_bigScrollView addSubview:tabbleView];
    [self.tableViews addObject:tabbleView];
    tabbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabbleView.delegate = self;
    tabbleView.dataSource = self;
    tabbleView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    [tabbleView registerClass:[ShengShiXianTableViewCell class] forCellReuseIdentifier:@"cell1"];
}

// 添加按钮
- (void)addTopBarItem{
    
    UIButton * topBarItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [topBarItem setTitle:@"请选择" forState:UIControlStateNormal];
    //    topBarItem.titleLabel.font = [UIFont systemFontOfSize:15];
    [topBarItem setTitleColor:FUIColorFromRGB(0x212121) forState:UIControlStateNormal];
    [topBarItem setTitleColor:FUIColorFromRGB(0x8979ff) forState:UIControlStateSelected];
    [topBarItem sizeToFit];
    topBarItem.centerY = _topBarView.height * 0.5;
    [self.topTabbarItems addObject:topBarItem];
    [_topBarView addSubview:topBarItem];
    [topBarItem addTarget:self action:@selector(topBarItemClick:) forControlEvents:UIControlEventTouchUpInside];
}

//点击按钮,滚动到对应位置
- (void)topBarItemClick:(UIButton *)btn{
    
    NSInteger index = [self.topTabbarItems indexOfObject:btn];
    
    [UIView animateWithDuration:0.25 animations:^{
        _bigScrollView.contentOffset = CGPointMake(index * Width, 0);
        [self changeUnderLineFrame:btn];
    }];
}

#pragma mark ----- UITableViewDataSource/UITableViewDelegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _arrForStreet.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 街道
    AddressModel *model = _arrForStreet[indexPath.row];
    
    ShengShiXianTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
    
    cell1.tag = indexPath.row + 3000;
    
    if (FirstXianSelect == YES) {
        
        cell1.titleLb.text = model.title;
        cell1.imgView.hidden = YES;
        
    }else {
        
        if (indexPath.row == SelectXianIndex) {
            cell1.imgView.hidden = NO;
        }else {
            cell1.imgView.hidden = YES;
        }
        
        cell1.titleLb.text = model.title;
    }
    
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell1;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 35;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FirstXianSelect = NO;
    // 区县
    SelectXianIndex = (NSInteger)indexPath.row;
    [tableView reloadData];
    
    ShengShiXianTableViewCell *cell = [self viewWithTag:3000 + indexPath.row];
    
    NSInteger index = _bigScrollView.contentOffset.x / Width;
    UIButton * btn = self.topTabbarItems[index];
    [btn setTitle:cell.titleLb.text forState:UIControlStateNormal];
    
    UIButton *btn0 = self.topTabbarItems[0];
    
    // 调整指示条和按钮大小
    [btn sizeToFit];
    _underLine.left = btn.left;
    _underLine.width = btn.width;
    
    self.address = [NSString stringWithFormat:@"%@",btn0.titleLabel.text];
    if (self.chooseFinish) {
        AddressModel *model = _arrForStreet[indexPath.row];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:btn0.titleLabel.text forKey:@"town"];
        [user setObject:model.id1 forKey:@"last_region_id"];

        self.chooseFinish();
    }
}


//当重新选择省或者市的时候，需要将下级视图移除。
- (void)removeLastItem{
    
    [self.tableViews.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
    [self.tableViews removeLastObject];
    
    [self.topTabbarItems.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
    [self.topTabbarItems removeLastObject];
}



// 选择其他地址点击事件
- (void) btnClick {
    
    [UIView animateWithDuration:0.25f animations:^{
        
        _view2.frame = CGRectMake(0, 40, Width, Height - 40);
        UIButton *btn = [self viewWithTag:666];
        btn.hidden = NO;
        
    } completion:^(BOOL finished) {
        
    }];
}

// 返回按钮点击事件
- (void) fanhuiClick {
    
    [UIView animateWithDuration:0.25f animations:^{
        
        _view2.frame = CGRectMake(Width, 40, Width, Height - 40);
        UIButton *btn = [self viewWithTag:666];
        btn.hidden = YES;
        
    } completion:^(BOOL finished) {
        
    }];
}


//调整指示条位置
- (void)changeUnderLineFrame:(UIButton  *)btn{
    
    _selectedBtn.selected = NO;
    btn.selected = YES;
    _selectedBtn = btn;
    _underLine.left = btn.left;
    _underLine.width = btn.width;
}


//滚动到下级界面,并重新设置顶部按钮条上对应按钮的title
- (void)scrollToNextItem:(NSString *)preTitle{
    
    NSInteger index = _bigScrollView.contentOffset.x / Width;
    UIButton * btn = self.topTabbarItems[index];
    [btn setTitle:preTitle forState:UIControlStateNormal];
    [btn sizeToFit];
    [self.topBarView layoutIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        _bigScrollView.contentSize = (CGSize){(self.tableViews.count) * Width,0};
        CGPoint offset = _bigScrollView.contentOffset;
        _bigScrollView.contentOffset = CGPointMake(offset.x + Width, offset.y);
        //        [self changeUnderLineFrame:self.topTabbarItems.lastObject];
        [self changeUnderLineFrame: [self.topBarView.subviews lastObject]];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
