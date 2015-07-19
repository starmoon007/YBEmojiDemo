//
//  YBKeyBoardInputBar.m
//  YBEmojDemo
//
//  Created by 杨彬 on 15/6/23.
//  Copyright © 2015年 macbook air. All rights reserved.
//

#import "YBKeyBoardInputBar.h"

#import "UIView+Extension.h"

#import "YBKeyboardInputBarButton.h"

#import "YBKeyboardEmojView.h"

#import "YBKeyboardVoiceView.h"

#import "YBKeyboardTextView.h"

#import "YBKeyboardEmojModel.h"
#import "NSString+Emoji.h"

#import "YBKeyboardEmojModel.h"
#import "YBKeyboardEmojiAttachment.h"




@interface YBKeyBoardInputBar ()<UITextFieldDelegate,YBKeyboardTextViewDelegate>

/** 录音按钮 */
@property (weak, nonatomic) YBKeyboardInputBarButton *voice_button;

/** 更多按钮 */
@property (weak, nonatomic) YBKeyboardInputBarButton *moreFunction_button;

/** 标签按钮 */
@property (weak, nonatomic) YBKeyboardInputBarButton *emoj_button;

/** 文本输入框 */
@property (weak, nonatomic) YBKeyboardTextView *input_textView;


@property (weak, nonatomic) UIImageView *textView_bgImageView;

@property (weak, nonatomic) UIView * top_line;

@property (weak, nonatomic) UIView * bottom_line;;


/** 表情键盘控件 */
@property (strong, nonatomic) YBKeyboardEmojView * emojView;

/** 更多功能键盘控件 */
@property (strong, nonatomic) YBKeyboardMoreFunctionView * moreFunctionView;

/** 语音键盘控件 */
@property (strong, nonatomic) YBKeyboardVoiceView * voiceView;


/** 是否正在切换系统键盘 */
@property (assign, nonatomic) BOOL switchingDefaultKeyboard;

/** 是否正在切换自定义键盘 */
@property (assign, nonatomic) BOOL switchingDIYKeyboard;

/** 影子输入控件,方便弹出各种自定义键盘 */
@property (weak, nonatomic) UITextField * replace_tf;

/** 遮盖视图 当显示自定义键盘时遮盖 input_view */
@property (strong, nonatomic) UIView * cover_view;

//@property (weak, nonatomic) UIView * test_view;


@end


@implementation YBKeyBoardInputBar


/** 录音按钮点击响应 */
- (void)voiceAction:(UIButton *)voice_button {
    self.emoj_button.selected = NO;
    self.moreFunction_button.selected = NO;
    voice_button.selected = ! voice_button.selected;
    
    if (self.activating){// 键盘是否被激活的判断（键盘是否弹起）这个时候键盘已经弹起，切换键盘
        if(voice_button.selected){// 切换到语音键盘
            [self switchVoiceKeyboard];
        }else{// 切换到默认键盘
            [self switchDefaultKeyborad];
        }
    }else{// 这个时候键盘没有弹起，弹起键盘
        if(voice_button.selected){// 弹起语音键盘
            [self popVoiceKeyBoard];
        }else{// 弹起默认键盘
            [self popDefaultKeyboar];
        }
    }
}

/** 表情按钮点击响应 */
- (void)emojAction:(UIButton *)emojButton {
    self.voice_button.selected = NO;
    self.moreFunction_button.selected = NO;
    
    emojButton.selected = !emojButton.selected;
    if (self.activating){// 键盘是否被激活的判断（键盘是否弹起）这个时候键盘已经弹起，切换键盘
        if(emojButton.selected){// 切换到表情键盘
            [self switchEmojKeyboard];
        }else{// 切换到默认键盘
            [self switchDefaultKeyborad];
        }
    }else{// 这个时候键盘没有弹起，弹起键盘
        if(emojButton.selected){// 弹起表情键盘
            [self popEmojKeyBoard];
        }else{// 弹起默认键盘
            [self popDefaultKeyboar];
        }
    }
}


/** 更多按钮点击响应 */
- (void)moreAction:(UIButton *)moreFunction_button {
    self.voice_button.selected = NO;
    self.emoj_button.selected = NO;
    moreFunction_button.selected = !moreFunction_button.selected;
    
    if (self.activating){// 键盘是否被激活的判断（键盘是否弹起）这个时候键盘已经弹起，切换键盘
        if(moreFunction_button.selected){// 切换到更多功能键盘
            [self switchMoreFunctionKeyboard];
        }else{// 切换到默认键盘
            [self switchDefaultKeyborad];
        }
    }else{// 这个时候键盘没有弹起，弹起键盘
        if(moreFunction_button.selected){// 弹起更多功能键盘
            [self popMoreFunctionKeyBoard];
        }else{// 弹起默认键盘
            [self popDefaultKeyboar];
        }
    }
}


