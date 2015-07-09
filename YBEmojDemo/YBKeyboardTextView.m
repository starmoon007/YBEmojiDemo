//
//  YBKeyboardTextView.m
//  YBEmojDemo
//
//  Created by Starmoon on 15/7/9.
//  Copyright (c) 2015年 macbook air. All rights reserved.
//

#import "YBKeyboardTextView.h"

@interface YBKeyboardTextView ()

@property (assign, nonatomic) BOOL beginEdit;
@property (assign, nonatomic) CGSize content_size;

@property (assign, nonatomic) id<YBKeyboardTextViewDelegate> yb_delegate;

@end


@implementation YBKeyboardTextView



-(void)setDelegate:(id<YBKeyboardTextViewDelegate>)delegate{
    
    [super setDelegate:delegate];
    
    self.yb_delegate = delegate;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor clearColor];
    
    
}


- (void)drawRect:(CGRect)rect
{
    if (self.hasText || self.beginEdit) return;
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = self.placeholderColor?self.placeholderColor:[UIColor grayColor];
    
    CGFloat x = 5;
    CGFloat w = rect.size.width - 2 * x;
    CGFloat y = 8;
    CGFloat h = rect.size.height - 2 * y;
    CGRect placeholderRect = CGRectMake(x, y, w, h);
    
    [self.placeholder drawInRect:placeholderRect withAttributes:attrs];
}

#pragma mark - 构造方法

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginEditing) name:UITextViewTextDidBeginEditingNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditing) name:UITextViewTextDidEndEditingNotification object:nil];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginEditing) name:UITextViewTextDidBeginEditingNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditing) name:UITextViewTextDidEndEditingNotification object:nil];
        
    }
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 通知响应

- (void)textDidChange
{
    self.beginEdit = NO;
    
    if (self.contentSize.height != self.content_size.height){
        if ([self.yb_delegate respondsToSelector:@selector(textViewDidChangeContent:withSize:)]){
            [self.yb_delegate textViewDidChangeContent:self withSize:self.contentSize];
        }
        self.content_size = self.contentSize;
    }
    
    
    [self setNeedsDisplay];
}

- (void)beginEditing{
    self.beginEdit = YES;
    [self setNeedsDisplay];
}

- (void)endEditing{
    self.beginEdit = NO;
    [self setNeedsDisplay];
}

#pragma Set and Get

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    [self setNeedsDisplay];
}


@end
