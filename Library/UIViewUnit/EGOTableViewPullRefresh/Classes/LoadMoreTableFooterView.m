//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
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

#import "LoadMoreTableFooterView.h"

@interface LoadMoreTableFooterView (Private)
- (void)setState:(EGOPullState)aState;
- (CGFloat)scrollViewOffsetFromBottom:(UIScrollView *)scrollView;
- (CGFloat)visibleTableHeightDiffWithBoundsHeight:(UIScrollView *)scrollView;
@end

@implementation LoadMoreTableFooterView

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {

    isLoading = NO;

    CGFloat midY = PULL_AREA_HEIGTH / 2;

    /* Config Status Updated Label */
    UILabel *label = [[UILabel alloc]
        initWithFrame:CGRectMake(0.0f, midY - 10, self.frame.size.width,
                                 20.0f)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.font = [UIFont boldSystemFontOfSize:13.0f];
    //    label.shadowOffset = CGSizeMake(0.0f, 1.0f);
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    _statusLabel = label;

    /* Config Arrow Image */
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(25.0f, midY - 20, 30.0f, 55.0f);
    layer.contentsGravity = kCAGravityResizeAspect;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
      layer.contentsScale = [[UIScreen mainScreen] scale];
    }
#endif
    [[self layer] addSublayer:layer];
    _arrowImage = layer;

    /* Config activity indicator */
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc]
        initWithActivityIndicatorStyle:DEFAULT_ACTIVITY_INDICATOR_STYLE];
    view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2.0 - 65,
                            midY - 10, 20.0f, 20.0f);
    [self addSubview:view];
    _activityView = view;
    [self setState:EGOOPullNormal]; // Also transform the image
    /* Configure the default colors and arrow image */
    [self setBackgroundColor:nil textColor:nil arrowImage:nil finishText:nil];
  }

  return self;
}

#pragma mark - Util
- (CGFloat)scrollViewOffsetFromBottom:(UIScrollView *)scrollView {
  CGFloat scrollAreaContenHeight = scrollView.contentSize.height;

  CGFloat visibleTableHeight =
      MIN(scrollView.bounds.size.height, scrollAreaContenHeight);
  CGFloat scrolledDistance = scrollView.contentOffset.y +
                             visibleTableHeight; // If scrolled all the way down
                                                 // this should add upp to the
                                                 // content heigh.

  CGFloat normalizedOffset = scrollAreaContenHeight - scrolledDistance;

  return normalizedOffset;
}

- (CGFloat)visibleTableHeightDiffWithBoundsHeight:(UIScrollView *)scrollView {
  return (scrollView.bounds.size.height -
          MIN(scrollView.bounds.size.height, scrollView.contentSize.height));
}

#pragma mark -
#pragma mark Setters

