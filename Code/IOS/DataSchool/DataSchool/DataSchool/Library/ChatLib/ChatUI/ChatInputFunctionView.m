//
//  UUInputFunctionView.m
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "ChatInputFunctionView.h"
#import "AudioRecord.h"
#import "UUProgressHUD.h"
@interface ChatInputFunctionView ()<UITextViewDelegate,AudioRecordDelegate>
{
    BOOL isbeginVoiceRecord;
    AudioRecord *voiceRecord;
    NSInteger playTime;
    NSTimer *playTimer;
    
    UILabel *placeHold;

}
@end

@implementation ChatInputFunctionView

- (id)initWithSuperVC:(UIViewController *)superVC
{
    self.superVC = superVC;
    CGFloat VCWidth = Main_Screen_Width;
    
    CGFloat allHeight = 58;
    CGFloat h = 31;//图片长宽
    CGFloat y = (allHeight - h) * 0.5;

    CGRect frame = CGRectMake(0, superVC.view.frame.size.height-allHeight, VCWidth, allHeight);
    
    self = [super initWithFrame:frame];
    if (self) {
        voiceRecord = [[AudioRecord alloc] initWithDelegate:self];
        self.backgroundColor = [UIColor whiteColor];
        //发送消息
        self.btnSendMessage = [[UIButton alloc] initWithFrame:CGRectMake(VCWidth - 60, (allHeight - 30) * 0.5, 60, 30)];
        self.isAbleToSendTextMessage = NO;
        self.btnSendMessage.titleLabel.font = [UIFont systemFontOfSize:kAppFontSizeTitle];
        [self.btnSendMessage setTitleColor:[UIColor appFontColorDark] forState:UIControlStateNormal];
        [self changeSendBtnWithPhoto:YES];
        [self.btnSendMessage addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        //ViewBorderRadius(self.btnSendMessage, 4, 0.5, [UIColor appFontColorLight]);
        
        [self addSubview:self.btnSendMessage];
        
        //改变状态（语音、文字）
        self.btnChangeVoiceState = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnChangeVoiceState.frame = CGRectMake(0, 0, h + kAppMarginSpaceH * 2, allHeight);
        isbeginVoiceRecord = NO;
        [self.btnChangeVoiceState setImage:[UIImage imageNamed:@"voice_icon"] forState:UIControlStateNormal];
        self.btnChangeVoiceState.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.btnChangeVoiceState addTarget:self action:@selector(voiceRecord:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnChangeVoiceState];

        //语音录入键
        self.btnVoiceRecord = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnVoiceRecord.frame = CGRectMake(self.btnChangeVoiceState.right, y, Main_Screen_Width - self.btnChangeVoiceState.width - self.btnSendMessage.width, h);
        self.btnVoiceRecord.hidden = YES;
        self.btnVoiceRecord.layer.masksToBounds = YES;
        ViewBorderRadius(self.btnVoiceRecord, 4, 0.5, [UIColor appFontColorLight]);
        //[self.btnVoiceRecord setBackgroundImage:[UIImage imageNamed:@"chat_message_back"] forState:UIControlStateNormal];
        [self.btnVoiceRecord setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.btnVoiceRecord setTitleColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        self.btnVoiceRecord.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.btnVoiceRecord setTitle:@"按下 说话" forState:UIControlStateNormal];
        [self.btnVoiceRecord setTitle:@"放开 确定" forState:UIControlStateHighlighted];
        [self.btnVoiceRecord addTarget:self action:@selector(beginRecordVoice:) forControlEvents:UIControlEventTouchDown];
        [self.btnVoiceRecord addTarget:self action:@selector(endRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnVoiceRecord addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside];
        [self.btnVoiceRecord addTarget:self action:@selector(interruptRecordVoice:) forControlEvents:UIControlEventTouchCancel];

        [self.btnVoiceRecord addTarget:self action:@selector(RemindDragExit:) forControlEvents:UIControlEventTouchDragExit];
        [self.btnVoiceRecord addTarget:self action:@selector(RemindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
        [self addSubview:self.btnVoiceRecord];
        
        //输入框
        self.textViewInput = [[UITextView alloc] initWithFrame:self.btnVoiceRecord.frame];
        self.textViewInput.layer.masksToBounds = YES;
        self.textViewInput.font = [UIFont systemFontOfSize:kAppFontSizeContent];
        self.textViewInput.delegate = self;
        ViewBorderRadius(self.textViewInput, 4, 0.5, [UIColor appFontColorLight]);

        [self addSubview:self.textViewInput];
        
        //输入框的提示语
        placeHold = [[UILabel alloc] initWithFrame:CGRectMake(5, 1, self.textViewInput.width, self.textViewInput.height)];
        placeHold.text = @"请输入文字留言";
        placeHold.textColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
        placeHold.font = [UIFont systemFontOfSize:12];
        [self.textViewInput addSubview:placeHold];
        
        //分割线
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
        
        //添加通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewDidEndEditing:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

#pragma mark - 录音touch事件

-(BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                bCanRecord = YES;
            }else {
                bCanRecord = NO;
            }
        }];
    }
    
    return bCanRecord;
}

- (void)beginRecordVoice:(UIButton *)button
{
    if ([self canRecord]) {
        [voiceRecord startRecord];
        playTime = 0;
        playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countVoiceTime) userInfo:nil repeats:YES];
        [UUProgressHUD show];
        
    } else {
        [UIAlertView showWithTitle:@"温馨提示" message:@"请在“设置-隐私-麦克风”选项中允许访问你的麦克风"];
    }
    
}