/** 切换回系统键盘 */
- (void)switchDefaultKeyborad{
    self.switchingDefaultKeyboard = YES;
    
    [self.replace_tf endEditing:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.input_textView becomeFirstResponder];
        self.switchingDefaultKeyboard = NO;
    });
}

/** 弹起默认键盘 */
- (void)popDefaultKeyboar{
    [self.input_textView becomeFirstResponder];
}


/** 切换成自定义键盘 */
- (void)showKeyBoard:(YBKeyboardType)keyboardType{
    
    self.switchingDIYKeyboard = YES;
    switch (keyboardType) {
        case YBKeyboard_Default:{
            
        }break;
        case YBKeyboard_Voice:{
            
        }break;
        case YBKeyboard_Emoj:{// 弹窗表情键盘
            [self popEmojKeyBoard];
        }break;
        case YBKeyboard_More:{
            
        }break;
        default:
            break;
    }
}


/** 切换出语音键盘 */
- (void)switchVoiceKeyboard{
    self.replace_tf.inputView = self.voiceView;
    self.switchingDIYKeyboard = YES;
    [self.input_textView endEditing:YES];
    [self.replace_tf endEditing:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.replace_tf becomeFirstResponder];
        self.switchingDIYKeyboard = NO;
    });
}

/** 弹出语音键盘 */
- (void)popVoiceKeyBoard{
    self.replace_tf.inputView = self.voiceView;
    [self.replace_tf becomeFirstResponder];
}


/** 切换出表情键盘 */
- (void)switchEmojKeyboard{
    self.replace_tf.inputView = self.emojView;
    self.switchingDIYKeyboard = YES;
    [self.input_textView endEditing:YES];
    [self.replace_tf endEditing:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.replace_tf becomeFirstResponder];
        self.switchingDIYKeyboard = NO;
    });
    
}



/** 弹出表情键盘 */
- (void)popEmojKeyBoard{
    self.replace_tf.inputView = self.emojView;
    [self.replace_tf becomeFirstResponder];
    
}

/** 切换出更多功能键盘 */
- (void)switchMoreFunctionKeyboard{
    self.replace_tf.inputView = self.moreFunctionView;
    self.switchingDIYKeyboard = YES;
    [self.input_textView endEditing:YES];
    [self.replace_tf endEditing:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.replace_tf becomeFirstResponder];
        self.switchingDIYKeyboard = NO;
    });
}

/** 弹出更多功能键盘 */
- (void)popMoreFunctionKeyBoard{
    self.replace_tf.inputView = self.moreFunctionView;
    [self.replace_tf becomeFirstResponder];
}




- (void)showKeyBoardInView:(UIView *)super_view{
    [self showKeyBoardInView:super_view inWindow:NO];
}


/** 显示方法方法,是否显示在屏幕外 */
- (void)showKeyBoardInView:(UIView *)super_view inWindow:(BOOL)inWindow{
    if (self.superview == super_view)return;
    self.height = 44;
    CGFloat height = super_view.height;
    if (inWindow){
        height = super_view.height - self.height;
    }
    
    if (self.superview == nil){
        [super_view addSubview:self];
        self.x = 0;
        self.y = height ;
    }
    self.width = super_view.width;
}



- (void)clickCoverView:(UITapGestureRecognizer *)tap{
    
    [self.cover_view removeFromSuperview];
    self.switchingDefaultKeyboard = YES;
    [self.replace_tf endEditing:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.input_textView becomeFirstResponder];
        self.switchingDefaultKeyboard = NO;
    });
}


#pragma mark - Notification Action

- (void)sendAction:(NSNotification *)notif{
    
    NSLog(@"%@",self.input_textView.textView_string);
    
}


- (void)didClickEmoji:(NSNotification *)notif{
    
    YBKeyboardEmojModel *emoji_model = notif.object;
    [self.input_textView insertEmoji:emoji_model];
}


- (void)deletedEmoji:(NSNotification *)notif{
    
    [self.input_textView deleteBackward];
    
}

