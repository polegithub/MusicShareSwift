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

#import "EGORefreshTableHeaderView.h"

@interface EGORefreshTableHeaderView (Private)
- (void)setState:(EGOPullState)aState;
@end

@implementation EGORefreshTableHeaderView

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {

    isLoading = NO;
    CGFloat midY = [self pullAreaMidY];

    /* Config Last Updated Label */
    UILabel *label = [[UILabel alloc]
        initWithFrame:CGRectMake(0.0f, midY, self.frame.size.width, 20.0f)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.font = [UIFont systemFontOfSize:12.0f];
    label.shadowOffset = CGSizeMake(0.0f, 1.0f);
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    _lastUpdatedLabel = label;

    /* Config Status Updated Label */
    label = [[UILabel alloc]
        initWithFrame:CGRectMake(0.0f, midY - 18, self.frame.size.width,
                                 20.0f)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.font = [UIFont boldSystemFontOfSize:13.0f];
    label.shadowOffset = CGSizeMake(0.0f, 1.0f);
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    _statusLabel = label;

    /* Config Arrow Image */
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(25.0f, midY - 35, 30.0f, 55.0f);
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
    view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2.0f - 60,
                            midY - 8.f, 20.0f, 20.0f);
    [self addSubview:view];
    _activityView = view;

    [self setState:EGOOPullNormal];

    /* Configure the default colors and arrow image */
    [self setBackgroundColor:nil textColor:nil arrowImage:nil];
  }

  return self;
}

//偏移值（下拉使用）
- (void)setPullAreaOffset:(CGFloat)pullAreaOffset {
  _pullAreaOffset = pullAreaOffset;

  // activityView更新frame
  CGRect actFrame = _activityView.frame;
  actFrame.origin =
      CGPointMake(actFrame.origin.x, actFrame.origin.y + pullAreaOffset);
  _activityView.frame = actFrame;
}

- (CGFloat)pullAreaMidY {
  CGFloat midY = self.frame.size.height - PULL_AREA_HEIGTH / 2;
  if (self.pullAreaOffset != 0) {
    midY += self.pullAreaOffset;
  }

  return midY;
}

#pragma mark -
#pragma mark Setters

#define aMinute 60
#define anHour 3600
#define aDay 86400

