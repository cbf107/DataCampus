//
//  ChatMessageContentButton.m
//  BloodSugarForDoc
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 shake. All rights reserved.
//

#import "ChatMessageContentButton.h"
#import "AudioPlay.h"
#import "UUImageAvatarBrowser.h"
#import "UIImageView+WebCache.h"


@interface ChatMessageContentButton ()<AudioPlayDelegate>
//bubble imgae
@property (nonatomic, strong) UIImageView *backImageView;
//audio
@property (nonatomic, strong) UIImageView *voice;
@property (nonatomic, strong) UIImageView *picture;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@end

@implementation ChatMessageContentButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self commonInit];

    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.titleLabel.font = ChatContentFont;
    self.titleLabel.numberOfLines = 0;
    
    [self addTarget:self action:@selector(btnContentClick:)  forControlEvents:UIControlEventTouchUpInside];

    //图片
    self.backImageView = [[UIImageView alloc] init];
    self.backImageView.userInteractionEnabled = YES;
    self.backImageView.layer.cornerRadius = 5;
    self.backImageView.layer.masksToBounds  = YES;
    self.backImageView.backgroundColor = [UIColor yellowColor];
    [self addSubview:self.backImageView];
    
    //语音
    
    UIImage *img = [UIImage imageNamed:@"voicePlaying3"];
    CGSize s = img.size;
    self.voice = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, s.width, s.height)];
    self.voice.image = [UIImage imageNamed:@"voicePlaying3"];
    self.voice.animationImages = [NSArray arrayWithObjects:
                                  [UIImage imageNamed:@"voicePlaying0"],
                                  [UIImage imageNamed:@"voicePlaying1"],
                                  [UIImage imageNamed:@"voicePlaying2"],
                                  [UIImage imageNamed:@"voicePlaying3"],nil];
    self.voice.animationDuration = 2;
    self.voice.animationRepeatCount = NSIntegerMax;
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicator.hidden = YES;
    
    [self addSubview:self.indicator];
    [self addSubview:self.voice];
    
    self.backImageView.userInteractionEnabled = NO;
    self.voice.userInteractionEnabled = NO;
    
    self.voice.backgroundColor = [UIColor clearColor];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioPlayerDidFinishPlay) name:@"VoicePlayHasInterrupt" object:nil];
}

-(void)stopPlay
{
    [self.voice stopAnimating];
    self.voice.image = [UIImage imageNamed:@"voicePlaying3"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setEnableLongPress:(BOOL)enable{
    _enableLongPress = enable;
    
    if (enable) {
        //button长按事件
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLongPress:)];
        longPress.minimumPressDuration = 0.8; //定义按的时间
        [self addGestureRecognizer:longPress];
    }
}

