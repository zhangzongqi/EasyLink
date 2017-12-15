//
//  PingjiaViewController.m
//  EasyLink
//
//  Created by 琦琦 on 17/3/9.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "PingjiaViewController.h"
#import "RatingBar.h" // 星级
#import "AddPhotoCollectionViewCell.h" // 评价cell
#import "ZLPhotoActionSheet.h"
#import "ZLDefine.h"
#import "ZLCollectionCell.h"
#import "ZLShowBigImage.h" // 查看大图
#import "ZheZhaoView.h" // 遮罩层
#import "AliPayBindingViewController.h"

@interface PingjiaViewController ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,RatingDelegate> {
    
    
    NSArray *_selectImgArr; // 保存已选图片
    
    NSString *_nimingStr; // 用于保存是否匿名
    
    NSString *_strTupianId; // 用于保存上传的图片的id
}

@property (nonatomic,strong) ZheZhaoView *zhezhaoVc;
@property (nonatomic,strong) UIView *tanchuVc;
@property (nonatomic,strong) UIButton *SureBtn;

@property (nonatomic,strong) UIImageView *goodsImgView;
@property (nonatomic,strong) RatingBar *bar; // 星级
@property (nonatomic,strong) UITextView *tfView; // 评价输入框
@property (nonatomic,strong) UICollectionView *addPhotoCollection; // collectionview
@property (nonatomic,strong) UIButton *nimingBtn; // 匿名Btn


@property (nonatomic, strong) NSArray<ZLSelectPhotoModel *> *lastSelectMoldels;
@property (nonatomic, strong) NSMutableArray *arrDataSources;

@property (nonatomic, copy) MBProgressHUD *HUD; // 动画

@end

@implementation PingjiaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = FUIColorFromRGB(0xffffff);
    
    // 设置导航栏标题
    UILabel *lbItemTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    lbItemTitle.text = @"发表评价";
    lbItemTitle.textColor = FUIColorFromRGB(0x212121);
    lbItemTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lbItemTitle;
    
    
    // 返回按钮
    [self createBackBtn];
    
    // 导航栏右侧按钮
    [self createRightBtn];
    
    // 初始化数组
    [self initDataSource];
    
    // 创建UI
    [self createUI];
}

// 初始化数组
- (void) initDataSource {
    
    // 用于保存上次你的图片的id
    _strTupianId = @"";
    
    // 用于保存是否是匿名
    _nimingStr = @"0"; // 初始状态，不匿名
    
    // 保存已选图片
    _selectImgArr = [NSArray array];
    
    // 数组
    _arrDataSources = [NSMutableArray array];
}

