//
//  RealNameYanZhengViewController.m
//  EasyLink
//
//  Created by 琦琦 on 16/11/4.
//  Copyright © 2016年 fengdian. All rights reserved.
//  实名认证

#import "RealNameYanZhengViewController.h"
#import "UIImage+ZZQheaderImg.h" // 做虚线边框

@interface RealNameYanZhengViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate> {
    
    UIScrollView *_bacScrollView;
    
    UIImage *_img0; // 正面
    UIImage *_img1; // 反面
    UIImage *_img2; // 手持
}


@end

@implementation RealNameYanZhengViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 页面背景色
    self.view.backgroundColor = FUIColorFromRGB(0xffffff);
    
    // 设置导航栏标题
    UILabel *lbItemTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    lbItemTitle.text = @"实名认证";
    lbItemTitle.textColor = [UIColor whiteColor];
    lbItemTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lbItemTitle;
    
    // 返回按钮
    [self createBackBtn];
    
    // 导航栏右侧按钮
    [self createRightBtn];
    
    // 布局页面
    [self layoutViews];
}

// 布局页面
- (void) layoutViews {
    
    // 底层滚动视图
    _bacScrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_bacScrollView];
    [_bacScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.left.equalTo(self.view);
        make.width.equalTo(@(W));
        make.height.equalTo(@(H - 64));
    }];
    _bacScrollView.contentSize = CGSizeMake(W, H * 2);
    _bacScrollView.backgroundColor = FUIColorFromRGB(0xffffff);
    
    
    NSArray *arrlbName = @[@"真实姓名",@"证件类型",@"证件号码",@"证件照片"];
    for (int i = 0; i < 4; i++) {
        // 认证项目名
        UILabel *lb = [[UILabel alloc] init];
        [_bacScrollView addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bacScrollView).with.offset(0.07 * H + 0.073 * H * i);
            make.left.equalTo(_bacScrollView).with.offset(W * 3 / 32);
            make.width.equalTo(@(60));
            make.height.equalTo(@(15));
        }];
        lb.textColor = FUIColorFromRGB(0x4e4e4e);
        lb.text = arrlbName[i];
        lb.font = [UIFont systemFontOfSize:14];
        
        if (i < 3) {
            // 分割线
            UILabel *lbFenge = [[UILabel alloc] init];
            [_bacScrollView addSubview:lbFenge];
            [lbFenge mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lb.mas_bottom).with.offset(0.0167 * H);
                make.left.equalTo(lb);
                make.right.equalTo(self.view.mas_right).with.offset(- W * 3 / 32);
                make.height.equalTo(@(1));
            }];
            lbFenge.backgroundColor = FUIColorFromRGB(0xd5d5d5);
            
            
            NSArray *arrTfPlaceholder = @[@"请输入真实姓名",@"身份证(目前仅支持此方式验证)",@"请输入身份证号"];
            
            // 输入框
            UITextField *tf = [[UITextField alloc] init];
            [_bacScrollView addSubview:tf];
            [tf mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lb).with.offset(0.5);
                make.left.equalTo(lb.mas_right).with.offset(0.047 * W);
                make.right.equalTo(self.view).with.offset(- W * 3 / 32);
                make.height.equalTo(lb);
            }];
            tf.font = [UIFont systemFontOfSize:13];
            tf.placeholder = arrTfPlaceholder[i];
            tf.tag = 1000 + i;
            if (i == 1) {
                tf.userInteractionEnabled = NO;
            }
        }
        
        if (i == 3) {
            
            NSArray *arrFroBtnAddName = @[@"身份证正面照片",@"身份证反面照片",@"手持身份证照片"];
            
            for (int j = 0; j < 3; j++) {
                UIView *vc = [[UIView alloc] init];
                [_bacScrollView addSubview:vc];
                [vc mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lb).with.offset(0.234 * H * j);
                    make.left.equalTo(lb.mas_right).with.offset(0.047 * W);
                    make.width.equalTo(@(self.view.frame.size.width - W * 3 / 32 - 60 - 0.047 * W - 0.11 * W));
                    make.height.equalTo(@(0.5625 * (self.view.frame.size.width - W * 3 / 32 - 60 - 0.047 * W - 0.11 * W)));
                }];
                [vc.layer setBorderWidth:1.0];
                UIImage *img = [UIImage imageWithSize:CGSizeMake(self.view.frame.size.width - W * 3 / 32 - 60 - 0.047 * W - 0.11 * W, 0.5625 * (self.view.frame.size.width - W * 3 / 32 - 60 - 0.047 * W - 0.11 * W)) borderColor:FUIColorFromRGB(0xd5d5d5) borderWidth:2.0];
                [vc.layer setBorderColor:[[UIColor colorWithPatternImage:img] CGColor]];
                vc.tag = 500+j;
                
                // 添加照片按钮
                UIButton *btnAddImg = [[UIButton alloc] init];
                [vc addSubview:btnAddImg];
                [btnAddImg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(vc).with.offset(0);
                    make.centerX.equalTo(vc);
                    make.width.equalTo(@(self.view.frame.size.width - W * 3 / 32 - 60 - 0.047 * W - 0.11 * W - 20));
                    make.height.equalTo(@(0.5625 * (self.view.frame.size.width - W * 3 / 32 - 60 - 0.047 * W - 0.11 * W)));
                }];
                
                btnAddImg.imageView.sd_layout
                .centerXEqualToView(btnAddImg)
                .topSpaceToView(btnAddImg,0.35 * btnAddImg.frame.size.height)
                .heightRatioToView(btnAddImg,0.143)
                .widthEqualToHeight();
                btnAddImg.titleLabel.sd_layout
                .centerXEqualToView(btnAddImg)
                .topSpaceToView(btnAddImg.imageView,0.09 * btnAddImg.frame.size.height)
                .heightIs(15);
                
                [btnAddImg setTitle:arrFroBtnAddName[j] forState:UIControlStateNormal];
                [btnAddImg setTitleColor:FUIColorFromRGB(0x999999) forState:UIControlStateNormal];
                btnAddImg.titleLabel.font = [UIFont systemFontOfSize:13];
                [btnAddImg setImage:[UIImage imageNamed:@"实名认证_添加"] forState:UIControlStateNormal];
                btnAddImg.tag = 300 + j;
                // 点击事件
                [btnAddImg addTarget:self action:@selector(btnAddClick:) forControlEvents:UIControlEventTouchUpInside];
                
                if (j == 2) {
                    UIButton *btnSubmit = [[UIButton alloc] init];
                    [_bacScrollView addSubview:btnSubmit];
                    [btnSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(vc.mas_bottom).with.offset(0.053 * H);
                        make.centerX.equalTo(self.view);
                        make.width.equalTo(@(0.65625 * W));
                        make.height.equalTo(@(0.0484 * H));
                    }];
                    btnSubmit.layer.cornerRadius = 0.0484 * H / 2;
                    [btnSubmit setTitle:@"提交认证" forState:UIControlStateNormal];
                    btnSubmit.backgroundColor = FUIColorFromRGB(0x8979ff);
                    [btnSubmit setTitleColor:FUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
                    btnSubmit.titleLabel.font = [UIFont systemFontOfSize:15];
                    
                    [btnSubmit addTarget:self action:@selector(btnSubmitClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                    // 固定layout,获取
                    [_bacScrollView layoutIfNeeded];
                    _bacScrollView.contentSize = CGSizeMake(W, btnSubmit.frame.origin.y + btnSubmit.frame.size.height + 30);
                }
            }
        }
    }
}

