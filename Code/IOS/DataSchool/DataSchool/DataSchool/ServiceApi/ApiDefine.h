//
//  ApiDefine.h
//  WanDaCloud
//
//  Created by coreyfu on 14/11/16.
//  Copyright (c) 2014年 Meinekechina. All rights reserved.
//

@import Foundation;

#ifndef MarketEleven_ApiDefine_h
#define MarketEleven_ApiDefine_h


//默认分页条数
#define kPageCount 20


#define IWanDaErrorDomain @"iWanDaErrorDomain"

typedef NS_ENUM(NSInteger, IWanDaRequestState)
{
    IWanDaRequestSuccess = 10000,
    IWanDaRequestFailed = 10001,
    IWanDaRequestInvalidUser = 11009,//无效用户：token过期或无此用户等
    IWanDaRequestInvalidData = 99999//数据异常

};

//@"http://develop.dtech-school.com"
#define kServerAddressTest          @"http://www.dtech-school.com/SchoolApps"
#define MemberRefID                 @"7E5E0D36-142D-4F76-9E9E-49D9FC0005EE"

//#define kServerURLAddress           @"http://115.28.85.127:8084"
//#define kServerAddressTestProduct   @"http://115.28.85.127:8084/wdpm/WDServlet/"
//#define kServerAddressProduct       @"http://115.28.85.127:8084/wdpm/WDServlet/"

#define kServerAddress kServerAddressTest

/*#if DEBUG
#define kServerAddress kServerAddressTest
#else
#define kServerAddress kServerAddressProduct
#endif*/

//对应菜单页面是APP还是网页
#define kAPP                        @"APP"
#define kHTML                       @"HTML"

//系统
#define kApiSysCode                 @"p_api_sysCode"
#define kApiLogin                   @"/schoolservice/LoginHandler.ashx"
#define kApiGetProfile              @"/schoolservice/GetUserSchoolProfileHandler.ashx"
#define kApiGetMenu                 @"/schoolservice/GetUserMenuHandler.ashx"
#define kApiChangePWD               @"/schoolservice/ChangePasswordHandler.ashx"
#define kApiExit                    @"/schoolservice/ExitHandler.ashx"


#define kApiGetShoolNewsCover       @"/schoolnews/GetSchoolNewsCover.ashx"
#define kApiGetShoolNews            @"/schoolnews/GetSchoolNews.ashx"
#define kApiGetNotifyType           @"/schoolnews/GetNoticeType.ashx"

#define kApiGetEventType            @"/EventsManage/GetEventCategoriesHandler.ashx"
#define kApiSendEvent               @"/EventsManage/SubmitEvent.ashx"
#define kApiGetEventHistory         @"/EventsManage/GetViewPage.ashx"

#define kApiSendNotice              @"/schoolnews/SendNotice.ashx"
#define kApiGetClassNotice          @"/schoolnews/GetClassNotice.ashx"
#define kApiDeleteNotice            @"/schoolnews/DeleteNotice.ashx"

#define kApiGetAlbumFolderList      @"/schoolAlbums/GetAlbumFolderList.ashx"
#define kApiGetThumbnailList        @"/schoolAlbums/GetThumbnailList.ashx"
#define kApiGetUploadFolderList     @"/schoolAlbums/GetUploadFolderList.ashx"
#define kApiUploadImage             @"/schoolAlbums/UploadImage.ashx"
#define kApiDeleteImage             @"/schoolAlbums/DeleteImage.ashx"

#define kApiUpdateHeadImg           @"/user/updateUserHead.ashx"
#define kApiGetReadLog              @"/user/GetReadLog.ashx"

//判断IOS机型
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define kAppMarginSpaceH  12//左右边距

#define MAKE_IMG_URL(path) [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kServerAddressTest, path]]

#endif
