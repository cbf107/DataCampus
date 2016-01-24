//
//  MenuVCTableViewCell.h
//  ZhiKu
//
//  Created by coreyfu on 15/5/28.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserMenu.h"

@interface MenuVCTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *mMenuName;

@property(nonatomic, strong)NSIndexPath *mIndexPath;


- (void)setInfo:(Menu *)menuItem;
@end
