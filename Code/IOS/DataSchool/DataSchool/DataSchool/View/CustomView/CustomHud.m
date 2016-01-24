//
//  CustomHud.m
//  WanDa
//
//  Created by coreyfu on 15/7/20.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <ImageIO/ImageIO.h>
#import "CustomHud.h"
#import "AppDelegate.h"

#define GifSpeed        0.03


#if __has_feature(objc_arc)
#define toCF (__bridge CFTypeRef)
#define fromCF (__bridge id)
#else
#define toCF (CFTypeRef)
#define fromCF (id)
#endif

#pragma mark - UIImage Animated GIF


@implementation UIImage (animatedGIF)

static int delayCentisecondsForImageAtIndex(CGImageSourceRef const source, size_t const i) {
    int delayCentiseconds = 1;
    CFDictionaryRef const properties = CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
    if (properties) {
        CFDictionaryRef const gifProperties = CFDictionaryGetValue(properties, kCGImagePropertyGIFDictionary);
        if (gifProperties) {
            NSNumber *number = fromCF CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFUnclampedDelayTime);
            if (number == NULL || [number doubleValue] == 0) {
                number = fromCF CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFDelayTime);
            }
            if ([number doubleValue] > 0) {
                // Even though the GIF stores the delay as an integer number of centiseconds, ImageIO “helpfully” converts that to seconds for us.
                delayCentiseconds = (int)lrint([number doubleValue] * 100);
            }
        }
        CFRelease(properties);
    }
    return delayCentiseconds;
}

static void createImagesAndDelays(CGImageSourceRef source, size_t count, CGImageRef imagesOut[count], int delayCentisecondsOut[count]) {
    for (size_t i = 0; i < count; ++i) {
        imagesOut[i] = CGImageSourceCreateImageAtIndex(source, i, NULL);
        delayCentisecondsOut[i] = delayCentisecondsForImageAtIndex(source, i);
    }
}

static int sum(size_t const count, int const *const values) {
    int theSum = 0;
    for (size_t i = 0; i < count; ++i) {
        theSum += values[i];
    }
    return theSum;
}

static int pairGCD(int a, int b) {
    if (a < b)
        return pairGCD(b, a);
    while (true) {
        int const r = a % b;
        if (r == 0)
            return b;
        a = b;
        b = r;
    }
}

static int vectorGCD(size_t const count, int const *const values) {
    int gcd = values[0];
    for (size_t i = 1; i < count; ++i) {
        // Note that after I process the first few elements of the vector, `gcd` will probably be smaller than any remaining element.  By passing the smaller value as the second argument to `pairGCD`, I avoid making it swap the arguments.
        gcd = pairGCD(values[i], gcd);
    }
    return gcd;
}

static NSArray *frameArray(size_t const count, CGImageRef const images[count], int const delayCentiseconds[count], int const totalDurationCentiseconds) {
    int const gcd = vectorGCD(count, delayCentiseconds);
    size_t const frameCount = totalDurationCentiseconds / gcd;
    UIImage *frames[frameCount];
    for (size_t i = 0, f = 0; i < count; ++i) {
        UIImage *const frame = [UIImage imageWithCGImage:images[i]];
        for (size_t j = delayCentiseconds[i] / gcd; j > 0; --j) {
            frames[f++] = frame;
        }
    }
    return [NSArray arrayWithObjects:frames count:frameCount];
}

static void releaseImages(size_t const count, CGImageRef const images[count]) {
    for (size_t i = 0; i < count; ++i) {
        CGImageRelease(images[i]);
    }
}

static UIImage *animatedImageWithAnimatedGIFImageSource(CGImageSourceRef const source) {
    size_t const count = CGImageSourceGetCount(source);
    CGImageRef images[count];
    int delayCentiseconds[count]; // in centiseconds
    createImagesAndDelays(source, count, images, delayCentiseconds);
    int const totalDurationCentiseconds = sum(count, delayCentiseconds);
    NSArray *const frames = frameArray(count, images, delayCentiseconds, totalDurationCentiseconds);
    UIImage *const animation = [UIImage animatedImageWithImages:frames duration:(NSTimeInterval)totalDurationCentiseconds / 100.0];
    releaseImages(count, images);
    return animation;
}

static UIImage *animatedImageWithAnimatedGIFReleasingImageSource(CGImageSourceRef CF_RELEASES_ARGUMENT source) {
    if (source) {
        UIImage *const image = animatedImageWithAnimatedGIFImageSource(source);
        CFRelease(source);
        return image;
    } else {
        return nil;
    }
}

+ (UIImage *)animatedImageWithAnimatedGIFData:(NSData *)data {
    return animatedImageWithAnimatedGIFReleasingImageSource(CGImageSourceCreateWithData(toCF data, NULL));
}

+ (UIImage *)animatedImageWithAnimatedGIFURL:(NSURL *)url {
    return animatedImageWithAnimatedGIFReleasingImageSource(CGImageSourceCreateWithURL(toCF url, NULL));
}

@end



#pragma mark - GIFHUD Private

typedef enum : NSUInteger {
    HudAnimType_Rotation = 0,
    HudAnimType_Frame
} HudAnimType;

@interface CustomHud ()

+ (CustomHud *)instance;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) BOOL shown;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, assign) HudAnimType animaType;
@end



#pragma mark - GIFHUD Implementation

@implementation CustomHud

#pragma mark Lifecycle

static CustomHud *instance;

+ (CustomHud *)instance {
    if (!instance) {
        instance = [[CustomHud alloc] initFrameAnima];
    }
    return instance;
}

