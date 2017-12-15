//
//  HttpRequest.m
//  EasyLink
//
//  Created by 琦琦 on 2017/5/2.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "HttpRequest.h"
#import "LoginViewController.h" // 登录页面
#import "AppDelegate.h"

@implementation HttpRequest

+ (void)postWithURL:(NSString *)str andDic:(NSDictionary *)dic success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure {
    
    //1.创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    
    manager.requestSerializer.timeoutInterval = 7.f;
    
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:str parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

// 获取公共rsa公钥
- (void) GetRSAPublicKeySuccess:(void(^)(id strPublickey))success failure:(void (^)(NSError *error))failure {
    
    NSString *str = [NSString stringWithFormat:@"%@%@",STRPATH,@"/System_getRsaPublicKey"];
    
    [HttpRequest postWithURL:str andDic:nil success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic valueForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            NSString *strPublicKey = [[NSString alloc]init];
            
            if (success) {
                
                success(strPublicKey);
            }
            
        }else {
            
            NSDictionary *DataDic = [dic objectForKey:@"data"];
            
            NSString *strPublicKey = [DataDic objectForKey:@"rsa_public_key"];
            
            if (success) {
                
                success(strPublicKey);
            }
        }
        
    } failure:^(NSError *error) {
        
        HttpRequest *http = [[HttpRequest alloc] init];
        
        [http GetHttpDefeatAlert:@"请求失败，请稍后再试"];
    }];
}


// 获取验证码
- (void) PostPhoneCodeWithDic:(NSDictionary *)datedic Success:(void(^)(id status))success failure:(void (^)(NSError *error))failure {
    
    NSString *str = [NSString stringWithFormat:@"%@%@",STRPATH,@"/User_sendSmsVerifyCode"];
    
    [HttpRequest postWithURL:str andDic:datedic success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic valueForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            HttpRequest *http = [[HttpRequest alloc] init];
            
            NSString *message = [dic objectForKey:@"msg"];
            NSLog(@"message:%@",message);
            NSString *errorCode = [dic objectForKey:@"errorCode"];
            NSLog(@"errorCode:%@",errorCode);
            
            if (success) {
                
                success([NSString stringWithFormat:@"%ld",statusInt]);
            }
            
            switch ([errorCode integerValue]) {
                case 1002: {
                    
                    [http GetHttpDefeatAlert:message];
                }
                    break;
                case 1003: {
                    
                    [http GetHttpDefeatAlert:message];
                }
                    break;
                case 1004: {
                    
                    [http GetHttpDefeatAlert:message];
                }
                    break;
                case 1005: {
                    
                    [http GetHttpDefeatAlert:message];
                }
                    break;
                case 1009: {
                    
                    [http GetHttpDefeatAlert:message];
                }
                    break;
                    
                default:{
                    
                    [http GetHttpDefeatAlert:@"获取验证码失败,请稍后再试"];
                }
                    break;
            }
            
        }else {
            
            NSString *message = [dic objectForKey:@"msg"];
            
            if (success) {
                
                success(message);
            }
        }
        
    } failure:^(NSError *error) {
        
        HttpRequest *http = [[HttpRequest alloc] init];
        
        [http GetHttpDefeatAlert:@"请求失败，请稍后再试"];
    }];

}


// 注册
- (void) PostRegisterWithDic:(NSDictionary *)datedic Success:(void(^)(id userDataJsonStr))success failure:(void (^)(NSError *error))failure {
    
    NSString *str = [NSString stringWithFormat:@"%@%@",STRPATH,@"/User_regist"];
    
    [HttpRequest postWithURL:str andDic:datedic success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic valueForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            NSString *message = [[NSString alloc]init];
            NSLog(@"message:%@",message);
            NSString *errorCode = [dic valueForKey:@"errorCode"];
            NSLog(@"errorCode:%@",errorCode);
            
            if (success) {
                
                success([NSString stringWithFormat:@"%ld",statusInt]);
                
                NSLog(@"message:%@",message);
                
            }
            
            // 提示注册失败
            HttpRequest *http = [[HttpRequest alloc] init];
            [http GetHttpDefeatAlert:@"注册失败，请稍后再试"];
            
        }else {
            
            NSString *message = [dic objectForKey:@"msg"];
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            
            // 拿到服务器给的key（里面有用我自己公钥加密后的后台的aes的key）
            NSString *strSeverKey = [dataDic objectForKey:@"key"];
            //
            // 再用本地保留的私钥进行rsa解密获取服务器的key，此过程已提前完成url解码和base64解码
            NSString *private_key_path = [[NSBundle mainBundle] pathForResource:@"private_key.p12" ofType:nil];
            NSString *keyForSever = [RSAEncryptor decryptString:strSeverKey privateKeyWithContentsOfFile:private_key_path password:@"123456easylink"];
            
            // 拿到实际的后台返回的key后，解析后台返回的加密的数据
            // 先拿到加密及编码的data
            NSString *userData = [dataDic objectForKey:@"data"];
            // 再用刚刚得到的后台的key对其进行aes解密得到data的Json字符串，此过程已提前完成url解码和base64解码
            NSString *userData2 = [userData AES128DecryptWithKey:keyForSever];
            
            
            if (success) {
                
                success(userData2);
                
                NSLog(@"message:%@",message);
                
            }
        }
        
    } failure:^(NSError *error) {
        
        HttpRequest *http = [[HttpRequest alloc] init];
        
        [http GetHttpDefeatAlert:@"请求失败，请稍后再试"];
    }];
}


// 登录
- (void) PostLoginWithDic:(NSDictionary *)datedic Success:(void(^)(id userDataJsonStr))success failure:(void (^)(NSError *error))failure {
    
    NSString *str = [NSString stringWithFormat:@"%@%@",STRPATH,@"/User_login"];
    
    [HttpRequest postWithURL:str andDic:datedic success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic valueForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            NSString *message = [[NSString alloc]init];
            NSLog(@"message:%@",message);
            NSString *errorCode = [dic valueForKey:@"errorCode"];
            NSLog(@"errorCode:%@",errorCode);
            
            if (success) {
                
                success([NSString stringWithFormat:@"%ld",statusInt]);
                
                NSLog(@"message:%@",message);
                
            }
            
            switch ([errorCode integerValue]) {
                case 1002:
                {
                    
                    // 提示登录失败
                    HttpRequest *http = [[HttpRequest alloc] init];
                    [http GetHttpDefeatAlert:@"用户名或密码错误"];
                }
                    break;
                case 1009: {
                    
                    // 提示登录失败
                    HttpRequest *http = [[HttpRequest alloc] init];
                    [http GetHttpDefeatAlert:@"用户不存在"];
                }
                    break;
                case 1010: {
                    
                    // 提示登录失败
                    HttpRequest *http = [[HttpRequest alloc] init];
                    [http GetHttpDefeatAlert:@"密码错误,请重新输入"];
                }
                    break;
                    
                default: {
                    
                    // 提示登录失败
                    HttpRequest *http = [[HttpRequest alloc] init];
                    [http GetHttpDefeatAlert:@"登录失败,请稍后重试"];
                }
                    break;
            }
            
            
        }else {
            
            NSString *message = [dic objectForKey:@"msg"];
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            
            // 拿到服务器给的key（里面有用我自己公钥加密后的后台的aes的key）
            NSString *strSeverKey = [dataDic objectForKey:@"key"];
            //
            // 再用本地保留的私钥进行rsa解密获取服务器的key，此过程已提前完成url解码和base64解码
            NSString *private_key_path = [[NSBundle mainBundle] pathForResource:@"private_key.p12" ofType:nil];
            NSString *keyForSever = [RSAEncryptor decryptString:strSeverKey privateKeyWithContentsOfFile:private_key_path password:@"123456easylink"];
            
            // 拿到实际的后台返回的key后，解析后台返回的加密的数据
            // 先拿到加密及编码的data
            NSString *userData = [dataDic objectForKey:@"data"];
            // 再用刚刚得到的后台的key对其进行aes解密得到data的Json字符串，此过程已提前完成url解码和base64解码
            NSString *userData2 = [userData AES128DecryptWithKey:keyForSever];
            
            
            if (success) {
                
                success(userData2);
                
                NSLog(@"message:%@",message);
                
            }
        }
        
    } failure:^(NSError *error) {
        
        HttpRequest *http = [[HttpRequest alloc] init];
        
        [http GetHttpDefeatAlert:@"请求失败，请稍后再试"];
    }];
}

