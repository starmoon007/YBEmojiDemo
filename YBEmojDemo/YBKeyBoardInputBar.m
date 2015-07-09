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





@interface YBKeyBoardInputBar ()<UITextFieldDelegate>

/** 录音按钮 */
@property (weak, nonatomic) IBOutlet YBKeyboardInputBarButton *voice_button;

/** 更多按钮 */
@property (weak, nonatomic) IBOutlet YBKeyboardInputBarButton *moreFunction_button;

/** 标签按钮 */
@property (weak, nonatomic) IBOutlet YBKeyboardInputBarButton *emoj_button;

/** 文本输入框 */
@property (weak, nonatomic) IBOutlet UITextView *input_textView;


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



@end


@implementation YBKeyBoardInputBar


/** 录音按钮点击响应 */
- (IBAction)voiceAction:(UIButton *)voice_button {
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
- (IBAction)emojAction:(UIButton *)emojButton {
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
- (IBAction)moreAction:(UIButton *)moreFunction_button {
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
    CGFloat height = super_view.height;
    if (inWindow){
        height = super_view.height - self.height;
    }
    
    if (self.superview == nil){
        [super_view addSubview:self];
        self.x = 0;
        self.y = height ;
    }
//    [self.input_textView becomeFirstResponder];
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

- (void)endEditing{
//    NSLog(@"endEditing");
//    [self endEditing:YES];
    
    
}

- (void)changeText{
//    NSLog(@"changeText");
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

-(UIView *)cover_view{
    if (_cover_view == nil){
        self.cover_view = [[UIView alloc]initWithFrame:self.input_textView.frame];
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
    YBKeyBoardInputBar *inputbar = [[[NSBundle mainBundle] loadNibNamed:@"YBKeyBoardInputBar" owner:nil options:nil] lastObject];
    inputbar.width = [UIScreen mainScreen].bounds.size.width;
    return inputbar;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [YBNotificationCenter addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [YBNotificationCenter addObserver:self selector:@selector(beginEditing) name:UITextViewTextDidBeginEditingNotification object:self.input_textView];
        [YBNotificationCenter addObserver:self selector:@selector(endEditing) name:UITextViewTextDidEndEditingNotification object:self.input_textView];
        [YBNotificationCenter addObserver:self selector:@selector(changeText) name:UITextViewTextDidChangeNotification object:self.input_textView];
    }
    return self;
}


-(void)awakeFromNib{
    [self.moreFunction_button setTitle:nil forState:UIControlStateNormal];
    [self.moreFunction_button setNormalStateImageString:@"messages_icon_more" selectedStateImage:@"sms_keyboard"];
    
    [self.emoj_button setTitle:nil forState:UIControlStateNormal];
    [self.emoj_button setNormalStateImageString:@"messages_icon_empty_status" selectedStateImage:@"sms_keyboard"];
}





@end
