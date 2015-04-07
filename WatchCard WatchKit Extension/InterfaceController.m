//
//  InterfaceController.m
//  WatchCard WatchKit Extension
//
//  Created by Zach Nagengast on 3/25/15.
//  Copyright (c) 2015 zaucetech. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
//    [WKInterfaceController openParentApplication:@{@"action" : @"loadParentApp"} reply:^(NSDictionary *replyInfo, NSError *error) {
//        if (error) {
//            NSLog(@"Error from parent: %@", error);
//        } else {
//            NSLog(@"Reply from parent: %@", replyInfo);
//        }
//    }];
    
    [self loadInterface];

}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)loadInterface
{
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.zaucetech.watchcard"];
    
    NSData *imageData = [defaults objectForKey:@"image"];
    UIImage *image = [UIImage imageWithData:imageData];
    
    if (image != nil)
    {
        [self.qrImage setImage:image];
        
        NSString *nameString = [defaults valueForKey:@"name"];
        NSString *descString = [defaults valueForKey:@"description"];
        
        [self.nameLabel setText:nameString];
        [self.descriptionLabel setText:descString];
    }
    else
    {
        [self.qrImage setImage:[UIImage imageNamed:@"ExampleContact"]];
    }
}

@end



