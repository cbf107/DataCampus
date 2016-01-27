#import <UIKit/UIKit.h>
#import "PhotoModel.h"
#import "PhotoBroswerType.h"


@interface PhotoBroswerVC : UIViewController


+(void)show:(UIViewController *)handleVC type:(PhotoBroswerVCType)type AlbumRefid:(NSString *)albumID ImgRefid:(NSString*)imgID index:(NSUInteger)index photoModelBlock:(NSArray *(^)())photoModelBlock;


@end
