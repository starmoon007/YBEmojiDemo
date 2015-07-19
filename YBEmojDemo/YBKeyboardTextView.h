//
//  YBKeyboardTextView.h
//  YBEmojDemo
//
//  Created by Starmoon on 15/7/9.
//  Copyright (c) 2015年 macbook air. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBKeyboardTextView;
@class YBKeyboardEmojModel;

@protocol YBKeyboardTextViewDelegate <NSObject,UITextViewDelegate>

@optional
- (void)textViewDidChangeContent:(UITextView *)textView withSize:(CGSize )content_size;

@end


@interface YBKeyboardTextView : UITextView
/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;

/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;

@property (assign, nonatomic) CGFloat content_height;

- (void)insertEmoji:(YBKeyboardEmojModel *)emoji;

@property (readonly,assign,nonatomic) NSMutableString * textView_string;



@end
