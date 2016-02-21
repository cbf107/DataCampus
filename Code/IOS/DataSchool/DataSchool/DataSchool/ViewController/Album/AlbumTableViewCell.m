//
//  RelationshipTableViewCell.m
//  ZhiKu
//
//  Created by coreyfu on 15/5/28.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import "AlbumTableViewCell.h"

@implementation AlbumTableViewCell
- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setInfo:(AlbumFolder *)info {
    //NSString *strURL = [NSString stringWithFormat:@"%@%@", kServerAddressTest,info.Thumbnail];
    [self.mInfoIcon sd_setImageWithURL:[NSURL URLWithString:info.Thumbnail] placeholderImage:[UIImage imageNamed:@"cellIcon"]];

    [self.mTitleLable setText:info.AlbumName];
    
    NSString *sNum = [NSString stringWithFormat:@"共%d张", info.Number];
    [self.mSubTitleLable setText:sNum];
}
@end
