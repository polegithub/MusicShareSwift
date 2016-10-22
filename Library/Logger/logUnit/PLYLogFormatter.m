//
//  PLYLogFormatter.m
//  baiduhealth
//
//  Created by Liu Bin on 13-11-19.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import "PLYLogFormatter.h"

@implementation PLYLogFormatter

/*
 formatLogMessage

 NSString *_message;
 DDLogLevel _level;
 DDLogFlag _flag;
 NSInteger _context;
 NSString *_file;
 NSString *_fileName;
 NSString *_function;
 NSUInteger _line;
 id _tag;
 DDLogMessageOptions _options;
 NSDate *_timestamp;
 NSString *_threadID;
 NSString *_threadName;
 NSString *_queueLabel;

 */

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
  [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
  NSString *time = [formatter stringFromDate:logMessage->_timestamp];
  NSString *file =
      [[logMessage->_file componentsSeparatedByString:@"/"] lastObject];
  int line = (int)logMessage->_line;
  return [NSString stringWithFormat:@"[%@][%@][%@:%d]\n%@\n", time, file,
                                    logMessage->_function, line,
                                    logMessage->_message];
}

@end
