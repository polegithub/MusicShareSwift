//
//  EGORefreshTableHeaderView.h
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

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
  EGOOPullPulling = 0,
  EGOOPullNormal,
  EGOOPullLoading,
  EGOOPullPullFinish, //上拉到底
} EGOPullState;

#define DEFAULT_ARROW_IMAGE [UIImage imageNamed:@"iOS_blueArrow.png"]

// "#eeeeee" = 238/255 238/255 238/255
#define DEFAULT_BACKGROUND_COLOR                                               \
  [UIColor colorWithRed:238.0 / 255.0                                          \
                  green:238.0 / 255.0                                          \
                   blue:238.0 / 255.0                                          \
                  alpha:1.0]

#define DEFAULT_TEXT_COLOR                                                     \
  [UIColor colorWithRed:0.0 / 255.0                                            \
                  green:0.0 / 255.0                                            \
                   blue:0.0 / 255.0                                            \
                  alpha:0.9]
#define DEFAULT_ACTIVITY_INDICATOR_STYLE UIActivityIndicatorViewStyleGray

#define FLIP_ANIMATION_DURATION 0.18f

#define PULL_AREA_HEIGTH 50.0f

#define PULL_TRIGGER_HEIGHT (PULL_AREA_HEIGTH - 50)

@protocol EGORefreshTableHeaderDelegate;
@interface EGORefreshTableHeaderView : UIView {

  EGOPullState _state;

  UILabel *_lastUpdatedLabel;

  CALayer *_arrowImage;
  UIActivityIndicatorView *_activityView;

  // Set this to Yes when egoRefreshTableHeaderDidTriggerRefresh delegate is
  // called and No with egoRefreshScrollViewDataSourceDidFinishedLoading
  BOOL isLoading;
}

@property(nonatomic, strong) UILabel *statusLabel;

//下拉区域偏移（目前仅首页使用）, >0表示向下偏移
@property(nonatomic, assign) CGFloat pullAreaOffset;

@property(nonatomic, weak) id<EGORefreshTableHeaderDelegate> delegate;

- (void)refreshLastUpdatedDate;
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:
    (UIScrollView *)scrollView;
- (void)startAnimatingWithScrollView:(UIScrollView *)scrollView;
- (void)setBackgroundColor:(UIColor *)backgroundColor
                 textColor:(UIColor *)textColor
                arrowImage:(UIImage *)arrowImage;
- (void)setPullAreaOffset:(CGFloat)pullAreaOffset;
@end

@protocol EGORefreshTableHeaderDelegate <NSObject>
- (void)egoRefreshTableHeaderDidTriggerRefresh:
    (EGORefreshTableHeaderView *)view;
@optional
- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:
    (EGORefreshTableHeaderView *)view;

@end
