//
//  SearchViewController.m
//  Sesame
//
//  Created by 杨卢青 on 16/5/20.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchDBManage.h"
#import "GroupViewController.h" // 首页

#define W self.view.frame.size.width   // 宽
#define H self.view.frame.size.height  // 高


// 最大存储的搜索历史 条数
#define MAX_COUNT 6

@interface SearchViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource> {
    
    UILabel *_lb;
}
/**
 *  搜索历史数据表单
 */
@property (nonatomic, strong) UITableView *tableView;
/**
 *  数据集合
 */
@property (nonatomic, strong) NSMutableArray *dataArray;
/**
 *  SearchBar
 */
@property (nonatomic, strong) UISearchBar *searchBar;


@property (nonatomic, assign, setter = setHasCentredPlaceholder:) BOOL hasCentredPlaceholder;

@end


@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    
    // 设置不透明
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor = [UIColor colorWithRed:237/255.0 green:239/255.0 blue:240/255.0 alpha:1.0];
    
    // 返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(-20, 0, 44, 44);
    
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];

    [backBtn addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = backItem;
    
    if (([[[ UIDevice currentDevice ] systemVersion ] floatValue ]>= 7.0 ? 20 : 0 ))
        
    {
        
        UIBarButtonItem *negativeSpacer = [[ UIBarButtonItem alloc ] initWithBarButtonSystemItem : UIBarButtonSystemItemFixedSpace
                                           
                                                                                          target : nil action : nil ];
        
        negativeSpacer.width = - 20 ;//这个数值可以根据情况自由变化
        
        self.navigationItem.leftBarButtonItems = @[ negativeSpacer,  backItem] ;
        
    } else {
        self . navigationItem . leftBarButtonItem = backItem;
    }
    
    
    
    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
    
    //初始化数据
    [self initData];
    
    // 创建搜索栏
    [self setNavTitleView];
    
    // 创建tableView
    [self initTableView];
}

#pragma mark - Helper
/**
 *  数据初始化
 */
- (void)initData
{
    self.dataArray = [[NSMutableArray alloc] init];
    //获取数据库里面的全部数据
    self.dataArray = [[SearchDBManage shareSearchDBManage] selectAllSearchModel];
}

/**
 *  设置导航搜索框
 */
- (void)setNavTitleView {
    
    //加上 搜索栏
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(- 10, 0, W - 50, 35)];//allocate titleView
    UIColor *color =  self.navigationController.navigationBar.barTintColor;
    
    titleView.backgroundColor = [UIColor clearColor];
    
    [titleView setBackgroundColor:color];
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    
    searchBar.delegate = self;
    searchBar.frame = CGRectMake(-10, 1, W - 50, 32);
    searchBar.backgroundColor = color;
    searchBar.layer.cornerRadius = 16;
    searchBar.layer.masksToBounds = YES;
    [searchBar.layer setBorderWidth:8];
    [searchBar.layer setBorderColor:[UIColor whiteColor].CGColor];  //设置边框为白色
    
    searchBar.placeholder = @"请输入关键字                                     ";
    
    self.searchBar = searchBar;
    
    [titleView addSubview:searchBar];
    
    //Set to titleView
    [self.navigationItem.titleView sizeToFit];
    self.navigationItem.titleView = titleView;
    
}

/**
 *  设置搜索历史显示表格
 */
