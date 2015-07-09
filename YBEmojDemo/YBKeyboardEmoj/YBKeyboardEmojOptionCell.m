//
//  YBKeyboardEmojOptionCell.m
//  YBEmojDemo
//
//  Created by Starmoon on 15/7/6.
//  Copyright © 2015年 macbook air. All rights reserved.
//

#import "YBKeyboardEmojOptionCell.h"
#import "YBKeyboardEmojOption.h"

#import "NSString+Emoji.h"
#import "UIView+Extension.h"

@interface YBKeyboardEmojOptionCell ()

@property (weak, nonatomic) UIImageView * option_imageView;

@property (weak, nonatomic) UILabel * option_label;

@property (weak, nonatomic) UIView * line;

@end


@implementation YBKeyboardEmojOptionCell

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.line.width = 0.5;
    self.line.height = self.height;
    self.line.x = self.width - 0.5;
    self.line.y = 0;
    
    self.option_imageView.size = CGSizeMake(20, 20);
    self.option_imageView.center = CGPointMake(self.width /2.0f, self.height / 2.0f);
    
    self.option_label.frame = self.bounds;
}


#pragma mark - Set and Get

-(void)setEmoj_option:(YBKeyboardEmojOption *)emoj_option{
    _emoj_option = emoj_option;
    
    if (_emoj_option.isCode){
        
        self.option_imageView.image = nil;
        self.option_label.text = _emoj_option.emoj_option_indexImageName.emoji;
        
    }else{
        self.option_label.text = @"";
        
        NSString *image_path_string = [NSString stringWithFormat:@"%@%@",emoj_option.emoj_option_urlString,emoj_option.emoj_option_indexImageName];
        
        NSString *image_path = [[NSBundle mainBundle] pathForResource:image_path_string ofType:nil];
        
        UIImage *image = [UIImage imageWithContentsOfFile:image_path];
        
        self.option_imageView.image = image;
    }
}


-(UIImageView *)option_imageView{
    if (_option_imageView == nil){
        UIImageView *option_imageView = [[UIImageView alloc]init];
//        option_imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:option_imageView];
        _option_imageView = option_imageView;
    }
    return _option_imageView;
}

-(UILabel *)option_label{
    if (_option_label == nil){
        UILabel *option_label = [[UILabel alloc]init];
        option_label.font = [UIFont systemFontOfSize:16];
        option_label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:option_label];
        _option_label = option_label;
        
    }
    return _option_label;
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

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectedBackgroundView = [[UIView alloc]init];
        self.selectedBackgroundView.backgroundColor = [UIColor grayColor];
    }
    return self;
}





@end
