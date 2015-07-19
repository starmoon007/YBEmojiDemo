//
//  YBKeyboardEmojListCell.m
//  YBEmojDemo
//
//  Created by Starmoon on 15/7/7.
//  Copyright © 2015年 macbook air. All rights reserved.
//

#import "YBKeyboardEmojListCell.h"

#import "YBKeyboardEmojListView.h"

#import "YBKeyboardEmojSet.h"

#import "UIView+Extension.h"

#import "YBKeyboardEmojiButton.h"

#import "YBKeyboardEmojiPopView.h"

@interface YBKeyboardEmojListCell ()


@property (strong, nonatomic) NSMutableArray * emoji_view_array;

@property (strong, nonatomic) NSArray * emoji_model_array;

@property (weak, nonatomic) UIButton * deleted_button;

@property (strong, nonatomic) YBKeyboardEmojiPopView * popView;


@end


@implementation YBKeyboardEmojListCell


-(void)layoutSubviews{
    [super layoutSubviews];
    
    // 边界
    CGFloat inset = 10;
    // 列
    NSUInteger row = self.page_count_index.row;
    // 行
    NSUInteger line = self.page_count_index.section;
    
    // 表情控件的宽
    CGFloat itemW = (self.width - 2 * inset) / row;
    // 表情控件的高
    CGFloat itemH = (self.height - 2 * inset) / line;
    
    // 控件的数量
    NSUInteger view_count = self.emoji_view_array.count;
    // 表情的数量
    NSUInteger emoji_count = self.emoji_model_array.count;
    
    NSUInteger count = view_count > emoji_count ? view_count : emoji_count;
    
    
    for (int i=0; i< count; i++){
        YBKeyboardEmojiButton *emoji_view = nil;
        YBKeyboardEmojModel *emoji_model = nil;
        
        if ( i >= view_count){// 表情控件不够 创建一个控件
            emoji_view = [[YBKeyboardEmojiButton alloc]init];
            emoji_model = self.emoji_model_array[i];
            [self addSubview:emoji_view];
            [self.emoji_view_array addObject:emoji_view];
            
            [emoji_view addTarget:self action:@selector(clickEmoji:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if (i >= emoji_count){// 表情控件有多
            emoji_view = self.emoji_view_array[i];
            emoji_view.hidden = YES;
        }else{
            emoji_view = self.emoji_view_array[i];
            emoji_view.hidden = NO;
            emoji_view.emoji_model = nil;
            emoji_view.path = nil;
            emoji_model = self.emoji_model_array[i];
        }
        
        // 排列控件
        if (emoji_model != nil && emoji_view != nil){
            emoji_view.width = itemW;
            emoji_view.height = itemH;
            
            emoji_view.path = self.emoj_set.emoj_option.emoj_option_urlString;
            emoji_view.emoji_model = emoji_model;
            
            emoji_view.x = inset + itemW * (i % row);
            NSUInteger number_of_line = i / row;
            emoji_view.y = inset + itemH * number_of_line;
        }
    }
    
    self.deleted_button.width = itemW;
    self.deleted_button.height = itemH;
    self.deleted_button.x = self.width - self.deleted_button.width - inset;
    self.deleted_button.y = self.height - self.deleted_button.height - inset;
}


- (void)clickEmoji:(YBKeyboardEmojiButton *)button{
    YBKeyboardEmojModel * emoji_model = button.emoji_model;
    
    if (emoji_model != nil){
        
        [self.popView showBtn:button];
        
        [YBNotificationCenter postNotificationName:YBKeyboardDidClickEmojiNotification object:emoji_model];
        
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.popView removeFromSuperview];
    });
}


- (void)longPress: (UILongPressGestureRecognizer *)longPress{
    
    CGPoint location = [longPress locationInView:longPress.view];
    YBKeyboardEmojiButton *emoji_button = [self emojiButtonWithLocation:location];
    
    switch (longPress.state) {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:{
            [self.popView removeFromSuperview];
            
            if (emoji_button){
                [YBNotificationCenter postNotificationName:YBKeyboardDidClickEmojiNotification object:emoji_button.emoji_model];
            }
            
        }break;
            
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:{
            [self.popView showBtn:emoji_button];
        }break;default:break;
    }
}

- (void)deleteEmoji:(UIButton *)delete_button{
    [YBNotificationCenter postNotificationName:YBKeyboardDeletedEmojiNotification object:nil];
}

- (YBKeyboardEmojiButton *)emojiButtonWithLocation:(CGPoint)location{
    
    NSUInteger count = self.emoji_view_array.count;
    for (int i=0; i< count ;i++){
        YBKeyboardEmojiButton *btn = self.emoji_view_array[i];
        if (CGRectContainsPoint(btn.frame, location)){
            return btn;
        }
    }
    return nil;
}


#pragma mark - Set and Get

-(void)setEmoj_set:(YBKeyboardEmojSet *)emoj_set{
    _emoj_set = emoj_set;
    
    self.emoji_model_array = _emoj_set.emoj_array;
    
    [self setNeedsLayout];
}


-(UIButton *)deleted_button{
    if (_deleted_button == nil){
        UIButton *deleted_button = [[UIButton alloc]init];
        [deleted_button setImage:[UIImage imageNamed:@"compose_emotion_delete@2x"] forState:UIControlStateNormal];
        [deleted_button setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted@2x"] forState:UIControlStateHighlighted];
        [deleted_button addTarget:self action:@selector(deleteEmoji:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleted_button];
        _deleted_button = deleted_button;
    }
    return _deleted_button;
}


-(NSMutableArray *)emoji_view_array{
    if (_emoji_view_array == nil){
        _emoji_view_array = [[NSMutableArray alloc]init];
    }
    return _emoji_view_array;
}


-(YBKeyboardEmojiPopView *)popView{
    if (_popView == nil){
        _popView = [YBKeyboardEmojiPopView popView];
        _popView.backgroundColor = [UIColor clearColor];
    }
    return _popView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
    }
    return self;
}


@end