// 核对验证码
- (void) PostCheckCodeWithDic:(NSDictionary *)datedic Success:(void(^)(id confirmCode))success failure:(void (^)(NSError *error))failure {
    
    NSString *str = [NSString stringWithFormat:@"%@%@",STRPATH,@"/User_checkSmsVerifyCode"];
    
    [HttpRequest postWithURL:str andDic:datedic success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic valueForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            NSString *message = [[NSString alloc]init];
            NSLog(@"message:%@",message);
            NSString *errorCode = [dic valueForKey:@"errorCode"];
            NSLog(@"errorCode:%@",errorCode);
            
            if (success) {
                
                success([NSString stringWithFormat:@"%ld",statusInt]);
                
                NSLog(@"message:%@",message);
                
            }
            
            switch ([errorCode integerValue]) {
                case 1006:
                {
                    
                    // 提示验证失败
                    HttpRequest *http = [[HttpRequest alloc] init];
                    [http GetHttpDefeatAlert:@"验证码错误,请重试"];
                }
                    break;
                
                    
                default: {
                    
                    // 提示验证失败
                    HttpRequest *http = [[HttpRequest alloc] init];
                    [http GetHttpDefeatAlert:@"验证失败,请稍后重试"];
                }
                    break;
            }
            
            
        }else {
            
            NSString *message = [dic objectForKey:@"msg"];
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            
            NSString *strCode1 = [dataDic objectForKey:@"confirm_code"];
            NSLog(@"strcode:%@",strCode1);
            
            
            // 获取到请求时保留的AES的key进行解密
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSLog(@"aesKey:%@",[user objectForKey:@"aesKey"]);
            NSString *strCode = [strCode1 AES128DecryptWithKey:[user objectForKey:@"aesKey"]];
            NSLog(@"strCode:%@",strCode);
            
            if (success) {
                
                success(strCode);
                
                NSLog(@"message:%@",message);
                
            }
        }
        
    } failure:^(NSError *error) {
        
        HttpRequest *http = [[HttpRequest alloc] init];
        
        [http GetHttpDefeatAlert:@"请求失败，请稍后再试"];
    }];
}


// 重置密码
- (void) PostResetPassWordWithDic:(NSDictionary *)datadic Success:(void(^)(id resetMessage))success failure:(void (^)(NSError *error))failure {
    
    // 请求地址
    NSString *str = [NSString stringWithFormat:@"%@%@",STRPATH,@"/User_resetPwd"];
    
    [HttpRequest postWithURL:str andDic:datadic success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic valueForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            NSString *message = [dic valueForKey:@"message"];
            NSLog(@"message:%@",message);
            NSString *errorCode = [dic valueForKey:@"errorCode"];
            NSLog(@"errorCode:%@",errorCode);
            
            
            // 判断是否登录超时，并进行处理
            [self LoginOvertime:errorCode];
            
            
            if (success) {
                
                success([NSString stringWithFormat:@"%ld",statusInt]);
                
                NSLog(@"message:%@",message);
                
            }
            
            // 提示密码重置失败
            HttpRequest *http = [[HttpRequest alloc] init];
            [http GetHttpDefeatAlert:@"密码重置失败,请稍后重试"];
            
        }else {
            
            NSString *message = [dic objectForKey:@"msg"];
            
            
            if (success) {
                
                success(message);
                
                NSLog(@"message:%@",message);
                
            }
        }
        
    } failure:^(NSError *error) {
        
        HttpRequest *http = [[HttpRequest alloc] init];
        
        [http GetHttpDefeatAlert:@"请求失败，请稍后再试"];
    }];
}


// 修改密码
- (void) PostRevisePassWordWithDic:(NSDictionary *)datadic Success:(void(^)(id resetMessage))success failure:(void (^)(NSError *error))failure {
    
    // 请求地址
    NSString *str = [NSString stringWithFormat:@"%@%@",STRPATH,@"/User_modifyPwd"];
    
    [HttpRequest postWithURL:str andDic:datadic success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic valueForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            NSString *message = [[NSString alloc]init];
            NSLog(@"message:%@",message);
            NSString *errorCode = [dic valueForKey:@"errorCode"];
            NSLog(@"errorCode:%@",errorCode);
            
            // 判断是否登录超时，并进行处理
            [self LoginOvertime:errorCode];
            
            if (success) {
                
                success([NSString stringWithFormat:@"%ld",statusInt]);
                
                NSLog(@"message:%@",message);
                
            }
            
            // 提示密码重置失败
            HttpRequest *http = [[HttpRequest alloc] init];
            [http GetHttpDefeatAlert:@"密码修改失败,请稍后重试"];
            
        }else {
            
            NSString *message = [dic objectForKey:@"msg"];
            
            
            if (success) {
                
                success(message);
                
                NSLog(@"message:%@",message);
                
            }
        }
        
    } failure:^(NSError *error) {
        
        HttpRequest *http = [[HttpRequest alloc] init];
        
        [http GetHttpDefeatAlert:@"请求失败，请稍后再试"];
    }];
}

// 获取城市
- (void) GetAddressWithPid:(NSString *)strPid Success:(void(^)(id addressMessage))success failure:(void (^)(NSError *error))failure {
    
    // 请求地址
    NSString *str = [NSString stringWithFormat:@"/System_getRegionList?pid=%ld",[strPid integerValue]];
    
    NSString *path = [NSString stringWithFormat:@"%@%@",STRPATH,str];
    
    [HttpRequest postWithURL:path andDic:nil success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic valueForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            //
            HttpRequest *alert = [[HttpRequest alloc] init];
            // 提示获取失败
            [alert GetHttpDefeatAlert:@"获取城市列表失败"];
            
            NSString *str = [[NSString alloc]init];
            
            if (success) {
                
                success(str);
            }
            
        }else {
            
            NSMutableArray *mutarrForData = [[NSMutableArray alloc] init];
            
            NSArray *arrForData = [dic valueForKey:@"data"];
            
            for (int i = 0; i<arrForData.count; i++) {
                
                NSDictionary *dicForData = [arrForData objectAtIndex:i];
                
                [mutarrForData addObject:dicForData];
            }
            
            NSMutableArray *arrForAddress = [AddressModel arrayOfModelsFromDictionaries:mutarrForData error:nil];
            
            if (success) {
                
                success(arrForAddress);
            }
        }
    } failure:^(NSError *error) {
        
        HttpRequest *alert = [[HttpRequest alloc] init];
        // 提示获取数据失败
        [alert GetHttpDefeatAlert:@"网络错误,请求失败"];
        
    }];
}

// 获取用户资料
- (void) PostUserInfoWithDic:(NSDictionary *)userInfoDic Success:(void(^)(id userInfo))success failure:(void (^)(NSError *error))failure {
    
    // 请求地址
    NSString *path = [NSString stringWithFormat:@"%@%@",STRPATH,@"/User_getUserInfo"];
    
    [HttpRequest postWithURL:path andDic:userInfoDic success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic valueForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        NSString *errorCode = [dic valueForKey:@"errorCode"];
        
        if (statusInt == 0) {
            
            NSString *msg = [dic valueForKey:@"msg"];
            NSLog(@"msg:%@",msg);
            
            
            //
            HttpRequest *alert = [[HttpRequest alloc] init];
            // 提示获取失败
            [alert GetHttpDefeatAlert:@"获取用户信息失败"];
            
            // 判断是否登录超时，并进行处理
            [self LoginOvertime:errorCode];
            
            
            if (success) {
                
//                success(str);
            }
            
        }else {
            
            NSDictionary *arrForDic = [dic valueForKey:@"data"];
            
            NSLog(@"arrForDic:%@",arrForDic);
            
            
            // 拿到服务器给的key（里面有用我自己公钥加密后的后台的aes的key）
            NSString *strSeverKey = [arrForDic objectForKey:@"key"];
            
            
            // 再用本地保留的私钥进行rsa解密获取服务器的key，此过程已提前完成url解码和base64解码
            NSString *private_key_path = [[NSBundle mainBundle] pathForResource:@"private_key.p12" ofType:nil];
            NSString *keyForSever = [RSAEncryptor decryptString:strSeverKey privateKeyWithContentsOfFile:private_key_path password:@"123456easylink"];
            
            // 拿到实际的后台返回的key后，解析后台返回的加密的数据
            // 先拿到加密及编码的data
            NSString *userData = [arrForDic objectForKey:@"data"];
            // 再用刚刚得到的后台的key对其进行aes解密得到data的Json字符串，此过程已提前完成url解码和base64解码
            NSString *userData2 = [userData AES128DecryptWithKey:keyForSever];
        
            
            NSLog(@"userData2:%@",userData2);
            
            
            if (success) {
                
                success(userData2);
            }
        }
    } failure:^(NSError *error) {
        
        HttpRequest *alert = [[HttpRequest alloc] init];
        // 提示获取数据失败
        [alert GetHttpDefeatAlert:@"网络错误,请求失败"];
        
    }];
}


