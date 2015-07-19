//
//  YBKeyboardTextView.m
//  YBEmojDemo
//
//  Created by Starmoon on 15/7/9.
//  Copyright (c) 2015年 macbook air. All rights reserved.
//

#import "YBKeyboardTextView.h"

#import "UIView+Extension.h"

#import "YBKeyboardEmojModel.h"

@interface YBKeyboardTextView ()

@property (assign, nonatomic) BOOL beginEdit;

@property (assign, nonatomic) CGSize content_size;

@property (assign, nonatomic) id<YBKeyboardTextViewDelegate> yb_delegate;


@property (copy, nonatomic) NSString * textView_string;

//@property (strong, nonatomic) NSMutableArray * string_array;


@end


@implementation YBKeyboardTextView


- (void)insertEmoji:(YBKeyboardEmojModel *)emoji{
    if (emoji.type == YBKeyboardEmojModelType_emoji){// emoji表情
        [self insertText:emoji.code.emoji];
    }else if (emoji.png_name){
        
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]init];
        
        [attributedText appendAttributedString:self.attributedText];
        
        // 加载图片
        
        NSTextAttachment *attch = [[NSTextAttachment alloc]init];
        
        NSString *image_path_string = [NSString stringWithFormat:@"%@%@",emoji.emoj_option_urlString,emoji.png_name];
        
        if ([[image_path_string lowercaseString] hasSuffix:@".png"]){
            image_path_string = [image_path_string substringWithRange:NSMakeRange(0,image_path_string.length - 4)];
            image_path_string = [NSString stringWithFormat:@"%@@2x",image_path_string];
        }
        
        NSString *image_path = [[NSBundle mainBundle] pathForResource:image_path_string ofType:@"png"];
        
        UIImage *image = [UIImage imageWithContentsOfFile:image_path];
        
        attch.image = image;
        
        CGFloat attchWH = self.font.lineHeight;
        attch.bounds = CGRectMake(0, -3, attchWH, attchWH);
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attch];
        
        NSUInteger loc = self.selectedRange.location;
        
        [attributedText insertAttributedString:imageStr atIndex:loc];
        
        [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];
        
        self.attributedText =  attributedText;
        
        self.selectedRange = NSMakeRange(loc + 1, 0);
    }
    
    
    BOOL hasText = self.attributedText.length > 0 ? YES : NO ;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YBKeyboardActivateSendButtonNotification object:@(hasText)];
    
}

- (void)deleteEmoji{
    
    if (self.attributedText.length <=0)return;
    
    NSUInteger loc = self.selectedRange.location;
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]init];
    
    [attributedText appendAttributedString:self.attributedText];
    
    [attributedText deleteCharactersInRange:NSMakeRange(loc - 1, 1)];
    
    
    self.attributedText= attributedText;
    
    BOOL hasText = self.attributedText.length > 0 ? YES : NO ;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YBKeyboardActivateSendButtonNotification object:@(hasText)];
    
    
}


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
    self.backgroundColor = [UIColor clearColor];
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
    [self scrollRangeToVisible:NSMakeRange(self.text.length, 1)];
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
    BOOL hasText = self.attributedText.length > 0 ? YES : NO ;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YBKeyboardActivateSendButtonNotification object:@(hasText)];
    
    
    
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
