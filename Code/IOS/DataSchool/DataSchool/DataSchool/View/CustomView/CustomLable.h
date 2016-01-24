//
//  CustomLable.h
//  ZhiKu
//
//  Created by coreyfu on 15/6/29.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RWLabel : UILabel

@end

@interface BaseLabel : UILabel
- (void)customInit;
@end

/*
 *标注文本
 */
@interface DarkGrayRemarkLabel : BaseLabel
@end
@interface LightGrayRemarkLabel : BaseLabel
@end
@interface GrayRemarkLabel : BaseLabel
@end

/*
 *正文文本
 */
@interface DarkGrayContentLabel : BaseLabel
@end
@interface LightGrayContentLabel : BaseLabel
@end
@interface GrayContentLabel : BaseLabel
@end

/*
 *个人中心文本
 */
@interface MineRowLabel : BaseLabel
@end

/*
 *仅字体颜色为红色
 */
@interface RedFontLabel : BaseLabel
@end
