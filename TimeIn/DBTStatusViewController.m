//
//  DBTStatusViewController.m
//  TimeIn
//
//  Created by nOki on 9/10/14.
//  Copyright (c) 2014 dennis tinoy. All rights reserved.
//

#import "DBTStatusViewController.h"
#import "DBTStatusView.h"
#import "DBTTimeRecordStore.h"
#import "DBTTimeRecord.h"

@implementation DBTStatusViewController

DBTTimeRecord *currentTimeRecord;

CGRect workingTimeRect;
UIView *workingTimeView;
UILabel *workingTimeLabel;
UILabel *workingTimeHour;

CGRect timeInRect;
NSDate *timeIn;
UIView *timeInView;
UILabel *timeInLabel;
UILabel *timeInHourLabel;
UILabel *timeInDayLabel;





UIButton *controlButton;

NSString *stringFromInterval(NSTimeInterval timeInterval)
{
#define SECONDS_PER_MINUTE (60)
#define MINUTES_PER_HOUR (60)
#define SECONDS_PER_HOUR (SECONDS_PER_MINUTE * MINUTES_PER_HOUR)
#define HOURS_PER_DAY (24)
    
    // convert the time to an integer, as we don't need double precision, and we do need to use the modulous operator
    int ti = round(timeInterval);
    
    return [NSString stringWithFormat:@"%.2d:%.2d:%.2d", (ti / SECONDS_PER_HOUR) % HOURS_PER_DAY, (ti / SECONDS_PER_MINUTE) % MINUTES_PER_HOUR, ti % SECONDS_PER_MINUTE];
    
#undef SECONDS_PER_MINUTE
#undef MINUTES_PER_HOUR
#undef SECONDS_PER_HOUR
#undef HOURS_PER_DAY
}

- (bool) isToday: (NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:date];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    if([today isEqualToDate:otherDate]) {
        return TRUE;
    }
    
    return FALSE;
}


- (instancetype) init
{
    self = [super init];
    
    if(self) {
        [self displayTimeIn];
        [self displayWorkingTime];
        [self displayControlButton];
//        [self startWorkingHoursTimer];
        
        NSArray *timeRecords = [[DBTTimeRecordStore sharedStore] allTimeRecords];
        
        if([timeRecords count])
        {
            [self createTimeOutButton];
        } else {
            [self createTimeInButton];
        }
        
    }
    
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Create a view
    DBTStatusView *backgroundView = [[DBTStatusView alloc] init];
    
    NSArray *timeRecords = [[DBTTimeRecordStore sharedStore] allTimeRecords];
    
    if([timeRecords count])
    {
        currentTimeRecord = [timeRecords lastObject];
        
        timeIn = [currentTimeRecord dateCreated];
        
        NSDateFormatter *formatter = nil;
        formatter = [[NSDateFormatter alloc] init];
        
        NSString *timeInLabelIndicator = @"Last";
        if([self isToday:timeIn])
        {
            timeInLabelIndicator = @"Today\'s";
        }
        NSString *timeInLabelText = [NSString stringWithFormat: @"%@ TimeIn", timeInLabelIndicator];
        [timeInLabel setText:timeInLabelText];
        
        
        NSString *timeInHourLabelText = [NSString stringWithFormat: @"h:mm:s a"];
        [formatter setDateFormat:timeInHourLabelText];
        [timeInHourLabel setText:[formatter stringFromDate:timeIn]];
        
        NSString *timeInDayLabelText = [NSString stringWithFormat: @"EE MMM d, yyyy"];
        [formatter setDateFormat:timeInDayLabelText];
        [timeInDayLabel setText:[formatter stringFromDate:timeIn]];
        
        
        
    } else {
        timeInHourLabel.text = @"No Record Found";
    }
    
    [backgroundView addSubview:workingTimeView];
    [workingTimeView addSubview:workingTimeLabel];
    [workingTimeView addSubview:workingTimeHour];
    
    
    [backgroundView addSubview:timeInView];
    [timeInView addSubview:timeInLabel];
    [timeInView addSubview:timeInHourLabel];
    [timeInView addSubview:timeInDayLabel];
    
    [backgroundView addSubview:controlButton];
    // Set it as *the* view of this view controller
    self.view = backgroundView;
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        
        // Set the tab bar item's title
        self.tabBarItem.title = @"Status";
        //        // Create a UIImage from a file
        //        // This will use Hypno@2x.png on retina display devices
        //        UIImage *i = [UIImage imageNamed:@"Hypno.png"];
        //
        //        // Put that image on the tab bar item
        //        self.tabBarItem.image = i;
    }
    
    return self;
}

