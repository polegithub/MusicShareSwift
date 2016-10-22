//
//  DDWGS-84ToGCJ-02.h
//  shop
//
//  Created by polen on 15/12/3.
//  Copyright (c) 2015年 DaDa Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsWGS_84ToGCJ_02 : NSObject

+ (CLLocation *)transformToMars:(CLLocation *)location;

@end