// 创建UI
- (void) createUI {
    
    // 遮罩层
    _zhezhaoVc = [[ZheZhaoView alloc] initWithFrame:CGRectMake(0, 0, W, H)];
    [self.navigationController.view addSubview:_zhezhaoVc];
    _zhezhaoVc.hidden = YES;
    // 弹出视图
    _tanchuVc = [[UIView alloc] init];
    [_zhezhaoVc addSubview:_tanchuVc];
//    422*370
    [_tanchuVc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_zhezhaoVc);
        make.centerX.equalTo(_zhezhaoVc);
        make.width.equalTo(@(W * 0.659375));
        make.height.equalTo(@(W * 0.578125));
    }];
    _tanchuVc.backgroundColor = FUIColorFromRGB(0xffffff);
    _tanchuVc.layer.cornerRadius = 6;
    _tanchuVc.clipsToBounds = YES;
    UIImageView *imgView = [[UIImageView alloc] init];
    [_tanchuVc addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tanchuVc).with.offset(W * 0.0625);
        make.centerX.equalTo(_tanchuVc);
        make.width.equalTo(@(W * 0.659375 * 69/211));
        make.height.equalTo(@(W * 0.659375 * 69/211));
    }];
    imgView.layer.cornerRadius = W * 0.659375 * 69/422;
    imgView.image = [UIImage imageNamed:@"order_review_ok"];
    
    // 评价状态提示label
    UILabel *pingjiaTipLb = [[UILabel alloc] init];
    [_tanchuVc addSubview:pingjiaTipLb];
    [pingjiaTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.mas_bottom).with.offset(W * 3/64);
        make.centerX.equalTo(_tanchuVc);
        make.height.equalTo(@(14));
    }];
    pingjiaTipLb.font = [UIFont systemFontOfSize:14];
    pingjiaTipLb.text = @"评价已发布,感谢您的发布";
    pingjiaTipLb.textColor = FUIColorFromRGB(0x4e4e4e);
    // 确定按钮
    _SureBtn = [[UIButton alloc] init];
    [_tanchuVc addSubview:_SureBtn];
    [_SureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pingjiaTipLb.mas_bottom).with.offset(W * 3/64);
        make.centerX.equalTo(_tanchuVc);
        make.width.equalTo(@(W * 5/16));
        make.height.equalTo(@(W * 0.075));
    }];
    _SureBtn.backgroundColor = FUIColorFromRGB(0x8979ff);
    [_SureBtn setTitleColor:FUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [_SureBtn setTitle:@"确定" forState:UIControlStateNormal];
    _SureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _SureBtn.layer.cornerRadius = W * 0.075/2;
    _SureBtn.clipsToBounds = YES;
    [_SureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
//    640*232
    
    // 商品图片
    _goodsImgView = [[UIImageView alloc] init];
    [self.view addSubview:_goodsImgView];
    [_goodsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(W * 0.025);
        make.left.equalTo(self.view).with.offset(W * 0.03125);
        make.width.equalTo(@(W * 0.12));
        make.height.equalTo(@(W * 0.12));
    }];
    _goodsImgView.image = [UIImage imageNamed:@"7"];
    _goodsImgView.layer.cornerRadius = W * 0.06;
    _goodsImgView.clipsToBounds = YES;
    
    
    // 描述相符label
    UILabel *lbTitle = [[UILabel alloc] init];
    [self.view addSubview:lbTitle];
    [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_goodsImgView);
        make.left.equalTo(_goodsImgView.mas_right).with.offset(W * 0.03125);
        make.height.equalTo(@(15));
    }];
    lbTitle.font = [UIFont systemFontOfSize:15];
    lbTitle.textColor = FUIColorFromRGB(0x4e4e4e);
    lbTitle.text = @"描述相符";
    
    //星级评价
    _bar = [[RatingBar alloc] initWithFrame:CGRectMake(0, 0, W * 0.32, 17)];
    _bar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_bar];
    [_bar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lbTitle);
        make.left.equalTo(lbTitle.mas_right).with.offset(-5);
        make.height.equalTo(@(17));
        make.width.equalTo(@(W * 0.32));
    }];
    _bar.delegate = self;
    
    // 分割线
    UILabel *lbFenge = [[UILabel alloc] init];
    [self.view addSubview:lbFenge];
    [lbFenge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_goodsImgView.mas_bottom).with.offset(W * 0.025);
        make.left.equalTo(_goodsImgView);
        make.right.equalTo(self.view);
        make.height.equalTo(@(1));
    }];
    lbFenge.backgroundColor = FUIColorFromRGB(0xeeeeee);
    
    _tfView = [[UITextView alloc] init];
    [self.view addSubview:_tfView];
    [_tfView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbFenge.mas_bottom).with.offset(W * 0.03125);
        make.left.equalTo(lbFenge);
        make.right.equalTo(self.view);
        make.height.equalTo(@(W * 0.16875));
    }];
    // 是否可编辑
    _tfView.editable = YES;
    //设置代理
    _tfView.delegate = self;
    //设置内容
    _tfView.text = @"宝贝满足你的期待吗？分享心得给想买的他们吧";
    //字体颜色
    _tfView.textColor = FUIColorFromRGB(0x999999);
    //设置字体
    _tfView.font = [UIFont systemFontOfSize:12];
    
    [_tfView layoutIfNeeded];
    [self.view layoutIfNeeded];
    
    
    // 创建collectionview
    //addPhoto
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _addPhotoCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_tfView.frame)+10, W, (W-50)/4+20) collectionViewLayout:flow];
    //    _addPhotoView.pagingEnabled = NO;
    _addPhotoCollection.backgroundColor = [UIColor whiteColor];
    _addPhotoCollection.delegate = self;
    _addPhotoCollection.dataSource = self;
    
    //注册
    [_addPhotoCollection registerNib:[UINib nibWithNibName:@"AddPhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_addPhotoCollection];
    
    
    // 分割线
    UILabel *lbFenge2 = [[UILabel alloc] init];
    [self.view addSubview:lbFenge2];
    [lbFenge2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addPhotoCollection.mas_bottom);
        make.left.equalTo(self.view);
        make.width.equalTo(@(W));
        make.height.equalTo(@(1));
    }];
    lbFenge2.backgroundColor = FUIColorFromRGB(0xeeeeee);
    
    // 匿名
    _nimingBtn = [[UIButton alloc] init];
    [self.view addSubview:_nimingBtn];
    [_nimingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbFenge2.mas_bottom);
        make.left.equalTo(self.view);
        make.width.equalTo(@(W * 0.1875));
        make.height.equalTo(@(W * 0.09375));
    }];
    _nimingBtn.imageView.sd_layout
    .leftSpaceToView(_nimingBtn,W * 0.03125)
    .centerYEqualToView(_nimingBtn)
    .heightRatioToView(_nimingBtn,0.5)
    .widthEqualToHeight();
    _nimingBtn.titleLabel.sd_layout
    .leftSpaceToView(_nimingBtn.imageView,5)
    .centerYEqualToView(_nimingBtn)
    .heightIs(15)
    .widthIs(31);
    _nimingBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_nimingBtn setTitle:@"匿名" forState:UIControlStateNormal];
    [_nimingBtn setTitleColor:FUIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [_nimingBtn setImage:[UIImage imageNamed:@"order_review_checkbox"] forState:UIControlStateNormal];
    [_nimingBtn setImage:[UIImage imageNamed:@"order_review_checkbox2"] forState:UIControlStateSelected];
    _nimingBtn.selected = NO;
    [_nimingBtn addTarget:self action:@selector(nimingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 提示label
    UILabel *tipLb = [[UILabel alloc] init];
    [self.view addSubview:tipLb];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_nimingBtn);
        make.right.equalTo(self.view).with.offset(- W * 0.03125);
        make.height.equalTo(@(14));
    }];
    tipLb.font = [UIFont systemFontOfSize:14];
    tipLb.textColor = FUIColorFromRGB(0x999999);
    tipLb.text = @"您的评价能帮助其他小伙伴哦";
    
}


