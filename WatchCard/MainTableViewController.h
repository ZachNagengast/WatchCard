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

@interface MainTableViewController : UITableViewController <ABPeoplePickerNavigationControllerDelegate, UITextFieldDelegate>

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;
@property (readwrite) BOOL hideTableSection;

@property (nonatomic, retain) IBOutlet UIImageView *qrImageView;
@property (nonatomic, retain) IBOutlet UILabel *previewNameView;
@property (nonatomic, retain) IBOutlet UILabel *previewDescriptionView;
@property (nonatomic, retain) IBOutlet UITextField *nameField;
@property (nonatomic, retain) IBOutlet UITextField *descriptionField;
@property (nonatomic, retain) IBOutlet UITableView;

- (IBAction)saveData:(id)sender;

@end