- (CustomHud *)initRotationAnima {
    self.animaType = HudAnimType_Rotation;// rotation animation
    
    UIImage *img = [UIImage imageNamed:@"loading_mg_00000"];
    CGRect r = CGRectMake(0, 0, 0, 0);
    r.size = img.size;
    
    if ((self = [super initWithFrame:r])) {
        
        //[self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1]];
        
        self.imageView = [[UIImageView alloc] initWithFrame:r];
        [self.imageView setImage:img];
        
        img = [UIImage imageNamed:@"loading_mg_00000"];
        r.size = img.size;
        UIImageView *carImg = [[UIImageView alloc] initWithFrame:r];
        [carImg setImage:img];
        
        UIView *v = [[UIView alloc] initWithFrame:r];
        v.backgroundColor = [UIColor clearColor];
        [v addSubview:carImg];
        [v addSubview:self.imageView];
        
        [self addSubview:v];
        
        v.center = self.center;
        carImg.center = self.imageView.center;
        
        self.bgView = v;
    }
    return self;
}

- (CustomHud *)initFrameAnima {
    self.animaType = HudAnimType_Frame;// frame animation
    
    UIImage *img = [UIImage imageNamed:@"loading_mg_00000"];
    CGRect r = CGRectMake(0, 0, 0, 0);
    r.size = img.size;
    
    if ((self = [super initWithFrame:r])) {
        
        //[self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1]];
        
        self.imageView = [[UIImageView alloc] initWithFrame:r];
        NSMutableArray *imgArr = [[NSMutableArray alloc]init];
        for (int i=0; i<27; i++) {
            [imgArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading_mg_%05d.jpg",i]]];
        }
        
        [self.imageView setAnimationImages:imgArr];
        [self.imageView setAnimationDuration:GifSpeed*imgArr.count];
        [self.imageView setAnimationRepeatCount:0];
        
        UIView *v = [[UIView alloc] initWithFrame:r];
        v.backgroundColor = [UIColor clearColor];
        [v addSubview:self.imageView];
        
        [self addSubview:v];
        v.center = self.center;
        self.bgView = v;
    }
    return self;
}

- (void)startAnimating
{
    if (self.animaType == HudAnimType_Rotation) {
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        rotationAnimation.duration = 1.0;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = NSIntegerMax;
        
        
        [self.imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    } else if (self.animaType == HudAnimType_Frame) {
        // frame animation
        //开始动画
        [self.imageView startAnimating];
    }
}

- (void)stopAnimating
{
    if (self.animaType == HudAnimType_Rotation) {
        [self.imageView.layer removeAnimationForKey:@"rotationAnimation"];
    } else if (self.animaType == HudAnimType_Frame) {
        [self.imageView stopAnimating];
    }
}

#pragma mark HUD

+ (void)showInView:(UIView *)view {
    
    
    [self dismiss:^{
        
        CustomHud *bgView = [self instance];
        
        CGRect r = CGRectMake(0, 0, 0, 0);
        r.size = view.frame.size;
        bgView.frame = r;
        
        [view addSubview:bgView];
        
        CGPoint c = bgView.center;
        bgView.bgView.center = c;
        
        [bgView setShown:YES];
        //[[bgView imageView] startAnimating];
        [bgView startAnimating];
    }];
}

+ (void)show {
    [self dismiss:^{
        
        CustomHud *bgView = [self instance];
        
        CGRect r = CGRectMake(0, 0, 0, 0);
        r.size = APPDELEGATE.window.frame.size;
        bgView.frame = r;
        
        bgView.bgView.center = bgView.center;
        
        [APPDELEGATE.window addSubview:bgView];
        [APPDELEGATE.window bringSubviewToFront:bgView];
        
        [bgView setShown:YES];
        //[[bgView imageView] startAnimating];
        [bgView startAnimating];
    }];
}


+ (void)dismiss {
    if (![[self instance] shown])
        return;
    
    [[self instance] removeFromSuperview];
    [[self instance] setShown:NO];
    //[[[self instance] imageView] stopAnimating];
    [[self instance] stopAnimating];
    
}


+ (void)dismiss:(void(^)(void))complated {
    if (![[self instance] shown])
        return complated ();
    
    [[self instance] setShown:NO];
    //[[[self instance] imageView] stopAnimating];
    [[self instance] stopAnimating];
    
    [[self instance] removeFromSuperview];
    complated ();
}

#pragma mark Gif

+ (void)setGifWithImages:(NSArray *)images {
    [[[self instance] imageView] setAnimationImages:images];
    [[[self instance] imageView] setAnimationDuration:GifSpeed];
}

+ (void)setGifWithImageName:(NSString *)imageName {
    [[[self instance] imageView] stopAnimating];
    
    UIImage *img = [UIImage animatedImageWithAnimatedGIFURL:[[NSBundle mainBundle] URLForResource:imageName withExtension:nil]];
    
    UIImageView *imgV = [[self instance] imageView];
    CGRect r = imgV.frame;
    r.size = img.size;
    imgV.frame = r;
    
    [[[self instance] imageView] setImage:img];
}

+ (void)setGifWithURL:(NSURL *)gifUrl {
    [[[self instance] imageView] stopAnimating];
    
    UIImage *img = [UIImage animatedImageWithAnimatedGIFURL:gifUrl];
    
    UIImageView *imgV = [[self instance] imageView];
    CGRect r = imgV.frame;
    r.size = img.size;
    imgV.frame = r;
    
    [[[self instance] imageView] setImage:img];
}

@end
