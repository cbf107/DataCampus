//
//  ChineseString.m
//  YUChineseSorting
//
//  Created by yuzhx on 15/4/19.
//  Copyright (c) 2015年 BruceYu. All rights reserved.
//

#import "CityString.h"

@implementation CityString
@synthesize mCommData;
@synthesize pinYin;

#pragma mark - 返回tableview右方 indexArray
+(NSMutableArray*)IndexArray:(NSArray*)commDataArr
{
    NSMutableArray *tempArray = [self ReturnSortChineseArrar:commDataArr];
    NSMutableArray *A_Result=[NSMutableArray array];
    NSString *tempString ;
    
    for (CityString* object in tempArray)
    {
        if (((CityString*)object).pinYin.length > 0) {
            NSString *pinyin = [((CityString*)object).pinYin substringToIndex:1];
            //不同
            if(![tempString isEqualToString:pinyin])
            {
                // NSLog(@"IndexArray----->%@",pinyin);
                [A_Result addObject:pinyin];
                tempString = pinyin;
            }

        }
    }
    return A_Result;
}

#pragma mark - 返回联系人
+(NSMutableArray*)LetterSortArray:(NSArray*)commDataArr
{
    NSMutableArray *tempArray = [self ReturnSortChineseArrar:commDataArr];
    NSMutableArray *LetterResult=[NSMutableArray array];
    NSMutableArray *item = [NSMutableArray array];
    NSString *tempString ;
    //拼音分组
    for (NSString* object in tempArray) {
        if (((CityString*)object).pinYin.length > 0) {
            NSString *pinyin = [((CityString*)object).pinYin substringToIndex:1];
            CommPropData *commData = ((CityString*)object).mCommData;
            //不同
            if(![tempString isEqualToString:pinyin])
            {
                //分组
                item = [NSMutableArray array];
                [item  addObject:commData];
                [LetterResult addObject:item];
                //遍历
                tempString = pinyin;
            }else//相同
            {
                [item  addObject:commData];
            }

        }
    }
    return LetterResult;
}

//过滤指定字符串   里面的指定字符根据自己的需要添加
+(NSString*)RemoveSpecialCharacter: (NSString *)str {
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @",.？、 ~￥#&<>《》()[]{}【】^@/￡¤|§¨「」『』￠￢￣~@#&*（）——+|《》$_€"]];
    if (urgentRange.location != NSNotFound)
    {
        return [self RemoveSpecialCharacter:[str stringByReplacingCharactersInRange:urgentRange withString:@""]];
    }
    return str;
}

///////////////////
//
//返回排序好的字符拼音
//
///////////////////
+(NSMutableArray*)ReturnSortChineseArrar:(NSArray*)commDataArr
{
    //获取字符串中文字的拼音首字母并与字符串共同存放
    NSMutableArray *cityStringsArray=[NSMutableArray array];
    for(int i=0;i<[commDataArr count];i++)
    {
        CityString *cityString=[[CityString alloc]init];
        //TKAddressBook *sContact = [contactArr objectAtIndex:i];
        //chineseString.addressBook.name=sContact.name;
        
        CommPropData *commData = [commDataArr objectAtIndex:i];
        cityString.mCommData = commData;
        if(cityString.mCommData.sName.length == 0){
            cityString.mCommData.sName=@"";
        }
        //去除两端空格和回车
        cityString.mCommData.sName  = [cityString.mCommData.sName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        //这里我自己写了一个递归过滤指定字符串   RemoveSpecialCharacter
        cityString.mCommData.sName =[CityString RemoveSpecialCharacter:cityString.mCommData.sName];
        // NSLog(@"string====%@",chineseString.string);
        
        
        //判断首字符是否为字母
        NSString *regex = @"[A-Za-z]+";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        NSString *initialStr = [cityString.mCommData.sName length]?[cityString.mCommData.sName substringToIndex:1]:@"";
        if ([predicate evaluateWithObject:initialStr])
        {
            //首字母大写
            cityString.pinYin = [cityString.mCommData.sName capitalizedString] ;
        }else{
            if(![cityString.mCommData.sName isEqualToString:@""]){
                NSString *pinYinResult=[NSString string];
                for(int j=0;j<cityString.mCommData.sName.length;j++){
                    NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",
                                                   
                                                   pinyinFirstLetter([cityString.mCommData.sName characterAtIndex:j])]uppercaseString];
                    //                    NSLog(@"singlePinyinLetter ==%@",singlePinyinLetter);
                    
                    pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
                }
                cityString.pinYin=pinYinResult;
            }else{
                cityString.pinYin=@"";
            }
        }
        [cityStringsArray addObject:cityString];
    }
    //按照拼音首字母对这些Strings进行排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [cityStringsArray sortUsingDescriptors:sortDescriptors];
    
    /*for(int i=0;i<[chineseStringsArray count];i++){
        //        NSLog(@"chineseStringsArray====%@",((ChineseString*)[chineseStringsArray objectAtIndex:i]).pinYin);
    }
    NSLog(@"-----------------------------");*/
    
    
    return cityStringsArray;
    
}

#pragma mark - 返回一组字母排序数组
+(NSMutableArray*)SortArray:(NSArray*)contactArr
{
    NSMutableArray *tempArray = [self ReturnSortChineseArrar:contactArr];
    
    //把排序好的内容从ChineseString类中提取出来
    NSMutableArray *result=[NSMutableArray array];
    for(int i=0;i<[contactArr count];i++){
        [result addObject:((CityString*)[tempArray objectAtIndex:i]).mCommData.sName];
    }
    return result;
}
@end