- (void)keyboardDidChangeFrame:(NSNotification *)notif{
    
    CGFloat keyboardHeight = [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    
    double duration = [[notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 1.切换成自定义键盘
    if (self.switchingDIYKeyboard == YES){
        
        [UIView animateWithDuration:duration animations:^{
            if (self.y <= YBScreenH){
                self.y = YBScreenH - 216 - self.height;
            }
        }completion:^(BOOL finished) {
            self.switchingDIYKeyboard = NO;
        }];
        return;
    }
    
    // 2.切换到系统默认键盘
    if (self.switchingDefaultKeyboard == YES){
        if (keyboardHeight >= YBScreenH)return;
        [UIView animateWithDuration:duration animations:^{
            if (self.y <= YBScreenH){
                self.y = keyboardHeight - self.height;
            }
        }completion:^(BOOL finished) {
            self.switchingDefaultKeyboard = NO;
        }];
        return;
    }
    
    
    // 3.弹出键盘
    [UIView animateWithDuration:duration animations:^{
        if (self.y <= YBScreenH){
            self.y = keyboardHeight - self.height;
        }
    }completion:^(BOOL finished) {
        self.switchingDefaultKeyboard = NO;
        self.switchingDIYKeyboard = NO;
    }];
}

// input_textView 的编辑状态转换调用方法
- (void)beginEditing{
    self.voice_button.selected = NO;
    self.emoj_button.selected = NO;
    self.moreFunction_button.selected = NO;
    
    [self.cover_view removeFromSuperview];
    self.cover_view = nil;
    
    [self.replace_tf endEditing:YES];
}

//- (void)endEditing{
////    NSLog(@"endEditing");
////    [self endEditing:YES];
//    
//    
//}
//
//- (void)changeText{
////    NSLog(@"changeText");
//}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.voice_button.width = 30;
    self.voice_button.height = 30;
    self.voice_button.x = 5;
    self.voice_button.y = self.height - 7 - self.voice_button.height;
    
    self.moreFunction_button.width = 30;
    self.moreFunction_button.height = 32;
    self.moreFunction_button.x = self.width - 5 - self.moreFunction_button.width;
    self.moreFunction_button.y = self.height - 7 - self.moreFunction_button.height;
    
    self.emoj_button.width = 30;
    self.emoj_button.height = 30;
    self.emoj_button.x = self.moreFunction_button.x - 5 - self.emoj_button.width;
    self.emoj_button.y = self.height - 7 - self.emoj_button.height;
    
    self.textView_bgImageView.x = CGRectGetMaxX(self.voice_button.frame) + 5;
    self.textView_bgImageView.y = 3;
    self.textView_bgImageView.width = self.emoj_button.x - 5 - self.textView_bgImageView.x;
    self.textView_bgImageView.height = self.height - 6;
    
    if (self.input_textView.height < 34){
        self.input_textView.width = self.textView_bgImageView.width;
        self.input_textView.center = CGPointMake(self.textView_bgImageView.width /2.0f, self.textView_bgImageView.height /2.0f);
    }else{
        self.input_textView.frame = self.textView_bgImageView.frame;
        self.input_textView.x = 0;
        self.input_textView.y = 2;
        self.input_textView.width = self.textView_bgImageView.width;
        self.input_textView.height = self.textView_bgImageView.height - 4;
    }
    
    self.top_line.frame = CGRectMake(0, 0, self.width, 0.5);
    self.bottom_line.frame = CGRectMake(0, self.height - 0.5, self.width, 0.5);
}


#pragma mark - YBKeyboardTextViewDelegate

- (void)textViewDidChangeContent:(UITextView *)textView withSize:(CGSize )content_size{
    CGFloat height = content_size.height;
    
    self.input_textView.center = CGPointMake(self.textView_bgImageView.width /2.0f, self.textView_bgImageView.height /2.0f);
    
    if (content_size.height < 19) height = 34;
    
    CGFloat distance = height + 10 - self.height;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.height = height + 10;
        self.y = self.y - distance;
    }];
    
    
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self cover_view];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (!self.switchingDIYKeyboard){
        self.voice_button.selected = NO;
        self.emoj_button.selected = NO;
        self.moreFunction_button.selected = NO;
    }
    return YES;
}

#pragma mark - Set and Get

-(YBKeyboardEmojView *)emojView{
    if (_emojView == nil){
        self.emojView = [[YBKeyboardEmojView alloc]init];
        NSIndexPath *index = [NSIndexPath indexPathForRow:7 inSection:3];
        _emojView.page_content_index = index;
        _emojView.width = self.width;
        _emojView.height = 216;
        _emojView.backgroundColor = [UIColor whiteColor];
    }
    return _emojView;
}

-(YBKeyboardMoreFunctionView *)moreFunctionView{
    if (_moreFunctionView == nil){
        self.moreFunctionView = [[YBKeyboardMoreFunctionView alloc]init];
        _moreFunctionView.width = self.width;
        _moreFunctionView.height = 216;
        _moreFunctionView.backgroundColor = [UIColor whiteColor];
    }
    return _moreFunctionView;
}

-(YBKeyboardVoiceView *)voiceView{
    if (_voiceView == nil){
        self.voiceView = [[YBKeyboardVoiceView alloc]init];
        _voiceView.width = self.width;
        _voiceView.height = 216;
        _voiceView.backgroundColor = YBRandomColor;
        
    }
    return _voiceView;
}

