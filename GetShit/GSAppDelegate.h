//
//  GSAppDelegate.h
//  GetShit
//
//  Created by Cameron Ehrlich on 9/10/12.
//  Copyright (c) 2012 Cameron Ehrlich. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "GSSearch.h"
#import "GSSearchItem.h"

@interface GSAppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic, strong) IBOutlet NSWindow *window;
@property (nonatomic, strong) IBOutlet NSTableView *tableView;
@property (nonatomic, strong) IBOutlet NSSearchField *searchField;
@property (nonatomic, strong) IBOutlet NSProgressIndicator *activityIndicator;
@property (nonatomic, strong) IBOutlet NSTextFieldCell *statusLabel;
@property (nonatomic, strong) GSSearch *searchObject;

- (IBAction)focusSearchBar:(id)sender;
- (IBAction)searchAction:(id)sender;
- (IBAction)downloadItemAtSelectedRow:(id)sender;

@end
