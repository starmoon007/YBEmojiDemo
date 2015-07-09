//
//  YBKeyboardEmojiButton.m
//  YBEmojDemo
//
//  Created by Starmoon on 15/7/8.
//  Copyright © 2015年 macbook air. All rights reserved.
//

#import "YBKeyboardEmojiButton.h"

#import "YBKeyboardEmojModel.h"

#import "NSString+Emoji.h"


@implementation YBKeyboardEmojiButton


- (void)setEmoji_model:(YBKeyboardEmojModel *)emoji_model{
    _emoji_model = emoji_model;
    
    if (_emoji_model.code){
        [self setTitle:_emoji_model.code.emoji forState:UIControlStateNormal];
        [self setImage:nil forState:UIControlStateNormal];
    }else{
        
        [self setTitle:nil forState:UIControlStateNormal];
        
        NSString *image_path_string = [NSString stringWithFormat:@"%@%@",self.path,_emoji_model.png_name];
        
        if ([[image_path_string lowercaseString] hasSuffix:@".png"]){
            image_path_string = [image_path_string substringWithRange:NSMakeRange(0,image_path_string.length - 4)];
            image_path_string = [NSString stringWithFormat:@"%@@2x",image_path_string];
        }
        
        NSString *image_path = [[NSBundle mainBundle] pathForResource:image_path_string ofType:@"png"];
        
        UIImage *image = [UIImage imageWithContentsOfFile:image_path];
        
        [self setImage:image forState:UIControlStateNormal];
    }
}

-(void)setHighlighted:(BOOL)highlighted{
    
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:30];
    }
    return self;
}


@end