- (void)setState:(EGOPullState)aState {

  switch (aState) {
  case EGOOPullPulling:

    //    _statusLabel.text = NSLocalizedStringFromTable(
    //        @"Release to load more...", @"PullTableViewLan",
    //        @"Release to load more status");
    //    _statusLabel.text = @"释放即可刷新";
    _statusLabel.text = @"加载更多...";
    [CATransaction begin];
    [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
    _arrowImage.transform = CATransform3DIdentity;
    [CATransaction commit];

    break;
  case EGOOPullNormal:

    if (_state == EGOOPullPulling) {
      [CATransaction begin];
      [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
      _arrowImage.transform =
          CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
      [CATransaction commit];
    }
    _statusLabel.text = @"上拉加载更多";
    [_activityView stopAnimating];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    _arrowImage.hidden = NO;
    _arrowImage.transform =
        CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
    [CATransaction commit];

    break;
  case EGOOPullLoading:
    _statusLabel.text = @"正在加载...";
    [_activityView startAnimating];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    _arrowImage.hidden = YES;
    [CATransaction commit];

    break;

  case EGOOPullPullFinish:
    _statusLabel.text = self.finishText;
    break;
  default:
    break;
  }

  _statusLabel.font = [UIFont systemFontOfSize:14];
  _state = aState;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
                 textColor:(UIColor *)textColor
                arrowImage:(UIImage *)arrowImage
                finishText:(NSString *)finishText {
  self.backgroundColor =
      backgroundColor ? backgroundColor : DEFAULT_BACKGROUND_COLOR;
  _statusLabel.textColor = textColor ? textColor : DEFAULT_TEXT_COLOR;
  _statusLabel.shadowColor = [UIColor clearColor];
  //      [_statusLabel.textColor colorWithAlphaComponent:0.1f];

  _arrowImage.contents =
      (id)(arrowImage ? arrowImage.CGImage : DEFAULT_ARROW_IMAGE.CGImage);

  self.finishText = finishText;
}

- (void)updatePullState:(EGOPullState)state {
  // finish的时候用
  [self setState:EGOOPullPullFinish];
}

#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {
  CGFloat bottomOffset = [self scrollViewOffsetFromBottom:scrollView];
  if (_state == EGOOPullLoading) {

    CGFloat offset = MAX(bottomOffset * -1, 0);
    offset = MIN(offset, PULL_AREA_HEIGTH);
    UIEdgeInsets currentInsets = scrollView.contentInset;
    currentInsets.bottom =
        offset
            ? offset + [self visibleTableHeightDiffWithBoundsHeight:scrollView]
            : 0;
    scrollView.contentInset = currentInsets;

  } else if (scrollView.isDragging) {
    if (_state == EGOOPullPulling && bottomOffset < 0.0f && !isLoading) {
      [self setState:EGOOPullNormal];
    } else if (_state == EGOOPullNormal &&
               bottomOffset < -PULL_TRIGGER_HEIGHT && !isLoading) {
      [self setState:EGOOPullPulling];
    }

    // add by polen
    if ([self scrollViewOffsetFromBottom:scrollView] <= PULL_TRIGGER_HEIGHT &&
        !isLoading) {
      [self startAnimatingWithScrollView:scrollView];

      if ([self.delegate
              respondsToSelector:@selector(
                                     loadMoreTableFooterDidTriggerLoadMore:)]) {
        [self.delegate loadMoreTableFooterDidTriggerLoadMore:self];
      }
    }

    if (scrollView.contentInset.bottom != 0) {
      UIEdgeInsets currentInsets = scrollView.contentInset;
      currentInsets.bottom = 0;
      scrollView.contentInset = currentInsets;
    }
  }
  //    DDLogDebug(@"%@",@(scrollView.contentOffset.y));

  // add by jiang  增加label透明度
  if (scrollView.contentOffset.y > -PULL_TRIGGER_HEIGHT) {
    _statusLabel.alpha =
        bottomOffset * 10.0f / -PULL_TRIGGER_HEIGHT / 10.0f - 0.1;
  } else {
    _statusLabel.alpha = 1.0f;
  }
}

- (void)startAnimatingWithScrollView:(UIScrollView *)scrollView {
  isLoading = YES;
  [self setState:EGOOPullLoading];
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.2];
  UIEdgeInsets currentInsets = scrollView.contentInset;
  currentInsets.bottom =
      PULL_AREA_HEIGTH +
      [self visibleTableHeightDiffWithBoundsHeight:scrollView];
  scrollView.contentInset = currentInsets;
  [UIView commitAnimations];
  if ([self scrollViewOffsetFromBottom:scrollView] == 0) {
    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x,
                                             scrollView.contentOffset.y +
                                                 PULL_TRIGGER_HEIGHT)
                        animated:YES];
  }
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {

  // move it to egoRefreshScrollViewDidScroll
  //  if ([self scrollViewOffsetFromBottom:scrollView] <= -PULL_TRIGGER_HEIGHT
  //  &&
  //      !isLoading) {
  //    [self startAnimatingWithScrollView:scrollView];
  //
  //    if ([self.delegate
  //            respondsToSelector:@selector(
  //                                   loadMoreTableFooterDidTriggerLoadMore:)])
  //                                   {
  //      [self.delegate loadMoreTableFooterDidTriggerLoadMore:self];
  //    }
  //  }
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:
    (UIScrollView *)scrollView {

  isLoading = NO;

  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:.3];
  UIEdgeInsets currentInsets = scrollView.contentInset;
  //  modify by polen v1.0.1:设置 =0，则loadmore之后会自动归位，
  //    currentInsets.bottom = 0;
  scrollView.contentInset = currentInsets;
  [UIView commitAnimations];

  [self setState:EGOOPullNormal];
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
  _delegate = nil;
}

@end
