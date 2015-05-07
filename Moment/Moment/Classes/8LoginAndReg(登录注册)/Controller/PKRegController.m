//
//  PKRegController.m
//  01-片刻
//
//  Created by qianfeng on 15-4-30.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKRegController.h"

#import "IWHttpTool.h"
#import "PKAccountTool.h"
#import "PKAccount.h"
#import "MBProgressHUD+MJ.h"


@interface PKRegController ()
@property (nonatomic, weak)UITextField * emailField;
@property (nonatomic, weak)UITextField * passwordField;
@property (nonatomic, weak)UITextField * nickNameField;
@property (nonatomic, weak)UIButton * regButton;

@end

@implementation PKRegController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"注册";

    
    [self setupTextFiled];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [PKNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:emailTextField];

    
    // 2,设置邮箱文字
    
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
    
    
    
    
    // 7,添加昵称框
    CGFloat nickNameW = emailW;
    CGFloat nickNameH = emailH;
    CGFloat nickNameX = emailX;
    CGFloat nickNameY = CGRectGetMaxY(sliderPassWord.frame)+passWordH;
    
    UITextField * nickNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(nickNameX, nickNameY, nickNameW, nickNameH)];
    [self.view addSubview:nickNameTextField];
    self.nickNameField = nickNameTextField;
    [PKNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:nickNameTextField];

    // 8,设置密码文字
    CGFloat nickNameFieldLabelW = 50;
    CGFloat nickNameFieldLabelH = 30;
    CGFloat nickNameFieldLabelX = nickNameX - nickNameFieldLabelW;
    CGFloat nickNameFieldLabelY = nickNameY;
    
    UILabel * nickNameFieldLabel = [[UILabel alloc]initWithFrame:CGRectMake(nickNameFieldLabelX, nickNameFieldLabelY, nickNameFieldLabelW, nickNameFieldLabelH)];
    nickNameFieldLabel.text = @"昵称:";
    [self.view addSubview:nickNameFieldLabel];
    
    
    // 9,添加一个分割线
    
    CGFloat slidernickNameFieldX = nickNameFieldLabelX;
    CGFloat slidernickNameFieldY = CGRectGetMaxY(nickNameFieldLabel.frame);
    CGFloat slidernickNameFieldW = nickNameW + nickNameFieldLabelW;
    CGFloat slidernickNameFieldH = 1;
    
    UIView * slidernickNameField = [[UIView alloc]initWithFrame:CGRectMake(slidernickNameFieldX, slidernickNameFieldY, slidernickNameFieldW, slidernickNameFieldH)];
    slidernickNameField.backgroundColor = [UIColor grayColor];
    [self.view addSubview:slidernickNameField];
    
    
    // 7,添加按钮
    CGFloat loginBtnX = sliderPassWordX;
    CGFloat loginBtnY = CGRectGetMaxY(slidernickNameField.frame) + 10;
    CGFloat loginBtnW = sliderPassWordW;
    CGFloat loginBtnH = 30;
    
    UIButton * loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(loginBtnX, loginBtnY, loginBtnW, loginBtnH)];
    loginBtn.backgroundColor = [UIColor colorWithRed:0.34f green:0.51f blue:0.21f alpha:1.00f];
    [loginBtn setTitle:@"注册" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(regClick) forControlEvents:UIControlEventTouchUpInside];
    
    loginBtn.layer.cornerRadius = 5;
    loginBtn.layer.masksToBounds = YES;
    
    [self.view addSubview:loginBtn];
    
}

/**
 *  监听文字改变
 */
-(void)textDidChange
{
    
    
    self.regButton.enabled = (self.emailField.text.length != 0)&&(self.passwordField.text.length != 0)&&(self.nickNameField.text.length != 0);
}

/**
 *  登录按钮点击
 */
-(void)regClick
{
    [MBProgressHUD showMessage:@"请稍后,正在验证信息"];
    PKLog(@"%@,%@",self.emailField.text,self.passwordField.text);
    PKAccountParam * param = [[PKAccountParam alloc]init];
    param.client = @(2);
    param.email = self.emailField.text;
    param.passwd = self.passwordField.text;
    param.uname = self.nickNameField.text;
    param.gender = @(2);
    
    
    [PKAccountTool postRegWithParam:param success:^(PKAccountResult * result) {
        
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
     
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"成功注册"];
            
            
            // 成功注册之后,直接登录.
            if ([self.delegate respondsToSelector:@selector(sendLoginEmail:passWord:)]) {
              
                [self.delegate sendLoginEmail:self.emailField.text passWord:self.passwordField.text];
            }
   
        }
        
    } failure:^(NSError * error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"信息有误,重新输入"];
    }];
}


@end
