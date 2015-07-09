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

@property (weak, nonatomic) UICollectionView * emoj_option_collectionView;




@property (weak, nonatomic) UIView * line;


@end


@implementation YBKeyboardEmojOptionView


-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.line.frame = CGRectMake(0, 0, self.width, 0.5);
    
    self.emoj_option_collectionView.frame = self.bounds;
    
}

- (void)moveToOptionWithIndex:(NSIndexPath *)indexPath{
    [self.emoj_option_collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
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



@end