- (void) displayControlButton
{
    CGRect controlButtonRect = CGRectMake(0 , 0, 72, 72);
    controlButton = [[UIButton alloc] initWithFrame:controlButtonRect];

    controlButton.layer.cornerRadius = controlButton.bounds.size.width / 2.0;
    

    controlButton.frame = CGRectMake(self.view.frame.size.width/2 - controlButton.frame.size.width/2,
                                     (self.view.frame.size.height/2 - controlButton.frame.size.height/2) +
                                     (workingTimeRect.origin.y-workingTimeRect.size.height),
                                     controlButton.frame.size.width,
                                     controlButton.frame.size.height);
    
    [controlButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    
}

- (void) createTimeOutButton
{
    [controlButton setTitle: @"TimeOut" forState: UIControlStateNormal];
    [controlButton setTitleColor: [UIColor lightTextColor] forState: UIControlStateNormal];
    
    [controlButton addTarget: self
                      action: @selector(stopTimeRecord:)
            forControlEvents: UIControlEventTouchDown];
    
    controlButton.layer.backgroundColor = [UIColor darkGrayColor].CGColor;
}
- (void) createTimeInButton
{
    [controlButton setTitle: @"TimeIn" forState: UIControlStateNormal];
    [controlButton setTitleColor: [UIColor darkGrayColor] forState: UIControlStateNormal];
    
    [controlButton addTarget: self
                      action: @selector(startTimeRecord:)
            forControlEvents: UIControlEventTouchDown];
    
    controlButton.layer.backgroundColor = [UIColor orangeColor].CGColor;
}
- (void) createResetButton
{
    [controlButton setTitle: @"Reset" forState: UIControlStateNormal];
    [controlButton setTitleColor: [UIColor darkGrayColor] forState: UIControlStateNormal];
    [controlButton addTarget: self
                      action: @selector(resetTimer:)
            forControlEvents: UIControlEventTouchDown];
    
    controlButton.layer.backgroundColor = [UIColor greenColor].CGColor;
}
- (void) refreshControlButton
{
    [controlButton removeTarget:nil
                         action:NULL
               forControlEvents:UIControlEventAllEvents];
}
- (void) displayWorkingTime
{
   
        workingTimeRect = CGRectMake(20, (timeInRect.origin.y + timeInRect.size.height + 20), 280, 80);
        CGRect workingTimeLabelRect = CGRectMake(0, 0, workingTimeRect.size.width, workingTimeRect.size.height/2);
        CGRect workingTimeHourRect = CGRectMake(0, workingTimeRect.size.height/2, workingTimeRect.size.width, workingTimeRect.size.height/3.3);
    
        workingTimeView = [[UIView alloc] initWithFrame:workingTimeRect];
    
        workingTimeLabel = [[UILabel alloc] initWithFrame:workingTimeLabelRect];
        workingTimeLabel.textColor = [UIColor darkGrayColor];
        workingTimeLabel.textAlignment = NSTextAlignmentCenter;
        [workingTimeLabel setFont:[UIFont systemFontOfSize:15]];
    
        workingTimeHour = [[UILabel alloc] initWithFrame:workingTimeHourRect];
        workingTimeHour.textColor = [UIColor orangeColor];
        workingTimeHour.textAlignment = NSTextAlignmentCenter;
        [workingTimeHour setFont:[UIFont systemFontOfSize:32]];
}

- (void) displayTimeIn
{
        timeInRect = CGRectMake(0, 70, 300, 60);
        CGRect timeInLabelRect = CGRectMake(20, 0, timeInRect.size.width, timeInRect.size.height/3);
        CGRect timeInHourLabelRect = CGRectMake(20, timeInLabelRect.origin.y + timeInLabelRect.size.height, timeInRect.size.width, timeInRect.size.height/3);
        CGRect timeInDayLabelRect = CGRectMake(20, timeInHourLabelRect.origin.y + timeInHourLabelRect.size.height, timeInRect.size.width, timeInRect.size.height/3);

        timeInView = [[UIView alloc] initWithFrame:timeInRect];
    
        timeInLabel = [[UILabel alloc] initWithFrame:timeInLabelRect];
        timeInHourLabel = [[UILabel alloc] initWithFrame:timeInHourLabelRect];
        timeInDayLabel = [[UILabel alloc] initWithFrame:timeInDayLabelRect];
    
        timeInLabel.textColor = [UIColor darkGrayColor];
        [timeInLabel setFont:[UIFont systemFontOfSize:20]];
    
        timeInHourLabel.textColor = [UIColor darkGrayColor];
        [timeInHourLabel setFont:[UIFont systemFontOfSize:15]];
    
        timeInDayLabel.textColor = [UIColor darkGrayColor];
        [timeInDayLabel setFont:[UIFont systemFontOfSize:10]];
}

- (IBAction)startTimeRecord:(id)sender
{
    NSLog(@"startTimeRecord");
    [[DBTTimeRecordStore sharedStore] createTimeRecord];
    
    [self refreshControlButton];
    [self createTimeOutButton];
    
    [self viewWillAppear: TRUE];
    [self startWorkingHoursTimer];
    
}

- (IBAction)resetTimer:(id)sender
{
    NSLog(@"resetTimer");
    //[self startWorkingHoursTimer];
    [self viewWillAppear: TRUE];
    [self refreshControlButton];
    [self createTimeInButton];
}

- (IBAction)stopTimeRecord:(id)sender
{
    NSLog(@"stopTimeRecord");
    [[DBTTimeRecordStore sharedStore] stopTimeRecord:currentTimeRecord];
    [timer invalidate];
    
    timer = nil;
    
    [self refreshControlButton];
    [self createResetButton];

    
}


-(void) startWorkingHoursTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(currentWorkingHoursTimerTick) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

-(void) currentWorkingHoursTimerTick
{
    NSTimeInterval currentWorkingHours = fabs([[NSDate date] timeIntervalSinceDate:timeIn]);

    workingTimeLabel.text = @"TimeIn duration";
    workingTimeView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    workingTimeView.layer.borderWidth = 1.0;
    
    
    NSString *workingTimeString = [NSString stringWithFormat: @"%@", stringFromInterval(currentWorkingHours)];
    workingTimeHour.text = workingTimeString;
    
}

@end
