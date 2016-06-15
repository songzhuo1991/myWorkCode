//
//  ViewController.m
//  登陆
//
//  Created by 宋卓 on 15/12/10.
//  Copyright © 2015年 songzhuo. All rights reserved.
//

#import "ViewController.h"
#import "MyBtn.h"
#import "MBProgressHUD+MJ.h"
@interface ViewController ()<UITextFieldDelegate,NSURLConnectionDataDelegate>
@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) UITextField * usernameField;
@property (nonatomic, strong) UITextField * pwdField;
@property (nonatomic, strong) MyBtn * loginBtn;
@property (nonatomic, strong) MyBtn * registerBtn;
@property (nonatomic, strong) NSMutableData * responseData;
@end

@implementation ViewController
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self createUI];
}
- (void)createUI{
    self.bgView.backgroundColor = [UIColor cyanColor];
    self.usernameField.placeholder = @"请输入用户名";
    self.pwdField.placeholder = @"请输入密码";
    [self.loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.registerBtn addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)loginClick{
    //1.表单验证
    NSString *username = self.usernameField.text;
    if (username.length == 0) {//没有输入用户名
        [MBProgressHUD showError:@"请输入用户名"];
        return;
    }
    NSString *pwd = self.pwdField.text;
    if (pwd.length == 0) {//没有输入密码
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    [MBProgressHUD showMessage:@"正在拼命登录中..."];
    //2设置请求路径
    NSString *urlStr = [NSString stringWithFormat:@""];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 5;
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
    [conn start];
//    NSOperationQueue *queue = [NSOperationQueue mainQueue];
//    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        [MBProgressHUD hideHUD];
//        if (data) {
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//            NSString *error = dict[@"error"];
//            if (error) {
//                [MBProgressHUD showError:error];
//            }else{
//                NSString *success = dict[@"success"];
//                [MBProgressHUD showSuccess:success];
//            }
//        }else{
//            [MBProgressHUD showError:@"网络繁忙，请稍后再试"];
//        }
//    }];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    self.responseData = [NSMutableData data];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.responseData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [MBProgressHUD hideHUD];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:nil];
    NSString *error = dict[@"error"];
    if (error) {
        [MBProgressHUD showError:error];
    }else{
        NSString *success = dict[@"success"];
        [MBProgressHUD showSuccess:success];
    }
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [MBProgressHUD hideHUD];
    [MBProgressHUD showError:@"网络繁忙, 请稍后再试"];
}
#pragma mark - 懒加载
- (UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [[MyBtn alloc]init];
        [_bgView addSubview:_loginBtn];
        [_loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
        
        _loginBtn.translatesAutoresizingMaskIntoConstraints = NO;
        //高度距离pwdField 10
        NSLayoutConstraint * btnTop = [NSLayoutConstraint constraintWithItem:_loginBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_pwdField attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10];
        [_bgView addConstraint:btnTop];
        //左边距离bgView 20
        NSLayoutConstraint * btnLeft = [NSLayoutConstraint constraintWithItem:_loginBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_bgView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:20];
        [_bgView addConstraint:btnLeft];
        //右边距离bgView 10
        NSLayoutConstraint * btnRight = [NSLayoutConstraint constraintWithItem:_loginBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_bgView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:-10];
        [_bgView addConstraint:btnRight];
        //底边距离bgView 20
        NSLayoutConstraint * btnBottom = [NSLayoutConstraint constraintWithItem:_loginBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_bgView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10];
        [_bgView addConstraint:btnBottom];
    }
    return _loginBtn;
}
- (UIButton *)registerBtn{
    if (!_registerBtn) {
        _registerBtn = [[MyBtn alloc]init];
        [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        [_bgView addSubview:_registerBtn];
        
        _registerBtn.translatesAutoresizingMaskIntoConstraints = NO;
        //高度距离pwdField 10
        NSLayoutConstraint * btnTop = [NSLayoutConstraint constraintWithItem:_registerBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_pwdField attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10];
        [_bgView addConstraint:btnTop];
        //左边距离bgView中点 10
        NSLayoutConstraint * btnLeft = [NSLayoutConstraint constraintWithItem:_registerBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_bgView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:10];
        [_bgView addConstraint:btnLeft];
        //右边距离bgView 20
        NSLayoutConstraint * btnRight = [NSLayoutConstraint constraintWithItem:_registerBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_bgView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-20];
        [_bgView addConstraint:btnRight];
        //底边距离bgView 20
        NSLayoutConstraint * btnBottom = [NSLayoutConstraint constraintWithItem:_registerBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_bgView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10];
        [_bgView addConstraint:btnBottom];

    }
    return _registerBtn;
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:self.bgView];
        //距离右边20
        NSLayoutConstraint * bgRight = [NSLayoutConstraint constraintWithItem:_bgView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-20];
        [self.view addConstraint:bgRight];
        //创建bgView的约束
        //距离左边20
        NSLayoutConstraint * bgLeft = [NSLayoutConstraint constraintWithItem:_bgView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:20];
        [self.view addConstraint:bgLeft];
        //距离上边20
        NSLayoutConstraint * bgTop = [NSLayoutConstraint constraintWithItem:_bgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:20];
        [self.view addConstraint:bgTop];
        //高度150
        NSLayoutConstraint * bgHC = [NSLayoutConstraint constraintWithItem:_bgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:150];
        [_bgView addConstraint:bgHC];
    }
    return _bgView;
}
//用户名
- (UITextField *)usernameField{
    if (!_usernameField) {
        _usernameField = [[UITextField alloc]init];
        _usernameField.translatesAutoresizingMaskIntoConstraints = NO;
        [_bgView addSubview:_usernameField];
        _usernameField.delegate = self;
        _usernameField.borderStyle = UITextBorderStyleRoundedRect;
        _usernameField.clearButtonMode = UITextFieldViewModeAlways;
       
        //距离背景view高10
        NSLayoutConstraint *_usernameTop = [NSLayoutConstraint constraintWithItem:_usernameField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_bgView attribute:NSLayoutAttributeTop multiplier:1.0 constant:10];
        [_bgView addConstraint:_usernameTop];
        //距离背景view左边10
        NSLayoutConstraint *_usernameLeft = [NSLayoutConstraint constraintWithItem:_usernameField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_bgView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10];
        [_bgView addConstraint:_usernameLeft];
        //距离背景view右边10
        NSLayoutConstraint *_usernameRight = [NSLayoutConstraint constraintWithItem:_usernameField attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_bgView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10];
        [_bgView addConstraint:_usernameRight];
        //自身高度40
        NSLayoutConstraint *_usernameHC = [NSLayoutConstraint constraintWithItem:_usernameField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40];
        [_usernameField addConstraint:_usernameHC];
    }
    return _usernameField;
}
//密码
- (UITextField *)pwdField{
    if (!_pwdField) {
        _pwdField = [[UITextField alloc]init];
        [_bgView addSubview:_pwdField];
        _pwdField.delegate = self;
        _pwdField.translatesAutoresizingMaskIntoConstraints = NO;
        _pwdField.borderStyle = UITextBorderStyleRoundedRect;
        _pwdField.clearButtonMode = UITextFieldViewModeAlways;
        _pwdField.secureTextEntry = YES;
        _pwdField.returnKeyType = UIReturnKeyDone;
        
        //距离背景view高10
        NSLayoutConstraint *pwdTop = [NSLayoutConstraint constraintWithItem:_pwdField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_bgView attribute:NSLayoutAttributeTop multiplier:1.0 constant:60];
        [_bgView addConstraint:pwdTop];
        //距离背景view左边10
        NSLayoutConstraint *pwdLeft = [NSLayoutConstraint constraintWithItem:_pwdField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_bgView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10];
        [_bgView addConstraint:pwdLeft];
        //距离背景view右边10
        NSLayoutConstraint *pwdRight = [NSLayoutConstraint constraintWithItem:_pwdField attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_bgView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10];
        [_bgView addConstraint:pwdRight];
        //自身高度40
        NSLayoutConstraint *pwdHC = [NSLayoutConstraint constraintWithItem:_pwdField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40];
        [_pwdField addConstraint:pwdHC];
    }
    return _pwdField;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
