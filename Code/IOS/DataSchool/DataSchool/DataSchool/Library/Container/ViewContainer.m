//
//  ViewContainer.m
//  TakeCar
//
//  Created by coreyfu on 14-7-1.
//  Copyright (c) 2014年 Meinekechina. All rights reserved.
//

#import "ViewContainer.h"

#define PAGECTRL_HEIGHT 20
#define PAGECTRL_OFF_SET 5

@interface ViewContainer ()<UIGestureRecognizerDelegate>
{
    ExPageControl *_pageCtrl;
    UILabel *_pageIndicator;
    UIScrollView *_scrollView;
    
    NSInteger _pageCount;
    NSInteger _currentPage;

    CGPoint _previousRightUpPoint;
    CGFloat _previousLineMaxHeight;
    
    BOOL _pageControlUsed;
    BOOL _showPageControl;
    
    EContainerAddPageMode _pageMode;
}
@end

@implementation ViewContainer

@synthesize backgroundImage;


- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    //从nib加载时用tag标记是否需要显示页面控制
    switch (self.tag) {
        case EContainerAddPageModeHorizontalNoPageControl:
            [self initMembers:self.frame showPageControl:NO ctrollMode:EContainerAddPageModeHorizontalNoPageControl];
            break;
            
        case EContainerAddPageModeHorizontalShowIndicatorUseStylePageControl:
            [self initMembers:self.frame showPageControl:YES ctrollMode:EContainerAddPageModeHorizontalShowIndicatorUseStylePageControl];
            break;
            
        case EContainerAddPageModeVerticalNoPageControl:
            [self initMembers:self.frame showPageControl:NO ctrollMode:EContainerAddPageModeVerticalNoPageControl];
            break;
            
        case EContainerAddPageModeHorizontalShowIndicatorUseStyleFraction:
            [self initMembers:self.frame showPageControl:YES ctrollMode:EContainerAddPageModeHorizontalShowIndicatorUseStyleFraction];
            break;
            
        case EContainerAddPageModeHorizontalShowIndicatorUseStylePageControlOnGuideStyle:
            [self initMembers:self.frame showPageControl:NO ctrollMode:EContainerAddPageModeHorizontalShowIndicatorUseStylePageControlOnGuideStyle];
            
        default:
            [self initMembers:self.frame showPageControl:YES ctrollMode:EContainerAddPageModeHorizontalShowIndicatorUseStylePageControl];
            break;
    }
    
}

- (id)initWithFrame:(CGRect)frame
  showPageIndicator:(BOOL)show
           pageMode:(EContainerAddPageMode)mode
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [self initMembers:frame showPageControl:show ctrollMode:mode];
    }
    return self;
}

- (void)clear
{
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _previousRightUpPoint = CGPointMake(0, 0);
    _previousLineMaxHeight = 0;
    
    _pageCount = 1;
    _currentPage = 0;
    
    [_scrollView setContentSize:_scrollView.frame.size];
    
    _pageCtrl.numberOfPages = _pageCount;
    
    _pageIndicator.text = nil;
    
}
- (UIScrollView *)scrollView
{
    return _scrollView;
}
- (NSMutableAttributedString *)attributedString:(NSString *)string
{
    if (string.length == 0) return nil;
    
    NSArray *arr = [string componentsSeparatedByString:@"/"];
    if (arr.count < 2) return nil;
    
    NSRange rangeLeft = NSMakeRange(0, [arr[0] length]);
    NSRange rangeMiddle = NSMakeRange(rangeLeft.length, 1);
    NSRange rangeRight = NSMakeRange(rangeLeft.length + rangeMiddle.length, [arr[1] length]);
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1] range:rangeLeft];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1] range:rangeMiddle];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1] range:rangeRight];
    
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Courier-BoldOblique" size:15] range:rangeLeft];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Courier-BoldOblique" size:15] range:rangeMiddle];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Courier-BoldOblique" size:15] range:rangeRight];
//    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:14] range:NSMakeRange(19, 6)];
    
    return str;
}

