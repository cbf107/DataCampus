//
//  RelationshipTableViewCell.h
//  ZhiKu
//
//  Created by coreyfu on 15/5/28.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumFolder.h"

@interface AlbumTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *mInfoIcon;
@property (nonatomic, weak) IBOutlet UILabel *mTitleLable;
@property (nonatomic, weak) IBOutlet UILabel *mSubTitleLable;


@property(nonatomic, strong)NSIndexPath *mIndexPath;

- (void)setInfo:(AlbumFolder *)info;

@end
