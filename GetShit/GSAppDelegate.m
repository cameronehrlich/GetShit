    //
    //  GSAppDelegate.m
    //  GetShit
    //
    //  Created by Cameron Ehrlich on 9/10/12.
    //  Copyright (c) 2012 Cameron Ehrlich. All rights reserved.
    //

#import <WebKit/WebKit.h>
#import "GSAppDelegate.h"


@implementation GSAppDelegate{
    NSArray *searchObjects;
    NSOperationQueue *operationQueue;
}



- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    operationQueue = [NSOperationQueue new];
    [operationQueue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
    
    [_window center];
    [_statusLabel setStringValue:@""];
    
    [_tableView setDoubleAction:@selector(downloadItemAtSelectedRow:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotifications:) name:@"statusUpdate" object:nil];
    
}

-(void)applicationDidBecomeActive:(NSNotification *)notification{
    [self focusSearchBar:nil];
}

-(void)getNotifications:(NSNotification*)notification{
    [_statusLabel setStringValue:[[notification userInfo] objectForKey:@"message"]];
    [_activityIndicator stopAnimation:nil];
    [_tableView reloadData];
}


- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
    return YES;
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [searchObjects count];
}

-(NSString *)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    
    if ([tableColumn.identifier isEqualToString:@"title"]) {
        return [[searchObjects objectAtIndex:row] title];
        
    }else if([tableColumn.identifier isEqualToString:@"category"]){
        return [[searchObjects objectAtIndex:row] category];
        
    }else if([tableColumn.identifier isEqualToString:@"seeders"]){
        return [[searchObjects objectAtIndex:row] seeders];
        
    }else if([tableColumn.identifier isEqualToString:@"leechers"]){
        return [[searchObjects objectAtIndex:row] leechers];
        
    }else if([tableColumn.identifier isEqualToString:@"size"]){
        return [[searchObjects objectAtIndex:row] sizeOfItem];
        
    }else if([tableColumn.identifier isEqualToString:@"uploaded"]){
        return [[searchObjects objectAtIndex:row] uploaded];
        
    }else if([tableColumn.identifier isEqualToString:@"magent"]){
        return [[searchObjects objectAtIndex:row] magnet];
        
    }else{
        return @"Error loading table";
    }
}

-(IBAction) downloadItemAtSelectedRow:(id) sender
{
    NSUInteger index = [[_tableView selectedRowIndexes] firstIndex];
        //iterate through set of selected indexes
    while(index != NSNotFound){
        WebView *downloadWebView = [[WebView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [downloadWebView setHidden:YES];
        [[downloadWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[searchObjects objectAtIndex:index] magnet]]]];
            //increment
        index= [[_tableView selectedRowIndexes] indexGreaterThanIndex: index];
    }
}

- (IBAction)focusSearchBar:(id)sender {
    [_searchField becomeFirstResponder];
}

- (IBAction)searchAction:(NSSearchField *)sender
{
    [_tableView deselectAll:self];
    [_statusLabel setStringValue:@""];
    if([[_searchField.stringValue stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]
       ||_searchField.stringValue == nil){
        searchObjects = @[];
        [_tableView reloadData];
    }
    else{
        NSLog(@"Searching : %@", sender.stringValue);
        
        [_activityIndicator startAnimation:nil];
        
        [operationQueue cancelAllOperations];
        [operationQueue addOperationWithBlock:^{
            NSArray *tmpSearch = [GSSearch searchWithQueryString:sender.stringValue];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                searchObjects = tmpSearch;
                [_tableView reloadData];
                [_activityIndicator stopAnimation:nil];
            }];
        }];
        
    }
    
}

@end
