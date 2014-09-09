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

- (void)removeTimeRecord:(DBTTimeRecord *)timeRecord
{
    [self.privateTimeRecords removeObjectIdenticalTo:timeRecord];
}
@end
