//
//  DBTTimeRecord.m
//  TimeIn
//
//  Created by nOki on 9/10/14.
//  Copyright (c) 2014 dennis tinoy. All rights reserved.
//

#import "DBTTimeRecord.h"

@implementation DBTTimeRecord

+ (instancetype) createTimeRecord
{
    DBTTimeRecord *newTimeRecord = [[self alloc] init];
    
    return newTimeRecord;
}

- (instancetype) init
{
    self = [super init];
    if (self) {
        _timeIn = [[NSDate alloc] init];
        _dateCreated = [[NSDate alloc] init];
    }
    return self;
}

- (void) setTimeIn:(NSDate *)date
{
    _timeIn = date;
}

- (NSDate *) timeIn
{
    return _timeIn;
}

- (void) setTimeOut:(NSDate *)date
{
    _timeOut = date;
}



- (NSDate *) timeOut
{
    return _timeOut;
}

- (NSDate *)dateCreated
{
    return _dateCreated;
}

@end
