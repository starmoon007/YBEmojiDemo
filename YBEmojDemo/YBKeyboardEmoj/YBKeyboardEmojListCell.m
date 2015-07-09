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

@interface YBKeyboardEmojListCell ()

@property (weak, nonatomic) YBKeyboardEmojListView * list_view;

@end


@implementation YBKeyboardEmojListCell


-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.list_view.frame = self.bounds;
}

#pragma mark - Set and Get

-(void)setEmoj_set:(YBKeyboardEmojSet *)emoj_set{
    _emoj_set = emoj_set;
    
    self.list_view.emoji_set = _emoj_set;
}


-(void)setBackward:(BOOL)backward{
    _backward = backward;
    self.list_view.backward = backward;
}


-(YBKeyboardEmojListView *)list_view{
    if (_list_view == nil){
        YBKeyboardEmojListView *list_view = [[YBKeyboardEmojListView alloc]init];
        [self addSubview:list_view];
        _list_view = list_view;
    }
    return _list_view;
}

@end
