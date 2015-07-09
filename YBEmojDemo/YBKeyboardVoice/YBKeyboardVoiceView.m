//
//  YBKeyboardVoiceView.m
//  YBEmojDemo
//
//  Created by 杨彬 on 15/6/29.
//  Copyright © 2015年 macbook air. All rights reserved.
//

#import "YBKeyboardVoiceView.h"

#import "UIView+Extension.h"

#import "YBKeyboardTalkbackView.h"
#import "YBKeyboardRecordView.h"
#import "YBKeyboardVoiceBillboard.h"




@interface YBKeyboardVoiceView ()<UIScrollViewDelegate>

@property (weak, nonatomic) UIScrollView * base_scrollView;

/** 对讲机控件 */
@property (weak, nonatomic) YBKeyboardTalkbackView * talkbackView;

/** 录音控件 */
@property (weak, nonatomic) YBKeyboardRecordView * recordView;

/** 提示板控件 */
@property (weak, nonatomic) YBKeyboardVoiceBillboard * voice_billboard;



@end


@implementation YBKeyboardVoiceView


-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.base_scrollView.frame = self.bounds;
    self.base_scrollView.contentSize = CGSizeMake(self.width * 2, self.height);
 
    self.talkbackView.frame = self.base_scrollView.bounds;
    self.recordView.frame = CGRectMake(self.base_scrollView.width, 0, self.base_scrollView.width, self.base_scrollView.height);
    
    
    self.voice_billboard.width = self.width;
    self.voice_billboard.height = 40;
    self.voice_billboard.x = 0;
    self.voice_billboard.y = self.height - self.voice_billboard.height;
    
}


#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat scale = scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.width);
    
    [self.voice_billboard moveWithScale:scale];
}



#pragma mark - Set and Get
-(UIScrollView *)base_scrollView{
    if (_base_scrollView == nil){
        UIScrollView *base_scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        base_scrollView.pagingEnabled = YES;
        base_scrollView.showsHorizontalScrollIndicator = NO;
        base_scrollView.showsVerticalScrollIndicator = NO;
        base_scrollView.delegate = self;
        [self addSubview:base_scrollView];
        _base_scrollView = base_scrollView;
    }
    return _base_scrollView;
}



-(YBKeyboardTalkbackView *)talkbackView{
    if (_talkbackView == nil){
        YBKeyboardTalkbackView *talkbackView = [[YBKeyboardTalkbackView alloc]init];
        talkbackView.backgroundColor = YBRandomColor;
        [self.base_scrollView addSubview:talkbackView];
        _talkbackView = talkbackView;
    }
    return _talkbackView;
}

-(YBKeyboardRecordView *)recordView{
    if (_recordView ==nil){
        YBKeyboardRecordView *recordView = [[YBKeyboardRecordView alloc]init];
        recordView.backgroundColor = YBRandomColor;
        [self.base_scrollView addSubview:recordView];
        _recordView = recordView;
    }
    return _recordView;
}


-(YBKeyboardVoiceBillboard *)voice_billboard{
    
    if (_voice_billboard == nil){
        YBKeyboardVoiceBillboard *voice_billboard = [YBKeyboardVoiceBillboard voiceBillboard];
        [self addSubview:voice_billboard];
        _voice_billboard = voice_billboard;
    }
    return _voice_billboard;
}


@end