// 修改用户头像
- (void)testUploadImageWithPost:(NSDictionary *)dic andImg:(UIImage *)image Success:(void(^)(id arrForDetail))success failure:(void (^)(NSError *error))failure{
    
    // 请求地址
    NSString *path = [NSString stringWithFormat:@"%@%@",STRPATH,@"/User_modifyUserIcon"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", nil];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //    NSString *imagePath = [[NSBundle mainBundle]pathForResource:@"hehe.jpg" ofType:nil];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    //    NSData *data = [NSData dataWithContentsOfFile:image];
    
    [manager POST:path parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:imageData name:@"icon" fileName:@"test.jpg"mimeType:@"image/jpg"];
        
    }success:^(NSURLSessionDataTask *operation,id responseObject) {
        
        NSLog(@"==============%@",responseObject);
        
        
        if ([[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]] isEqualToString:@"0"]) {
            
            // 上传失败，提示信息
            HttpRequest *httpAlert = [[HttpRequest  alloc] init];
            [httpAlert GetHttpDefeatAlert:[responseObject objectForKey:@"msg"]];
            
            
            NSString *errorCode = [responseObject objectForKey:@"errorCode"];
            
            // 判断是否登录超时，并进行处理
            [self LoginOvertime:errorCode];
            
            if (success) {
                success([NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]]);
            }
            
        }else {
            
            // 上传成功
            HttpRequest *httpAlert = [[HttpRequest  alloc] init];
            [httpAlert GetHttpDefeatAlert:@"上传成功"];
            
            if (success) {
                success(responseObject);
            }
        }
        
        
    }failure:^(NSURLSessionDataTask *operation,NSError *error) {
        
        NSLog(@"#######upload error%@", error);
    }];
    
}

// 上传图片
- (void) PostImgToServerWithUserInfo:(NSDictionary *)dic andImg:(UIImage *)image1 Success:(void(^)(id arrForDetail))success failure:(void (^)(NSError *error))failure {
    
    // 请求地址
    NSString *path = [NSString stringWithFormat:@"%@%@",STRPATH,@"/System_uploadPic"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", nil];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    
    NSData *imageData = UIImagePNGRepresentation(image1);
    
    
    [manager POST:path parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:imageData name:@"img" fileName:@"test.jpg"mimeType:@"image/jpg"];
        
    }success:^(NSURLSessionDataTask *operation,id responseObject) {
        
        
        if ([[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]] isEqualToString:@"0"]) {
            
            NSString *errorCode = [responseObject objectForKey:@"errorCode"];
            NSLog(@"errorCode,%@",errorCode);
            
            // 判断是否登录超时，并进行处理
            [self LoginOvertime:errorCode];
            
            // 上传失败，提示信息
            HttpRequest *httpAlert = [[HttpRequest  alloc] init];
            [httpAlert GetHttpDefeatAlert:@"图片上传失败,请稍后再试"];
            
            if (success) {
                success([NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]]);
            }
            
        }else {
            
            // 上传成功
            
            if (success) {
                success(responseObject);
            }
        }
        
    }failure:^(NSURLSessionDataTask *operation,NSError *error) {
        
        NSLog(@"#######upload error%@", error);
    }];
}


// 上传评价
- (void) PostAddPingjiaWithDic:(NSDictionary *)userInfoDic Success:(void(^)(id arrForDetail))success failure:(void (^)(NSError *error))failure {
    
    // 请求地址
    NSString *path = [NSString stringWithFormat:@"%@%@",STRPATH,@"/Order_addComment"];

    
    [HttpRequest postWithURL:path andDic:userInfoDic success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic valueForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        NSString *errorCode = [dic valueForKey:@"errorCode"];
        
        if (statusInt == 0) {
            
            NSString *msg = [dic valueForKey:@"msg"];
            NSLog(@"msg:%@",msg);
            
            // 判断是否登录超时，并进行处理
            [self LoginOvertime:errorCode];
            
            //
            HttpRequest *alert = [[HttpRequest alloc] init];
            // 提示上传评价失败
            [alert GetHttpDefeatAlert:msg];
            
            
            if (success) {
                
                
            }
            
        }else {
            
            NSString *msg = [dic valueForKey:@"msg"];
            NSLog(@"msg:%@",msg);
            
            
//            HttpRequest *alert = [[HttpRequest alloc] init];
            // 提示上传评价成功
//            [alert GetHttpDefeatAlert:msg];
            
            if (success) {
                
                success(@"1");
            }
        }
    } failure:^(NSError *error) {
        
        HttpRequest *alert = [[HttpRequest alloc] init];
        // 提示获取数据失败
        [alert GetHttpDefeatAlert:@"网络错误,请求失败"];
        
    }];

}


// 修改用户头像
//- (void) PostReviseUserIconWithDic:(NSDictionary *)userInfoData Success:(void(^)(id userInfo))success failure:(void (^)(NSError *error))failure {
//    
//    // 请求地址
//    NSString *path = @"";
//    
//    [HttpRequest postWithURL:path andDic:userInfoData success:^(id responseObj) {
//        
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
//        
//        NSString *status = [dic valueForKey:@"status"];
//        NSInteger statusInt = [status integerValue];
//        
//        if (statusInt == 0) {
//            
//            NSString *errorCode = [dic valueForKey:@"errorCode"];
//            NSLog(@"errorcode:%@",errorCode);
//            
//            
//            // 判断是否登录超时，并进行处理
//            [self LoginOvertime:errorCode];
//            
//            //
//            HttpRequest *alert = [[HttpRequest alloc] init];
//            // 提示修改失败
//            [alert GetHttpDefeatAlert:@"修改头像失败"];
//            
//            
//            if (success) {
//                
//                success([NSString stringWithFormat:@"%ld",statusInt]);
//            }
//            
//        }else {
//            
//            HttpRequest *alert = [[HttpRequest alloc] init];
//            // 提示修改失败
//            [alert GetHttpDefeatAlert:@"修改头像成功"];
//            
//            NSString *dataString = [dic valueForKey:@"data"];
//            
//            if (success) {
//                
//                success(dataString);
//            }
//        }
//    } failure:^(NSError *error) {
//        
//        HttpRequest *alert = [[HttpRequest alloc] init];
//        // 提示获取数据失败
//        [alert GetHttpDefeatAlert:@"网络错误,请求失败"];
//        
//    }];
//}

// 修改用户资料
- (void) PostReviseUserInfoWithDic:(NSDictionary *)userInfoData Success:(void(^)(id userInfo))success failure:(void (^)(NSError *error))failure {
    
    // 请求地址
    NSString *path = [NSString stringWithFormat:@"%@%@",STRPATH,@"/User_modifyUserInfo"];
    
    [HttpRequest postWithURL:path andDic:userInfoData success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic valueForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            NSString *errorCode = [dic valueForKey:@"errorCode"];
            NSLog(@"errorcode:%@",errorCode);
            NSString *msg = [dic valueForKey:@"msg"];
            
            // 判断是否登录超时，并进行处理
            [self LoginOvertime:errorCode];
            
            //
            HttpRequest *alert = [[HttpRequest alloc] init];
            // 提示获取失败
            [alert GetHttpDefeatAlert:msg];
            
            
            if (success) {
                
                success([NSString stringWithFormat:@"%ld",statusInt]);
            }
            
        }else {
            
            NSDictionary *arrForDic = [dic valueForKey:@"data"];
            
            NSLog(@"arrForDic:%@",arrForDic);
            
            // 拿到服务器给的key（里面有用我自己公钥加密后的后台的aes的key）
            NSString *strSeverKey = [arrForDic objectForKey:@"key"];
            
            
            // 再用本地保留的私钥进行rsa解密获取服务器的key，此过程已提前完成url解码和base64解码
            NSString *private_key_path = [[NSBundle mainBundle] pathForResource:@"private_key.p12" ofType:nil];
            NSString *keyForSever = [RSAEncryptor decryptString:strSeverKey privateKeyWithContentsOfFile:private_key_path password:@"123456easylink"];
            
            // 拿到实际的后台返回的key后，解析后台返回的加密的数据
            // 先拿到加密及编码的data
            NSString *userData = [arrForDic objectForKey:@"data"];
            // 再用刚刚得到的后台的key对其进行aes解密得到data的Json字符串，此过程已提前完成url解码和base64解码
            NSString *userData2 = [userData AES128DecryptWithKey:keyForSever];
            
            
            NSLog(@"userData2:%@",userData2);
            
            
            if (success) {
                
                success(userData2);
            }
        }
    } failure:^(NSError *error) {
        
        HttpRequest *alert = [[HttpRequest alloc] init];
        // 提示获取数据失败
        [alert GetHttpDefeatAlert:@"网络错误,请求失败"];
        
    }];
}