- (void)setMessageFrame:(ChatMessageFrame *)mf
{
    _messageFrame = mf;
 
    [self setTitle:@"" forState:UIControlStateNormal];
    self.voice.hidden = YES;
    self.backImageView.hidden = YES;
    
    self.frame = mf.contentF;
    self.indicator.center = CGPointMake(mf.contentF.size.width * 0.5, mf.contentF.size.height * 0.5);

    //背景气泡图
    UIImage *normal;
    CGRect r = self.voice.frame;

    if (mf.message.fromType == EChatMessageFromMe) {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.contentEdgeInsets = UIEdgeInsetsMake(ChatContentMarginV, ChatContentMarginRight, ChatContentMarginV, ChatContentMarginLeft);
        
        normal = [UIImage imageNamed:@"relationship_blue_bg"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(18, 15, 15, 25)];
        
        r.origin.x = self.width - 8 - r.size.width;

    }else{
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.contentEdgeInsets = UIEdgeInsetsMake(ChatContentMarginV, ChatContentMarginLeft, ChatContentMarginV, ChatContentMarginRight);
        
        normal = [UIImage imageNamed:@"relationship_gray_bg"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(18, 25, 15, 15)];
        
        r.origin.x = 8;

    }
    [self setBackgroundImage:normal forState:UIControlStateNormal];
    [self setBackgroundImage:normal forState:UIControlStateHighlighted];
    self.voice.frame = r;

    switch (mf.message.messageType) {
        case EChatMessageTypeText:
            [self setTitle:mf.message.strContent forState:UIControlStateNormal];
            break;
        case EChatMessageTypePicture:
        {
            self.backImageView.hidden = NO;
            if (mf.message.picture) {
                self.backImageView.image = mf.message.picture;
            } else {
                [self.backImageView sd_setImageWithURL:MAKE_IMG_URL(mf.message.pictureUrl)];
            }
            
            CGRect frame = self.frame;
            if (mf.message.fromType == EChatMessageFromMe) {
                frame.origin.x = 15;
            } else {
                frame.origin.x = 25;
            }
            frame.origin.y = 18;
            frame.size.width -= 40;
            frame.size.height -= 33;
            
            [self.backImageView setFrame:frame];
        }
            break;
        case EChatMessageTypeVoice:
        {
            self.voice.hidden = NO;
            CGRect frame = self.voice.frame;
            if (mf.message.fromType == EChatMessageFromMe) {
                frame.origin.x = 15;
            } else {
                frame.origin.x = 25;
            }
            
            [self.voice setFrame:frame];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)btnContentClick:(ChatMessageContentButton *)btn{
    //play audio
    
    ChatMessage *message = self.messageFrame.message;
    
    if (message.messageType == EChatMessageTypeVoice) {
        
        AudioPlay *player = [AudioPlay sharedInstance];
        
        if ([player playing]) {
            
            [player stopSound];

            //可能是self或其他button处于playing状态
            [[NSNotificationCenter defaultCenter] postNotificationName:@"stopSelfIfAnotherBegain" object:nil];

            //播放当前点击
            //[btn stopPlay];

        }else{
            player.delegate = self;
            
            if (message.voiceWav) {
                [player playSongWithData:message.voiceWav];
            }else if (message.voiceAmrUrl){
                [player playSongWithUrl:message.voiceAmrUrl];
            }
        }
    }
    //show the picture
    else if (message.messageType == EChatMessageTypePicture)
    {
        if (self.backImageView) {
            [UUImageAvatarBrowser showImage:self.backImageView];
        }
//        if ([self.delegate isKindOfClass:[UIViewController class]]) {
//            [[(UIViewController *)self.delegate view] endEditing:YES];
//        }
    }
    // show text and gonna copy that
    else if (message.messageType == EChatMessageTypeText)
    {
        //nothing
    }
}

-(void)btnLongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        if (self.messageFrame.message.messageType == EChatMessageTypeText || self.messageFrame.message.messageType == EChatMessageTypeVoice){
            
            [self becomeFirstResponder];
            
            UIMenuController *menu = [UIMenuController sharedMenuController];
            
            [menu setTargetRect:self.frame inView:self.superview];
            [menu setMenuVisible:YES animated:YES];
            
        }
    }
}

- (void)stopSelfIfAnotherBegain{
    [self stopPlay];
}

#pragma mark AudioPlayDelegate delegate

- (void)audioPlayerBeiginLoadVoice
{
    self.voice.hidden = YES;
    [self.indicator startAnimating];
}

- (void)audioPlayerFinishLoadVoice
{
    self.voice.hidden = NO;

    [self.indicator stopAnimating];
}

- (void)audioPlayerBeiginPlay
{
    [self.indicator stopAnimating];
    [self.voice startAnimating];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopSelfIfAnotherBegain) name:@"stopSelfIfAnotherBegain" object:nil];

}
- (void)audioPlayerDidFinishPlay
{
    [self stopPlay];
    [[AudioPlay sharedInstance] stopSound];
}


#pragma mark copy delete method

//添加
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    if (self.messageFrame.message.messageType == EChatMessageTypeText){
        
        return (action == @selector(copy:) || action == @selector(delete:));
        
    }else if (self.messageFrame.message.messageType == EChatMessageTypeVoice){
        return (action == @selector(delete:));
    }
    
    return NO;
}

-(void)copy:(id)sender{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.titleLabel.text;
}

- (void)delete:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatMessageContentButtonDeleteMessage:)])  {
        [self.delegate chatMessageContentButtonDeleteMessage:self.messageFrame.message];
    }
}

@end
