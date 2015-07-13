//
//  YBKeyboardEmojiPopView.m
//  YBEmojDemo
//
//  Created by Starmoon on 15/7/13.
//  Copyright (c) 2015年 macbook air. All rights reserved.
//

#import "YBKeyboardEmojiPopView.h"

#import "YBKeyboardEmojiButton.h"
#import "YBKeyboardEmojModel.h"

#import "UIView+Extension.h"

@interface YBKeyboardEmojiPopView ()

@property (weak, nonatomic) UIImageView * bg_imageView;

@property (weak, nonatomic) YBKeyboardEmojiButton * emoji_button;

@end


@implementation YBKeyboardEmojiPopView



-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.bg_imageView.frame = self.bounds;
    
    self.emoji_button.x = 0;
    self.emoji_button.y = 0;
    self.emoji_button.width = self.emoji_button.height = self.width;
    
    [self bringSubviewToFront:self.emoji_button];
    
}

- (void)showBtn:(YBKeyboardEmojiButton *)emoji_button{
    YBKeyboardEmojModel *emoji_model = emoji_button.emoji_model;
    
    UIWindow *window =[[UIApplication sharedApplication].windows lastObject];
    
    CGRect btnFrame = [emoji_button convertRect:emoji_button.bounds toView:window];
    
    self.path = emoji_button.path;
    
    self.emoji_model = emoji_model;
    
    self.y = CGRectGetMidY(btnFrame) - self.height;
    
    self.centerX = CGRectGetMidX(btnFrame);
    
    [window addSubview:self];
}


#pragma mark - Set and Get


-(void)setEmoji_model:(YBKeyboardEmojModel *)emoji_model{
    _emoji_model = emoji_model;
    
    self.emoji_button.path = self.path;
    
    self.emoji_button.emoji_model = _emoji_model;
}

-(UIImageView *)bg_imageView{
    if (_bg_imageView == nil){
        UIImageView *bg_imageView = [[UIImageView alloc]init];
        [self addSubview:bg_imageView];
        bg_imageView.image = [UIImage imageNamed:@"emoticon_keyboard_magnifier@2x"];
        
        _bg_imageView = bg_imageView;
    }
    return _bg_imageView;
}


-(YBKeyboardEmojiButton *)emoji_button{
    if (_emoji_button == nil){
        YBKeyboardEmojiButton *emoji_button = [[YBKeyboardEmojiButton alloc]init];
        [self addSubview:emoji_button];
        _emoji_button = emoji_button;
    }
    return _emoji_button;
}

+ (instancetype)popView{
    return [[self alloc] initWithFrame:CGRectMake(0, 0, 64, 91)];
}




@end