// 添加浏览历史
- (void) PostAddHisWithDic:(NSDictionary *)userInfoData Success:(void(^)(id userInfo))success failure:(void (^)(NSError *error))failure {
    
    // 请求地址
    NSString *path = [NSString stringWithFormat:@"%@%@",STRPATH,@"/User_addHistory"];
    
    [HttpRequest postWithURL:path andDic:userInfoData success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic valueForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            NSString *errorCode = [dic valueForKey:@"errorCode"];
            
            // 判断是否登录超时，并进行处理
            [self LoginOvertime:errorCode];
            
            NSString *str = [[NSString alloc]init];
            
            if (success) {
                
                success(str);
            }
            
        }else {
            
            NSString *status = [dic valueForKey:@"msg"];
            NSLog(@"msg,%@",status);
            
            if (success) {
                
                success(status);
            }
        }
    } failure:^(NSError *error) {
    
        // 网络请求失败
    }];

}


// 添加收藏
- (void) PostAddFavWithDic:(NSDictionary *)userInfoData Success:(void(^)(id userInfo))success failure:(void (^)(NSError *error))failure {

    // 请求地址
    NSString *path = [NSString stringWithFormat:@"%@%@",STRPATH,@"/User_addCollection"];

    
    [HttpRequest postWithURL:path andDic:userInfoData success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic valueForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            NSString *errorCode = [dic valueForKey:@"errorCode"];
            
            
            // 判断是否登录超时，并进行处理
            [self LoginOvertime:errorCode];
            
            
            HttpRequest *httpAlert = [[HttpRequest alloc] init];
            [httpAlert GetHttpDefeatAlert:@"关注失败"];
            
            NSString *str = [[NSString alloc]init];
            
            if (success) {
                
                success(str);
            }
            
        }else {
            
            HttpRequest *httpAlert = [[HttpRequest alloc] init];
            [httpAlert GetHttpDefeatAlert:@"关注成功"];
            
            NSString *status = [dic valueForKey:@"msg"];
            NSLog(@"msg,%@",status);
            
            if (success) {
                
                success(status);
            }
        }
    } failure:^(NSError *error) {
        
        HttpRequest *alert = [[HttpRequest alloc] init];
        // 提示获取数据失败
        [alert GetHttpDefeatAlert:@"网络错误,请求失败"];
        
    }];
}

// 删除历史浏览
- (void) PostDelHisWithDic:(NSDictionary *)userInfoData Success:(void(^)(id userInfo))success failure:(void (^)(NSError *error))failure {
    
    // 请求地址
    NSString *path = [NSString stringWithFormat:@"%@%@",STRPATH,@"/User_delHistory"];
    
    [HttpRequest postWithURL:path andDic:userInfoData success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic valueForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            NSString *errorCode = [dic valueForKey:@"errorCode"];
            
            // 判断是否登录超时，并进行处理
            [self LoginOvertime:errorCode];
            
            NSString *str = [[NSString alloc]init];
            
            if (success) {
                
                success(str);
            }
            
        }else {
            
            NSString *status = [dic valueForKey:@"msg"];
            
            if (success) {
                
                success(status);
            }
        }
    } failure:^(NSError *error) {
        
        HttpRequest *alert = [[HttpRequest alloc] init];
        // 提示获取数据失败
        [alert GetHttpDefeatAlert:@"网络错误,请求失败"];
        
    }];

}

// 删除收藏
- (void) PostDelFavWithDic:(NSDictionary *)userInfoData Success:(void(^)(id userInfo))success failure:(void (^)(NSError *error))failure {

    // 请求地址
    NSString *path = [NSString stringWithFormat:@"%@%@",STRPATH,@"/User_delCollection"];
    
    [HttpRequest postWithURL:path andDic:userInfoData success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic valueForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            NSString *errorCode = [dic valueForKey:@"errorCode"];
            
            // 提示失败
            HttpRequest *httpAlert = [[HttpRequest alloc] init];
            [httpAlert GetHttpDefeatAlert:@"取消关注失败"];
            
            // 判断是否登录超时，并进行处理
            [self LoginOvertime:errorCode];
            
            NSString *str = [[NSString alloc]init];
            
            if (success) {
                
                success(str);
            }
            
        }else {
            
            NSString *status = [dic valueForKey:@"msg"];
            
            if (success) {
                
                success(status);
            }
        }
    } failure:^(NSError *error) {
        
        HttpRequest *alert = [[HttpRequest alloc] init];
        // 提示获取数据失败
        [alert GetHttpDefeatAlert:@"网络错误,请求失败"];
        
    }];
}

// 获取用户浏览历史
- (void) PostUserHisWithDic:(NSDictionary *)userInfoData Success:(void (^)(id GetData))success failure:(void (^)(NSError *error))failure {
    
    // 请求地址
    NSString *path = [NSString stringWithFormat:@"%@%@",STRPATH,@"/User_getHistoryList"];
    
    [HttpRequest postWithURL:path andDic:userInfoData success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic valueForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            NSString *errorCode = [dic valueForKey:@"errorCode"];
            NSLog(@"errorCode%@",errorCode);
            
            if ([errorCode isEqualToString:@"1001"]) {
                
                HttpRequest *alert = [[HttpRequest alloc] init];
                // 提示获取失败
                [alert GetHttpDefeatAlert:@"已没有更多数据(>-<)~~"];
                
            }else {
                
                HttpRequest *alert = [[HttpRequest alloc] init];
                // 提示获取失败
                [alert GetHttpDefeatAlert:@"获取数据失败,请重试"];
            }
            
            // 判断是否登录超时，并进行处理
            [self LoginOvertime:errorCode];
            
        
            
            
            if (success) {
                
                success([NSString stringWithFormat:@"%ld",statusInt]);
            }
            
        }else {
            
            NSArray *arrForData = [dic valueForKey:@"data"];
            NSLog(@"=========arrForData%@",arrForData);
            
            NSMutableArray *arrForPintuan = [HomeDataModel arrayOfModelsFromDictionaries:arrForData error:nil];
            
            if (success) {
                
                success(arrForPintuan);
            }
        }
    } failure:^(NSError *error) {
        
        HttpRequest *alert = [[HttpRequest alloc] init];
        // 提示获取数据失败
        [alert GetHttpDefeatAlert:@"网络错误,请求失败"];
        
    }];
}

// 获取用户所有收藏
- (void) PostUserAllFavDic:(NSDictionary *)userInfoData Success:(void (^)(id GetData))success failure:(void (^)(NSError *error))failure {
    
    // 请求地址
    NSString *path = [NSString stringWithFormat:@"%@%@",STRPATH,@"/User_getAllCollectionList"];
    
    [HttpRequest postWithURL:path andDic:userInfoData success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic valueForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            NSString *errorCode = [dic valueForKey:@"errorCode"];
            
            NSLog(@"errorCode%@",errorCode);
            
            
            // 判断是否登录超时，并进行处理
            [self LoginOvertime:errorCode];
            
            NSString *str = [[NSString alloc]init];
            
            if (success) {
                
                success(str);
            }
            
        }else {
            
            NSArray *dataArr = [dic valueForKey:@"data"];
            
            NSLog(@"dataArr%@",dataArr);
            
            if (success) {
                
                success(dataArr);
            }
        }
    } failure:^(NSError *error) {
        
        HttpRequest *alert = [[HttpRequest alloc] init];
        // 提示获取数据失败
        [alert GetHttpDefeatAlert:@"网络错误,请求失败"];
        
    }];
}

