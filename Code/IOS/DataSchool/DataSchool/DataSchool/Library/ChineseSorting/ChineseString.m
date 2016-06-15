//
//  ChineseString.m
//  YUChineseSorting
//
//  Created by yuzhx on 15/4/19.
//  Copyright (c) 2015年 BruceYu. All rights reserved.
//

#import "ChineseString.h"

@implementation ChineseString
@synthesize leaveTeacher;
@synthesize pinYin;

#pragma mark - 返回tableview右方 indexArray
+(NSMutableArray*)IndexArray:(NSArray*)contactArr
{
    NSMutableArray *tempArray = [self ReturnSortChineseArrar:contactArr];
    NSMutableArray *A_Result=[NSMutableArray array];
    NSString *tempString ;
    
    for (ChineseString* object in tempArray)
    {
        if (((ChineseString*)object).pinYin.length > 0) {
            NSString *pinyin = [((ChineseString*)object).pinYin substringToIndex:1];
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
+(NSMutableArray*)LetterSortArray:(NSArray*)contactArr
{
    NSMutableArray *tempArray = [self ReturnSortChineseArrar:contactArr];
    NSMutableArray *LetterResult=[NSMutableArray array];
    NSMutableArray *item = [NSMutableArray array];
    NSString *tempString ;
    //拼音分组
    for (NSString* object in tempArray) {
        if (((ChineseString*)object).pinYin.length > 0) {
            NSString *pinyin = [((ChineseString*)object).pinYin substringToIndex:1];
            LeaveTeacher *contact = ((ChineseString*)object).leaveTeacher;
            //不同
            if(![tempString isEqualToString:pinyin])
            {
                //分组
                item = [NSMutableArray array];
                [item  addObject:contact];
                [LetterResult addObject:item];
                //遍历
                tempString = pinyin;
            }else//相同
            {
                [item  addObject:contact];
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
+(NSMutableArray*)ReturnSortChineseArrar:(NSArray*)contactArr
{
    //获取字符串中文字的拼音首字母并与字符串共同存放
    NSMutableArray *chineseStringsArray=[NSMutableArray array];
    for(int i=0;i<[contactArr count];i++)
    {
        ChineseString *chineseString=[[ChineseString alloc]init];
        //TKAddressBook *sContact = [contactArr objectAtIndex:i];
        //chineseString.addressBook.name=sContact.name;
        
        LeaveTeacher *sContact = [contactArr objectAtIndex:i];
        chineseString.leaveTeacher = sContact;
        if(chineseString.leaveTeacher.TeacherName.length == 0){
            chineseString.leaveTeacher.TeacherName=@"";
        }
        //去除两端空格和回车
        chineseString.leaveTeacher.TeacherName  = [chineseString.leaveTeacher.TeacherName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        //这里我自己写了一个递归过滤指定字符串   RemoveSpecialCharacter
        chineseString.leaveTeacher.TeacherName =[ChineseString RemoveSpecialCharacter:chineseString.leaveTeacher.TeacherName];
        // NSLog(@"string====%@",chineseString.string);
        
        
        //判断首字符是否为字母
        NSString *regex = @"[A-Za-z]+";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        NSString *initialStr = [chineseString.leaveTeacher.TeacherName length]?[chineseString.leaveTeacher.TeacherName substringToIndex:1]:@"";
        if ([predicate evaluateWithObject:initialStr])
        {
            NSLog(@"chineseString.string== %@",chineseString.leaveTeacher.TeacherName);
            //首字母大写
            chineseString.pinYin = [chineseString.leaveTeacher.TeacherName capitalizedString] ;
        }else{
            if(![chineseString.leaveTeacher.TeacherName isEqualToString:@""]){
                NSString *pinYinResult=[NSString string];
                for(int j=0;j<chineseString.leaveTeacher.TeacherName.length;j++){
                    NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",
                                                   
                                                   pinyinFirstLetter([chineseString.leaveTeacher.TeacherName characterAtIndex:j])]uppercaseString];
                    //                    NSLog(@"singlePinyinLetter ==%@",singlePinyinLetter);
                    
                    pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
                }
                chineseString.pinYin=pinYinResult;
            }else{
                chineseString.pinYin=@"";
            }
        }
        [chineseStringsArray addObject:chineseString];
    }
    //按照拼音首字母对这些Strings进行排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    /*for(int i=0;i<[chineseStringsArray count];i++){
        //        NSLog(@"chineseStringsArray====%@",((ChineseString*)[chineseStringsArray objectAtIndex:i]).pinYin);
    }
    NSLog(@"-----------------------------");*/
    
    
    return chineseStringsArray;
    
}

#pragma mark - 返回一组字母排序数组
+(NSMutableArray*)SortArray:(NSArray*)contactArr
{
    NSMutableArray *tempArray = [self ReturnSortChineseArrar:contactArr];
    
    //把排序好的内容从ChineseString类中提取出来
    NSMutableArray *result=[NSMutableArray array];
    for(int i=0;i<[contactArr count];i++){
        [result addObject:((ChineseString*)[tempArray objectAtIndex:i]).leaveTeacher.TeacherName];
    }
    return result;
}
@end