// 提交审核按钮点击事件
- (void) btnSubmitClick:(UIButton *)btnSubmit {
    
    alert(@"点击了提交认证");
}

// 添加验证照片点击事件
- (void) btnAddClick:(UIButton *)btnAddImg {
    // tag值  300 301 302
    NSLog(@"添加身份证照片");
    
    
    if (btnAddImg.tag == 300) {
        // 添加正面
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *str = @"正面";
        [user setObject:str forKey:@"正面"];
    }else if (btnAddImg.tag == 301) {
        // 添加反面
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *str = @"反面";
        [user setObject:str forKey:@"反面"];
    }else {
        // 添加反面
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *str = @"手持";
        [user setObject:str forKey:@"手持"];
    }
    
    UIAlertController *actionController = [UIAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            // 实现照相功能
            // 类型Camera
            [self loadImageWithType:UIImagePickerControllerSourceTypeCamera];
            
        }else {
            
            NSLog(@"抱歉,暂时不能照相");
            // 给用户提示
            [self showMessage:@"不支持照相功能"];
        }
        
        
    }];
    [actionController addAction:action1];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // 相册取照片 和照相相似  只需修改类型  类型为PhotoLabrary
        [self loadImageWithType:UIImagePickerControllerSourceTypePhotoLibrary];
        
    }];
    [actionController addAction:action2];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    
    [actionController addAction:action3];
    
    [self presentViewController:actionController animated:YES completion:nil];

    
    
}

