//
//  DBTTimeRecord.h
//  TimeIn
//
//  Created by nOki on 9/10/14.
//  Copyright (c) 2014 dennis tinoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBTTimeRecord : NSObject
{
    NSDate *_timeIn;
    NSDate *_timeOut;
    NSDate *_dateCreated;
    NSTimeInterval _workingTime;

}
+ (instancetype) createTimeRecord;

- (instancetype) init;
+ (instancetype) createTimeRecordWithTimeOut;

- (instancetype) initWithTimeOut;

- (void) setTimeIn:(NSDate *)date;
- (NSDate *)timeIn;

- (void) setTimeOut:(NSDate *)date;
- (NSDate *)timeOut;

- (void) setWorkingTime:(NSTimeInterval)timeInterval;
- (NSTimeInterval)workingTime;

- (NSDate *) dateCreated;

@end