- (void)initMembers:(CGRect)frame
    showPageControl:(BOOL)show
         ctrollMode:(EContainerAddPageMode)mode
{
    
    _previousRightUpPoint = CGPointMake(0, 0);
    _pageCount = 1;
    _currentPage = 0;
    
    _showPageControl = show;
    _pageMode = mode;
    
    //scroll view
    CGRect scrollFrame;
    if (mode == EContainerAddPageModeHorizontalShowIndicatorUseStylePageControlOnGuideStyle) {
        scrollFrame = CGRectMake(0,0,frame.size.width,frame.size.height);
    }else{
        scrollFrame = CGRectMake(0,
                                 0,
                                 frame.size.width,
                                 _showPageControl?(frame.size.height - PAGECTRL_OFF_SET * 2 - PAGECTRL_HEIGHT):frame.size.height);
    }
    
    _scrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
    _scrollView.tag = -1;
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    _scrollView.scrollsToTop = NO;
    _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    [_scrollView setPagingEnabled:YES];
    [_scrollView setDelegate:(id<UIScrollViewDelegate>)self];
    [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    [self addSubview:_scrollView];
    [self sendSubviewToBack:_scrollView];
    
    if(_showPageControl == YES){
        
        if (_pageMode == EContainerAddPageModeHorizontalShowIndicatorUseStylePageControl || _pageMode == EContainerAddPageModeHorizontalShowIndicatorUseStylePageControlOnGuideStyle) {
            //page control
            _pageCtrl = [[ExPageControl alloc] initWithFrame:CGRectMake(0,
                                                                        frame.size.height - PAGECTRL_OFF_SET - PAGECTRL_HEIGHT,
                                                                        frame.size.width,
                                                                        PAGECTRL_HEIGHT)];
            [_pageCtrl setBackgroundColor:[UIColor clearColor]];

            [_pageCtrl setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
            [_pageCtrl setNumberOfPages:_pageCount];
            _pageCtrl.hidesForSinglePage = YES;
            [_pageCtrl setIndicatorDiameter: 8.0f] ;
            [_pageCtrl setIndicatorSpace: 10.0f] ;
            [_pageCtrl setDrawPageNumber:YES];
            _pageCtrl.onColor = [UIColor lightGrayColor];
            _pageCtrl.offColor = [UIColor whiteColor];
            [_pageCtrl addTarget: self
                          action: @selector(pageChange:)
                forControlEvents: UIControlEventValueChanged] ;
            
            [self addSubview:_pageCtrl];
        }else if (_pageMode == EContainerAddPageModeHorizontalShowIndicatorUseStyleFraction){
            _pageIndicator = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                       frame.size.height - PAGECTRL_OFF_SET - PAGECTRL_HEIGHT,
                                                                       frame.size.width,
                                                                       PAGECTRL_HEIGHT)];
            [_pageIndicator setBackgroundColor:[UIColor clearColor]];
            [_pageIndicator setTextAlignment:NSTextAlignmentCenter];
            [self addSubview:_pageIndicator];
        }
    }
    
}

-(void)pageChange:(id)sender
{
    ExPageControl *thePageControl = (ExPageControl *)sender ;
    // we need to scroll to the new index
	[_scrollView setContentOffset: CGPointMake(_scrollView.frame.size.width * thePageControl.currentPage, _scrollView.contentOffset.y) animated: YES] ;
    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: below.
    _pageControlUsed = YES;
}