// 获取用户页面收藏列表
- (void) PostUserFavListDic:(NSDictionary *)userInfoData Success:(void (^)(id GetData))success failure:(void (^)(NSError *error))failure {
    
    // 请求地址
    NSString *path = [NSString stringWithFormat:@"%@%@",STRPATH,@"/User_getCollectionList"];
    
    
    [HttpRequest postWithURL:path andDic:userInfoData success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic valueForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            NSString *errorCode = [dic valueForKey:@"errorCode"];
            NSLog(@"errorCode%@",errorCode);
            
            // 判断是否登录超时，并进行处理
            [self LoginOvertime:errorCode];
            
            
            if ([errorCode isEqualToString:@"1001"]) {
                
                HttpRequest *alert = [[HttpRequest alloc] init];
                // 提示获取失败
                [alert GetHttpDefeatAlert:@"已没有更多数据(>-<)~~"];
                
            }else {
                
                HttpRequest *alert = [[HttpRequest alloc] init];
                // 提示获取失败
                [alert GetHttpDefeatAlert:@"获取数据失败,请重试"];
            }
            
            if (success) {
                
                success([NSString stringWithFormat:@"%ld",statusInt]);
            }
            
        }else {
            
            NSArray *arrForData = [dic valueForKey:@"data"];
            NSLog(@"=========arrForData%@",arrForData);
            
            
            NSMutableArray *arrForPintuan = [HomeDataModel arrayOfModelsFromDictionaries:arrForData error:nil];
            
            if (success) {
                
                success(arrForPintuan);
            }
        }
    } failure:^(NSError *error) {
        
        HttpRequest *alert = [[HttpRequest alloc] init];
        // 提示获取数据失败
        [alert GetHttpDefeatAlert:@"网络错误,请求失败"];
        
    }];
}

// 获取商品分类
- (void) GetGoodsCategorySuccess:(void (^)(id arrForList))success failure:(void (^)(NSError *error))failure {
    
    // 请求地址
    NSString *str = [NSString stringWithFormat:@"%@%@",STRPATH,@"/Goods_getCategoryList"];
    
    // 请求数据
    [HttpRequest postWithURL:str andDic:nil success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic objectForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            
            HttpRequest *alert = [[HttpRequest alloc] init];
            // 提示获取失败
            [alert GetHttpDefeatAlert:@"获取分类数据失败,请重试"];
            
            
            if (success) {
                
                success([NSString stringWithFormat:@"%ld",statusInt]);
            }
            
            
        }else {
            
            NSArray *arrForData = [dic valueForKey:@"data"];
            
            NSLog(@"arrForData:%@",arrForData);
            
//            NSMutableArray *arrForCategoryList = [CategoryListModel arrayOfModelsFromDictionaries:arrForData error:nil];
            
            if (success) {
                
                success(arrForData);
            }
        }
        
    } failure:^(NSError *error) {
        
        HttpRequest *alert = [[HttpRequest alloc] init];
        // 提示获取数据失败
        [alert GetHttpDefeatAlert:@"网络错误,请求失败"];
        
    }];
}

// 获取首页拼团数据
- (void) GetHomeDataForCategory:(NSInteger)category andKeyWord:(NSString *)keyWord andOrderKey:(NSInteger)orderKey andOrderBy:(NSInteger)orderby andPageStart:(NSInteger)pageStart andPageSize:(NSInteger)pageSize Success:(void (^)(id arrForList))success failure:(void (^)(NSError *error))failure {
    
    // 请求地址
    NSString *str = [NSString stringWithFormat:@"/GroupBuy_getList?category=%ld&keyword=%@&orderKey=%ld&orderby=%ld&pageStart=%ld&pageSize=%ld",category,[NSString stringWithFormat:@"%@",keyWord],orderKey,orderby,pageStart,pageSize];
    
    // 请求地址
    NSString *path = [NSString stringWithFormat:@"%@%@",STRPATH,str];
    
    // 请求数据
    [HttpRequest postWithURL:path andDic:nil success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic objectForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            NSString *errorCode = [dic objectForKey:@"errorCode"];
            if ([errorCode isEqualToString:@"1001"]) {
                
                HttpRequest *alert = [[HttpRequest alloc] init];
                // 提示获取失败
                [alert GetHttpDefeatAlert:@"已没有更多数据(>-<)~~"];
            }else {
                
                HttpRequest *alert = [[HttpRequest alloc] init];
                // 提示获取失败
                [alert GetHttpDefeatAlert:@"获取数据失败,请重试"];
            }
            
            
            if (success) {
                
                success([NSString stringWithFormat:@"%ld",statusInt]);
            }
            
        }else {
            
            NSArray *arrForData = [dic valueForKey:@"data"];

            
            NSMutableArray *arrForPintuan = [HomeDataModel arrayOfModelsFromDictionaries:arrForData error:nil];
            
            if (success) {
                
                success(arrForPintuan);
            }
        }
        
    } failure:^(NSError *error) {
        
        HttpRequest *alert = [[HttpRequest alloc] init];
        // 提示获取数据失败
        [alert GetHttpDefeatAlert:@"网络错误,请求失败"];
        
    }];
}


// 获取快递是否可以配送
- (void) GetGoodsCanDistributionWithId:(NSInteger) id1 andRegionId:(NSInteger) regionId Success:(void (^)(id arrForGoodsData))success failure:(void (^)(NSError *error))failure {
    
    // 请求地址
    NSString *str = [NSString stringWithFormat:@"/GroupBuy_checkIfCanShip?id=%ld&regionId=%ld",id1,regionId];
    
    // 请求地址
    NSString *path = [NSString stringWithFormat:@"%@%@",STRPATH,str];
    
    // 请求数据
    [HttpRequest postWithURL:path andDic:nil success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic objectForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            NSString *errorCode = [dic objectForKey:@"errorCode"];
            NSLog(@"errorCode%@",errorCode);
            
            
            if (success) {
                
                success([NSString stringWithFormat:@"%ld",statusInt]);
            }
            
        }else {
            
            NSArray *arrForData = [dic valueForKey:@"data"];
            
            if (success) {
                
                success(arrForData);
            }
        }
        
    } failure:^(NSError *error) {
        
        // 提示获取数据失败
    }];
    
}

// 获取快递价格
- (void) PostGetfastMailWithDataDic:(NSDictionary *)dic Success:(void (^)(id arrForGoodsData))success failure:(void (^)(NSError *error))failure {
    
    // 请求地址
    NSString *path = [NSString stringWithFormat:@"%@%@",STRPATH,@"/GroupBuy_calcuShipMoney"];
    
    // 请求数据
    [HttpRequest postWithURL:path andDic:dic success:^(id responseObj) {
        
        NSLog(@"responseObj,%@",[NSString stringWithFormat:@"%@",responseObj]);
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        
        NSLog(@"dic,%@",dic);
        
        NSString *status = [dic objectForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            NSString *errorCode = [dic objectForKey:@"errorCode"];
            NSLog(@"errorCode%@",errorCode);
            
            // 判断是否登录超时，并进行处理
            [self LoginOvertime:errorCode];
            
            
            if (success) {
                
                success([NSString stringWithFormat:@"%ld",statusInt]);
            }
            
        }else {
            
            NSArray *arrForData = [dic valueForKey:@"data"];
            
            if (success) {
                
                success(arrForData);
            }
        }
        
    } failure:^(NSError *error) {
        
        // 提示获取数据失败
        NSLog(@"访问错误");
        NSLog(@"%@",error);
//        NSLog(@"**********************error ==%@", [error userInfo][@"com.alamofire.serialization.response.error.string"]);
    }];

}


