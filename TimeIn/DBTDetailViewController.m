//
//  DBTDetailViewController.m
//  TimeIn
//
//  Created by nOki on 9/10/14.
//  Copyright (c) 2014 dennis tinoy. All rights reserved.
//

#import "DBTDetailViewController.h"
#import "DBTTimeRecord.h"

@interface DBTDetailViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *timeInField;
@property (weak, nonatomic) IBOutlet UIDatePicker *timeOutField;

@property (weak, nonatomic) IBOutlet UILabel *timeInLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeOutLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdDateLabel;

@end

@implementation DBTDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    DBTTimeRecord *timeRecord = self.timeRecord;

    self.timeInField.date = timeRecord.timeIn;
    
    
    if(timeRecord.timeOut != nil)
    {
        self.timeOutField.date = timeRecord.timeOut;
    } else
    {
        [self.timeOutLabel removeFromSuperview];
        [self.timeOutField removeFromSuperview];
    }
    
    NSDate *dateCreated = [timeRecord dateCreated];
    
    
    NSDateFormatter *formatter = nil;
	formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"' 'EE MMM d, yyyy h:mm a' '"];
	[self.createdDateLabel setText:[formatter stringFromDate:dateCreated]];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Clear first responder
    [self.view endEditing:YES];
    
    DBTTimeRecord *timeRecord = self.timeRecord;
    timeRecord.timeIn = self.timeInField.date;
    
    if(self.timeOutField.date != nil)
    {
       timeRecord.timeOut = self.timeOutField.date;
    }
    
}
@end
