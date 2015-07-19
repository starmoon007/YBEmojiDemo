//
//  YBKeyboardEmojListView.m
//  YBEmojDemo
//
//  Created by Starmoon on 15/7/7.
//  Copyright © 2015年 macbook air. All rights reserved.
//




// 放弃使用


#import "YBKeyboardEmojListView.h"

#import "UIView+Extension.h"

#import "YBKeyboardEmojModel.h"
#import "YBKeyboardEmojSet.h"

#import "YBKeyboardEmojiButton.h"
#import "YBKeyboardEmojiPopView.h"


@interface YBKeyboardEmojListView ()<UIScrollViewDelegate>

@property (assign, nonatomic) YBKeyboardEmojModelType emoj_type;


@property (weak, nonatomic) UIScrollView * bg_scrollView;

/** 表情控件的数组 */
@property (strong, nonatomic) NSMutableArray * emoj_view_array;

/** 删除控件的数组 */
@property (strong, nonatomic) NSMutableArray * deleted_view_array;


@property (strong, nonatomic) NSMutableArray * emoj_model_array;

@property (assign, nonatomic) NSInteger index;



@property (strong, nonatomic) YBKeyboardEmojiPopView * popView;






@end

@implementation YBKeyboardEmojListView

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.bg_scrollView.frame = self.bounds;
    
    
    // 边界
    CGFloat inset = 10;
    // 列
    NSUInteger row = 7;
    // 行
    NSUInteger line = 3;
    
    // 表情控件的宽
    CGFloat itemW = (self.bg_scrollView.width - 2 * inset) / row;
    // 表情控件的高
    CGFloat itemH = (self.bg_scrollView.height - 2 * inset) / line;
    
    // 控件的数量
    NSUInteger view_count = self.emoj_view_array.count;
    // 表情的数量
    NSUInteger emoji_count = self.emoj_model_array.count;
    
    NSUInteger count = view_count > emoji_count ? view_count : emoji_count;
    
    NSUInteger activiated_count = 0;// 显示的控件数量
    
    
    
    for (int i=0; i< count; i++){
        YBKeyboardEmojiButton *emoji_view = nil;
        YBKeyboardEmojModel *emoji_model = nil;
        
        if ( i >= view_count){// 表情控件不够 创建一个控件
            emoji_view = [[YBKeyboardEmojiButton alloc]init];
            emoji_model = self.emoj_model_array[i];
            [self.bg_scrollView addSubview:emoji_view];
            [self.emoj_view_array addObject:emoji_view];
            
            [emoji_view addTarget:self action:@selector(clickEmoji:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if (i >= emoji_count){// 表情控件有多
            emoji_view = self.emoj_view_array[i];
            emoji_view.hidden = YES;
        }else{
            emoji_view = self.emoj_view_array[i];
            emoji_view.hidden = NO;
            emoji_view.emoji_model = nil;
            emoji_view.path = nil;
            emoji_model = self.emoj_model_array[i];
        }
        
        
        if (i % (row * line - 1) == 0 && i != 0){// 每一页最后删除按钮
            activiated_count++;
        }
        
        // 排列控件
        if (emoji_model != nil && emoji_view != nil){
            emoji_view.width = itemW;
            emoji_view.height = itemH;
//            emoji_view.backgroundColor = YBRandomColor;
            emoji_view.path = self.emoji_set.emoj_option.emoj_option_urlString;
            emoji_view.emoji_model = emoji_model;
            
            
            NSUInteger page_index = activiated_count / (line * row);// 第几页
            
            emoji_view.x = inset + itemW * (activiated_count % row) + self.bg_scrollView.width * page_index ;
            NSUInteger number_of_line = activiated_count/ row;
            emoji_view.y = inset + itemH * number_of_line - page_index * itemH * line ;
            activiated_count ++;
        }
    }
    
    NSUInteger page_count = (emoji_count - 1) / (line * row) + 1;
    
    self.bg_scrollView.contentSize = CGSizeMake(self.bg_scrollView.width * page_count, self.bg_scrollView.height);
    
    
    // 给每一页最后加上删除按钮
    
    NSUInteger delete_count = self.deleted_view_array.count;
    
    count = delete_count > page_count ? delete_count : page_count ;
    
    for (int i=0; i< count; i++){
        UIButton *delete_button = nil;
        
        if (i >= delete_count){// 删除按钮不够
            delete_button = [[UIButton alloc]init];
            delete_button.backgroundColor = [UIColor whiteColor];
            [delete_button setImage:[UIImage imageNamed:@"compose_emotion_delete@2x"] forState:UIControlStateNormal];
            [delete_button setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted@2x"] forState:UIControlStateHighlighted];
            [delete_button addTarget:self action:@selector(deleteEmoji:) forControlEvents:UIControlEventTouchUpInside];
            [self.bg_scrollView addSubview:delete_button];
            [self.deleted_view_array addObject:delete_button];
        }else if (i > page_count){// 删除按钮有多 隐藏
            delete_button = self.deleted_view_array[i];
            delete_button.hidden = YES;
        }else{//
            delete_button = self.deleted_view_array[i];
            delete_button.hidden = NO;
        }
        delete_button.width = itemW;
        delete_button.height = itemH;
        delete_button.x = self.bg_scrollView.width * (i + 1) - inset - itemW;
        delete_button.y = self.bg_scrollView.height - inset - itemH;
    }
    
    if (self.backward ){
        self.bg_scrollView.contentOffset = CGPointMake(0, 0);
        [[NSNotificationCenter defaultCenter] postNotificationName:YBKeyBoardEmojiDragEmojiListView object:nil userInfo:@{@"index": @(0) , @"count" : @(page_count) }];
    }else{
        self.bg_scrollView.contentOffset = CGPointMake(self.bg_scrollView.contentSize.width - self.bg_scrollView.width , 0);
        [[NSNotificationCenter defaultCenter] postNotificationName:YBKeyBoardEmojiDragEmojiListView object:nil userInfo:@{@"index": @(page_count) , @"count" : @(page_count) }];
    }
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSUInteger offSetX = (NSUInteger)(scrollView.contentOffset.x + scrollView.width /2);
    
    NSUInteger index = offSetX / ((NSUInteger)scrollView.width);
    
    NSUInteger count = (NSUInteger) scrollView.contentSize.width / scrollView.width;
    
    if (index != self.index){
        [[NSNotificationCenter defaultCenter] postNotificationName:YBKeyBoardEmojiDragEmojiListView object:nil userInfo:@{@"index": @(index) , @"count" : @(count) }];
        
        self.index = index;
    }
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

- (void)deleteEmoji:(UIButton *)btn{
    
    [YBNotificationCenter postNotificationName:YBKeyboardDeletedEmojiNotification object:nil];
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

- (YBKeyboardEmojiButton *)emojiButtonWithLocation:(CGPoint)location{
    
    NSUInteger count = self.emoj_view_array.count;
    for (int i=0; i< count ;i++){
        YBKeyboardEmojiButton *btn = self.emoj_view_array[i];
        if (CGRectContainsPoint(btn.frame, location)){
            return btn;
        }
    }
    return nil;
}


#pragma mark - Set and Get


-(void)setEmoji_set:(YBKeyboardEmojSet *)emoji_set{
    _emoji_set = emoji_set;
    
    self.emoj_model_array = _emoji_set.emoj_array;
}

-(void)setEmoj_model_array:(NSMutableArray *)emoj_model_array{
    _emoj_model_array = emoj_model_array;
    
    YBKeyboardEmojModel *emojModel = [_emoj_model_array lastObject];
    
    if ([emojModel isKindOfClass:[YBKeyboardEmojModel class]]){
        self.emoj_type = emojModel.type;
    }
    [self setNeedsLayout];
}



-(UIScrollView *)bg_scrollView{
    if (_bg_scrollView == nil){
        UIScrollView *bg_scrollView = [[UIScrollView alloc]init];
        bg_scrollView.delegate = self;
        bg_scrollView.showsHorizontalScrollIndicator = NO;
        bg_scrollView.showsVerticalScrollIndicator = NO;
        bg_scrollView.bounces = NO;
        bg_scrollView.pagingEnabled = YES;
        [self addSubview:bg_scrollView];
        _bg_scrollView = bg_scrollView;
    }
    return _bg_scrollView;
}

-(YBKeyboardEmojiPopView *)popView{
    if (_popView == nil){
        _popView = [YBKeyboardEmojiPopView popView];
        _popView.backgroundColor = [UIColor clearColor];
    }
    return _popView;
}


-(NSMutableArray *)deleted_view_array{
    if (_deleted_view_array == nil){
        _deleted_view_array = [[NSMutableArray alloc]init];
    }
    return _deleted_view_array;
}




-(NSMutableArray *)emoj_view_array{
    if (_emoj_view_array == nil){
        _emoj_view_array = [[NSMutableArray alloc]init];
    }
    return _emoj_view_array;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.bg_scrollView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
    }
    return self;
}

@end