// 计算商品总价格
- (void) PostGetGoodsFinalPriceWithDataDic:(NSDictionary *)dicData Success:(void (^)(id arrForGoodsData))success failure:(void (^)(NSError *error))failure {
    
    // 请求地址
    NSString *path = [NSString stringWithFormat:@"%@%@",STRPATH,@"/Order_calcuOrderMoney"];
    
    // 请求数据
    [HttpRequest postWithURL:path andDic:dicData success:^(id responseObj) {
        
        
//        NSLog(@"responseObj,%@",[NSString stringWithFormat:@"%@",responseObj]);
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"dic,%@",dic);
        
        NSString *status = [dic objectForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            NSString *errorCode = [dic objectForKey:@"errorCode"];
            NSLog(@"errorCode%@",errorCode);
            NSString *msg = [dic objectForKey:@"msg"];
            NSLog(@"msg%@",msg);
            
            // 判断是否登录超时，并进行处理
            [self LoginOvertime:errorCode];
            
            if (success) {
                
                success([NSString stringWithFormat:@"%ld",statusInt]);
            }
            
        }else {
            
            NSArray *arrForData = [dic valueForKey:@"data"];
            
            if (success) {
                
                success(arrForData);
            }
        }
        
    } failure:^(NSError *error) {
        
        // 提示获取数据失败
        NSLog(@"访问错误");
        NSLog(@"%@",error);
//        NSLog(@"**********************error ==%@", [error userInfo][@"com.alamofire.serialization.response.error.string"]);
    }];
}


// 获取评价数据
- (void) GetPingjiaDataFromId:(NSInteger)groupBuyId andpageStart:(NSInteger) pageStart Success:(void (^)(id arrForpingjiaList))success failure:(void (^)(NSError *error))failure {
    
    // 请求地址
    NSString *str = [NSString stringWithFormat:@"/Goods_getComment?id=%ld&pageStart=%ld&pageSize=10",groupBuyId,pageStart];
    
    // 请求地址
    NSString *path = [NSString stringWithFormat:@"%@%@",STRPATH,str];
    
    // 请求数据
    [HttpRequest postWithURL:path andDic:nil success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic objectForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            NSString *errorCode = [dic objectForKey:@"errorCode"];
            NSLog(@"errorCode%@",errorCode);
            if ([errorCode isEqualToString:@"1001"]) {
                
                HttpRequest *alert = [[HttpRequest alloc] init];
                // 提示获取失败
                [alert GetHttpDefeatAlert:@"已没有更多数据(>-<)~~"];
                
            }else {
                
                HttpRequest *alert = [[HttpRequest alloc] init];
                // 提示获取失败
                [alert GetHttpDefeatAlert:@"获取评价数据失败,请重试"];
            }
            
            if (success) {
                
                success([NSString stringWithFormat:@"%ld",statusInt]);
            }
            
        }else {
            
            NSArray *arrForData = [dic valueForKey:@"data"];
            
            NSMutableArray *arrForpingjia = [PingJiaModel arrayOfModelsFromDictionaries:arrForData error:nil];
            
            if (success) {
                
                success(arrForpingjia);
            }
        }
        
    } failure:^(NSError *error) {
        
        HttpRequest *alert = [[HttpRequest alloc] init];
        // 提示获取数据失败
        [alert GetHttpDefeatAlert:@"网络错误,请求失败"];
        
    }];
}


// 添加用户地址
- (void) PostAddUserAddressWithDataDic:(NSDictionary *)dicData Success:(void (^)(id messageData))success failure:(void (^)(NSError *error))failure {
    
    // 请求地址
    NSString *path = [NSString stringWithFormat:@"%@%@",STRPATH,@"/User_addAddress"];
    
    // 请求数据
    [HttpRequest postWithURL:path andDic:dicData success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic objectForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            NSString *errorCode = [dic objectForKey:@"errorCode"];
            NSLog(@"errorCode%@",errorCode);
            NSString *msg = [dic objectForKey:@"msg"];
            NSLog(@"msg%@",msg);
            
            // 判断是否登录超时，并进行处理
            [self LoginOvertime:errorCode];
            
            // 提示添加地址失败
            HttpRequest *httpAlert = [[HttpRequest alloc] init];
            [httpAlert GetHttpDefeatAlert:@"添加地址失败,请重试"];
            
            if (success) {
                
//                success([NSString stringWithFormat:@"%ld",statusInt]);
            }
            
        }else {
            
            HttpRequest *httpAlert = [[HttpRequest alloc] init];
            [httpAlert GetHttpDefeatAlert:@"添加收货地址成功"];
            
            NSString *str = @"1";
            
            if (success) {
                
                success(str);
            }
        }
        
    } failure:^(NSError *error) {
        
        HttpRequest *alert = [[HttpRequest alloc] init];
        // 提示获取数据失败
        [alert GetHttpDefeatAlert:@"网络错误,请求失败"];
        
    }];
}



// 修改用户收货地址
- (void) PostXiugaiAddressWithDataDic:(NSDictionary *)dicData Success:(void (^)(id messageData))success failure:(void (^)(NSError *error))failure {
    
    
    // 请求地址
    NSString *path = [NSString stringWithFormat:@"%@%@",STRPATH,@"/User_editAddress"];
    
    // 请求数据
    [HttpRequest postWithURL:path andDic:dicData success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic objectForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            NSString *errorCode = [dic objectForKey:@"errorCode"];
            NSLog(@"errorCode%@",errorCode);
            NSString *msg = [dic objectForKey:@"msg"];
            NSLog(@"msg%@",msg);
            
            // 判断是否登录超时，并进行处理
            [self LoginOvertime:errorCode];
            
            // 提示添加地址失败
            HttpRequest *httpAlert = [[HttpRequest alloc] init];
            [httpAlert GetHttpDefeatAlert:@"修改地址失败,请重试"];
            
            if (success) {
                
                //                success([NSString stringWithFormat:@"%ld",statusInt]);
            }
            
        }else {
            
            HttpRequest *httpAlert = [[HttpRequest alloc] init];
            [httpAlert GetHttpDefeatAlert:@"修改收货地址成功"];
            
            NSString *str = @"1";
            
            if (success) {
                
                success(str);
            }
        }
        
    } failure:^(NSError *error) {
        
        HttpRequest *alert = [[HttpRequest alloc] init];
        // 提示获取数据失败
        [alert GetHttpDefeatAlert:@"网络错误,请求失败"];
        
    }];
}

// 删除用户收货地址
- (void) PostDeleteAddressWithDicData:(NSDictionary *)dicData Success:(void (^)(id messageData))success failure:(void (^)(NSError *error))failure {
    
    // 请求地址
    NSString *path = [NSString stringWithFormat:@"%@%@",STRPATH,@"/User_delAddress"];
    
    // 请求数据
    [HttpRequest postWithURL:path andDic:dicData success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic objectForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            NSString *errorCode = [dic objectForKey:@"errorCode"];
            NSLog(@"errorCode%@",errorCode);
            NSString *msg = [dic objectForKey:@"msg"];
            NSLog(@"msg%@",msg);
            
            // 判断是否登录超时，并进行处理
            [self LoginOvertime:errorCode];
            
            // 提示添加地址失败
            HttpRequest *httpAlert = [[HttpRequest alloc] init];
            [httpAlert GetHttpDefeatAlert:@"删除地址失败,请重试"];
            
            if (success) {
                
                //                success([NSString stringWithFormat:@"%ld",statusInt]);
            }
            
        }else {
            
            HttpRequest *httpAlert = [[HttpRequest alloc] init];
            [httpAlert GetHttpDefeatAlert:@"删除收货地址成功"];
            
            NSString *str = @"1";
            
            if (success) {
                
                success(str);
            }
        }
        
    } failure:^(NSError *error) {
        
        HttpRequest *alert = [[HttpRequest alloc] init];
        // 提示获取数据失败
        [alert GetHttpDefeatAlert:@"网络错误,请求失败"];
        
    }];
}

// 获取用户全部收货地址
- (void) PostGetUserAllAddressWithDicData:(NSDictionary *)dicData Success:(void (^)(id messageData))success failure:(void (^)(NSError *error))failure {
    
    // 请求地址
    NSString *path = [NSString stringWithFormat:@"%@%@",STRPATH,@"/User_getAddressList"];
    
    // 请求数据
    [HttpRequest postWithURL:path andDic:dicData success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic objectForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            NSString *errorCode = [dic objectForKey:@"errorCode"];
            NSLog(@"errorCode%@",errorCode);
            NSString *msg = [dic objectForKey:@"msg"];
            NSLog(@"msg%@",msg);
            
            if ([errorCode isEqualToString:@"1001"]) {
                
                // 提示添加地址失败
                HttpRequest *httpAlert = [[HttpRequest alloc] init];
                [httpAlert GetHttpDefeatAlert:@"没有数据,请先添加收货地址"];
            }else {
                
                // 提示获取地址失败
                HttpRequest *httpAlert = [[HttpRequest alloc] init];
                [httpAlert GetHttpDefeatAlert:@"获取收货地址失败,请重试"];
            }
            
            // 判断是否登录超时，并进行处理
            [self LoginOvertime:errorCode];
            
            
            if (success) {
                
                //                success([NSString stringWithFormat:@"%ld",statusInt]);
            }
            
        }else {
            
            NSArray *arrForData = [dic objectForKey:@"data"];
            
            NSMutableArray *arrForUserAddress = [UserAddressModel arrayOfModelsFromDictionaries:arrForData error:nil];
            
            if (success) {
                
                success(arrForUserAddress);
            }
        }
        
    } failure:^(NSError *error) {
        
        HttpRequest *alert = [[HttpRequest alloc] init];
        // 提示获取数据失败
        [alert GetHttpDefeatAlert:@"网络错误,请求失败"];
        
    }];
}


