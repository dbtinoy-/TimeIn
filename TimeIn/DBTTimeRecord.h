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

}
+ (instancetype) createTimeRecord;

- (instancetype) init;


- (void) setTimeIn:(NSDate *)date;
- (NSString *)timeIn;

- (void) setTimeOut:(NSDate *)date;
- (NSString *)timeOut;

- (NSDate *) dateCreated;

@end