- (float)reloadData
{
    
    [self clear];
    
    if (!self.datasource) return 0;
    
    NSInteger count = 0;
    if ([(NSObject *)self.datasource respondsToSelector:@selector(numberOfItems:)]) {
        count = [self.datasource numberOfItems:self];
    }
    
    if (count == 0) return 0;
    
    UIEdgeInsets edge = UIEdgeInsetsMake(0, 0, 0, 0);
    NSInteger x = 0;
    NSInteger y = 0;

    if ([(NSObject *)self.datasource respondsToSelector:@selector(containerEdgeInsets)]) {
        edge = [self.datasource containerEdgeInsets];
    }
    
    if ([(NSObject *)self.datasource respondsToSelector:@selector(xSpaceOfItem:)]) {
        x = [self.datasource xSpaceOfItem:self];
    }
    
    if ([(NSObject *)self.datasource respondsToSelector:@selector(ySpaceOfItem:)]) {
        y = [self.datasource ySpaceOfItem:self];
    }
    
    BOOL hasDatasource = [(NSObject *)self.datasource respondsToSelector:@selector(container:itemAtIndex:)];
    
    float h = edge.top;
    for (int i = 0 ; i < count; i++) {
        if (hasDatasource) {
            UIView *v = [self.datasource container:self itemAtIndex:i];
            UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
            tapGestureRecognize.delegate = self;
            tapGestureRecognize.numberOfTapsRequired = 1;
            [v addGestureRecognizer:tapGestureRecognize];
            v.tag = i;
            if (v)  {
                h += [self addSubItem:v edgeInsets:edge xSpace:x ySpace:y];
            }
        }
    }
    h += edge.bottom;
    
    if (_pageMode == EContainerAddPageModeHorizontalShowIndicatorUseStylePageControl || _pageMode == EContainerAddPageModeHorizontalShowIndicatorUseStylePageControlOnGuideStyle) {
        _pageCtrl.numberOfPages = _pageCount;
    }else if (_pageMode == EContainerAddPageModeHorizontalShowIndicatorUseStyleFraction){
        _pageIndicator.attributedText = [self attributedString:[NSString stringWithFormat:@"%d/%d",(int)(_currentPage + 1),(int)_pageCount]];
    }
    
    return h;
}

- (void)addSubItem:(UIView *)item
{
    if (item) {
        
        item.tag = _scrollView.subviews.count;
        
        UIEdgeInsets edge = UIEdgeInsetsMake(0, 0, 0, 0);
        NSInteger x = 0;
        NSInteger y = 0;
        
        if ([(NSObject *)self.datasource respondsToSelector:@selector(containerEdgeInsets)]) {
            edge = [self.datasource containerEdgeInsets];
        }
        
        if ([(NSObject *)self.datasource respondsToSelector:@selector(xSpaceOfItem:)]) {
            x = [self.datasource xSpaceOfItem:self];
        }
        
        if ([(NSObject *)self.datasource respondsToSelector:@selector(ySpaceOfItem:)]) {
            y = [self.datasource ySpaceOfItem:self];
        }
                
        [self addSubItem:item edgeInsets:edge xSpace:x ySpace:y];
    }
}

- (void)insertItem:(UIView *)item atIndex:(NSInteger)index
{
    NSInteger count = _scrollView.subviews.count;
    if (index >= 0 && index <= count) {
        
        if (index == count) {
            item.tag = index;
            [self addSubItem:item];
        }else{
            
            UIView *preView;
            UIView *currentView;
            //[_scrollView addSubview:item];
            //item.tag = -11;
            UIView *lastView = [_scrollView viewWithTag:count - 1];
            NSLog(@"%@",[UIView displayViews:_scrollView]);
            //[lastView removeFromSuperview];
            
            if (count == 1 && index == 0) {
                currentView = lastView;
            }else if(index == count - 1){
                currentView = [_scrollView viewWithTag:index];
                //preView = [_scrollView viewWithTag:count - 1];
            }else{
                for (NSInteger i = count - 1;i > index;i--) {
                    currentView = [_scrollView viewWithTag:i];
                    preView = [_scrollView viewWithTag:i - 1];
                    preView.frame = currentView.frame;
                    preView.tag = currentView.tag ;
                    currentView.tag = currentView.tag + 1;

                }
            }
            
            item.frame = currentView.frame;
            item.tag = index;
            [lastView removeFromSuperview];
            lastView.tag = lastView.tag + 1;

            [_scrollView addSubview:item];
            [self addSubItem:lastView];
        }
    }
}

- (void)reloadDataAtIndex:(NSInteger)index
{
    NSInteger count = 0;
    if ([(NSObject *)self.datasource respondsToSelector:@selector(numberOfItems:)]) {
        count = [self.datasource numberOfItems:self];
    }
    
    if (index >= 0 && index < count) {
        UIView *vOld = [_scrollView viewWithTag:index];
        UIView *vNew = [self.datasource container:self itemAtIndex:index];
        vNew.tag = index;
        
        vNew.frame = vOld.frame;
        [vOld removeFromSuperview];
        [_scrollView addSubview:vNew];
    }
}

