//
//  YBkeyboardMoreFunctionButton.h
//  YBEmojDemo
//
//  Created by 杨彬 on 15/6/29.
//  Copyright © 2015年 macbook air. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YBkeyboardMoreFunctionModel;

@interface YBkeyboardMoreFunctionButton : UIButton

@property (strong, nonatomic) YBkeyboardMoreFunctionModel * function_model;


+ (instancetype)functionButton;

@end