- (void)refreshLastUpdatedDate {
  NSDate *date = nil;
  if ([self.delegate
          respondsToSelector:
              @selector(egoRefreshTableHeaderDataSourceLastUpdated:)]) {
    date = [self.delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
  }
  if (date) {
    NSTimeInterval timeSinceLastUpdate = [date timeIntervalSinceNow];
    NSInteger timeToDisplay = 0;
    timeSinceLastUpdate *= -1;

    if (timeSinceLastUpdate < anHour) {
      timeToDisplay = (NSInteger)(timeSinceLastUpdate / aMinute);

      if (timeToDisplay == /* Singular*/ 1) {
        _lastUpdatedLabel.text = [NSString
            stringWithFormat:NSLocalizedStringFromTable(
                                 @"Updated %ld minute ago", @"PullTableViewLan",
                                 @"Last uppdate in minutes singular"),
                             (long)timeToDisplay];
      } else {
        /* Plural */
        _lastUpdatedLabel.text =
            [NSString stringWithFormat:NSLocalizedStringFromTable(
                                           @"Updated %ld minutes ago",
                                           @"PullTableViewLan",
                                           @"Last uppdate in minutes plural"),
                                       (long)timeToDisplay];
      }

    } else if (timeSinceLastUpdate < aDay) {
      timeToDisplay = (NSInteger)(timeSinceLastUpdate / anHour);
      if (timeToDisplay == /* Singular*/ 1) {
        _lastUpdatedLabel.text = [NSString
            stringWithFormat:NSLocalizedStringFromTable(
                                 @"Updated %ld hour ago", @"PullTableViewLan",
                                 @"Last uppdate in hours singular"),
                             (long)timeToDisplay];
      } else {
        /* Plural */
        _lastUpdatedLabel.text = [NSString
            stringWithFormat:NSLocalizedStringFromTable(
                                 @"Updated %ld hours ago", @"PullTableViewLan",
                                 @"Last uppdate in hours plural"),
                             (long)timeToDisplay];
      }

    } else {
      timeToDisplay = (NSInteger)(timeSinceLastUpdate / aDay);
      if (timeToDisplay == /* Singular*/ 1) {
        _lastUpdatedLabel.text = [NSString
            stringWithFormat:NSLocalizedStringFromTable(
                                 @"Updated %ld day ago", @"PullTableViewLan",
                                 @"Last uppdate in days singular"),
                             (long)timeToDisplay];
      } else {
        /* Plural */
        _lastUpdatedLabel.text = [NSString
            stringWithFormat:NSLocalizedStringFromTable(
                                 @"Updated %ld days ago", @"PullTableViewLan",
                                 @"Last uppdate in days plural"),
                             (long)timeToDisplay];
      }
    }

  } else {
    _lastUpdatedLabel.text = nil;
  }

  // Center the status label if the lastupdate is not available
  CGFloat midY = [self pullAreaMidY];
  if (!_lastUpdatedLabel.text) {
    _statusLabel.frame =
        CGRectMake(0.0f, midY - 8, self.frame.size.width, 20.0f);
  } else {
    _statusLabel.frame =
        CGRectMake(0.0f, midY - 18, self.frame.size.width, 20.0f);
  }
}

- (void)setState:(EGOPullState)aState {

  switch (aState) {
  case EGOOPullPulling:

    //			_statusLabel.text = NSLocalizedStringFromTable(@"Release
    // to
    // refresh...",@"PullTableViewLan", @"Release to refresh status");
    _statusLabel.text = @"释放即可刷新";
    [CATransaction begin];
    [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
    _arrowImage.transform =
        CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
    [CATransaction commit];

    break;
  case EGOOPullNormal:

    if (_state == EGOOPullPulling) {
      [CATransaction begin];
      [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
      _arrowImage.transform = CATransform3DIdentity;
      [CATransaction commit];
    }

    //    _statusLabel.text = NSLocalizedStringFromTable(
    //        @"Pull down to refresh...", @"PullTableViewLan",
    //        @"Pull down to refresh status");
    _statusLabel.text = @"下拉刷新";
    [_activityView stopAnimating];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    _arrowImage.hidden = NO;
    _arrowImage.transform = CATransform3DIdentity;
    [CATransaction commit];

    [self refreshLastUpdatedDate];

    break;
  case EGOOPullLoading:

    //    _statusLabel.text = NSLocalizedStringFromTable(
    //        @"Loading...", @"PullTableViewLan", @"Loading Status");
    _statusLabel.text = @"正在刷新...";
    [_activityView startAnimating];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    _arrowImage.hidden = YES;
    [CATransaction commit];

    break;

  default:
    break;
  }
  _statusLabel.font = [UIFont systemFontOfSize:14];
  _state = aState;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
                 textColor:(UIColor *)textColor
                arrowImage:(UIImage *)arrowImage {
  self.backgroundColor =
      backgroundColor ? backgroundColor : DEFAULT_BACKGROUND_COLOR;

  if (textColor) {
    _lastUpdatedLabel.textColor = textColor;
    _statusLabel.textColor = textColor;
  } else {
    _lastUpdatedLabel.textColor = DEFAULT_TEXT_COLOR;
    _statusLabel.textColor = DEFAULT_TEXT_COLOR;
  }
  _lastUpdatedLabel.shadowColor = [UIColor clearColor];
  //      [_lastUpdatedLabel.textColor colorWithAlphaComponent:0.1f];
  _statusLabel.shadowColor = [UIColor clearColor];
  //      [_statusLabel.textColor colorWithAlphaComponent:0.1f];

  _arrowImage.contents =
      (id)(arrowImage ? arrowImage.CGImage : DEFAULT_ARROW_IMAGE.CGImage);
}

- (void)setHeadVerticalOffset:(CGFloat)offset {
  //向上/向下偏移
}

#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {

  if (_state == EGOOPullLoading) {
    CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
    offset = MIN(offset, PULL_AREA_HEIGTH);
    UIEdgeInsets currentInsets = scrollView.contentInset;
    currentInsets.top = offset;
    scrollView.contentInset = currentInsets;

  } else if (scrollView.isDragging) {
    if (_state == EGOOPullPulling &&
        scrollView.contentOffset.y > -PULL_AREA_HEIGTH &&
        scrollView.contentOffset.y < 0.0f && !isLoading) {
      [self setState:EGOOPullNormal];
    } else if (_state == EGOOPullNormal &&
               scrollView.contentOffset.y < -PULL_AREA_HEIGTH && !isLoading) {
      [self setState:EGOOPullPulling];
    }

    if (scrollView.contentInset.top != 0) {
      UIEdgeInsets currentInsets = scrollView.contentInset;
      currentInsets.top = 0;
      scrollView.contentInset = currentInsets;
    }
  }

  // add by jiang  增加label透明度
  if (scrollView.contentOffset.y > -PULL_AREA_HEIGTH) {
    _statusLabel.alpha =
        scrollView.contentOffset.y * 10.0f / -PULL_AREA_HEIGTH / 10.0f - 0.1;
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
  currentInsets.top = PULL_AREA_HEIGTH;
  scrollView.contentInset = currentInsets;
  [UIView commitAnimations];
  if (scrollView.contentOffset.y == 0) {
    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x,
                                             -PULL_TRIGGER_HEIGHT)
                        animated:YES];
  }
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {

  // add by jiang
  if (scrollView.contentOffset.y <= -PULL_AREA_HEIGTH && !isLoading) {
    if ([_delegate
            respondsToSelector:@selector(
                                   egoRefreshTableHeaderDidTriggerRefresh:)]) {
      [_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
    }
    [self startAnimatingWithScrollView:scrollView];
  }
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:
    (UIScrollView *)scrollView {

  isLoading = NO;

  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:.3];
  UIEdgeInsets currentInsets = scrollView.contentInset;
  currentInsets.top = 0;
  scrollView.contentInset = currentInsets;
  [UIView commitAnimations];

  [self setState:EGOOPullNormal];
}

- (void)egoRefreshScrollViewWillBeginDragging:(UIScrollView *)scrollView {
  [self refreshLastUpdatedDate];
}



#pragma mark -
#pragma mark Dealloc

@end