- (void)scrollToPage:(NSInteger)page
{
    float w = page * _scrollView.frame.size.width;

    _pageControlUsed = YES;
    [_scrollView setContentOffset:CGPointMake(w, _scrollView.contentOffset.y) animated:NO];
}

- (float)addSubItem:(UIView *)item
        edgeInsets:(UIEdgeInsets)edge
            xSpace:(NSInteger)xSpace
            ySpace:(NSInteger)ySpace
{
    // single tap gesture recognizer
    CGRect frame = item.frame;
    
    float h = frame.size.height;
    
    NSInteger width = _scrollView.frame.size.width;
    NSInteger height = _scrollView.frame.size.height;
    
    if (CGPointEqualToPoint(_previousRightUpPoint, CGPointZero))
    {
        if (edge.left + frame.size.width + edge.right > width /*||
            _contentInset.top + frame.size.height + _contentInset.bottom > height*/)
        {
            //NSException *ex = [NSException exceptionWithName:@"加入出错" reason:@"子frame大于父frame，无法加入" userInfo:nil];
            NSLog(@"%@",@"子frame大于父frame，无法加入");
            //@throw ex;
        }else{
            frame.origin.x = edge.left;
            frame.origin.y = edge.top;
            item.frame = frame;
            
            _previousRightUpPoint.x = frame.origin.x + frame.size.width;
            _previousRightUpPoint.y = frame.origin.y;
            
            _previousLineMaxHeight = frame.size.height;
            
            [_scrollView addSubview:item];
        }
        
        return _previousLineMaxHeight;
    }
    
    NSInteger x = _previousRightUpPoint.x + xSpace;
    
    if (x + frame.size.width > width * _pageCount)//next line
    {
        CGFloat needHeight = _previousRightUpPoint.y + _previousLineMaxHeight + frame.size.height + ySpace;
        if (needHeight > height)//next page
        {
            if (_pageMode != EContainerAddPageModeVerticalNoPageControl){
                //add page
                _pageCount++;
                
                CGSize size = CGSizeMake(width * _pageCount, _scrollView.contentSize.height);
                
                [_scrollView setContentSize:size];
                
                //add item
                frame.origin.x = edge.left + width * (_pageCount - 1);
                frame.origin.y = edge.top;
                item.frame = frame;
                
                _previousRightUpPoint.x = frame.origin.x + frame.size.width;
                _previousRightUpPoint.y = frame.origin.y;
                
                h = 0;
            } else {
                
                CGSize size = _scrollView.contentSize;
                size.height += (needHeight - height + edge.bottom);
                
                [_scrollView setContentSize:size];
                
                //add item
                frame.origin.x = edge.left;
                frame.origin.y = _previousRightUpPoint.y + _previousLineMaxHeight + ySpace;
                item.frame = frame;
                
                _previousRightUpPoint.x = frame.origin.x + frame.size.width;
                _previousRightUpPoint.y = frame.origin.y;
    
                h = ySpace + _previousLineMaxHeight;
            }
    
            [_scrollView addSubview:item];
            
        }else{
            frame.origin.x = edge.left + width * (_pageCount - 1);
            frame.origin.y = _previousRightUpPoint.y + _previousLineMaxHeight + ySpace;
            item.frame = frame;
            
            _previousRightUpPoint.x = frame.origin.x + frame.size.width;
            _previousRightUpPoint.y = frame.origin.y;
            
            _previousLineMaxHeight = frame.size.height;
            
            [_scrollView addSubview:item];
            
            h = ySpace + _previousLineMaxHeight;
        }
    }else{
        frame.origin.x = x;
        frame.origin.y = _previousRightUpPoint.y ;
        item.frame = frame;
        
        if (_previousLineMaxHeight < frame.size.height)
            _previousLineMaxHeight = frame.size.height;
        
        _previousRightUpPoint.x = frame.origin.x + frame.size.width;
        
        [_scrollView addSubview:item];
        
        h = 0;
    }
    
    return h;
}

