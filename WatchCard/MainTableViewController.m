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

@synthesize name;
@synthesize description;
@synthesize nameField;
@synthesize descriptionField;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _hideTableSection = NO;
    
    self.nameField.delegate = self;
    self.descriptionField.delegate = self;
    self.previewNameView.text = @"Scroll down to setup";
    self.previewDescriptionView.text = @"Follow @zaucetech";
    [self.qrImageView.layer setCornerRadius:5];
    self.qrImageView.clipsToBounds = YES;
    self.qrImageView.image = [UIImage QRCodeGenerator:@"http://www.zaucetech.com"
                                       andLightColour:[UIColor colorWithRed:0.0 green:.886 blue:.447 alpha:1.0]
                                        andDarkColour:[UIColor blackColor]
                                         andQuietZone:1
                                              andSize:300];
    
    [self updateWatchFace];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
//    [self.view addGestureRecognizer:tap];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        NSLog(@"%@", [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text]);
        ABPeoplePickerNavigationController *nav = [[ABPeoplePickerNavigationController alloc] init];
        nav.peoplePickerDelegate = self;
        [self.navigationController presentViewController:nav animated:YES completion:nil];
        
    }
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        NSLog(@"%@", [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text]);

        [self.nameField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0];
    }
    if (indexPath.section == 1 && indexPath.row == 1)
    {
        NSLog(@"%@", [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text]);

        [self.descriptionField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0];
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Set the text color of our header/footer text.
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor colorWithRed:0.0 green:.886 blue:.447 alpha:1.0]];
    
    if  (section == 1)
    {
        _hideTableSection ? [header.textLabel setText:@""] : [header.textLabel setText:@"INTERFACE"];
    }
    
    // Set the background color of our header/footer.
//    header.contentView.backgroundColor = [UIColor blackColor];
    
    // You can also do this to set the background color of our header/footer,
    //    but the gradients/other effects will be retained.
    // view.tintColor = [UIColor blackColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if(section == 1 && _hideTableSection){
        return 0; //header height for selected section
    } else {
        return [super tableView:tableView heightForHeaderInSection:section]; }  //keeps inalterate all other Header
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if(section == 1 && _hideTableSection){
        return 0; //header height for selected section
    } else {
        return [super tableView:tableView heightForFooterInSection:section]; } //keeps inalterate all other footer
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 1) //Index number of interested section
    {
        if(_hideTableSection)
            return 0; //number of row in section when you click on hide
        else
            return 2; //number of row in section when you click on show (if it's higher than rows in Storyboard, app willcrash)
    }
    else
    {
        return [super tableView:tableView numberOfRowsInSection:section]; //keeps inalterate all other rows
    }
    
}

#pragma mark - AddressBook Delegate Methods

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    return YES;
}


-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    
    // reset the stuff
    self.name = @"";
    self.description = @"";
    self.previewNameView.text = nil;
    self.nameField.text = nil;
    self.previewDescriptionView.text = nil;
    self.descriptionField.text = nil;
    self.qrImageView.image = nil;
    
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
    NSString *number;
    if (property == kABPersonPhoneProperty)
    {
        
        CFTypeRef multivalue = ABRecordCopyValue(person, property);
        
        // Get the index of the selected number. Remember that the number multi-value property is being returned as an array.
        CFIndex index = ABMultiValueGetIndexForIdentifier(multivalue, identifier);
        
        // Copy the number value into a string.
        number = (__bridge NSString *)ABMultiValueCopyValueAtIndex(multivalue, index);
        
        
    }
    
    NSString *vCard = [VCard generateVCardStringWithRec:person];
    
    self.name = fullName;
    self.description = number;
    
    if (fullName == nil || [fullName isEqualToString:@""])
    {
        self.name = @"";
    }
    
    if (self.description == nil || [self.description isEqualToString:@""])
    {
        CFTypeRef multivalue = ABRecordCopyValue(person, kABPersonEmailProperty);
        
        // Get the index of the selected number. Remember that the number multi-value property is being returned as an array.
        CFIndex index = ABMultiValueGetIndexForIdentifier(multivalue, identifier);
        
        self.description = (__bridge NSString *)ABMultiValueCopyValueAtIndex(multivalue, index);;
    }
    
    
    
    self.qrImageView.image = [UIImage QRCodeGenerator:vCard
                                     andLightColour:[UIColor colorWithRed:0.0 green:.886 blue:.447 alpha:1.0]
                                      andDarkColour:[UIColor blackColor]
                                       andQuietZone:1
                                            andSize:300];
    
    self.nameField.text = self.name;
    self.descriptionField.text = self.description;

    [self saveData:nil];
    
    return NO;
}

- (void)updateWatchFace
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.zaucetech.watchcard"];
    NSString *nameString = [defaults objectForKey:@"name"];
    NSString *descString = [defaults objectForKey:@"description"];
    UIImage *img = [UIImage imageWithData:[defaults objectForKey:@"image"]];
    if (nameString != nil || descString != nil || img != nil)
    {
        self.previewNameView.text = nameString;
        self.nameField.text = nameString;
//    }
//    if (descString != nil)
//    {
        self.previewDescriptionView.text = descString;
        self.descriptionField.text = descString;
//    }
//    if (img != nil)
//    {
        self.qrImageView.image = img;
        
        _hideTableSection = NO;
    }
    else
    {
        _hideTableSection = YES;
    }
    
}

- (IBAction)saveData:(id)sender
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.zaucetech.watchcard"];
    
    [defaults setObject:self.nameField.text forKey:@"name"];
    [defaults setObject:self.descriptionField.text forKey:@"description"];
    [defaults setObject:UIImagePNGRepresentation(self.qrImageView.image) forKey:@"image"];
    [defaults synchronize];
    
    [self updateWatchFace];
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    NSLog(@"picked person");
    [self peoplePickerNavigationController:peoplePicker shouldContinueAfterSelectingPerson:person property:property identifier:identifier];
}


// Implement this delegate method to make the Cancel button of the Address Book working.
-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
//    [_addressBookController dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return ![self isEditing];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField performSelector:@selector(resignFirstResponder) withObject:nil afterDelay:0];
    if (textField == self.nameField)
    {
        [self.descriptionField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0];
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"began editting");
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

@end
