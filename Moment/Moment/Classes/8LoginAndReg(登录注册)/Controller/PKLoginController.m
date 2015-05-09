//
//  PKLoginReginController.m
//  01-片刻
//
//  Created by qianfeng on 15-4-30.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKLoginController.h"
#import "PKRegController.h"
#import "IWHttpTool.h"
#import "PKAccountTool.h"
#import "PKAccount.h"
#import "MBProgressHUD+MJ.h"

@interface PKLoginController ()<PKRegControllerDelegate>
@property (nonatomic, weak)UITextField * emailField;
@property (nonatomic, weak)UITextField * passwordField;
@property (nonatomic, weak)UIButton * loginButton;

@end

@implementation PKLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 1,设置导航栏属性
    [self setupNavBar];
    
    // 2,设置主题内容.
    [self setupTextFiled];
    
}

#pragma mark - 导航栏的样式
/**
 *  设置导航栏属性
 */
-(void)setupNavBar
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStyleDone target:self action:@selector(reg)];
    
    
    
    self.title = @"登录";
}
/**
 *  退出登录页面
 */
-(void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  注册
 */
-(void)reg
{
    PKRegController * reg = [[PKRegController alloc]init];
    [self.navigationController pushViewController:reg animated:YES];
}

#pragma mark - 设置输入框
/**
 *  设置输入框
 */
-(void)setupTextFiled
{
    CGFloat viewW = self.view.frame.size.width;
    CGFloat viewH = self.view.frame.size.height;
    
    CGFloat emailW = viewW * 0.6;
    CGFloat emailH = 30;
    CGFloat emailX = viewW * 0.5 - emailW * 0.4;
    CGFloat emailY = viewH * 0.5 - 100;
    
    // 1,创建邮箱的输入框
    UITextField * emailTextField = [[UITextField alloc]initWithFrame:CGRectMake(emailX, emailY, emailW, emailH)];
    [self.view addSubview:emailTextField];
    self.emailField = emailTextField;
    // 2,设置邮箱文字
    
    [PKNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:emailTextField];

    
    CGFloat emailLabelW = 50;
    CGFloat emailLabelH = 30;
    CGFloat emailLabelX = emailX -emailLabelW;
    CGFloat emailLabelY = emailY;
    
    UILabel * emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(emailLabelX, emailLabelY, emailLabelW, emailLabelH)];
    emailLabel.text = @"邮箱:";
    [self.view addSubview:emailLabel];
    
    // 3,添加一个分割线
    
    CGFloat sliderEmailX = emailLabelX;
    CGFloat sliderEmailY = CGRectGetMaxY(emailLabel.frame);
    CGFloat sliderEmailW = emailW + emailLabelW;
    CGFloat sliderEmailH = 1;
    
    UIView * sliderEmail = [[UIView alloc]initWithFrame:CGRectMake(sliderEmailX, sliderEmailY, sliderEmailW, sliderEmailH)];
    sliderEmail.backgroundColor = [UIColor grayColor];
    [self.view addSubview:sliderEmail];
    
    // 4,添加密码框
    CGFloat passWordW = emailW;
    CGFloat passWordH = emailH;
    CGFloat passWordX = emailX;
    CGFloat passWordY = CGRectGetMaxY(sliderEmail.frame)+passWordH;
    
    UITextField * passWordTextField = [[UITextField alloc]initWithFrame:CGRectMake(passWordX, passWordY, passWordW, passWordH)];
    passWordTextField.secureTextEntry = YES;
    [self.view addSubview:passWordTextField];
    self.passwordField = passWordTextField;
    [PKNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:passWordTextField];

    // 5,设置密码文字
    CGFloat passWordLabelW = 50;
    CGFloat passWordLabelH = 30;
    CGFloat passWordLabelX = passWordX - passWordLabelW;
    CGFloat passWordLabelY = passWordY;
    
    UILabel * passWordLabel = [[UILabel alloc]initWithFrame:CGRectMake(passWordLabelX, passWordLabelY, passWordLabelW, passWordLabelH)];
    passWordLabel.text = @"密码:";
    [self.view addSubview:passWordLabel];
    
    
    // 6,添加一个分割线
    
    CGFloat sliderPassWordX = passWordLabelX;
    CGFloat sliderPassWordY = CGRectGetMaxY(passWordLabel.frame);
    CGFloat sliderPassWordW = passWordW + passWordLabelW;
    CGFloat sliderPassWordH = 1;
    
    UIView * sliderPassWord = [[UIView alloc]initWithFrame:CGRectMake(sliderPassWordX, sliderPassWordY, sliderPassWordW, sliderPassWordH)];
    sliderPassWord.backgroundColor = [UIColor grayColor];
    [self.view addSubview:sliderPassWord];
    
    // 7,添加按钮
    CGFloat loginBtnX = sliderPassWordX;
    CGFloat loginBtnY = CGRectGetMaxY(sliderPassWord.frame) + 10;
    CGFloat loginBtnW = sliderPassWordW;
    CGFloat loginBtnH = 30;
    
    
    
    UIButton * loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(loginBtnX, loginBtnY, loginBtnW, loginBtnH)];
    loginBtn.backgroundColor = [UIColor colorWithRed:0.34f green:0.51f blue:0.21f alpha:1.00f];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.enabled = NO;
    loginBtn.layer.cornerRadius = 5;
    loginBtn.layer.masksToBounds = YES;
    
    [self.view addSubview:loginBtn];
    self.loginButton = loginBtn;
}
/**
 *  监听文字改变
 */
-(void)textDidChange
{

    self.loginButton.enabled = (self.emailField.text.length != 0)&&(self.passwordField.text.length != 0);
}
-(void)sendLoginEmail:(NSString *)emailStr passWord:(NSString *)passwordStr
{
    self.emailField.text = emailStr;
    self.passwordField.text = passwordStr;
    
    [self loginClick];
}
/**
 *  登录按钮点击
 */
-(void)loginClick
{
    PKLog(@"22222222222222");
    [MBProgressHUD showMessage:@"正在登录..."];
    
    PKLog(@"%@,%@",self.emailField.text,self.passwordField.text);
    PKAccountParam * param = [[PKAccountParam alloc]init];
    param.client = @(2);
    param.email = self.emailField.text;
    param.passwd = self.passwordField.text;
    
    [PKAccountTool postLoginWithParam:param success:^(PKAccountResult * result) {
        
        
        PKAccount * account = result;
        
        if (account.msg != nil) {
            //登录失败
            
            [MBProgressHUD hideHUD];
            NSString * message = [NSString stringWithFormat:@"%@",account.msg];
            [MBProgressHUD showError:message];
            PKLog(@"%@",message);
            
        }else{
            
            //存储登录后,获取的唯一auth字段~
            [PKAccountTool saveAccount:account];
            
            
            
            // 刷新HomeRight
            if ([self.delegate respondsToSelector:@selector(LoginAfterReloadView:)]) {
                [self.delegate LoginAfterReloadView:self];
            }
            
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"成功登录"];
            
            // 退出登录页面
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }


    } failure:^(NSError * error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"信息有误,重新输入"];
    }];
}

@end
