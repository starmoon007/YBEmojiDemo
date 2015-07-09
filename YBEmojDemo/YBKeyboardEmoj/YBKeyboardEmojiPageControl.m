//
//  YBKeyboardEmojiPageControl.m
//  YBEmojDemo
//
//  Created by Starmoon on 15/7/8.
//  Copyright © 2015年 macbook air. All rights reserved.
//

#import "YBKeyboardEmojiPageControl.h"

@implementation YBKeyboardEmojiPageControl


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeState:) name:YBKeyBoardEmojiDragEmojiListView object:nil];
        
        self.pageIndicatorTintColor = [UIColor lightGrayColor];
        self.currentPageIndicatorTintColor = [UIColor grayColor];
        
    }
    return self;
}


- (void)changeState:(NSNotification *)notif{
    
    NSDictionary *dic = notif.userInfo;
    
    NSUInteger count = [dic[@"count"] integerValue];
    NSUInteger index = [dic[@"index"] integerValue];
    
    self.numberOfPages = count;
    self.currentPage = index;
}

@end
