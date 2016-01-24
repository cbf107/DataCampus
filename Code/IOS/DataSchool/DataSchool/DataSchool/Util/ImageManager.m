//
//  ImageManager.m
//
//  Created by apple on 14-2-21.
//  Copyright (c) 2014年 coreyfu. All rights reserved.
//

#import "ImageManager.h"

@implementation ImageManager

+ (UIImage *)imageOfType:(EImageNameType)type
{
    UIEdgeInsets edgeNone = UIEdgeInsetsMake(-1, -1, -1, -1);
    UIEdgeInsets edgeInsets = edgeNone;
    
    NSString *name = [ImageManager nameOfType:type edgeInsets:&edgeInsets];
    
    UIImage *image = [UIImage imageNamed:name];
    
    if (UIEdgeInsetsEqualToEdgeInsets(edgeInsets, edgeNone)) return image;
    
    return [image resizableImageWithCapInsets:edgeInsets];
}

+ (NSString *)nameOfType:(EImageNameType)t edgeInsets:(UIEdgeInsets *)insets
{
    switch (t) {
        case EImage_Home_Water_Bg:
            *insets = UIEdgeInsetsMake(2, 2, 2, 2);
            return @"water-carriage_bg";
   
        case EImage_Home_Visitor_Bg:
            *insets = UIEdgeInsetsMake(2, 2, 2, 2);
            return @"visitor_bg";
            
        case EImage_Home_Service_Bg:
            *insets = UIEdgeInsetsMake(2, 2, 2, 2);
            return @"service_bg";

        case EImage_Home_Clean_Bg:
            *insets = UIEdgeInsetsMake(2, 2, 2, 2);
            return @"clean_bg";
            
        case EImage_Home_CarWash_Bg:
            *insets = UIEdgeInsetsMake(2, 2, 2, 2);
            return @"car-wash_bg";
            
        case EImage_Home_Contect_Bg:
            *insets = UIEdgeInsetsMake(2, 2, 2, 2);
            return @"contact-property_bg";
            
        case EImage_Home_Express_Bg:
            *insets = UIEdgeInsetsMake(2, 2, 2, 2);
            return @"express_bg";
            
        case EImage_Home_Eat_Bg:
            *insets = UIEdgeInsetsMake(2, 2, 2, 2);
            return @"eat_bg";
            
        case EImage_TabBar_Bg:
            *insets = UIEdgeInsetsMake(1, 0, 0, 0);
            return @"home_bottom-tab_bg_normal";
            
        case EImage_TabBar_Select:
            *insets = UIEdgeInsetsMake(1, 0, 0, 0);
            return @"home_bottom-tab_bg_selected";
            
        case EImage_Personal_Btn_Normal:
            *insets = UIEdgeInsetsMake(2, 2, 2, 2);
            return @"personal_bg_btn_signin_normal";
            
        case EImage_Personal_Btn_Select:
            *insets = UIEdgeInsetsMake(2, 2, 2, 2);
            return @"personal_bg_btn_signin_selected";
            
        case EImage_Edit_Region_Bg:
            *insets = UIEdgeInsetsMake(2, 2, 2, 2);
            return @"bg_inputbox";
            
        case EImage_Default_Photo:
            return nil;

        default:
            break;
    }
    
    return nil;
}
@end