- (void)initTableView
{
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(10, 0, W - 20, H - 64 - 49);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor colorWithRed:237/255.0 green:239/255.0 blue:240/255.0 alpha:1.0];
    
    
    // 设置tableView的cell分割线顶边
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
    //清空历史搜索按钮
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(-1, 0, self.view.frame.size.width + 1, 35)];
    UIButton *clearButton = [[UIButton alloc] init];
    clearButton.frame = CGRectMake(0, 0, self.view.frame.size.width, 35);
    [clearButton setTitle:@"清空搜索记录" forState:UIControlStateNormal];
    clearButton.backgroundColor = [UIColor whiteColor];
    [clearButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    clearButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [clearButton addTarget:self action:@selector(clearButtonClick) forControlEvents:UIControlEventTouchDown];
//    clearButton.layer.cornerRadius = 3;
    clearButton.layer.borderWidth = 1.0;
    clearButton.layer.borderColor = [UIColor colorWithRed:237/255.0 green:239/255.0 blue:240/255.0 alpha:1.0].CGColor;
    [footerView addSubview:clearButton];
    [_tableView setTableFooterView:footerView];
    
    //历史搜索
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    UILabel *hisLb = [[UILabel alloc] init];
    hisLb.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    hisLb.text = @"历史搜索";
    hisLb.textColor = [UIColor grayColor];
    hisLb.backgroundColor = [UIColor colorWithRed:237/255.0 green:239/255.0 blue:240/255.0 alpha:1.0];
    [headerView addSubview:hisLb];
    [_tableView setTableHeaderView:headerView];
    
}

/**
 *  清空搜索历史操作
 */
- (void)clearButtonClick{
    [[SearchDBManage shareSearchDBManage] deleteAllSearchModel];
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - TableViewDelegate, dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray.count == 0) {
        
        _tableView.hidden = YES;
        
        //没有历史数据时隐藏
        self.tableView.tableFooterView.hidden = YES;
        
        _lb.hidden = NO;
        
        self.tableView.tableHeaderView.hidden = YES;
        
    }else {
        
        _tableView.hidden = NO;
        
        //有历史数据时显示
        self.tableView.tableFooterView.hidden = NO;
        
        _lb.hidden = YES;
        
        self.tableView.tableHeaderView.hidden = NO;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
//        cell.layer.borderColor = [UIColor colorWithRed:107/255.0    green:108/255.0 blue:109/255.0 alpha:1.0].CGColor;
        cell.backgroundColor = [UIColor whiteColor];
    }
    SearchModel *model = (SearchModel *)[self exchangeArray:_dataArray][indexPath.row];
    cell.textLabel.text = model.keyWord;
    cell.textLabel.textColor = [UIColor colorWithRed:66/255.0    green:67/255.0 blue:68/255.0 alpha:1.0];
    cell.detailTextLabel.text = model.currentTime;
    cell.detailTextLabel.textColor = [UIColor colorWithRed:66/255.0 green:67/255.0 blue:68/255.0 alpha:1.0];
    
    cell.imageView.image = [UIImage imageNamed:@"s搜索03"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    // 设置tableView的cell分割线顶边
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    
    return cell;
}
/**
 *  数组逆序
 *
 *  @param array 需要逆序的数组
 *
 *  @return 逆序后的输出
 */
- (NSMutableArray *)exchangeArray:(NSMutableArray *)array{
    NSInteger num = array.count;
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (NSInteger i = num - 1; i >= 0; i --) {
        [temp addObject:[array objectAtIndex:i]];
        
    }
    return temp;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 释放第一响应者
    [_searchBar resignFirstResponder];

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SearchModel *model = (SearchModel *)[self exchangeArray:self.dataArray][indexPath.row];
    
    self.searchBar.text = model.keyWord;
    
    [self searchBarSearchButtonClicked:self.searchBar];
    
//    [_searchBar becomeFirstResponder];
    
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
}

