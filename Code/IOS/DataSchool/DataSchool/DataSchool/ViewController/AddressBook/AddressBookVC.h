//
//  Register2VC.h
//  ZhiKu
//
//  Created by mac on 15/5/22.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import <UIKit/UIKit.h>
/*@interface TKAddressBook : NSObject {
    NSInteger sectionNumber;
    NSInteger recordID;
    NSString *name;
    NSString *tel;
}
@property NSInteger sectionNumber;
@property NSInteger recordID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *tel;

@end*/

@interface AddressBookVC : UITableViewController
@property (nonatomic, copy) NSMutableArray *addressBookTemp;
@property(nonatomic,retain) NSMutableArray *indexArray;
@property(nonatomic,retain) NSMutableArray *LetterResultArr;
@property(nonatomic,retain) NSArray<TKAddressBook> *statusAddressBook;

@end