// 获取banner
- (void) GetBannerListWithPosition:(NSInteger) position Success:(void (^)(id bannerList))success failure:(void (^)(NSError *error))failure {
    
    
    NSString *str = [NSString stringWithFormat:@"/System_getBannerList?position=%ld",position];
    
    // 请求地址
    NSString *path = [NSString stringWithFormat:@"%@%@",STRPATH,str];
    
    // 请求数据
    [HttpRequest postWithURL:path andDic:nil success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic objectForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            NSString *errorCode = [dic objectForKey:@"errorCode"];
            NSLog(@"errorCode%@",errorCode);
            NSString *msg = [dic objectForKey:@"msg"];
            NSLog(@"msg%@",msg);
            
            // 提示添加地址失败
            HttpRequest *httpAlert = [[HttpRequest alloc] init];
            [httpAlert GetHttpDefeatAlert:@"获取滚动图失败,请重试"];
            
            if (success) {
                
                
            }
            
        }else {
            
            NSArray *helpListArr = [dic objectForKey:@"data"];
            
            if (success) {
                
                success(helpListArr);
            }
        }
        
    } failure:^(NSError *error) {
        
        HttpRequest *alert = [[HttpRequest alloc] init];
        // 提示获取数据失败
        [alert GetHttpDefeatAlert:@"网络错误,请求失败"];
        
    }];
}


// 获取帮助列表
- (void) GetHelpListSuccess:(void (^)(id helpList))success failure:(void (^)(NSError *error))failure {
    
    // 请求地址
    NSString *path = [NSString stringWithFormat:@"%@%@",STRPATH,@"/System_getAppHelpList"];
    
    
    // 请求数据
    [HttpRequest postWithURL:path andDic:nil success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic objectForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            NSString *errorCode = [dic objectForKey:@"errorCode"];
            NSLog(@"errorCode%@",errorCode);
            NSString *msg = [dic objectForKey:@"msg"];
            NSLog(@"msg%@",msg);
            
            // 提示添加地址失败
            HttpRequest *httpAlert = [[HttpRequest alloc] init];
            [httpAlert GetHttpDefeatAlert:@"添加banner失败,请重试"];
            
            if (success) {
                
                //                success([NSString stringWithFormat:@"%ld",statusInt]);
            }
            
        }else {
            
            NSArray *bannerListArr = [dic objectForKey:@"data"];
            
            if (success) {
                
                success(bannerListArr);
            }
        }
        
    } failure:^(NSError *error) {
        
        HttpRequest *alert = [[HttpRequest alloc] init];
        // 提示获取数据失败
        [alert GetHttpDefeatAlert:@"网络错误,请求失败"];
        
    }];
}



// 获取帮助详情
- (void) GetHelpListDetailWithId:(NSString *) strId Success:(void (^)(id helpDetailDic))success failure:(void (^)(NSError *error))failure {
    
    NSString *str = [NSString stringWithFormat:@"/System_getAppHelpDetail?id=%@",strId];
    
    // 请求地址
    NSString *path = [NSString stringWithFormat:@"%@%@",STRPATH,str];
    
    
    // 请求数据
    [HttpRequest postWithURL:path andDic:nil success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic objectForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            NSString *errorCode = [dic objectForKey:@"errorCode"];
            NSLog(@"errorCode%@",errorCode);
            NSString *msg = [dic objectForKey:@"msg"];
            NSLog(@"msg%@",msg);
            
            // 提示添加地址失败
            HttpRequest *httpAlert = [[HttpRequest alloc] init];
            [httpAlert GetHttpDefeatAlert:@"获取帮助详情失败,请重试"];
            
            if (success) {
                
                //                success([NSString stringWithFormat:@"%ld",statusInt]);
            }
            
        }else {
            
            NSDictionary *helpDetail = [dic objectForKey:@"data"];
            
            if (success) {
                
                success(helpDetail);
            }
        }
        
    } failure:^(NSError *error) {
        
        HttpRequest *alert = [[HttpRequest alloc] init];
        // 提示获取数据失败
        [alert GetHttpDefeatAlert:@"网络错误,请求失败"];
        
    }];
}


// 获取推荐数据列表
- (void) PostGetRecommendedListWithDic:(NSDictionary *)dic Success:(void (^)(id RecommendedListDic))success failure:(void (^)(NSError *error))failure {
    
    // 请求地址
    NSString *path = [NSString stringWithFormat:@"%@%@",STRPATH,@"/GroupBuy_getRecommendedList"];
    
    // 请求数据
    [HttpRequest postWithURL:path andDic:dic success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic objectForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            NSString *errorCode = [dic objectForKey:@"errorCode"];
            if ([errorCode isEqualToString:@"1001"]) {
                
                HttpRequest *alert = [[HttpRequest alloc] init];
                // 提示获取失败
                [alert GetHttpDefeatAlert:@"已没有更多数据(>-<)~~"];
            }else {
                
                HttpRequest *alert = [[HttpRequest alloc] init];
                // 提示获取失败
                [alert GetHttpDefeatAlert:@"获取数据失败,请重试"];
            }
            
            
            if (success) {
                
                success([NSString stringWithFormat:@"%ld",statusInt]);
            }
            
        }else {
            
            NSArray *arrForData = [dic valueForKey:@"data"];
            
            
            NSMutableArray *arrForPintuan = [HomeDataModel arrayOfModelsFromDictionaries:arrForData error:nil];
            
            if (success) {
                
                success(arrForPintuan);
            }
        }
        
    } failure:^(NSError *error) {
        
        HttpRequest *alert = [[HttpRequest alloc] init];
        // 提示获取数据失败
        [alert GetHttpDefeatAlert:@"网络错误,请求失败"];
        
    }];
    
    
}


// 获取推荐评价数据
- (void) GetTuijianPingjiaDataFromId:(NSInteger)groupBuyId Success:(void (^)(id arrForpingjiaList))success failure:(void (^)(NSError *error))failure {
    
    // 请求地址
    NSString *str = [NSString stringWithFormat:@"/Goods_getRecommendedComment?id=%ld",groupBuyId];
    
    // 请求地址
    NSString *path = [NSString stringWithFormat:@"%@%@",STRPATH,str];
    
    // 请求数据
    [HttpRequest postWithURL:path andDic:nil success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic objectForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            NSString *errorCode = [dic objectForKey:@"errorCode"];
            if ([errorCode isEqualToString:@"1001"]) {
                
                HttpRequest *alert = [[HttpRequest alloc] init];
                // 提示获取失败
                [alert GetHttpDefeatAlert:@"已没有更多数据(>-<)~~"];
            }else {
                
                HttpRequest *alert = [[HttpRequest alloc] init];
                // 提示获取失败
                [alert GetHttpDefeatAlert:@"获取评价数据失败,请重试"];
            }
            
            if (success) {
                
                success([NSString stringWithFormat:@"%ld",statusInt]);
            }
            
        }else {
            
            NSDictionary *arrForDic = [dic valueForKey:@"data"];
            
            
            if (success) {
                
                success(arrForDic);
            }
        }
        
    } failure:^(NSError *error) {
        
        HttpRequest *alert = [[HttpRequest alloc] init];
        // 提示获取数据失败
        [alert GetHttpDefeatAlert:@"网络错误,请求失败"];
        
    }];
}


