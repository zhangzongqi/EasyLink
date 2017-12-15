//
//  AddressSelectView.m
//  AddressDemo
//
//  Created by 琦琦 on 17/3/14.
//  Copyright © 2017年 zzq. All rights reserved.
//

#import "AddressSelectView.h"
#import "SelectAddressTableViewCell.h" // 选择现有地址Cell

#define Width self.frame.size.width
#define Height self.frame.size.height


@implementation AddressSelectView

- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    SelectIndex = 100000;
    
    FirstShengSelect = YES;
    FirstShiSelect = YES;
    FirstXianSelect = YES;
    
    
    // 已有的地址数组
    _addressArr = [NSArray array];
    
    
    _arrForSheng = [[NSMutableArray alloc] init];
    _arrForShi = [[NSMutableArray alloc] init];
    _arrForQu = [[NSMutableArray alloc] init];
    
    
    _tableViews = [NSMutableArray array];
    _topTabbarItems = [NSMutableArray array];
    
    
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
        tipLb.text = @"配送至";
        
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
        // 返回按钮
        UIButton *fanhuiBtn = [[UIButton alloc] init];
        [topView addSubview:fanhuiBtn];
        [fanhuiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topView);
            make.left.equalTo(topView);
            make.width.equalTo(@(40));
            make.height.equalTo(topView);
        }];
        fanhuiBtn.imageView.sd_layout
        .leftSpaceToView(fanhuiBtn,Width / 32)
        .centerYEqualToView(fanhuiBtn)
        .widthIs(9)
        .heightIs(16);
        [fanhuiBtn setImage:[UIImage imageNamed:@"details_return"] forState:UIControlStateNormal];
        [fanhuiBtn addTarget:self action:@selector(fanhuiClick) forControlEvents:UIControlEventTouchUpInside];
        fanhuiBtn.hidden = YES;
        fanhuiBtn.tag = 666;
        
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

        // 选择其他地址
        UIButton *anotherAddressBtn = [[UIButton alloc] init];
        [bottomView addSubview:anotherAddressBtn];
        [anotherAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(bottomView);
            make.left.equalTo(bottomView);
            make.width.equalTo(@(Width));
            make.height.equalTo(@(42));
        }];
        anotherAddressBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [anotherAddressBtn setTitle:@"选择其他地址" forState:UIControlStateNormal];
        [anotherAddressBtn setTitleColor:FUIColorFromRGB(0x4e4e4e) forState:UIControlStateNormal];
        anotherAddressBtn.backgroundColor = FUIColorFromRGB(0xf4f4f4);
        [anotherAddressBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        // 选择当前地址tableview
        _selectTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, Width, Height - 83) style:UITableViewStylePlain];
        _selectTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _selectTableView.delegate = self;
        _selectTableView.dataSource = self;
        [bottomView addSubview:_selectTableView];
        [_selectTableView registerClass:[SelectAddressTableViewCell class] forCellReuseIdentifier:@"cell0"];
        // 加入数组
        [_tableViews addObject:_selectTableView];
        
        
        [self initDataForMomentAddress];
        
        
        // 省市区地址选择的视图
        _view2 = [[UIView alloc] initWithFrame:CGRectMake(Width, 40, Width, Height - 40)];
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
        HttpRequest *http = [[HttpRequest alloc] init];
        [http GetAddressWithPid:@"0" Success:^(id addressMessage) {
            
            _arrForSheng =  addressMessage;
            
            [self addTableView];
            
        } failure:^(NSError *error) {
            
        }];
        
    }
    
    return self;
}


// 获取当前已有的地址
- (void) initDataForMomentAddress {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *token = [user objectForKey:@"token"];
    
    if (token == nil) {
        
        _addressArr = @[@"登陆后才能看到已添加的地址哟"];
        
    }else {
        
        NSArray *arr = [GetUserJiaMi getUserTokenAndCgAndKey];
        
        NSDictionary *dicData = @{@"tk":arr[0],@"key":arr[1],@"cg":arr[2]};
        
        // 创建请求对象,发起请求
        HttpRequest *http = [[HttpRequest alloc] init];
        [http PostGetUserAllAddressWithDicData:dicData Success:^(id messageData) {
            
            // 保存地址列表信息
            _addressArr = messageData;
            
            // 刷新列表
            [_selectTableView reloadData];
            
        } failure:^(NSError *error) {
            
            // 网络错误,获取失败
        }];
    }
}


