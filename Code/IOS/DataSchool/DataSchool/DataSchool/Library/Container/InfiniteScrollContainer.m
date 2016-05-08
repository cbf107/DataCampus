//
//  InfiniteScrollContainer.m
//  ImageScrollTest
//
//  Created by coreyfu on 14-7-25.
//  Copyright (c) 2014年 Meinekechina. All rights reserved.
//

#import "InfiniteScrollContainer.h"
#import "ExPageControl.h"

#define kSwitchTimeInterval 5
#define PAGECTRL_HEIGHT 20
#define PAGECTRL_OFF_SET 0

@interface InfiniteScrollContainer()<UIScrollViewDelegate>

@property (nonatomic) NSInteger currentIndex;
@property (strong, nonatomic) NSMutableArray *visibleItems;
@property (strong, nonatomic) NSMutableArray *itemReusableQueue;

@property (strong, nonatomic) UIView *containerView;
@property (nonatomic, assign) NSInteger currentPageIndex;

@property (nonatomic, strong) ExPageControl *pageCtrl;
@end

@implementation InfiniteScrollContainer

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [self commonInit];
}

- (void)commonInit
{
    
    self.visibleItems = [[NSMutableArray alloc] init];
    self.itemReusableQueue = [[NSMutableArray alloc] init];
    
    self.containerView = [[UIView alloc] init];
    self.containerView.clipsToBounds = YES;
    self.circular = YES;
    self.paging= YES;
    self.currentIndex = 0;
    self.delegate = self;
    self.decelerationRate = UIScrollViewDecelerationRateNormal;
    [self addSubview:self.containerView];
    
    [self setShowsHorizontalScrollIndicator:NO];
    
    ExPageControl *pageCtrl = [[ExPageControl alloc] initWithFrame:CGRectMake(self.bounds.size.width * 0.75,
                                                                self.bounds.size.height - PAGECTRL_OFF_SET - PAGECTRL_HEIGHT-40,
                                                                self.bounds.size.width * 0.25,
                                                                PAGECTRL_HEIGHT)];
    [pageCtrl setBackgroundColor:[UIColor clearColor]];
    pageCtrl.userInteractionEnabled = NO;
    [pageCtrl setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    pageCtrl.hidesForSinglePage = YES;
    [pageCtrl setIndicatorDiameter: 8.0f] ;
    [pageCtrl setIndicatorSpace: 8.0f] ;
    
    //    pageCtrl.onColor = [UIColor colorWithHexString:@"00"];
    //alex
    pageCtrl.onColor = [UIColor colorWithHexString:@"00beff"];
    pageCtrl.offColor = [UIColor whiteColor];
    
//    [pageCtrl addTarget: self
//                  action: @selector(pageChange:)
//        forControlEvents: UIControlEventValueChanged] ;
    
    [self addSubview:pageCtrl];
    
    self.pageCtrl = pageCtrl;
    [self reloadData];
}

- (void)resetState
{
    [self.visibleItems removeAllObjects];

    NSUInteger totalItems = [self.dataSource numberOfItemsInInfiniteScrollContainer:self];
    
    self.pageCtrl.numberOfPages = totalItems;
    self.pageCtrl.currentPage = 0;
}

- (void)calculateContentSize {
	if (!self.dataSource) return;
	
	NSUInteger totalItems = [self.dataSource numberOfItemsInInfiniteScrollContainer:self];
	CGSize totalItemSize = CGSizeMake(0.0, self.bounds.size.height);
	for (int i = 0; i < totalItems; i++) {
		totalItemSize.width += [self.dataSource infiniteScrollContainer:self widthForIndex:i];
	}
	
	self.contentSize = CGSizeMake(totalItemSize.width * 2, totalItemSize.height);
	self.containerView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoScroll) object:nil];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // If not dragging, send event to next responder
    if (!self.dragging) {
        UITouch *touch = [touches anyObject];
        CGPoint newPoint = [touch locationInView:self];
        UIView *result = [self itemViewAtPoint:newPoint];
        if (self.delegateSC && [(NSObject *)self.delegateSC respondsToSelector:@selector(infiniteScrollContainer:didSelectItem:atIndex:)]) {
            [self.delegateSC infiniteScrollContainer:self didSelectItem:result atIndex:result.tag];
        }
        [self.nextResponder touchesEnded: touches withEvent:event];
    } else {
        [super touchesEnded: touches withEvent: event];
    }
    
    [self performSelector:@selector(autoScroll) withObject:nil afterDelay:kSwitchTimeInterval];
}

