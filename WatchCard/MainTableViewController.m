//
//  MainTableViewController.m
//  WatchCard
//
//  Created by Zach Nagengast on 3/25/15.
//  Copyright (c) 2015 zaucetech. All rights reserved.
//

#import "MainTableViewController.h"
#import "VCard.h"
#import "UIImage+QRCodeGenerator.h"

@interface MainTableViewController ()

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        NSLog(@"%@", [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text]);
        ABPeoplePickerNavigationController *nav = [[ABPeoplePickerNavigationController alloc] init];
        nav.peoplePickerDelegate = self;
        [self.navigationController presentViewController:nav animated:YES completion:nil];
        
    }
    
}

#pragma mark - AddressBook Delegate Methods

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    return YES;
}


-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    
    // Get the first and the last name. Actually, copy their values using the person object and the appropriate
    // properties into two string variables equivalently.
    // Watch out the ABRecordCopyValue method below. Also, notice that we cast to NSString *.
    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    // Compose the full name.
    NSString *fullName = @"";
    // Before adding the first and the last name in the fullName string make sure that these values are filled in.
    if (firstName != nil) {
        fullName = [fullName stringByAppendingString:firstName];
    }
    if (lastName != nil) {
        fullName = [fullName stringByAppendingString:@" "];
        fullName = [fullName stringByAppendingString:lastName];
    }
    
    
    // Get the multivalue number property.
    CFTypeRef multivalue = ABRecordCopyValue(person, property);
    
    // Get the index of the selected number. Remember that the number multi-value property is being returned as an array.
    CFIndex index = ABMultiValueGetIndexForIdentifier(multivalue, identifier);
    
    // Copy the number value into a string.
    NSString *number = (__bridge NSString *)ABMultiValueCopyValueAtIndex(multivalue, index);
    
    
    NSString *vCard = [VCard generateVCardStringWithRec:person];
    
    self.qrImageView.image = [UIImage QRCodeGenerator:vCard
                                       andLightColour:[UIColor blackColor]
                                        andDarkColour:[UIColor whiteColor]
                                         andQuietZone:1
                                              andSize:300];
    
//    nameTextField.text = fullName;
//    numberTextField.text = number;
    
    // Dismiss the contacts view controller.
//    [_addressBookController dismissViewControllerAnimated:YES completion:nil];
    
    return NO;
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    NSLog(@"picked person");
    [self peoplePickerNavigationController:peoplePicker shouldContinueAfterSelectingPerson:person property:property identifier:identifier];
}


// Implement this delegate method to make the Cancel button of the Address Book working.
-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
//    [_addressBookController dismissViewControllerAnimated:YES completion:nil];
}

@end
