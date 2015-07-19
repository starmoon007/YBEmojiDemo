//
//  YBKeyboardEmojOptionView.m
//  YBEmojDemo
//
//  Created by Starmoon on 15/7/3.
//  Copyright © 2015年 macbook air. All rights reserved.
//

#import "YBKeyboardEmojOptionView.h"

#import "UIView+Extension.h"
#import "MJExtension.h"

#import "YBKeyboardEmojOptionCell.h"


#import "YBKeyboardEmojOption.h"

@interface YBKeyboardEmojOptionView ()<UICollectionViewDataSource,UICollectionViewDelegate>

/** 表情包列表collecttionview */
@property (weak, nonatomic) UICollectionView * emoj_option_collectionView;

/** 发送按钮*/
@property (weak, nonatomic) UIButton * send_button;

/** 顶部分割线 */
@property (weak, nonatomic) UIView * line;


@property (assign, nonatomic) BOOL showSendButton;


@end


@implementation YBKeyboardEmojOptionView


-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.emoj_option_collectionView.frame = self.bounds;
    
    self.send_button.x = self.emoj_option_collectionView.width;
    self.send_button.y = self.emoj_option_collectionView.y;
    self.send_button.width = 50;
    self.send_button.height = self.emoj_option_collectionView.height;
    
    if (self.showSendButton){
        self.emoj_option_collectionView.width = self.width - 50;
        self.send_button.x = self.emoj_option_collectionView.width;
    }
    
     self.line.frame = CGRectMake(0, 0, self.width, 0.5);
}


- (void)activiteSendButton:(NSNotification *)notif{
    
    BOOL activiteSendButton = [notif.object boolValue];
    
    if (activiteSendButton){
        self.send_button.backgroundColor = [UIColor colorWithRed:0.38 green:0.84 blue:1 alpha:1];
        [self.send_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        self.send_button.backgroundColor = [UIColor whiteColor];
        [self.send_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}


- (void)sendAction:(UIButton *)send_button{
    [[NSNotificationCenter defaultCenter] postNotificationName:YBKeyboardSendActionNotification object:nil userInfo:nil];
}

- (void)moveToOptionWithIndex:(NSUInteger )index{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.emoj_option_collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    
    YBKeyboardEmojOption *emoj_option = self.option_array[indexPath.row];
    
    self.showSendButton = !emoj_option.isLargeEmoji;
}

#pragma mark - UICollectionViewDataSource

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YBKeyboardEmojOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YBKeyboardEmojOptionCell" forIndexPath:indexPath];
    YBKeyboardEmojOption *emoj_option = self.option_array[indexPath.row];
    cell.emoj_option = emoj_option;
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.option_array.count;
}



#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(keyboardEmojOptionView:didClickOptionWithOptionModel: withIndex:)]){
        YBKeyboardEmojOption * emoji_option = self.option_array[indexPath.row];
        [self.delegate keyboardEmojOptionView:self didClickOptionWithOptionModel:emoji_option withIndex:indexPath.row];
    }
}


#pragma mark - Set and Get

-(UICollectionView *)emoj_option_collectionView{
    if (_emoj_option_collectionView == nil){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(60 , self.height);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        UICollectionView * emoj_option_collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 10, 10) collectionViewLayout:layout];
        emoj_option_collectionView.backgroundColor = [UIColor clearColor];
        emoj_option_collectionView.showsHorizontalScrollIndicator = NO;
        emoj_option_collectionView.showsVerticalScrollIndicator = NO;
        emoj_option_collectionView.dataSource = self;
        emoj_option_collectionView.delegate = self;
        [self addSubview:emoj_option_collectionView];
        [emoj_option_collectionView registerClass:[YBKeyboardEmojOptionCell class] forCellWithReuseIdentifier:@"YBKeyboardEmojOptionCell"];
        _emoj_option_collectionView = emoj_option_collectionView;
    }
    return _emoj_option_collectionView;
}


-(void)setShowSendButton:(BOOL)showSendButton{
    _showSendButton = showSendButton;
    [self setNeedsLayout];
}

-(void)setOption_array:(NSMutableArray *)option_array{
    _option_array = option_array;
    [self setNeedsLayout];
}


-(UIView *)line{
    if (_line == nil){
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
        _line = line;
    }
    return _line;
}

-(UIButton *)send_button{
    if (_send_button == nil){
        UIButton *send_button = [[UIButton alloc]init];
        [send_button setTitle:@"发送" forState:UIControlStateNormal];
        [send_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        send_button.titleLabel.font = [UIFont systemFontOfSize:14];
        [send_button addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:send_button];
        _send_button = send_button;
    }
    return _send_button;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activiteSendButton:) name:YBKeyboardActivateSendButtonNotification object:nil];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
