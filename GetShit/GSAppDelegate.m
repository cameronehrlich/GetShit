    //
    //  GSAppDelegate.m
    //  GetShit
    //
    //  Created by Cameron Ehrlich on 9/10/12.
    //  Copyright (c) 2012 Cameron Ehrlich. All rights reserved.
    //

#import <WebKit/WebKit.h>
#import "GSAppDelegate.h"


@implementation GSAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [_window center];
    
    _searchObject = [[GSSearch alloc] init];
    [GSSearch searchWithQueryString:@"colbert"];
    
    [_statusLabel setStringValue:@""];
    
    
    [_tableView setDoubleAction:@selector(downloadItemAtSelectedRow:)];
    
    [_tableView setTarget:self];
    [_tableView setDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotifications:) name:@"statusUpdate" object:nil];
    
}

-(void)getNotifications:(NSNotification*)notification{
    [_statusLabel setStringValue:[[notification userInfo] objectForKey:@"message"]];
    [_activityIndicator stopAnimation:nil];
    [[_searchObject searchData] removeAllObjects];
    [_tableView reloadData];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
    return YES;
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [[_searchObject searchData] count];
}

-(NSString *)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if (row < _searchObject.searchData.count) {
        
        if ([tableColumn.identifier isEqualToString:@"title"]) {
            return [[_searchObject searchData][row] title];
        }else if([tableColumn.identifier isEqualToString:@"category"]){
            return [[_searchObject searchData][row] category];
        }else if([tableColumn.identifier isEqualToString:@"seeders"]){
            return [[_searchObject searchData][row] seeders];
        }else if([tableColumn.identifier isEqualToString:@"leechers"]){
            return [[_searchObject searchData][row] leechers];
        }else if([tableColumn.identifier isEqualToString:@"size"]){
            return [[_searchObject searchData][row] sizeOfItem];
        }else if([tableColumn.identifier isEqualToString:@"uploaded"]){
            return [[_searchObject searchData][row] uploaded];
        }else if([tableColumn.identifier isEqualToString:@"magent"]){
            return [[_searchObject searchData][row] magnet];
        }else{
                //not possible
            NSLog(@"Error building table");
            return @"Error building table";
        }
    }
    return @"";
}



-(IBAction) downloadItemAtSelectedRow:(id) sender
{
    NSUInteger index = [[_tableView selectedRowIndexes] firstIndex];
        //iterate through set of selected indexes
    while(index != NSNotFound){
        WebView *downloadWebView = [[WebView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [downloadWebView setHidden:YES];
        [[downloadWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[_searchObject searchData][index] magnet]]]];
            //increment
        index= [[_tableView selectedRowIndexes] indexGreaterThanIndex: index];
    }
}

- (IBAction)focusSearchBar:(id)sender {
    [_searchField becomeFirstResponder];
}

- (IBAction)searchAction:(id)sender
{
    [_tableView deselectAll:self];
    [_statusLabel setStringValue:@""];
    if([[_searchField.stringValue stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]
       ||_searchField.stringValue == nil){
        
            //do nothing
    }
    else{
        [_activityIndicator startAnimation:nil];
//        dispatch_block_t block = ^{
//            
//            dispatch_queue_t main = dispatch_get_main_queue();
//            dispatch_block_t reload = ^{
//                if (_searchObject.searchData.count > 0) {
//                    [_tableView reloadData];
//                    [_activityIndicator stopAnimation:nil];
//                }
//            };
//            
//            dispatch_async(main, reload);
//        };
//        
//        dispatch_async(queue, block);
        
    }
    
}

@end