- (void)loadImageWithType:(UIImagePickerControllerSourceType)type {
    
    // 创建UIImagePickerController对象
    UIImagePickerController *imagePC = [[UIImagePickerController alloc] init];
    
    // 设置资源类型
    imagePC.sourceType = type;
    // 设置是否可以后续操作
    imagePC.allowsEditing = YES;
    // 设置代理
    imagePC.delegate = self;
    
    // 一般都采用模态视图跳转方式
    [self presentViewController:imagePC animated:YES completion:^{
        
        NSLog(@"跳转完成");
    }];
}
// 提示框
- (void)showMessage:(NSString *)message {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alert show];
}

#pragma mark - UIImagePickerControllerDelegate -
// 点击choose完成按钮实现的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // 选取资源类型 这里是Media类型
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    // 判断当前的图片是普通图片 public.image
    if ([type isEqualToString:@"public.image"]) {
        // 选取图片 根据类型EditedImage 这个key得到图片image
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        
        if ([[user valueForKey:@"正面"] isEqualToString:@"正面"]) {
            _img0 = [info objectForKey:UIImagePickerControllerEditedImage];
            UIView *vc = [_bacScrollView viewWithTag:500];
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - W * 3 / 32 - 60 - 0.047 * W - 0.11 * W, 0.5625 * (self.view.frame.size.width - W * 3 / 32 - 60 - 0.047 * W - 0.11 * W))];
            [vc addSubview:imgView];
            imgView.image = _img0;
            [user removeObjectForKey:@"正面"];
        }else if ([[user valueForKey:@"反面"] isEqualToString:@"反面"]) {
            _img1 = [info objectForKey:UIImagePickerControllerEditedImage];
            UIView *vc = [_bacScrollView viewWithTag:501];
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - W * 3 / 32 - 60 - 0.047 * W - 0.11 * W, 0.5625 * (self.view.frame.size.width - W * 3 / 32 - 60 - 0.047 * W - 0.11 * W))];
            [vc addSubview:imgView];
            imgView.image = _img1;
            [user removeObjectForKey:@"反面"];
        }else {
            _img2 = [info objectForKey:UIImagePickerControllerEditedImage];
            UIView *vc = [_bacScrollView viewWithTag:502];
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - W * 3 / 32 - 60 - 0.047 * W - 0.11 * W, 0.5625 * (self.view.frame.size.width - W * 3 / 32 - 60 - 0.047 * W - 0.11 * W))];
            [vc addSubview:imgView];
            imgView.image = _img2;
            [user removeObjectForKey:@"手持"];
        }
        
        // 压缩大小
//        _img = [self scaleToSize:[info objectForKey:UIImagePickerControllerEditedImage] size:CGSizeMake(200,200)];
        
        // 压缩大小（内存）
//        [self imageData:_img];
        
    }
    // 跳回去  必须要加  否则用户无法跳回应用
    [picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"返回完成");
    }];
    
}

// 点击cancel取消按钮时执行的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    NSLog(@"取消");
    [picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"返回完成");
    }];
}

// 压缩图片大小
- (NSData *)imageData:(UIImage *)myimage
{
    NSData *data=UIImageJPEGRepresentation(myimage, 1.0);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(myimage, 0.1);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(myimage, 0.5);
        }else if (data.length>200*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(myimage, 0.9);
        }
    }
    return data;
}

// 压缩图片
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}


// 导航栏右侧按钮和视图
- (void) createRightBtn {
    
    // 右侧按钮
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 28, 15);
    [menuBtn setTitle:@"示例" forState:UIControlStateNormal];
    menuBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [menuBtn setTitleColor:FUIColorFromRGB(0xded9fe) forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    menuBtn.selected = NO;
    menuBtn.tag = 666;
}

// 示例点击事件（导航栏右侧）
- (void) rightBtnClick:(UIButton *)menuBtn {
    
    NSLog(@"示例");
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

// 页面将要显示
- (void) viewWillAppear:(BOOL)animated {
    
    // 设置导航栏背景色(用到了UIImage+GradientColor.h这个类扩展)
    UIColor *topleftColor = FUIColorFromRGB(0x9080ff);
    UIColor *bottomrightColor = FUIColorFromRGB(0x7765ff);
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor, bottomrightColor] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(W, 64)];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:bgImg]];

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