/**
 *  点击搜索时, 历史记录插入数据库
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [self insterDBData:searchBar.text];
    
    //取消第一响应者状态, 键盘消失
    [searchBar resignFirstResponder];
    
    
    // 跳入首页界面
    self.tabBarController.selectedIndex = 0;
    
    GroupViewController *vc = self.tabBarController.childViewControllers[0].childViewControllers[0];
    
    vc.tfForSearch.text = searchBar.text;
    
    [vc.dropDownMenu makemenuIndex:2 andTitle:@"全部"];
    [vc.dropDownMenu makemenuIndex:1 andTitle:@"综合"];
    vc.currentData2Index = 0;
    vc.currentData3Index = 0;
    vc.currentData3SelectedIndex = 0;
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
//    SearchDetailViewController *vc = [[SearchDetailViewController alloc] init];
//    
//    vc.strTitle = searchBar.text;
//    
//    [vc setHidesBottomBarWhenPushed:YES];
//    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  点击取消按钮
 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //插入数据库
    [self insterDBData:searchBar.text];
    [searchBar resignFirstResponder];
}

/**
 *  关键词插入数据库
 *
 *  @param keyword 关键词
 */
- (BOOL)insterDBData:(NSString *)keyword{
    if (keyword.length == 0) {
        return NO;
    }
    else{//搜索历史插入数据库
        //先删除数据库中相同的数据
        [self removeSameData:keyword];
        //再插入数据库
        [self moreThan20Data:keyword];
        // 读取数据库里面的数据
        self.dataArray = [[SearchDBManage shareSearchDBManage] selectAllSearchModel];
        [self.tableView reloadData];
        return YES;
    }
}

/**
 *  去除数据库中已有的相同的关键词
 *
 *  @param keyword 关键词
 */
- (void)removeSameData:(NSString *)keyword{
    NSMutableArray *array = [[SearchDBManage shareSearchDBManage] selectAllSearchModel];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SearchModel *model = (SearchModel *)obj;
        if ([model.keyWord isEqualToString:keyword]) {
            [[SearchDBManage shareSearchDBManage] deleteSearchModelByKeyword:keyword];
        }
    }];
}

/**
 *  多余20条数据就把第0条去除
 *
 *  @param keyword 插入数据库的模型需要的关键字
 */
- (void)moreThan20Data:(NSString *)keyword{
    // 读取数据库里面的数据
    NSMutableArray *array = [[SearchDBManage shareSearchDBManage] selectAllSearchModel];
    
    if (array.count > MAX_COUNT - 1) {
        NSMutableArray *temp = [self moveArrayToLeft:array keyword:keyword]; // 数组左移
        [[SearchDBManage shareSearchDBManage] deleteAllSearchModel]; //清空数据库
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        [temp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SearchModel *model = (SearchModel *)obj; // 取出 数组里面的搜索模型
            [[SearchDBManage shareSearchDBManage] insterSearchModel:model]; // 插入数据库
        }];
    }
    else if (array.count <= MAX_COUNT - 1){ // 小于等于19 就把第20条插入数据库
        [[SearchDBManage shareSearchDBManage] insterSearchModel:[SearchModel creatSearchModel:keyword currentTime:[self getCurrentTime]]];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    
    _lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, W, 50)];
    _lb.textAlignment = NSTextAlignmentCenter;
    
    _lb.text = @"暂无历史搜索记录...";
    
    _lb.textColor = [UIColor grayColor];
    
    [self.view addSubview:_lb];
    
    _lb.hidden = YES;
    
//    if (self.tabBarController.tabBar.hidden == NO) {
//        self.tabBarController.tabBar.hidden = YES;
//    }
    
    [self.searchBar becomeFirstResponder];
}

/**
 *  数组左移
 *
 *  @param array   需要左移的数组
 *  @param keyword 搜索关键字
 *
 *  @return 返回新的数组
 */
- (NSMutableArray *)moveArrayToLeft:(NSMutableArray *)array keyword:(NSString *)keyword{
    [array addObject:[SearchModel creatSearchModel:keyword currentTime:[self getCurrentTime]]];
    [array removeObjectAtIndex:0];
    return array;
}

/**
 *  获取当前时间
 *
 *  @return 当前时间
 */
- (NSString *)getCurrentTime{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY年MM月dd日HH:mm:ss"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}

- (void)doBack:(id)sender
{
    
    [_searchBar resignFirstResponder];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
