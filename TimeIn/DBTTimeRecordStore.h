//
//  DBTTimeRecordStore.h
//  TimeIn
//
//  Created by nOki on 9/10/14.
//  Copyright (c) 2014 dennis tinoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBTTimeRecord;

@interface DBTTimeRecordStore : NSObject

@property (nonatomic, readonly) NSArray *allTimeRecords;


+ (instancetype) sharedStore;

- (DBTTimeRecord *)createTimeRecord;
- (DBTTimeRecord *)createTimeRecordWithTimeOut;
- (void)removeTimeRecord:(DBTTimeRecord *)timeRecord;
- (void)stopTimeRecord:(DBTTimeRecord *)timeRecord;
@end
