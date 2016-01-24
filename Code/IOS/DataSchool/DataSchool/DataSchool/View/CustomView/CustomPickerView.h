//
//  CustomPickerView.h
//  MarketEleven
//
//  Created by Bergren Lam on 12/22/14.
//  Copyright (c) 2014 Meinekechina. All rights reserved.
//

@interface CustomPickerView : UIView
@property (nonatomic,strong) id currentValue;

@property (nonatomic, copy)void (^onOkBlock) (id value);
@property (nonatomic, copy)void (^onCacelBlock) (id value);
+(CustomPickerView *)show;
@end
