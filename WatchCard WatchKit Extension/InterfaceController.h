//
//  InterfaceController.h
//  WatchCard WatchKit Extension
//
//  Created by Zach Nagengast on 3/25/15.
//  Copyright (c) 2015 zaucetech. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface InterfaceController : WKInterfaceController

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *nameLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceImage *qrImage;

@end