// 添加tableview
- (void)addTableView{
    
    // 减一，是因为外面直接选择地址时，已经有一个tableview
    UITableView * tabbleView = [[UITableView alloc]initWithFrame:CGRectMake((self.tableViews.count-1) * Width, 0, Width, _bigScrollView.height)];
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
    
    
    if([self.tableViews indexOfObject:tableView] == 0){
        
        
        // 直接选择地址的Array
        return _addressArr.count;
        
    }else if ([self.tableViews indexOfObject:tableView] == 1){
        
        // 省级别
        return _arrForSheng.count;
        
        
    }else if ([self.tableViews indexOfObject:tableView] == 2){
        
        // 市级别
        return _arrForShi.count;
        
        
    }else if ([self.tableViews indexOfObject:tableView] == 3) {
        
        // 县区级别
        return _arrForQu.count;
        
    }else {
        
        return 0;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_tableViews indexOfObject:tableView] == 0) {
        
        UserAddressModel *model = _addressArr[indexPath.row];
        
        SelectAddressTableViewCell *cell0 = [tableView dequeueReusableCellWithIdentifier:@"cell0" forIndexPath:indexPath];
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *strToken = [user objectForKey:@"token"];
        if (strToken == nil) {
            // 未登录
            cell0.imgView.hidden = YES;
            cell0.yesImgView.hidden = YES;
            cell0.lbAddress.textColor = FUIColorFromRGB(0x4e4e4e);
            // 地址
            cell0.lbAddress.text = _addressArr[0];
        }else {
            
            if (SelectIndex == 100000) {
                
                // 还没选
                cell0.imgView.hidden = YES;
                cell0.yesImgView.hidden = YES;
                cell0.lbAddress.textColor = FUIColorFromRGB(0x4e4e4e);
                
            }else {
                
                if (indexPath.row == SelectIndex) {
                    cell0.imgView.hidden = NO;
                    cell0.yesImgView.hidden = NO;
                    cell0.lbAddress.textColor = FUIColorFromRGB(0x8979ff);
                }else {
                    cell0.imgView.hidden = YES;
                    cell0.yesImgView.hidden = YES;
                    cell0.lbAddress.textColor = FUIColorFromRGB(0x4e4e4e);
                }
            }
            
            
            // 地址
            cell0.lbAddress.text = [NSString stringWithFormat:@"%@%@%@%@",model.province,model.city,model.district,model.town];
            
            cell0.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell0;
        
    }else if([self.tableViews indexOfObject:tableView] == 1){
        
        // 获取省份
        AddressModel *model = _arrForSheng[indexPath.row];
        
        ShengShiXianTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        
        cell1.tag = indexPath.row + 10;
        
        // 省
        if (FirstShengSelect == YES) {
            
            cell1.titleLb.text = model.title;
            cell1.imgView.hidden = YES;
            
        }else {
            
            if (indexPath.row == SelectShengIndex) {
                cell1.imgView.hidden = NO;
            }else {
                cell1.imgView.hidden = YES;
            }
            
            cell1.titleLb.text = model.title;
        }
        
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell1;
        
    }else if([self.tableViews indexOfObject:tableView] == 2){
        
        // 市
        
        AddressModel *model = _arrForShi[indexPath.row];
        
        ShengShiXianTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        
        cell1.tag = indexPath.row + 200;
        
        if (FirstShiSelect == YES) {
            
            cell1.titleLb.text = model.title;
            cell1.imgView.hidden = YES;
            
        }else {
            
            if (indexPath.row == SelectShiIndex) {
                cell1.imgView.hidden = NO;
            }else {
                cell1.imgView.hidden = YES;
            }
            
            cell1.titleLb.text = model.title;
        }
        
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell1;
        
    }else if([self.tableViews indexOfObject:tableView] == 3){
        
        // 区县
        
        AddressModel *model = _arrForQu[indexPath.row];
        
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
        
    }else {
        return nil;
    }
    

}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_tableViews indexOfObject:tableView] == 0) {
        
        return 46;
        
    }else {
        return 35;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_tableViews indexOfObject:tableView] == 0) {
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *strToken = [user objectForKey:@"token"];
        if (strToken == nil) {
            
            // 未登录
            
            
        }else {
            
            SelectIndex = (NSInteger)indexPath.row;
            [tableView reloadData];
            
            UserAddressModel *model = _addressArr[indexPath.row];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:model.id1 forKey:@"getStreetId"];
            
            // 设置外部显示的地址
            self.address = [NSString stringWithFormat:@"%@%@%@%@",model.province,model.city,model.district,model.town];
            
            if (self.chooseFinish) {
                self.chooseFinish();
            }
        }
        
        
        
        
    }else if([_tableViews indexOfObject:tableView] == 1){
        
        AddressModel *model = _arrForSheng[indexPath.row];
        
        // 第一次选
        if (FirstShengSelect == YES) {
            
            FirstShengSelect = NO;
            // 省级tableview
            SelectShengIndex = (NSInteger)indexPath.row;
            [tableView reloadData];
            
            ShengShiXianTableViewCell *cell = [self viewWithTag:10 + indexPath.row];
            
            
            // 网络请求
            HttpRequest *http = [[HttpRequest alloc] init];
            [http GetAddressWithPid:model.id1 Success:^(id addressMessage) {
                
                _arrForShi =  addressMessage;
                
                [self addTableView];
                
            } failure:^(NSError *error) {
                
            }];
            
            [self addTopBarItem];
            [_topBarView layoutIfNeeded];
            [self scrollToNextItem:cell.titleLb.text];
            
        }else {
            
            // 不是第一次选
            if (self.tableViews.count == 4) {
                [self removeLastItem];
                [self removeLastItem];
                [tableView reloadData];
            }else if (self.tableViews.count == 3) {
                [self removeLastItem];
                [tableView reloadData];
            }
            
            FirstShiSelect = YES;
            FirstXianSelect = YES;
            // 省级tableview
            SelectShengIndex = (NSInteger)indexPath.row;
            
            ShengShiXianTableViewCell *cell = [self viewWithTag:10 + indexPath.row];
            
            // 网络请求
            HttpRequest *http = [[HttpRequest alloc] init];
            [http GetAddressWithPid:model.id1  Success:^(id addressMessage) {
                
                _arrForShi =  addressMessage;
                
                [self addTableView];
                
            } failure:^(NSError *error) {
                
            }];
            
            [self addTopBarItem];
            [_topBarView layoutIfNeeded];
            
            UITableView *tableView2 = self.tableViews[1];
            [tableView2 reloadData];
            
            [self scrollToNextItem:cell.titleLb.text];
        }
        
    }else if ([_tableViews indexOfObject:tableView] == 2) {
        
        AddressModel *model = _arrForShi[indexPath.row];
        
        if (FirstShiSelect == YES) {
            
            FirstShiSelect = NO;
            // 市
            SelectShiIndex = (NSInteger)indexPath.row;
            [tableView reloadData];
            
            ShengShiXianTableViewCell *cell = [self viewWithTag:200 + indexPath.row];
            
            
            // 网络请求
            HttpRequest *http = [[HttpRequest alloc] init];
            [http GetAddressWithPid:model.id1  Success:^(id addressMessage) {
                
                _arrForQu =  addressMessage;
                
                [self addTableView];
                
            } failure:^(NSError *error) {
                
            }];
            
            [self addTopBarItem];
            [_topBarView layoutIfNeeded];
            [self scrollToNextItem:cell.titleLb.text];
            
        }else {
            
            
            [self removeLastItem];
            
            
            FirstXianSelect = YES;
            // 市
            SelectShiIndex = (NSInteger)indexPath.row;
            [tableView reloadData];
            
            ShengShiXianTableViewCell *cell = [self viewWithTag:200 + indexPath.row];
            
            // 网络请求
            HttpRequest *http = [[HttpRequest alloc] init];
            [http GetAddressWithPid:model.id1  Success:^(id addressMessage) {
                
                _arrForQu =  addressMessage;
                
                [self addTableView];
                
            } failure:^(NSError *error) {
                
            }];
            
            [self addTopBarItem];
            
            UITableView *tableView2 = self.tableViews[2];
            [tableView2 reloadData];
            
            [_topBarView layoutIfNeeded];
            [self scrollToNextItem:cell.titleLb.text];
        }
        
    }else {
        
        
        FirstXianSelect = NO;
        // 区县
        SelectXianIndex = (NSInteger)indexPath.row;
        [tableView reloadData];
        
        ShengShiXianTableViewCell *cell = [self viewWithTag:3000 + indexPath.row];
        
        NSInteger index = _bigScrollView.contentOffset.x / Width;
        UIButton * btn = self.topTabbarItems[index];
        [btn setTitle:cell.titleLb.text forState:UIControlStateNormal];
        
        UIButton *btn0 = self.topTabbarItems[0];
        UIButton *btn1 = self.topTabbarItems[1];
        UIButton *btn2 = self.topTabbarItems[2];
        
        
        self.address = [NSString stringWithFormat:@"%@%@%@",btn0.titleLabel.text,btn1.titleLabel.text,btn2.titleLabel.text];
        if (self.chooseFinish) {
            
            AddressModel *model = _arrForQu[indexPath.row];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:model.id1 forKey:@"getStreetId"];
            self.chooseFinish();
        }
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
        _bigScrollView.contentSize = (CGSize){(self.tableViews.count-1) * Width,0};
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
