//
//  YBKeyboardVoiceBillboard.h
//  YBEmojDemo
//
//  Created by 杨彬 on 15/6/29.
//  Copyright © 2015年 macbook air. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBKeyboardVoiceBillboard : UIView

+ (instancetype)voiceBillboard;

/** 移动方法 提示文字移动方法  scale (0,1) */
- (void)moveWithScale:(CGFloat )scale;

@end
