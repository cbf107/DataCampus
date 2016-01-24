//
//  LeveyPopListViewCell.m
//  LeveyPopListViewDemo
//
//  Created by Levey on 2/21/12.
//  Copyright (c) 2012 Levey. All rights reserved.
//

#import "LeveyPopListViewCell.h"

@implementation LeveyPopListViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"6d9ccb"];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.];
        
        
        if (!self.mTextMoney) {
            self.mTextMoney = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-100, self.frame.origin.y+5, 40, self.frame.size.height-10)];
            self.mTextMoney.textColor = [UIColor whiteColor];
            self.mTextMoney.font = [UIFont fontWithName:@"Helvetica" size:15.];
            [self addSubview:self.mTextMoney];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectOffset(self.imageView.frame, 6, 0);
    self.textLabel.frame = CGRectOffset(self.textLabel.frame, 6, 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
