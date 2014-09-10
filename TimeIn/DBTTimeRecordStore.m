//
//  DBTTimeRecordStore.m
//  TimeIn
//
//  Created by nOki on 9/10/14.
//  Copyright (c) 2014 dennis tinoy. All rights reserved.
//

#import "DBTTimeRecordStore.h"
#import "DBTTimeRecord.h"

@interface DBTTimeRecordStore ()

@property (nonatomic) NSMutableArray *privateTimeRecords;

@end

@implementation DBTTimeRecordStore

+ (instancetype) sharedStore
{
    static DBTTimeRecordStore *sharedStore = nil;
    
    if(!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
    
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[DBTTimeRecordStore sharedStore]"
                                 userInfo:nil];
    return nil;
}
        
- (instancetype)initPrivate
{
    self = [super init];
    
    if(self)
    {
        _privateTimeRecords = [[NSMutableArray alloc] init];
    }
        
    return self;
}

- (NSArray *) allTimeRecords
{
    return [self.privateTimeRecords copy];
}

- (DBTTimeRecord *) createTimeRecord
{
    DBTTimeRecord *timeRecord = [DBTTimeRecord createTimeRecord];
    
    [self.privateTimeRecords addObject:timeRecord];
    
    return timeRecord;
}
- (DBTTimeRecord *) createTimeRecordWithTimeOut
{
    DBTTimeRecord *timeRecord = [DBTTimeRecord createTimeRecordWithTimeOut];
    
    [self.privateTimeRecords addObject:timeRecord];
    
    return timeRecord;
}
- (void)removeTimeRecord:(DBTTimeRecord *)timeRecord
{
    [self.privateTimeRecords removeObjectIdenticalTo:timeRecord];
}

- (void)stopTimeRecord:(DBTTimeRecord *)timeRecord
{
    NSDate *date = [NSDate date] ;
    NSTimeInterval workingHours = fabs([date timeIntervalSinceDate:timeRecord.timeIn]);
    
    timeRecord.timeOut = date;
    timeRecord.workingTime = workingHours;
    
}
@end