- (void)jumpToIndex:(NSInteger)itemIndex {
    if ((self.isCircular && itemIndex < 0) &&
		(self.isCircular && itemIndex >= [self.dataSource numberOfItemsInInfiniteScrollContainer:self]))
		return;
	
	[self setContentOffset:CGPointMake(0, self.contentOffset.y) animated:NO];
	
	CGRect visibleBounds = [self convertRect:self.bounds toView:self.containerView];
	CGFloat minimumVisibleX = CGRectGetMinX(visibleBounds);
	CGFloat maximumVisibleX = CGRectGetMaxX(visibleBounds);
	
	[self.visibleItems removeAllObjects];
	self.currentIndex = itemIndex;
	
	[self tileItemsFromMinX:minimumVisibleX toMaxX:maximumVisibleX];
}

- (UIView *)getViewFromVisibleCellsWithIndex:(NSInteger)itemIndex {
	__block UIView *itemView = nil;
	[self.visibleItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		UIView *visibleItemView = (UIView *)obj;
		
		if (visibleItemView.tag == itemIndex) {
			itemView = visibleItemView;
			*stop = YES;
		}
	}];
	
	return itemView;
}

- (id)dequeueReusableItem {
    id item = [self.itemReusableQueue lastObject];
    [self.itemReusableQueue removeObject:item];
    return item;
}

- (void)autoScroll
{
    UIView *item = [self itemViewAtPoint:self.contentOffset];
    
    CGPoint destinationPoint = [item convertPoint:CGPointMake(item.bounds.size.width, 0.0) toView:self];
    
    [self setContentOffset:destinationPoint animated:YES];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoScroll) object:nil];
    [self performSelector:@selector(autoScroll) withObject:nil afterDelay:kSwitchTimeInterval];
}

- (void)reloadData {
	if (!self.dataSource) return;
	
    [self resetState];
    
	
	[self jumpToIndex:0];
    
    [self setNeedsLayout];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoScroll) object:nil];
//    [self performSelector:@selector(autoScroll) withObject:nil afterDelay:kSwitchTimeInterval];
}

- (void)resume
{
    [self performSelector:@selector(autoScroll) withObject:nil afterDelay:kSwitchTimeInterval];
}

- (void)pause
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoScroll) object:nil];
}

#pragma mark - Layout

// recenter content periodically
- (void)recenterIfNecessary {
    CGPoint currentOffset = self.contentOffset;
    CGFloat contentWidth = self.contentSize.width;
    CGFloat centerOffsetX = (contentWidth - self.bounds.size.width) / 2.0;
    CGFloat distanceFromCenter = fabs(currentOffset.x - centerOffsetX);
    
    if (distanceFromCenter > (contentWidth / 4.0)) {
        self.contentOffset = CGPointMake(centerOffsetX, currentOffset.y);
        
        for (UIView *item in self.visibleItems) {
            CGPoint center = [self.containerView convertPoint:item.center toView:self];
            center.x += (centerOffsetX - currentOffset.x);
            item.center = [self convertPoint:center toView:self.containerView];
        }
    }
}

- (void)layoutSubviews {
    //NSLog(@"layoutSubviews\n");
    [super layoutSubviews];
    
    [self calculateContentSize];
    
    [self recenterIfNecessary];
    
    // tile content in visible bounds
    CGRect visibleBounds = [self convertRect:self.bounds toView:self.containerView];
    CGFloat minimumVisibleX = CGRectGetMinX(visibleBounds);
    CGFloat maximumVisibleX = CGRectGetMaxX(visibleBounds);
    
    [self tileItemsFromMinX:minimumVisibleX toMaxX:maximumVisibleX];
}

#pragma mark - Item Tiling

- (UIView *)insertItemWithIndex:(NSInteger)index {
    if (self.dataSource && [(NSObject *)self.dataSource respondsToSelector:@selector(infiniteScrollContainer:forIndex:)]) {
        UIView *viewFromDelegate = [self.dataSource infiniteScrollContainer:self forIndex:index];
        viewFromDelegate.tag = index;
        [self.containerView addSubview:viewFromDelegate];
        
        return viewFromDelegate;
    }
    
    return nil;
}

- (CGFloat)placeNewItemOnRight:(CGFloat)rightEdge {
    if ([self.visibleItems count] > 0) {
        UIView *lastItem = [self.visibleItems lastObject];
        NSInteger nextIndex = lastItem.tag + 1;
        if ([self isCircular])
            nextIndex = (nextIndex >= [self.dataSource numberOfItemsInInfiniteScrollContainer:self]) ? 0 : nextIndex;
        self.currentIndex = nextIndex;
    }
    
    UIView *item = [self insertItemWithIndex:self.currentIndex];
    [self.visibleItems addObject:item];
    
    CGRect frame = item.frame;
    frame.origin.x = rightEdge;
    frame.origin.y = 0; //self.containerView.bounds.size.height - frame.size.height;
    item.frame = frame;
    
    return CGRectGetMaxX(frame);
}

