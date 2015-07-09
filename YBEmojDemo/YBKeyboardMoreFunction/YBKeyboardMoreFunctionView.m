//
//  YBKeyboardMoreFunctionView.m
//  YBEmojDemo
//
//  Created by 杨彬 on 15/6/26.
//  Copyright © 2015年 macbook air. All rights reserved.
//

#import "YBKeyboardMoreFunctionView.h"

#import "MJExtension.h"
#import "UIView+Extension.h"


#import "YBkeyboardMoreFunctionModel.h"

#import "YBkeyboardMoreFunctionButton.h"


NSString* const YBKeyboardDidClickFuctionButtonNotification =  @"YBKeyboardDidClickFuctionButtonNotification";

@interface YBKeyboardMoreFunctionView ()<UIScrollViewDelegate>

@property (weak, nonatomic) UIScrollView * base_scrollView;

@property (weak, nonatomic) UIPageControl * pageControl;

@property (strong, nonatomic) NSArray * function_model_array;

@end


@implementation YBKeyboardMoreFunctionView


- (void)clickFunctionButton:(YBkeyboardMoreFunctionButton *)functionButton{
    YBkeyboardMoreFunctionModel *function_model = functionButton.function_model;
    
    NSDictionary *userInfo = @{@"FunctionModel" :function_model};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YBKeyboardDidClickFuctionButtonNotification object:self userInfo:userInfo];
}



-(void)layoutSubviews{
    [super layoutSubviews];
    
    NSArray *function_model_array = self.function_model_array;
    NSUInteger count = function_model_array.count;
    NSUInteger section = self.page_layoutplan.section;
    NSUInteger row = self.page_layoutplan.row;
    
    // 内边距
    CGFloat inset = 10;
    
    self.base_scrollView.frame = self.bounds;
    self.base_scrollView.height = self.height - 10;
    
    CGFloat width = (self.base_scrollView.width - 2*inset) / row;
    CGFloat height = (self.base_scrollView.height - 2*inset)/ section;
    
    for (int i=0; i<count; i++){
        YBkeyboardMoreFunctionModel *function_model = function_model_array[i];

        YBkeyboardMoreFunctionButton *functionButton = [YBkeyboardMoreFunctionButton functionButton];
        functionButton.function_model = function_model;
        [functionButton addTarget:self action:@selector(clickFunctionButton:) forControlEvents:UIControlEventTouchUpInside];
        
        functionButton.width = width;
        functionButton.height = height;
        
        NSUInteger page_index = i / (section * row);// 第几页
//        NSUInteger item_index = i % (section * row);// 这一页的第几个
        
        functionButton.x = inset + page_index * self.base_scrollView.width + (i % row ) * width;
        functionButton.y = inset + (i/ row) * height - page_index * height * section;
    
        [self.base_scrollView addSubview:functionButton];
    }
    
    NSUInteger page_count = (count + section * row - 1) / (section * row );
    self.base_scrollView.contentSize = CGSizeMake(self.base_scrollView.width * page_count, self.base_scrollView.height);
    
    self.pageControl.x =0;
    self.pageControl.y = self.height - 20;
    self.pageControl.width = self.width;
    self.pageControl.height = 20;
    self.pageControl.numberOfPages = page_count;
    
    self.pageControl.hidden = page_count == 0 ? YES : NO;
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat current_page = self.base_scrollView.contentOffset.x / self.base_scrollView.bounds.size.width;
    
    self.pageControl.currentPage = (int)(current_page + 0.5);
}


#pragma mark - Set and Get

-(NSArray *)function_model_array{
    if (_function_model_array == nil){
        // 1. 从plist里面获取功能按钮数组
        NSArray *function_dict_array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"YBKeyboardMoreFunction" ofType:@"plist"]];
        
        _function_model_array = [YBkeyboardMoreFunctionModel objectArrayWithKeyValuesArray:function_dict_array];
    }
    return _function_model_array;
}


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
-(UIPageControl *)pageControl{
    if (_pageControl == nil){
        UIPageControl *pageControl = [[UIPageControl alloc]init];
        [self addSubview:pageControl];
        pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        pageControl.currentPageIndicatorTintColor = YBColor(90, 90, 90);
        pageControl.enabled = NO;
        _pageControl = pageControl;
    }
    return _pageControl;
}


-(NSIndexPath *)page_layoutplan{
    if (_page_layoutplan == nil){
        _page_layoutplan = [NSIndexPath indexPathForRow:4 inSection:2];
    }
    return _page_layoutplan;
}


@end
