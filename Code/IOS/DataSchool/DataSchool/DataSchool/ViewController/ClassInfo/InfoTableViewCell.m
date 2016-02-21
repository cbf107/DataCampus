//
//  RelationshipTableViewCell.m
//  ZhiKu
//
//  Created by coreyfu on 15/5/28.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import "InfoTableViewCell.h"
#import "ImageManager.h"
#import "UIImageView+WebCache.h"

@implementation InfoTableViewCell
- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setInfo:(ClassNotice *)info {
    [self.mTitleLable setText:info.Title];
    [self.mSubTitleLable setText:info.Content];
    
    //NSString *strURL = [NSString stringWithFormat:@"%@%@", kServerAddressTest,info.Img];
    NSString *strURL = info.TypeIcon;
    [self.mInfoIcon sd_setImageWithURL:[NSURL URLWithString:strURL] placeholderImage:[UIImage imageNamed:@"cellIcon"]];
}
@end
