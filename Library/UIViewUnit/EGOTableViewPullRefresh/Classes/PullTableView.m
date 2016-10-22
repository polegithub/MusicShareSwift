//
//  PullTableView.m
//  TableViewPull
//
//  Created by Emre Berge Ergenekon on 2011-07-30.
//  Copyright 2011 Emre Berge Ergenekon. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "PullTableView.h"

@interface PullTableView (Private) <UIScrollViewDelegate>
- (void)config;
- (void)configDisplayProperties;
@end

@implementation PullTableView

#pragma mark - Initialization / Deallocation

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
  self = [super initWithFrame:frame style:style];
  if (self) {
    [self config];
  }

  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  [self config];
}

- (void)dealloc {
  delegateInterceptor = nil;
}

#pragma mark - Custom view configuration

- (void)config {
  /* Message interceptor to intercept scrollView delegate messages */
  delegateInterceptor = [[MessageInterceptor alloc] init];
  delegateInterceptor.middleMan = self;
  delegateInterceptor.receiver = self.delegate;
  super.delegate = (id)delegateInterceptor;

  /* Status Properties */
  pullTableIsRefreshing = NO;
  pullTableIsLoadingMore = NO;
  self.isFinished = NO;
  self.refreshEnable = YES;

  /* Refresh View */
  _refreshView = [[EGORefreshTableHeaderView alloc]
      initWithFrame:CGRectMake(0, -self.bounds.size.height,
                               self.bounds.size.width,
                               self.bounds.size.height)];
  _refreshView.autoresizingMask =
      UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
  _refreshView.delegate = self;
  [self addSubview:_refreshView];

  /* Load more view init */
  _loadMoreView = [[LoadMoreTableFooterView alloc]
      initWithFrame:CGRectMake(0, self.bounds.size.height,
                               self.bounds.size.width,
                               self.bounds.size.height)];
  _loadMoreView.autoresizingMask =
      UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
  _loadMoreView.delegate = self;
  [self addSubview:_loadMoreView];
  //  self.tableFooterView = _loadMoreView;
}

#pragma mark - View changes

- (void)layoutSubviews {
  [super layoutSubviews];
  CGFloat visibleTableDiffBoundsHeight =
      (self.bounds.size.height -
       MIN(self.bounds.size.height, self.contentSize.height));

  CGRect loadMoreFrame = _loadMoreView.frame;
  loadMoreFrame.origin.y =
      self.contentSize.height + visibleTableDiffBoundsHeight;
  _loadMoreView.frame = loadMoreFrame;
}

#pragma mark - Preserving the original behaviour

- (void)setDelegate:(id<UITableViewDelegate>)delegate {
  if (delegateInterceptor) {
    super.delegate = nil;
    delegateInterceptor.receiver = delegate;
    super.delegate = (id)delegateInterceptor;
  } else {
    super.delegate = delegate;
  }
}

- (void)reloadData {
  [super reloadData];
  // Give the footers a chance to fix it self.
  //  [_loadMoreView egoRefreshScrollViewDidScroll:self];
}

#pragma mark - Status Propreties

@synthesize pullTableIsRefreshing;
@synthesize pullTableIsLoadingMore;

- (void)setPullTableIsRefreshing:(BOOL)isRefreshing {
  if (!pullTableIsRefreshing && isRefreshing) {
    // If not allready refreshing start refreshing
    [_refreshView startAnimatingWithScrollView:self];
    pullTableIsRefreshing = YES;
  } else if (pullTableIsRefreshing && !isRefreshing) {
    [_refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    pullTableIsRefreshing = NO;
  }
}

- (void)setPullTableIsLoadingMore:(BOOL)isLoadingMore {
  if (!pullTableIsLoadingMore && isLoadingMore) {
    // If not allready loading more start refreshing
    [_loadMoreView startAnimatingWithScrollView:self];
    pullTableIsLoadingMore = YES;
  } else if (pullTableIsLoadingMore && !isLoadingMore) {
    [_loadMoreView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    pullTableIsLoadingMore = NO;
  }
}

#pragma mark - Display properties

@synthesize pullArrowImage;
@synthesize pullBackgroundColor;
@synthesize pullTextColor;
@synthesize pullLastRefreshDate;

- (void)configDisplayProperties {
  [_refreshView setBackgroundColor:self.pullBackgroundColor
                         textColor:self.pullTextColor
                        arrowImage:self.pullArrowImage];
  [_loadMoreView setBackgroundColor:self.pullBackgroundColor
                          textColor:self.pullTextColor
                         arrowImage:self.pullArrowImage
                         finishText:nil];
}

- (void)setPullArrowImage:(UIImage *)aPullArrowImage {
  if (aPullArrowImage != pullArrowImage) {
    pullArrowImage = [aPullArrowImage copy];
    [self configDisplayProperties];
  }
}

- (void)setPullBackgroundColor:(UIColor *)aColor {
  if (aColor != pullBackgroundColor) {
    pullBackgroundColor = [aColor copy];
    [self configDisplayProperties];
  }
}

- (void)setPullTextColor:(UIColor *)aColor {
  if (aColor != pullTextColor) {
    pullTextColor = [aColor copy];
    [self configDisplayProperties];
  }
}

- (void)setPullLastRefreshDate:(NSDate *)aDate {
  if (aDate != pullLastRefreshDate) {
    pullLastRefreshDate = [aDate copy];
    [_refreshView refreshLastUpdatedDate];
  }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (!self.refreshEnable) {
    return;
  }

  [_refreshView egoRefreshScrollViewDidScroll:scrollView];

  if (!self.isFinished) {
    _loadMoreView.hidden = NO;
    [_loadMoreView egoRefreshScrollViewDidScroll:scrollView];
  } else {
    [self.loadMoreView updatePullState:EGOOPullPullFinish];
  }

  // Also forward the message to the real delegate
  if ([delegateInterceptor.receiver
          respondsToSelector:@selector(scrollViewDidScroll:)]) {
    [delegateInterceptor.receiver scrollViewDidScroll:scrollView];
  }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {

  if (!self.refreshEnable) {
    return;
  }

  [_refreshView egoRefreshScrollViewDidEndDragging:scrollView];

  // Also forward the message to the real delegate
  if ([delegateInterceptor.receiver
          respondsToSelector:@selector(scrollViewDidEndDragging:
                                                 willDecelerate:)]) {
    [delegateInterceptor.receiver scrollViewDidEndDragging:scrollView
                                            willDecelerate:decelerate];
  }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  if (!self.refreshEnable) {
    return;
  }

  [_refreshView egoRefreshScrollViewWillBeginDragging:scrollView];

  // Also forward the message to the real delegate
  if ([delegateInterceptor.receiver
          respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
    [delegateInterceptor.receiver scrollViewWillBeginDragging:scrollView];
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}

#pragma mark - EGORefreshTableHeaderDelegate

- (void)egoRefreshTableHeaderDidTriggerRefresh:
    (EGORefreshTableHeaderView *)view {
  pullTableIsRefreshing = YES;
  [_pullDelegate pullTableViewDidTriggerRefresh:self];
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:
    (EGORefreshTableHeaderView *)view {
  return self.pullLastRefreshDate;
}

#pragma mark - LoadMoreTableViewDelegate

- (void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView *)view {
  pullTableIsLoadingMore = YES;
  [_pullDelegate pullTableViewDidTriggerLoadMore:self];
}

@end