- (void)endRecordVoice:(UIButton *)button
{
    if (playTimer) {
        [voiceRecord stopRecord];
        [playTimer invalidate];
        playTimer = nil;
    }
}

- (void)cancelRecordVoice:(UIButton *)button
{
    if (playTimer) {
        [voiceRecord cancelRecord];
        [playTimer invalidate];
        playTimer = nil;
    }
    [UUProgressHUD dismissWithError:@"取消录音"];
}

- (void)interruptRecordVoice:(UIButton *)button
{
    if (playTimer) {
        [voiceRecord cancelRecord];
        [playTimer invalidate];
        playTimer = nil;
    }
    [UUProgressHUD dismissWithError:nil];
}

- (void)RemindDragExit:(UIButton *)button
{
    [UUProgressHUD changeTitle:@"释放取消录音"];
}

- (void)RemindDragEnter:(UIButton *)button
{
    [UUProgressHUD changeTitle:@"滑动取消录音"];
}


- (void)countVoiceTime
{
    playTime ++;
    if (playTime >= 300) {
        [self endRecordVoice:nil];
    }
}

#pragma mark - Mp3RecorderDelegate

//回调录音资料
- (void)audioRecordEndConvertWavData:(NSData *)data toAmrData:(NSData *)voiceData
{
    [self.delegate chatInputFunctionView:self sendVoiceWav:data voiceAmr:voiceData time:playTime+1];
    [UUProgressHUD dismissWithSuccess:@"录音成功"];
   
    //缓冲消失时间 (最好有block回调消失完成)
    self.btnVoiceRecord.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.btnVoiceRecord.enabled = YES;
    });
}

- (void)audioRecordFailRecord
{
    [UUProgressHUD dismissWithSuccess:@"录音失败"];
    
    //缓冲消失时间 (最好有block回调消失完成)
    self.btnVoiceRecord.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.btnVoiceRecord.enabled = YES;
    });
}

//改变输入与录音状态
- (void)voiceRecord:(UIButton *)sender
{
    self.btnVoiceRecord.hidden = !self.btnVoiceRecord.hidden;
    self.textViewInput.hidden  = !self.textViewInput.hidden;
    isbeginVoiceRecord = !isbeginVoiceRecord;
    
    self.btnSendMessage.hidden = isbeginVoiceRecord;
    self.btnMore.hidden = isbeginVoiceRecord;

    if (isbeginVoiceRecord) {
        [self.btnChangeVoiceState setImage:[UIImage imageNamed:@"keybord_icon"] forState:UIControlStateNormal];
        
        CGRect r = self.btnVoiceRecord.frame;
        r.size.width += 47;
        self.btnVoiceRecord.frame = r;
        self.textViewInput.frame = r;

        [self.textViewInput resignFirstResponder];
    }else{
        [self.btnChangeVoiceState setImage:[UIImage imageNamed:@"voice_icon"] forState:UIControlStateNormal];
        
        CGRect r = self.textViewInput.frame;
        r.size.width -= 47;
        self.textViewInput.frame = r;
        self.btnVoiceRecord.frame = r;

        [self.textViewInput becomeFirstResponder];
    }
}

//发送消息（文字图片）
- (void)sendMessage:(UIButton *)sender
{
    if (self.isAbleToSendTextMessage) {
        [self.textViewInput resignFirstResponder];

        NSString *resultStr = self.textViewInput.text;
        if (resultStr.length > 0) {
            [self.delegate chatInputFunctionView:self sendMessage:resultStr];
            self.textViewInput.text = @"";
        }
        placeHold.hidden = self.textViewInput.text.length > 0;

        [self changeSendBtnWithPhoto:self.textViewInput.text.length>0?NO:YES];
    }else{
        [self.textViewInput resignFirstResponder];
        UIActionSheet *actionSheet= [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"图片",nil];
        [actionSheet showInView:self.window];
    }
}


#pragma mark - TextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (self.textViewInput.text.length > 0) {
        placeHold.hidden = YES;
    } else {
        placeHold.hidden = NO;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self changeSendBtnWithPhoto:textView.text.length>0?NO:YES];
    placeHold.hidden = textView.text.length > 0;
}

- (void)changeSendBtnWithPhoto:(BOOL)isPhoto
{
    self.isAbleToSendTextMessage = !isPhoto;
    [self.btnSendMessage setTitle:isPhoto?@"":@"发送" forState:UIControlStateNormal];
    //self.btnSendMessage.frame = RECT_CHANGE_width(self.btnSendMessage, isPhoto?30:35);
    UIImage *image = [UIImage imageNamed:@"Chat_take_picture"];
    [self.btnSendMessage setImage:(isPhoto?image:nil) forState:UIControlStateNormal];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.textViewInput.text.length > 0) {
        placeHold.hidden = YES;
    } else {
        placeHold.hidden = NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - Add Picture
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self addCarema];
    }else if (buttonIndex == 1){
        [self openPicLibrary];
    }
}

-(void)addCarema{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.superVC presentViewController:picker animated:YES completion:^{}];
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备不支持拍照功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)openPicLibrary{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.superVC presentViewController:picker animated:YES completion:^{
        }];
    }
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.superVC dismissViewControllerAnimated:YES completion:^{
        [self.delegate chatInputFunctionView:self sendPicture:editImage];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.superVC dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
