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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (instancetype) init
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if(self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"TimeIn Records";
    }
    
    return self;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        
        // Set the tab bar item's title
        self.tabBarItem.title = @"Records";
        
        //        // Create a UIImage from a file
        //        // This will use Hypno@2x.png on retina display devices
        //        UIImage *i = [UIImage imageNamed:@"Hypno.png"];
        //
        //        // Put that image on the tab bar item
        //        self.tabBarItem.image = i;
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
    
    NSDate *timeIn = [timeRecord timeIn];
    
    
    NSDateFormatter *formatter = nil;
	formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"' 'EE MMM d, yyyy h:mm:s a' '"];
	[cell.textLabel setText:[formatter stringFromDate:timeIn]];
    
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
    DBTTimeRecord *newTimeRecord = [[DBTTimeRecordStore sharedStore] createTimeRecordWithTimeOut];
    
    NSInteger lastRow = [[[DBTTimeRecordStore sharedStore] allTimeRecords] indexOfObject:newTimeRecord];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
