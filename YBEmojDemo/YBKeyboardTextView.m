//
//  YBKeyboardTextView.m
//  YBEmojDemo
//
//  Created by Starmoon on 15/7/9.
//  Copyright (c) 2015年 macbook air. All rights reserved.
//

#import "YBKeyboardTextView.h"

#import "UIView+Extension.h"

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
        [self setup];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setup{
    self.backgroundColor = [UIColor grayColor];
    self.contentInset = UIEdgeInsetsMake(-8, 0, -8, 0);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginEditing) name:UITextViewTextDidBeginEditingNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditing) name:UITextViewTextDidEndEditingNotification object:nil];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        [self addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGFloat height =self.contentSize.height - 16;
    height=height<35?18:height;
    
    if (height>100){
        height=100;
        self.bounces = YES;
    }else{
        self.bounces = NO;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.height = height;
    }];
    
    if ([self.yb_delegate respondsToSelector:@selector(textViewDidChangeContent:withSize:)]){
        [self.yb_delegate textViewDidChangeContent:self withSize:CGSizeMake(self.content_size.width, height)];
    }
}


#pragma mark - 通知响应

- (void)textDidChange
{
    self.beginEdit = NO;
    
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


-(CGFloat)content_height{
    if (_content_height == 0){
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
            
            CGRect textFrame=[[self layoutManager]usedRectForTextContainer:[self textContainer]];
            _content_height = textFrame.size.height;
        }else {
            
            _content_height = self.contentSize.height;
        }
    }
    return _content_height;
}





@end