// 创建加载动画
- (void)createLoading {
    
    // 加载动画
    _HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    // 展示
    [_HUD show:YES];
    
    // 15秒隐藏动画
    [_HUD hide:YES afterDelay:15];
    
}

// 匿名按钮点击事件
- (void) nimingBtnClick:(UIButton *)btn {
    
    if (btn.selected == NO) {
        
        btn.selected = YES;
        // 修改保存的匿名状态
        _nimingStr = @"1";
        
    }else {
        
        btn.selected = NO;
        // 修改保存的匿名状态
        _nimingStr = @"0";
    }
}

// 确定按钮点击事件
- (void) sureBtnClick {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (_arrDataSources.count == 0) {
        
        return 1;
        
    }else {
        
        if (_arrDataSources.count>0&&_arrDataSources.count<=3){
            collectionView.frame = CGRectMake(0, CGRectGetMaxY(_tfView.frame)+10, W, (W-50)/4+20);
        }else if (_arrDataSources.count>3&&_arrDataSources.count<=7){
            collectionView.frame = CGRectMake(0, CGRectGetMaxY(_tfView.frame)+10, W, (W-50)/2+30);
        }else {
            collectionView.frame = CGRectMake(0, CGRectGetMaxY(_tfView.frame)+10, W, (W-50)/4*3+40);
        }
        
        return _arrDataSources.count+1;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AddPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        
        cell.imageView.image = [UIImage imageNamed:@"addPhoto.jpg"];
    }else {
        
        cell.imageView.image = _arrDataSources[indexPath.row-1];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return cell;
}

// 图片转字符串
- (NSString *)UIImageToBase64Str:(UIImage *) image

{
    
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return encodedImageStr;
    
}

//点击方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if (indexPath.row == 0) {
        ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
        //设置照片最大选择数
        actionSheet.maxSelectCount = 5;
        
        weakify(self);
        [actionSheet showPhotoLibraryWithSender:self lastSelectPhotoModels:self.lastSelectMoldels completion:^(NSArray<UIImage *> * _Nonnull selectPhotos, NSArray<ZLSelectPhotoModel *> * _Nonnull selectPhotoModels) {
            strongify(weakSelf);
            strongSelf.arrDataSources = [[NSMutableArray alloc]initWithArray:selectPhotos];
            strongSelf.lastSelectMoldels = selectPhotoModels;
            [strongSelf.addPhotoCollection reloadData];
            NSLog(@"%@", selectPhotos);
            
            _selectImgArr = selectPhotos;
            NSLog(@"_selectImgArr,%@",_selectImgArr);
        }];
        
    }else {
        ZLCollectionCell *cell = (ZLCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [ZLShowBigImage showBigImage:cell.imageView];
    }
}

