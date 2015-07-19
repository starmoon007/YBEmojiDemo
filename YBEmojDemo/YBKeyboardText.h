//
//  YBKeyboardText.h
//  YBEmojDemo
//
//  Created by Starmoon on 15/7/19.
//  Copyright (c) 2015年 macbook air. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YBKeyboardEmojModel;

@interface YBKeyboardText : NSObject


@property (strong, nonatomic) YBKeyboardEmojModel * emoji_model;

@property (assign, nonatomic) NSRange range;




@end
