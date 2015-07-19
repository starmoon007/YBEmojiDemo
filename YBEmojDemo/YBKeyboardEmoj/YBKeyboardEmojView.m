//
//  YBKeyboardEmojView.m
//  YBEmojDemo
//
//  Created by 杨彬 on 15/6/24.
//  Copyright © 2015年 macbook air. All rights reserved.
//

#import "YBKeyboardEmojView.h"

#import "YBKeyboardEmojOptionView.h"
#import "YBKeyboardEmojListCell.h"
#import "YBKeyboardEmojiPageControl.h"

#import "MJExtension.h"
#import "UIView+Extension.h"

#import "YBKeyboardEmojSet.h"


@interface YBKeyboardEmojView ()<UICollectionViewDataSource,UICollectionViewDelegate,YBKeyboardEmojOptionViewDelegate>

@property (weak, nonatomic) YBKeyboardEmojOptionView * emojOptionView;

@property (weak, nonatomic) UICollectionView * emojList_collectionView;

@property (weak, nonatomic) YBKeyboardEmojiPageControl * pageControl;

@property (strong, nonatomic) NSMutableArray * emojOption_array;

/** 当前显示的表情集 */
@property (strong, nonatomic) NSIndexPath * show_index;


@end

@implementation YBKeyboardEmojView


-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.emojOptionView.width = self.width;
    self.emojOptionView.height = 40;
    self.emojOptionView.x= 0;
    self.emojOptionView.y = self.height - self.emojOptionView.height;
    
    self.pageControl.x =0;
    self.pageControl.y = self.height - self.emojOptionView.height - 20;
    self.pageControl.width = self.width;
    self.pageControl.height = 20;
    
    self.emojList_collectionView.x = 0;
    self.emojList_collectionView.y = 0;
    self.emojList_collectionView.width = self.width;
    self.emojList_collectionView.height = self.height - self.emojOptionView.height - self.pageControl.height;
}


- (void)sendAction:(UIButton *)send_button{
    
    
    
}

#pragma mark - UICollectionViewDataSource

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YBKeyboardEmojListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YBKeyboardEmojListCell" forIndexPath:indexPath];
    cell.page_count_index = self.page_content_index;
    cell.emoj_set = self.emojOption_array[indexPath.row];
    return cell;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.emojOption_array.count;
}


#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSUInteger index = scrollView.contentOffset.x / scrollView.width;
    if (index < self.emojOption_array.count){
        YBKeyboardEmojSet *emoji_set = self.emojOption_array[index];
        self.pageControl.numberOfPages = emoji_set.page_count;
        self.pageControl.currentPage = emoji_set.page_index;
        
        [self.emojOptionView moveToOptionWithIndex:emoji_set.emoj_option.index];
    }
}



#pragma mark - YBKeyboardEmojOptionViewDelegate

-(void)keyboardEmojOptionView:(YBKeyboardEmojOptionView *)keyboardEmojOptionView didClickOptionWithOptionModel:(YBKeyboardEmojOption *)emoji_option withIndex:(NSUInteger)index{
    
//    [self.emojList_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
}

#pragma mark - Set and Get

-(NSMutableArray *)emojOption_array{
    if (_emojOption_array == nil){
        _emojOption_array = [[NSMutableArray alloc]init];
        
        NSArray *emojOption_dic_array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"YBKeyboardEmoj" ofType:@"plist"]];
        NSArray *option_array = [YBKeyboardEmojOption objectArrayWithKeyValuesArray:emojOption_dic_array];
        self.emojOptionView.option_array = option_array;
        NSUInteger count = option_array.count;
        for (int i=0; i<count; i++){
            YBKeyboardEmojOption *emoj_option = option_array[i];
            
            NSString *path_string = [NSString stringWithFormat:@"%@info.plist",emoj_option.emoj_option_urlString];
            NSString *path = [[NSBundle mainBundle] pathForResource:path_string ofType:nil];
            NSArray *emoji_model_array = [YBKeyboardEmojModel objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
            
            // 每一页显示多少个表情（最后一个是删除按钮 所以要减去一个）
            NSUInteger count_of_page = self.page_content_index.row * self.page_content_index.section - 1;
            // 这个表情多少页
            NSUInteger page_count = (emoji_model_array.count + count_of_page - 1) / (count_of_page);
            
            for (int i=0; i<page_count ; i++){
                YBKeyboardEmojSet *emoj_set = [[YBKeyboardEmojSet alloc]init];
                emoj_set.emoj_option = emoj_option;
                emoj_set.page_count = page_count;
                emoj_set.page_index = i;
                // 计算这一页的表情范围
                NSRange range;
                range.location = i * count_of_page;
                // left：剩余的表情个数（可以截取的）
                NSUInteger left = emoji_model_array.count - range.location;
                if (left >= count_of_page) { // 这一页足够20个
                    range.length = count_of_page;
                } else {
                    range.length = left;
                }
                emoj_set.emoj_array = [emoji_model_array subarrayWithRange:range];
                [_emojOption_array addObject:emoj_set];
            }
        }
        
        // 给pagecontroll一个初始值，初始值跟第一组表情相关
        YBKeyboardEmojSet *first_emoji_set = [_emojOption_array firstObject];
        self.pageControl.numberOfPages = first_emoji_set.page_count;
        self.pageControl.currentPage = first_emoji_set.page_index;
        
        [self.emojOptionView moveToOptionWithIndex:first_emoji_set.emoj_option.index];
    }
    return _emojOption_array;
}



-(YBKeyboardEmojOptionView *)emojOptionView{
    if (_emojOptionView == nil){
        YBKeyboardEmojOptionView *emojOptionView = [[YBKeyboardEmojOptionView alloc]init];
        emojOptionView.delegate = self;
        [self addSubview:emojOptionView];
        _emojOptionView = emojOptionView;
    }
    return _emojOptionView;
}

-(YBKeyboardEmojiPageControl *)pageControl{
    if (_pageControl == nil){
        YBKeyboardEmojiPageControl *pageControl = [[YBKeyboardEmojiPageControl alloc]init];
        [self addSubview:pageControl];
        _pageControl = pageControl;
    }
    return _pageControl;
}

-(UICollectionView *)emojList_collectionView{
    if (_emojList_collectionView == nil){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(self.width , self.height - self.emojOptionView.height - self.pageControl.height);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        UICollectionView * emojList_collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 10, 10) collectionViewLayout:layout];
        emojList_collectionView.backgroundColor = [UIColor clearColor];
        emojList_collectionView.showsHorizontalScrollIndicator = NO;
        emojList_collectionView.showsVerticalScrollIndicator = NO;
        emojList_collectionView.dataSource = self;
        emojList_collectionView.delegate = self;
        emojList_collectionView.pagingEnabled = YES;
//        emojList_collectionView.bounces = NO;
        [self addSubview:emojList_collectionView];
        [emojList_collectionView registerClass:[YBKeyboardEmojListCell class] forCellWithReuseIdentifier:@"YBKeyboardEmojListCell"];
        _emojList_collectionView = emojList_collectionView;
    }
    return _emojList_collectionView;
}



@end
