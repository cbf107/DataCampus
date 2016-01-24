//
//  NSArray+GNUtil.m
//  Untitled
//
//  Created by coreyfu on 14-9-22.
//
//
#import "pinyin.h"
#import "NSArray+GNUtil.h"

@implementation NSArray (GNUtil)

- (NSArray *)fuzzySearchUsingKey:(NSString *)key
{
    if([self count] == 0 || [key length] == 0) return self;
    
    //搜索结果
    NSMutableArray *searchArray = [[NSMutableArray alloc] init];
    
    //搜索关键字
    NSString *searchKey = @"";
    searchKey = [NSString stringWithCString:[key UTF8String] encoding:NSUTF8StringEncoding];
    
    //循环数组
    for(int i = 0; i < [self count]; i++)
    {
        //数据源
        NSString *indexData = self[i];
        
        //搜索关键字有中文
        if([searchKey canBeConvertedToEncoding:NSASCIIStringEncoding]){//将搜索源转换为大写拼音简写（中文为首字母简写）
            NSMutableString *pinyin = [[NSMutableString alloc] init];
            for(int i=0; i<[indexData length];i++)
            {
                NSString *str =[[NSString stringWithFormat:@"%c",pinyinFirstLetter([indexData characterAtIndex:i])] uppercaseString];
                [pinyin appendString:str];
            }
            if([pinyin length] > 0)
                indexData =  pinyin;
        }
        
        int findCount = 0;
        int currentLocation = 0;
        
        //搜索关键字的每一个字符是否存在
        for (int searchIndex = 0; searchIndex < searchKey.length; searchIndex++) {
            
            NSString *currentSearchKey = [searchKey substringWithRange:NSMakeRange(searchIndex,1)];
            
            BOOL notFind = YES;
            while (notFind && [indexData length] > currentLocation ) {
                
                NSComparisonResult result = [indexData compare:currentSearchKey
                                                       options:NSCaseInsensitiveSearch
                                                         range:NSMakeRange(currentLocation, 1)];
                if (result == NSOrderedSame){
                    findCount++;
                    notFind = NO;
                }
                currentLocation++;
            }
        }
        
        //匹配
        if (findCount == searchKey.length) [searchArray addObject:self[i]];
    }
    
    return searchArray;
}

- (NSDictionary *)fuzzySearchGroupResultsByAlphabetUsingKey:(NSString *)key
{
    
    if([self count] == 0) return nil;
    
    //搜索结果
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    
    
    //搜索关键字
    NSString *searchKey = @"";
    if (key) searchKey = [NSString stringWithCString:[key UTF8String] encoding:NSUTF8StringEncoding];

    //搜索关键字长度为0时返回所有元素
    BOOL all = (searchKey.length == 0);
    //循环数组
    for(NSInteger i = 0; i < [self count]; i++)
    {
        //数据源
        NSString *indexData = self[i];
        
        //搜索关键字有中文
        if([searchKey canBeConvertedToEncoding:NSASCIIStringEncoding]){//将搜索源转换为大写拼音简写（中文为首字母简写）
            NSMutableString *pinyin = [[NSMutableString alloc] init];
            for(NSInteger i = 0; i < [indexData length]; i++)
            {
                NSString *str =[[NSString stringWithFormat:@"%c",pinyinFirstLetter([indexData characterAtIndex:i])] uppercaseString];
                [pinyin appendString:str];
            }
            if([pinyin length] > 0)
                indexData =  pinyin;
        }
        
        NSInteger findCount = 0;
        if (!all) {//搜索关键字不为空时逐个判断是否匹配
            
            NSInteger currentLocation = 0;
            //搜索关键字的每一个字符是否存在
            for (NSInteger searchIndex = 0; searchIndex < searchKey.length; searchIndex++) {
                
                NSString *currentSearchKey = [searchKey substringWithRange:NSMakeRange(searchIndex,1)];
                
                BOOL notFind = YES;
                while (notFind && [indexData length] > currentLocation ) {
                    
                    NSComparisonResult result = [indexData compare:currentSearchKey
                                                           options:NSCaseInsensitiveSearch
                                                             range:NSMakeRange(currentLocation, 1)];
                    if (result == NSOrderedSame){
                        findCount++;
                        notFind = NO;
                    }
                    currentLocation++;
                }
            }
        }
        
        //匹配，包含搜索关键字为空和不为空，为空时0==0
        if (findCount == searchKey.length){
            
            NSString *firstLetter = [indexData substringWithRange:NSMakeRange(0,1)];
            
            NSRange range = [ALPHA rangeOfString:firstLetter];
            if (range.location == NSNotFound) firstLetter = @"#";
            
            NSMutableArray *group = resultDic[firstLetter];
            if (!group){
                group = [[NSMutableArray alloc] init];
                [resultDic setObject:group forKey:firstLetter];
            }
            [group addObject:self[i]];
        }
    }
    
    return resultDic;
}

- (NSArray *)binarySearchUsingKey:(NSString *)key
{
    if([self count] < 1) return self;
    
    NSInteger high = self.count - 1;
    NSInteger low = 0;
    
    NSInteger result = -1;

    while(low <= high)
    {
        NSInteger mid = (low + high) / 2;
        int find = [self[mid] compare:key options:NSCaseInsensitiveSearch
                                                     range:NSMakeRange(0, [key length])];
        if(find >= 0)
        {
            result = mid;
            high = mid - 1;
        }else low = mid + 1;
    }
    
    NSMutableArray *searchArray = [[NSMutableArray alloc] init];
    BOOL isFind = NO;
    NSString *searchData = @"";
    searchData = [NSString stringWithCString:[key UTF8String] encoding:NSUTF8StringEncoding];
    
	if([searchData length] > 0)
	{
        for(NSInteger i = result; i < [self count]; i++)
        {
            BOOL result = [self[i] compare:key options:NSCaseInsensitiveSearch
                                                         range:NSMakeRange(0, [key length])];
            if (result == NSOrderedSame)
            {
                [searchArray addObject:self[i]];
                isFind = YES;
            }
            if(isFind == YES && result != NSOrderedSame)
                break;
        }
    }
    
    return searchArray;
}

@end
