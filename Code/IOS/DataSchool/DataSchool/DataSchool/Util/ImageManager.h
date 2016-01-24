//
//  ImageManager.h
//
//  Created by apple on 14-2-21.
//  Copyright (c) 2014年 coreyfu. All rights reserved.
//

typedef NS_ENUM(NSInteger, EImageNameType)
{
    //common images
    EImage_Home_Water_Bg = 0,       //主页送水按钮呢背景
    EImage_Home_Visitor_Bg,         //主页访客按钮呢背景
    EImage_Home_Service_Bg,         //主页维修按钮呢背景
    EImage_Home_Clean_Bg,           //主页清洁呢背景
    EImage_Home_CarWash_Bg,         //主页洗车按钮呢背景
    EImage_Home_Contect_Bg,         //主页联络按钮呢背景
    EImage_Home_Express_Bg,         //主页快递按钮呢背景
    EImage_Home_Eat_Bg,             //主页吃饭按钮呢背景
    
    EImage_TabBar_Bg,
    EImage_TabBar_Select,
    
    EImage_Personal_Btn_Normal,
    EImage_Personal_Btn_Select,
    
    EImage_Edit_Region_Bg,

    EImage_Default_Photo
};

@interface ImageManager : NSObject

/*
 * 根据图片类型获取图片
 * @type 图片类型
 */
+ (UIImage *)imageOfType:(EImageNameType)type;
@end