-(YBKeyboardInputBarButton *)voice_button{
    if (_voice_button == nil){
        YBKeyboardInputBarButton *voice_button = [[YBKeyboardInputBarButton alloc]init];
        [voice_button setTitle:@"语音" forState:UIControlStateNormal];
        [voice_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        voice_button.titleLabel.font = [UIFont systemFontOfSize:12];
        [voice_button addTarget:self action:@selector(voiceAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:voice_button];
        
        _voice_button = voice_button;
    }
    return _voice_button;
}

-(YBKeyboardInputBarButton *)moreFunction_button{
    if (_moreFunction_button == nil){
        YBKeyboardInputBarButton *moreFunction_button = [[YBKeyboardInputBarButton alloc]init];
        [moreFunction_button setTitle:nil forState:UIControlStateNormal];
        [moreFunction_button setNormalStateImageString:@"messages_icon_more" selectedStateImage:@"sms_keyboard"];
        [moreFunction_button addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:moreFunction_button];
        
        _moreFunction_button = moreFunction_button;
    }
    return _moreFunction_button;
}

-(YBKeyboardInputBarButton *)emoj_button{
    if (_emoj_button == nil){
        YBKeyboardInputBarButton *emoj_button = [[YBKeyboardInputBarButton alloc]init];
        
        [emoj_button setTitle:nil forState:UIControlStateNormal];
        [emoj_button setNormalStateImageString:@"messages_icon_empty_status" selectedStateImage:@"sms_keyboard"];
        
        [emoj_button addTarget:self action:@selector(emojAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:emoj_button];
        
        _emoj_button = emoj_button;
    }
    return _emoj_button;
}

-(UIImageView *)textView_bgImageView{
    if (_textView_bgImageView == nil){
        UIImageView *textView_bgImageView = [[UIImageView alloc]init];
        textView_bgImageView.userInteractionEnabled = YES;
        textView_bgImageView.image = [[UIImage imageNamed:@"YBtextView_bgImage@2x"] stretchableImageWithLeftCapWidth:4 topCapHeight:16];
        [self addSubview:textView_bgImageView];
        _textView_bgImageView = textView_bgImageView;
    }
    return _textView_bgImageView;
}

-(YBKeyboardTextView *)input_textView{
    if (_input_textView == nil){
        YBKeyboardTextView *input_textView = [[YBKeyboardTextView alloc]init];
        input_textView.font = [UIFont systemFontOfSize:15];
        input_textView.delegate = self;
        
        [self.textView_bgImageView addSubview:input_textView];
        _input_textView = input_textView;
    }
    return _input_textView;
}

-(UIView *)top_line{
    if (_top_line == nil){
        UIView *top_line = [[UIView alloc]init];
        top_line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:top_line];
        _top_line = top_line;
    }
    return _top_line;
}

-(UIView *)bottom_line{
    if (_bottom_line == nil){
        UIView *bottom_line = [[UIView alloc]init];
        bottom_line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:bottom_line];
        _bottom_line = bottom_line;
    }
    return _bottom_line;
}


/** 判断键盘是否激活 （键盘有没有弹起）*/
-(BOOL)activating{
    if (self.y < (self.superview.height - self.height) ){
        return YES;
    }else{
        return NO;
    } 
}


-(UITextField *)replace_tf{
    if (_replace_tf == nil){
        UITextField *replace_tf = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        replace_tf.hidden = YES;
        replace_tf.delegate = self;
        [self addSubview:replace_tf];
        _replace_tf = replace_tf;
    }
    return _replace_tf;
}

//-(UIView *)test_view{
//    if (_test_view == nil){
//        UIView *test_view = [[UIView alloc]init];
//        test_view.backgroundColor = [UIColor redColor];
//        [self addSubview:test_view];
//        _test_view = test_view;
//    }
//    return _test_view;
//}

-(UIView *)cover_view{
    if (_cover_view == nil){
//        self.cover_view = [[UIView alloc]initWithFrame:self.input_textView.frame];
        _cover_view.backgroundColor = [UIColor clearColor];
        _cover_view.userInteractionEnabled = YES;
        [_cover_view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCoverView:)]];
        [self addSubview:_cover_view];
    }
    return _cover_view;
}


#pragma mark - 初始化和销毁方法

-(void)dealloc{
    [YBNotificationCenter removeObserver:self];
}

+ (instancetype)keyBoardInputBar{
    
    return [[self alloc] init];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setup{
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [YBNotificationCenter addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [YBNotificationCenter addObserver:self selector:@selector(beginEditing) name:UITextViewTextDidBeginEditingNotification object:self.input_textView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didClickEmoji:) name:YBKeyboardDidClickEmojiNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletedEmoji:) name:YBKeyboardDeletedEmojiNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendAction:) name:YBKeyboardSendActionNotification object:nil];
    
    
}



@end
