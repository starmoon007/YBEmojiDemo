//
//  ViewController.m
//  YBEmojDemo
//
//  Created by 杨彬 on 15/6/23.
//  Copyright © 2015年 macbook air. All rights reserved.
//

#import "ViewController.h"
#import "YBKeyBoardInputBar.h"

#import "YBKeyboardInputBarButton.h"

@interface ViewController ()<UITextViewDelegate>

@property (strong, nonatomic) YBKeyBoardInputBar * keyboardInputBar;


@end

@implementation ViewController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YBKeyboardInputBarButton *button = [YBKeyboardInputBarButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(30, 110, 100, 100);
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(aaa) forControlEvents:UIControlEventTouchUpInside];
    
    [button becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didClickMoreFunctionButton:) name:YBKeyboardDidClickFuctionButtonNotification object:nil];
}

- (void)didClickMoreFunctionButton:(NSNotification *)notif{
    NSDictionary *userInfo = notif.userInfo;
    
    YBkeyboardMoreFunctionModel *functionModel = userInfo[@"FunctionModel"];
    
    NSLog(@"你点击了第%lu个名字叫作%@的按钮",(unsigned long)functionModel.index,functionModel.title);
}


- (void)aaa{
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (self.keyboardInputBar.activating){
        [self.view endEditing:YES];
    }else{
        [self.keyboardInputBar showKeyBoardInView:self.view inWindow:YES];
    }
    
}



-(YBKeyBoardInputBar *)keyboardInputBar{
    if (_keyboardInputBar == nil){
        _keyboardInputBar = [YBKeyBoardInputBar keyBoardInputBar];
    }
    
    return _keyboardInputBar;
}

@end
