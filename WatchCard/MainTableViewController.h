//
//  MainTableViewController.h
//  WatchCard
//
//  Created by Zach Nagengast on 3/25/15.
//  Copyright (c) 2015 zaucetech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface MainTableViewController : UITableViewController <ABPeoplePickerNavigationControllerDelegate>

@property (nonatomic,retain) IBOutlet UIImageView *qrImageView;

@end