//设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((W-50)/4, (W-50)/4);
    
}
//单元格间 横向距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
//纵向
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
    
}
//与屏幕四周的间隔
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
    
}



#pragma mark - UITextViewDelegate协议中的方法
//将要进入编辑模式
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if ([_tfView.text isEqualToString:@"宝贝满足你的期待吗？分享心得给想买的他们吧"]) {
        
        //设置内容
        _tfView.text = @"";
        //字体颜色
        _tfView.textColor = FUIColorFromRGB(0x4e4e4e);
        //设置字体
        _tfView.font = [UIFont systemFontOfSize:14];
    }
    
    return YES;
}
//已经进入编辑模式
- (void)textViewDidBeginEditing:(UITextView *)textView{}
//将要结束/退出编辑模式
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{return YES;}
//已经结束/退出编辑模式
- (void)textViewDidEndEditing:(UITextView *)textView{

    if ([_tfView.text isEqualToString:@""]) {
        //设置字体
        _tfView.font = [UIFont systemFontOfSize:12];
        //设置内容
        _tfView.text = @"宝贝满足你的期待吗？分享心得给想买的他们吧";
        //字体颜色
        _tfView.textColor = FUIColorFromRGB(0x999999);
    }
}
//当textView的内容发生改变的时候调用
- (void)textViewDidChange:(UITextView *)textView{}
//选中textView 或者输入内容的时候调用
- (void)textViewDidChangeSelection:(UITextView *)textView{}
//从键盘上将要输入到textView 的时候调用
//rangge  光标的位置
//text  将要输入的内容
//返回YES 可以输入到textView中  NO不能
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{return YES;}


// 触摸屏幕触发事件
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if ([_tfView isFirstResponder]) {
        [_tfView resignFirstResponder];
    }
}


// 导航栏右侧按钮和视图
- (void) createRightBtn {
    
    // 右侧按钮
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 28, 15);
    [menuBtn setTitle:@"发布" forState:UIControlStateNormal];
    menuBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [menuBtn setTitleColor:FUIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    
    
    
}