#pragma mark  ----- UIScrollViewDelegate Functions------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	// We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (_pageControlUsed == YES) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        _pageControlUsed = NO;
        return;
    }

    CGPoint p = scrollView.contentOffset;
    if (p.x < 0) {
        [scrollView setContentOffset:CGPointMake(0, scrollView.contentOffset.y) animated:NO];
    }
    
    float w = (_pageCount - 1) * scrollView.frame.size.width;
    if (p.x > w) {
        [scrollView setContentOffset:CGPointMake(w, scrollView.contentOffset.y) animated:NO];
    }
    
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = _scrollView.bounds.size.width;
    
    float fractionalPage = (_scrollView.contentOffset.x - pageWidth / 2) / pageWidth ;
    
	NSInteger nearestNumber = lround(fractionalPage) ;
	
    if (nearestNumber < 0) nearestNumber = 0;
	if (_currentPage != nearestNumber)
	{
        _currentPage = nearestNumber;
        if (_pageMode == EContainerAddPageModeHorizontalShowIndicatorUseStylePageControl || _pageMode == EContainerAddPageModeHorizontalShowIndicatorUseStylePageControlOnGuideStyle) {
            _pageCtrl.currentPage = _currentPage ;
            // if we are dragging, we want to update the page control directly during the drag
            if (_scrollView.dragging)
                [_pageCtrl updateCurrentPageDisplay] ;
        }else if (_pageMode == EContainerAddPageModeHorizontalShowIndicatorUseStyleFraction){
            _pageIndicator.attributedText = [self attributedString:[NSString stringWithFormat:@"%d/%d",(int)(_currentPage + 1),(int)_pageCount]];
        }
        
        if ([(NSObject *)self.delegate respondsToSelector:@selector(viewContainer:didScrollToPage:)]) {
            [self.delegate viewContainer:self didScrollToPage:_currentPage];
        }
	}
    
    return;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // if we are animating (triggered by clicking on the page control), we update the page control
    if (_pageMode == EContainerAddPageModeHorizontalShowIndicatorUseStylePageControl || _pageMode == EContainerAddPageModeHorizontalShowIndicatorUseStylePageControlOnGuideStyle) {
        [_pageCtrl updateCurrentPageDisplay] ;
        
        _pageControlUsed = NO;
    }
	
}


- (BOOL)isTouchInRect:(CGRect)aRect point:(CGPoint) aPoint
{
    if(aPoint.x >= aRect.origin.x  &&
       aPoint.x <= (aRect.origin.x + aRect.size.width) &&
       (aPoint.y >= aRect.origin.y &&
        aPoint.y <= (aRect.origin.y + aRect.size.height)))
        return YES;
    
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_pageMode == EContainerAddPageModeHorizontalShowIndicatorUseStylePageControl || _pageMode == EContainerAddPageModeHorizontalShowIndicatorUseStylePageControlOnGuideStyle) {
        UITouch *touch = [touches anyObject];
        
        CGPoint location = [touch locationInView:self];
        
        if ([self isTouchInRect:_pageCtrl.frame point:location])
        {
            [_pageCtrl touchesBegan:touches withEvent:event];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_pageMode == EContainerAddPageModeHorizontalShowIndicatorUseStylePageControl || _pageMode == EContainerAddPageModeHorizontalShowIndicatorUseStylePageControlOnGuideStyle) {
        UITouch *touch = [touches anyObject];
        
        CGPoint location = [touch locationInView:self];
        
        if ([self isTouchInRect:_pageCtrl.frame point:location])
        {
            [_pageCtrl touchesEnded:touches withEvent:event];
        }
    }
}

- (void)setBackgroundImage:(UIImage *)image
{
    backgroundImage = image;
    [self setNeedsDisplay];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.backgroundColor = [UIColor clearColor];
    if (self.backgroundImage)
        [self.backgroundImage drawInRect:rect];
}


- (void)singleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if ([(NSObject *)self.delegate respondsToSelector:@selector(itemDidClickedInView:)]) {
            [self.delegate itemDidClickedInView:gestureRecognizer.view];
        }
    }
}

@end

