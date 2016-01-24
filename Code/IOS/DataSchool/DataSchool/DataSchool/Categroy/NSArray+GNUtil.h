//
//  NSArray+GNUtil.h
//  Untitled
//
//  Created by coreyfu on 14-9-22.
//
//

#import <Foundation/Foundation.h>

@interface NSArray (GNUtil)
//模糊查找,连续和非连续查找
//如@[@"李小明",@"李小小",@"孙小雷",@"刘明",@"Adbey",@"hlnm",@"adBey",@"小小"]
//查找@"lm"，返回@[@"李小明",@"刘明",@"hlnm"]
- (NSArray *)fuzzySearchUsingKey:(NSString *)key;//模糊查找中，英文

//返回键值对，键为@"ABCDEFGHIJKLMNOPQRSTUVWXYZ#"之一，因为NSDictionary的allKeys或allValues的顺序是没定义的，所以方法内没有进行排序，如果掉用方需要根据字母排序的话自己先对键排序，然后再根据键取对应的值数组
- (NSDictionary *)fuzzySearchGroupResultsByAlphabetUsingKey:(NSString *)key;//模糊查找中，英文,结果按字母分组

//二分查找，只能查找连续字符
- (NSArray *)binarySearchUsingKey:(NSString *)key;
@end
