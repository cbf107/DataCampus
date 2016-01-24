//
//  RelationshipTableViewCell.m
//  ZhiKu
//
//  Created by coreyfu on 15/5/28.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import "ThumbnailCollectionCell.h"
#import "ImageManager.h"
#import "UIImageView+WebCache.h"

@implementation ThumbnailCollectionCell
- (void)awakeFromNib {
    //self.selectionStyle =  UITableViewCellSelectionStyleNone;
    self.isDisplayingPlaceholderNow = YES;
}

/*- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}*/

- (void)setInfo:(ThumbnailInfo *)info {
    //[self.mThumbnail sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kServerAddressTest, [UserManager currentUser].Icon]] placeholderImage:[ImageManager imageOfType:EImage_Default_Photo]];

    [self.mThumbnail sd_setImageWithURL:[NSURL URLWithString:info.ThumbnailURL] placeholderImage:nil options:SDWebImageHandleCookies completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error && [imageURL isEqual:info.ThumbnailURL]) {
            // fade in animation
            _isDisplayingPlaceholderNow = NO;
        }
    }];
}
@end
