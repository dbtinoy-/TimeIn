//
//  DBTTimeRecordsViewController.m
//  TimeIn
//
//  Created by nOki on 9/10/14.
//  Copyright (c) 2014 dennis tinoy. All rights reserved.
//

#import "DBTTimeRecordsViewController.h"
#import "DBTTimeRecordStore.h"
#import "DBTTimeRecord.h"
#import "DBTDetailViewController.h"

@interface DBTTimeRecordsViewController ()

@property (nonatomic, strong) IBOutlet UIView *headerView;

@end

@implementation DBTTimeRecordsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
    
    UIView *header = self.headerView;
    [self.tableView setTableHeaderView:header];
}

- (instancetype) init
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if(self) {

    }
    
    return self;
}

- (UIView *)headerView
{
    if (!_headerView) {
        
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView"
                                      owner:self
                                    options:nil];
    }
    
    return _headerView;
}


- (instancetype) initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBTDetailViewController *detailViewController =
    [[DBTDetailViewController alloc] init];
    
    
    NSArray *timeRecords = [[DBTTimeRecordStore sharedStore] allTimeRecords];
    DBTTimeRecord *selectedTimeRecord = timeRecords[indexPath.row];
    
    // Give detail view controller a pointer to the item object in row
    detailViewController.timeRecord = selectedTimeRecord;
    
    
    [self.navigationController pushViewController:detailViewController
                                         animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                    forIndexPath:indexPath];
    

    NSArray *timeRecords = [[DBTTimeRecordStore sharedStore] allTimeRecords];
    DBTTimeRecord *timeRecord = timeRecords[indexPath.row];
    
    NSDate *dateCreated = [timeRecord dateCreated];
    
    
    NSDateFormatter *formatter = nil;
	formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"' 'EE MMM d, yyyy h:mm a' '"];
	[cell.textLabel setText:[formatter stringFromDate:dateCreated]];
    
    return cell;
}
                       
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[DBTTimeRecordStore sharedStore] allTimeRecords] count];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *timeRecords = [[DBTTimeRecordStore sharedStore] allTimeRecords];
        DBTTimeRecord *timeRecord = timeRecords[indexPath.row];
        [[DBTTimeRecordStore sharedStore] removeTimeRecord:timeRecord];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (IBAction)addNewTimeRecord:(id)sender
{
    DBTTimeRecord *newTimeRecord = [[DBTTimeRecordStore sharedStore] createTimeRecord];
    
    NSInteger lastRow = [[[DBTTimeRecordStore sharedStore] allTimeRecords] indexOfObject:newTimeRecord];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
}

- (IBAction)toggleEditingMode:(id)sender
{
    if (self.isEditing) {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        [self setEditing:NO animated:YES];
    } else { 
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        [self setEditing:YES animated:YES];
    }
}
@end