- (CGFloat)placeNewItemOnLeft:(CGFloat)leftEdge {
    UIView *firstItem = [self.visibleItems objectAtIndex:0];
    NSInteger previousIndex = firstItem.tag - 1;
    if ([self isCircular])
        previousIndex = (previousIndex < 0) ? [self.dataSource numberOfItemsInInfiniteScrollContainer:self]-1 : previousIndex;
    self.currentIndex = previousIndex;
    
    UIView *item = [self insertItemWithIndex:self.currentIndex];
    [self.visibleItems insertObject:item atIndex:0];
    
    CGRect frame = item.frame;
    frame.origin.x = leftEdge - frame.size.width;
    frame.origin.y = 0; //self.containerView.bounds.size.height - frame.size.height;
    item.frame = frame;
    
    return CGRectGetMinX(frame);
}

- (void)tileItemsFromMinX:(CGFloat)minimumVisibleX toMaxX:(CGFloat)maximumVisibleX {
    if ([self.visibleItems count] == 0) {
        [self placeNewItemOnRight:minimumVisibleX];
    }
    
    UIView *lastItem = [self.visibleItems lastObject];
    CGFloat rightEdge = CGRectGetMaxX(lastItem.frame);
    while (rightEdge < maximumVisibleX) {
        rightEdge = [self placeNewItemOnRight:rightEdge];
    }
    
    UIView *firstItem = [self.visibleItems objectAtIndex:0];
    CGFloat leftEdge = CGRectGetMinX(firstItem.frame);
    while (leftEdge > minimumVisibleX) {
        leftEdge = [self placeNewItemOnLeft:leftEdge];
    }
    
    lastItem = [self.visibleItems lastObject];
    while (lastItem.frame.origin.x > maximumVisibleX) {
        [lastItem removeFromSuperview];
        [self.visibleItems removeLastObject];
        [self.itemReusableQueue addObject:lastItem];
        
        lastItem = [self.visibleItems lastObject];
    }
    
    firstItem = [self.visibleItems objectAtIndex:0];
    while (CGRectGetMaxX(firstItem.frame) < minimumVisibleX) {
        [firstItem removeFromSuperview];
        [self.visibleItems removeObjectAtIndex:0];
        [self.itemReusableQueue addObject:firstItem];
        
        firstItem = [self.visibleItems objectAtIndex:0];
    }
}

- (UIView *)itemViewAtPoint:(CGPoint)point {
    __block UIView *itemView = nil;
    [self.visibleItems enumerateObjectsUsingBlock:^(UIView *visibleItemView, NSUInteger idx, BOOL *stop) {
        if (CGRectContainsPoint(visibleItemView.frame, point)) {
            itemView = visibleItemView;
            *stop = YES;
        }
    }];
    
    return itemView;
}

#pragma mark - Scroll View Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint pageCenter = self.pageCtrl.center;
    pageCenter.x = scrollView.contentOffset.x + self.bounds.size.width * 0.875;
    self.pageCtrl.center = pageCenter;

    
    UIView *item = [self itemViewAtPoint:scrollView.contentOffset];
    if (item && item.tag != self.currentPageIndex) {
        self.currentPageIndex = item.tag;
        self.pageCtrl.currentPage = item.tag;
    }
}

// custom paging
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoScroll) object:nil];
    
    if (self.isPaging) {
        
        CGPoint velocity = [scrollView.panGestureRecognizer velocityInView:[self superview]];
        
        UIView *item = [self itemViewAtPoint:scrollView.contentOffset];
        
        CGPoint destinationPoint;
        if (velocity.x > 0) {
            destinationPoint = [item convertPoint:CGPointMake(0.0, 0.0) toView:scrollView];
        } else {
            destinationPoint = [item convertPoint:CGPointMake(item.bounds.size.width, 0.0) toView:scrollView];
        }
        
        [scrollView setContentOffset:destinationPoint animated:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoScroll) object:nil];
    [self performSelector:@selector(autoScroll) withObject:nil afterDelay:kSwitchTimeInterval];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoScroll) object:nil];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (self.isPaging) {
        if (!decelerate) {
            
            UIView *item = [self itemViewAtPoint:scrollView.contentOffset];
            CGPoint localPoint = [scrollView convertPoint:scrollView.contentOffset toView:item];
            
            CGPoint destinationPoint;
            if (localPoint.x > (item.bounds.size.width / 2)) {
                destinationPoint = [item convertPoint:CGPointMake(item.bounds.size.width, 0.0) toView:scrollView];
            } else {
                destinationPoint = [item convertPoint:CGPointMake(0.0, 0.0) toView:scrollView];
            }
            
            [UIView animateWithDuration:.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{scrollView.contentOffset = destinationPoint;} completion:nil];
        }
    }
    
    [self performSelector:@selector(autoScroll) withObject:nil afterDelay:kSwitchTimeInterval];
}

@end