// 获取团购详情数据
- (void) GetGoodsDetailDataForId:(NSString *) goodsId Success:(void (^)(id arrForGoodsData))success failure:(void (^)(NSError *error))failure {
    
    // 请求地址
    NSString *str = [NSString stringWithFormat:@"/GroupBuy_getDetail?id=%ld",[goodsId integerValue]];
    
    // 请求地址
    NSString *path = [NSString stringWithFormat:@"%@%@",STRPATH,str];
    
    // 请求数据
    [HttpRequest postWithURL:path andDic:nil success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic objectForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            NSString *errorCode = [dic valueForKey:@"errorCode"];
            NSLog(@"errorCode%@",errorCode);
            
            
            HttpRequest *alert = [[HttpRequest alloc] init];
            // 提示获取失败
            [alert GetHttpDefeatAlert:@"获取详情数据失败"];
            
            if (success) {
                
//                success([NSString stringWithFormat:@"%ld",statusInt]);
            }
            
        }else {
            
            NSDictionary *arrForDic = [dic valueForKey:@"data"];
            
            if (success) {
                
                success(arrForDic);
            }
        }
        
    } failure:^(NSError *error) {
        
        HttpRequest *alert = [[HttpRequest alloc] init];
        // 提示获取数据失败
        [alert GetHttpDefeatAlert:@"网络错误,请求失败"];
        
    }];
}


// 获取团购详情下面的HTML数据
- (void) GetGoodsDetatilHtmlDataForId:(NSString *)id1 Success:(void (^)(id goodsHtmlData))success failure:(void (^)(NSError *error))failure {
    
    
    NSString *str = [NSString stringWithFormat:@"/GroupBuy_getDetailContent?id=%@", id1];
    
    // 请求地址
    NSString *path = [NSString stringWithFormat:@"%@%@",STRPATH,str];
    
    // 请求数据
    [HttpRequest postWithURL:path andDic:nil success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic objectForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            NSString *errorCode = [dic valueForKey:@"errorCode"];
            NSLog(@"errorCode%@",errorCode);
            
            
            HttpRequest *alert = [[HttpRequest alloc] init];
            // 提示获取失败
            [alert GetHttpDefeatAlert:@"获取详情数据失败"];
            
            if (success) {
                
                // 不做处理
            }
            
        }else {
            
            // 需要填充的Html参数
            NSString *dataStr = [dic valueForKey:@"data"];
            
            if (success) {
                
                success(dataStr);
            }
        }
        
    } failure:^(NSError *error) {
        
        HttpRequest *alert = [[HttpRequest alloc] init];
        // 提示获取数据失败
        [alert GetHttpDefeatAlert:@"网络错误,请求失败"];
        
    }];
}


// 生成订单
- (void) PostMakeOderWithDicData:(NSDictionary *)dicData Success:(void (^)(id oderMessage))success failure:(void (^)(NSError *error))failure {
    
    // 请求地址
    NSString *path = [NSString stringWithFormat:@"%@%@",STRPATH,@"/Order_addOrder"];
    
    // 请求数据
    [HttpRequest postWithURL:path andDic:dicData success:^(id responseObj) {
        
        NSString *result = [[NSString alloc]initWithData:responseObj encoding:NSUTF8StringEncoding];
        NSLog(@"**********************%@",result);
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic objectForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            NSString *errorCode = [dic objectForKey:@"errorCode"];
            NSLog(@"errorCode%@",errorCode);
            NSString *msg = [dic objectForKey:@"msg"];
            NSLog(@"msg%@",msg);
            
            // 判断是否登录超时，并进行处理
            [self LoginOvertime:errorCode];
            
            // 提示添加地址失败
            HttpRequest *httpAlert = [[HttpRequest alloc] init];
            [httpAlert GetHttpDefeatAlert:@"生成订单失败,请重试"];
            
            if (success) {
                
                // 不做任何操作
            }
            
        }else {
            
            
            NSDictionary *OderInfoDic = [dic objectForKey:@"data"];
            
            NSLog(@"*********======********%@",[dic objectForKey:@"data"]);
            
            if (success) {
                
                success(OderInfoDic);
            }
        }
        
    } failure:^(NSError *error) {
        
        HttpRequest *alert = [[HttpRequest alloc] init];
        // 提示获取数据失败
        [alert GetHttpDefeatAlert:@"网络错误,请求失败"];
        
    }];
}


// 获取全部订单列表
- (void) PostGetAllOrderListWithDicData:(NSDictionary *)dicData Success:(void (^)(id allOrderList))success failure:(void (^)(NSError *error))failure {
    
    
    // 请求地址
    NSString *path = [NSString stringWithFormat:@"%@%@",STRPATH,@"/Order_getList"];
    
    // 请求数据
    [HttpRequest postWithURL:path andDic:dicData success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic objectForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            NSString *errorCode = [dic objectForKey:@"errorCode"];
            NSLog(@"errorCode%@",errorCode);
            NSString *msg = [dic objectForKey:@"msg"];
            NSLog(@"msg%@",msg);
            
            // 判断是否登录超时，并进行处理
            [self LoginOvertime:errorCode];
            
            // 提示添加地址失败
            HttpRequest *httpAlert = [[HttpRequest alloc] init];
            [httpAlert GetHttpDefeatAlert:@"获取订单信息失败,请重试"];
            
            if (success) {
                
                // 不做任何操作
            }
            
        }else {
            
            
            NSArray *listData = [dic objectForKey:@"data"];
            
            if (success) {
                
                success(listData);
            }
        }
        
    } failure:^(NSError *error) {
        
        HttpRequest *alert = [[HttpRequest alloc] init];
        // 提示获取数据失败
        [alert GetHttpDefeatAlert:@"网络错误,请求失败"];
        
    }];
    
}



// 判断用户是否登录超时
- (void) PostPanduanUserTimeOutWithDic:(NSDictionary *)dic Success:(void (^)(id statusInfo))success failure:(void (^)(NSError *error))failure {
    
    // 请求地址
    NSString *path = [NSString stringWithFormat:@"%@%@",STRPATH,@"/User_checkIfLongTimeNoUse"];
    
    // 请求数据
    [HttpRequest postWithURL:path andDic:dic success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = [dic objectForKey:@"status"];
        NSInteger statusInt = [status integerValue];
        
        if (statusInt == 0) {
            
            // 登录超时
            
            NSString *errorCode = [dic objectForKey:@"errorCode"];
            NSLog(@"errorCode%@",errorCode);
            NSString *msg = [dic objectForKey:@"msg"];
            NSLog(@"msg%@",msg);
            
            // 判断是否登录超时，并进行处理
            if ([errorCode isEqualToString:@"1015"]) {
                
                // 提示登录超时
                HttpRequest *http = [[HttpRequest alloc] init];
                [http GetHttpDefeatAlert:@"登录超时,请重新登录"];
                
                // 清除当前用户信息
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user removeObjectForKey:@"token"];
                [user removeObjectForKey:@"severPublicKey"];
            }
            
            if (success) {
                
                // 不做任何操作
            }
            
            
        }else {
            
            if (success) {
                
                // 不做任何操作
            }
        }
        
    } failure:^(NSError *error) {
        
        HttpRequest *alert = [[HttpRequest alloc] init];
        // 提示获取数据失败
        [alert GetHttpDefeatAlert:@"网络错误,请求失败"];
        
    }];
}



// 登录超时
- (void) LoginOvertime:(NSString *)strCode {
    
    if ([strCode isEqualToString:@"1015"]) {
        
        // 提示登录超时
        HttpRequest *http = [[HttpRequest alloc] init];
        [http GetHttpDefeatAlert:@"登录超时,请重新登录"];
        
        // 清除当前用户信息
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user removeObjectForKey:@"token"];
        [user removeObjectForKey:@"severPublicKey"];
    
        // 登录页面
        LoginViewController *logVc = [[LoginViewController alloc] init];

        // 获取delegate
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        // 隐藏底边栏
        [logVc setHidesBottomBarWhenPushed:YES];
        tempAppDelegate.mainTabbarController.selectedIndex = 0;
        // 跳转到登录页面
        [tempAppDelegate.mainTabbarController.viewControllers[0] pushViewController:logVc animated:NO];
        
    }
}



// 转换时间戳方法
- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}


// 获取数据失败
- (void) GetHttpDefeatAlert:(NSString *)str {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:alert
                                    repeats:YES];
}



//弹出框消失的方法
- (void)timerFireMethod:(NSTimer*)theTimer
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert = NULL;
    
    [theTimer invalidate]; // 销毁
}



@end
