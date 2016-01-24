//
//  RelationshipTableViewCell.h
//  ZhiKu
//
//  Created by coreyfu on 15/5/28.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThumbnailInfo.h"

@interface ThumbnailCollectionCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *mThumbnail;
@property (nonatomic, assign)BOOL isDisplayingPlaceholderNow;

@property(nonatomic, strong)NSIndexPath *mIndexPath;

- (void)setInfo:(ThumbnailInfo *)info;

@end