// 右侧按钮点击事件
- (void) rightBtnClick:(UIButton *) menuBtn {
    
    
    // 创建请求接口对象
    HttpRequest *http = [[HttpRequest alloc] init];
    
    
    
    if (_bar.starNumber == 0) {
        
        // 请选择评价星级
        [http GetHttpDefeatAlert:@"请选择评价星级"];
        
    }else if ([_tfView.text isEqualToString:@""] || [_tfView.text isEqualToString:@"宝贝满足你的期待吗？分享心得给想买的他们吧"]) {
        
        // 先写点东西吧
        [http GetHttpDefeatAlert:@"先写点东西吧~O(∩_∩)O~"];
        
    }else {
        
        
        // 创建加载动画
        [self createLoading];
        
        if (_selectImgArr .count > 0) {
            
            // 有图片
            
            
            // 创建单例,获取到用户RSAKey
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *userRsaPublicKey = [user objectForKey:@"severPublicKey"];
            
            
            // 生成一个16位的AES的key,并保存用于解密服务器返回的信息
            NSString *strAESkey = [NSString set32bitString:16];
            [user setObject:strAESkey forKey:@"aesKey"];
            // 最终加密好的key参数的密文
            NSString *keyMiWenStr = [RSAEncryptor encryptString:strAESkey publicKey:userRsaPublicKey];
            NSLog(@"keyMiWenStr:%@",keyMiWenStr);
            
            
            // 获取当前时间戳，转换成json类型，并用AES进行加密,并做了base64及urlcode转码处理
            NSDate *senddate = [NSDate date];
            NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
            NSDictionary *cgDic = @{@"requestTime":date2};
            // 最终加密好的cg参数的密文
            NSString *cgMiWenStr = [[MakeJson createJson:cgDic] AES128EncryptWithKey:strAESkey];
            
            NSLog(@"cgMiWenStr:%@",cgMiWenStr);
            
            // 用户token
            NSString *userToken = [user objectForKey:@"token"];
            NSLog(@"userToken%@",userToken);
            
            
            // 创建要发送的字典数据
            NSDictionary *dic = @{@"tk":userToken,@"key":keyMiWenStr,@"cg":cgMiWenStr};
            
            // 一张张上传图片
            for (int i = 0; i < _selectImgArr.count; i++) {
                
                [http PostImgToServerWithUserInfo:dic andImg:_selectImgArr[i] Success:^(id arrForDetail) {
                    
                    NSLog(@"=========*************===========%@",arrForDetail);
                    
                    if ([arrForDetail isKindOfClass:[NSString class]] && [arrForDetail isEqualToString:@"0"]) {
                        
                        // 上传失败
                        if (i == 0) {
                            
                            _strTupianId = @"错误";
                        }else {
                            
                            _strTupianId = [NSString stringWithFormat:@"%@,%@",_strTupianId,@"错误"];
                        }
                        
                    }else {
                        
                        // 上传成功
                        NSLog(@"上传成功");
                        
                        if (i == 0) {
                            
                            _strTupianId = [NSString stringWithFormat:@"%@",[[arrForDetail objectForKey:@"data"] objectForKey:@"id"]];
                        }else {
                            
                            _strTupianId = [NSString stringWithFormat:@"%@,%@",_strTupianId,[[arrForDetail objectForKey:@"data"] objectForKey:@"id"]];
                        }
                        
                        if ([_strTupianId componentsSeparatedByString:@","].count == _selectImgArr.count && [_strTupianId containsString:@"错误"] == false ) {
                            
                            // 创建评论传输的参数dic
                            NSDictionary *dicForPingJiaDetail = @{@"order_sn":@"1234567",@"star":[NSString stringWithFormat:@"%ld",_bar.starNumber],@"hide_username_flag":_nimingStr,@"summary":_tfView.text,@"img_list":_strTupianId};
                            
                            NSString *strMiwenData = [[MakeJson createJson:dicForPingJiaDetail]  AES128EncryptWithKey:strAESkey];
                            
                            
                            NSDictionary *dicForData = @{@"tk":userToken,@"key":keyMiWenStr,@"cg":cgMiWenStr,@"data":strMiwenData};
                            
                            // 请求接口，添加评价
                            [http PostAddPingjiaWithDic:dicForData Success:^(id arrForDetail) {
                                
                                if ([arrForDetail isEqualToString:@"1"]) {
                                    
                                    
                                    NSLog(@"=======================%@",_strTupianId);
                                    
                                    NSLog(@"arrforDetail,%@",arrForDetail);
                                    
                                    
                                    // 显示发布成功
                                    // 遮罩层
                                    ZheZhaoView *zhezhao = [[ZheZhaoView alloc] initWithFrame:CGRectMake(0, 0, W, H + 64)];
                                    [self.navigationController.view addSubview:zhezhao];
                                    zhezhao.tag = 9090;
                    
                                    // 弹出视图
                                    UIView *tanchu = [[UIView alloc] init];
                                    [zhezhao addSubview:tanchu];
                                    //    422*370
                                    [tanchu mas_makeConstraints:^(MASConstraintMaker *make) {
                                        make.centerY.equalTo(zhezhao);
                                        make.centerX.equalTo(zhezhao);
                                        make.width.equalTo(@(W * 0.659375));
                                        make.height.equalTo(@(W * 0.578125));
                                    }];
                                    tanchu.backgroundColor = FUIColorFromRGB(0xffffff);
                                    tanchu.layer.cornerRadius = 6;
                                    tanchu.clipsToBounds = YES;
                                    UIImageView *imgView = [[UIImageView alloc] init];
                                    [tanchu addSubview:imgView];
                                    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                                        make.top.equalTo(tanchu).with.offset(W * 0.0625);
                                        make.centerX.equalTo(tanchu);
                                        make.width.equalTo(@(W * 0.659375 * 69/211));
                                        make.height.equalTo(@(W * 0.659375 * 69/211));
                                    }];
                                    imgView.layer.cornerRadius = W * 0.659375 * 69/422;
                                    imgView.image = [UIImage imageNamed:@"order_review_ok"];
                                    
                                    // 评价状态提示label
                                    UILabel *pingjiaTipLb = [[UILabel alloc] init];
                                    [tanchu addSubview:pingjiaTipLb];
                                    [pingjiaTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
                                        make.top.equalTo(imgView.mas_bottom).with.offset(W * 3/64);
                                        make.centerX.equalTo(tanchu);
                                        make.height.equalTo(@(14));
                                    }];
                                    pingjiaTipLb.font = [UIFont systemFontOfSize:14];
                                    pingjiaTipLb.text = @"评价已发布,感谢您的发布";
                                    pingjiaTipLb.textColor = FUIColorFromRGB(0x4e4e4e);
                                    // 确定按钮
                                    UIButton *btn = [[UIButton alloc] init];
                                    [tanchu addSubview:btn];
                                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                        make.top.equalTo(pingjiaTipLb.mas_bottom).with.offset(W * 3/64);
                                        make.centerX.equalTo(tanchu);
                                        make.width.equalTo(@(W * 5/16));
                                        make.height.equalTo(@(W * 0.075));
                                    }];
                                    btn.backgroundColor = FUIColorFromRGB(0x8979ff);
                                    [btn setTitleColor:FUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
                                    [btn setTitle:@"确定" forState:UIControlStateNormal];
                                    btn.titleLabel.font = [UIFont systemFontOfSize:15];
                                    btn.layer.cornerRadius = W * 0.075/2;
                                    btn.clipsToBounds = YES;
                                    [btn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
                                    
                                }
                                
                                [_HUD hide:YES];
                                
                            } failure:^(NSError *error) {
                                
                                [_HUD hide:YES];
                            }];
                        }
                    }
                    
                    
                    
                } failure:^(NSError *error) {
                    
                    // 请求错误
                    
                    [_HUD hide:YES];
                }];
            }
            
        }else {
            
            // 无图片
            
            
            // 创建单例,获取到用户RSAKey
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *userRsaPublicKey = [user objectForKey:@"severPublicKey"];
            
            
            // 生成一个16位的AES的key,并保存用于解密服务器返回的信息
            NSString *strAESkey = [NSString set32bitString:16];
            [user setObject:strAESkey forKey:@"aesKey"];
            // 最终加密好的key参数的密文
            NSString *keyMiWenStr = [RSAEncryptor encryptString:strAESkey publicKey:userRsaPublicKey];
            NSLog(@"keyMiWenStr:%@",keyMiWenStr);
            
            
            // 获取当前时间戳，转换成json类型，并用AES进行加密,并做了base64及urlcode转码处理
            NSDate *senddate = [NSDate date];
            NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
            NSDictionary *cgDic = @{@"requestTime":date2};
            // 最终加密好的cg参数的密文
            NSString *cgMiWenStr = [[MakeJson createJson:cgDic] AES128EncryptWithKey:strAESkey];
            
            NSLog(@"cgMiWenStr:%@",cgMiWenStr);
            
            // 用户token
            NSString *userToken = [user objectForKey:@"token"];
            NSLog(@"userToken%@",userToken);
            
            
            // 创建评论传输的参数dic
            NSDictionary *dicForPingJiaDetail = @{@"order_sn":@"1234567",@"star":[NSString stringWithFormat:@"%ld",_bar.starNumber],@"hide_username_flag":_nimingStr,@"summary":_tfView.text,@"img_list":@""};
            
            NSString *strMiwenData = [[MakeJson createJson:dicForPingJiaDetail]  AES128EncryptWithKey:strAESkey];
            
            
            NSDictionary *dicForData = @{@"tk":userToken,@"key":keyMiWenStr,@"cg":cgMiWenStr,@"data":strMiwenData};
            
            
            
            
            // 请求接口，添加评价
            [http PostAddPingjiaWithDic:dicForData Success:^(id arrForDetail) {
                
                NSLog(@"arrforDetail,%@",arrForDetail);
                
                if ([arrForDetail isEqualToString:@"1"]) {
                    
                    // 显示发布成功
                    [self showSuccessView];
                    
                    [_HUD hide:YES];
                }
                
            } failure:^(NSError *error) {
                
                [_HUD hide:YES];
            }];
        }
        
    }

        
}



- (void) showSuccessView {
    
    // 显示发布成功
    [UIView animateWithDuration:0.35f animations:^{
        
        _zhezhaoVc.hidden = NO;
    }];
}



// 返回按钮
- (void) createBackBtn {
    
    // 返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(20, 0, 10.4, 18.4);
    
    [backBtn setImage:[UIImage imageNamed:@"details_return"] forState:UIControlStateNormal];
    
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

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleDefault;
}

// 返回按钮点击事件
- (void) doBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 页面将要消失
- (void) viewWillDisappear:(BOOL)animated {
    
    ZheZhaoView *vc = [self.navigationController.view viewWithTag:9090];
    [vc removeFromSuperview];
    
    [_zhezhaoVc removeFromSuperview];
    
    // 打开手势返回
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    //这个接口可以动画的改变statusBar的前景色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

// 页面将要显示
- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    //这个接口可以动画的改变statusBar的前景色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    // 关闭手势返回
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
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
