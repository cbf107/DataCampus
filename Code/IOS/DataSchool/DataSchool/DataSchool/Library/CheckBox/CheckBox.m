//
//  CheckBox.m
//  ZhiKu
//
//  Created by Bergren Lam on 15/5/24.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import "CheckBox.h"

@interface CheckBox()

@property(nonatomic,retain)UIImage *onImage;
@property(nonatomic,retain)UIImage *offImage;

@end

@implementation CheckBox

 - (id)initWithFrame:(CGRect)frame{
     self = [super initWithFrame:frame];
     if (self) {
         // Initialization code
     }
     
     return self;
}

-(id)initWithText:(NSString *)text frame:(CGRect)frame imageType:(int)type{
     self=[super initWithFrame:frame];
     if(self){
         _text=text;
         self.backgroundColor=[UIColor clearColor];
         if (type == 0) {
             self.onImage=[UIImage imageNamed:@"clean_cleanicon.png"];//选中图片
             self.offImage=[UIImage imageNamed:@"clean_dateicon.png"];//取消图片
         }else if(type == 1){
             self.onImage=[UIImage imageNamed:@"regid_check.png"];//选中图片
             self.offImage=[UIImage imageNamed:@"regid_uncheck.png"];//取消图片
         }
      }
     
     return self;
}

-(void)setChecked:(BOOL)checked{
    _checked=checked;
    //注册代理事件，通知状态改变
    if([self.delegate  respondsToSelector:@selector(onChangeDelegate:isCheck:)]){
        [self.delegate onChangeDelegate:self isCheck:_checked];
    }
    
    [self setNeedsDisplay];
}

 -(void)drawRect:(CGRect)rect{
     //将text,image绘制到UIView上面
     UIImage *image=self.checked?self.onImage:self.offImage;
     [image drawInRect:rect];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //self.checked = !self.checked;
}

@end

