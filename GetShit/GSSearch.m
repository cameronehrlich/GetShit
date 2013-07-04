    //
    //  GSSearch.m
    //  GetShit
    //
    //  Created by Cameron Ehrlich on 9/10/12.
    //  Copyright (c) 2012 Cameron Ehrlich. All rights reserved.
    //

#import "GSSearch.h"

static NSString *thePirateBayUrl = @"http://thepiratebay.com";

@implementation GSSearch

-(id) init
{
    self = [super init];
    if (self) {
        _searchData = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (NSArray *) searchWithQueryString:(NSString *)query{
    
    NSMutableArray *results = [NSMutableArray new];
    
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:[NSData dataWithContentsOfURL:[self constructURLWithQueryString:query]]];
    NSMutableArray * elements  = [[doc searchWithXPathQuery:@"/html/body/div/div/div/table/tr"] mutableCopy];
    
    for (TFHppleElement *element in elements) {
        GSSearchItem *searchItem = [[GSSearchItem alloc] init];
        // get all the tds with in a tr
        NSArray *tmpTDs = [element childrenWithTagName:@"td"];
        
        //get the title and the link the the comments
        TFHppleElement *tmpLink = [[[tmpTDs objectAtIndex:1] firstChildWithClassName:@"detName"] firstChildWithClassName:@"detLink"];

         // link to the comments
        // [NSString stringWithFormat:@"%@%@", thePirateBayUrl, [[tmpLink attributes] objectForKey:@"href"]];

        NSString *tmpTitle = [tmpLink text];
        searchItem.title = tmpTitle;
        
        
        // get the magnet link url
        searchItem.magnet = [[[[tmpTDs objectAtIndex:1] firstChildWithTagName:@"a"] attributes] objectForKey:@"href"];
        
        // get categories
        NSMutableArray *tmpCategories = [NSMutableArray new];

        NSArray *tmpCategoryLinks = [[[tmpTDs objectAtIndex:0] firstChildWithTagName:@"center"] childrenWithTagName:@"a"];
        for (TFHppleElement *cat in tmpCategoryLinks) {
            [tmpCategories addObject:[cat text]];
        }
        searchItem.category = [tmpCategories objectAtIndex:0];
        

        TFHppleElement *tmpDescription = [[tmpTDs objectAtIndex:1] firstChildWithClassName:@"detDesc"];
        NSArray *tmpDescriptionTDs = [[tmpDescription text] componentsSeparatedByString:@", "];
        
        // uploaded date
        NSString *tmpUploadedString = [tmpDescriptionTDs objectAtIndex:0];
        tmpUploadedString = [tmpUploadedString stringByReplacingOccurrencesOfString:@"Uploaded " withString:@""];
        searchItem.uploaded = tmpUploadedString;

        // size
        NSString *tmpSizeString = [tmpDescriptionTDs objectAtIndex:1];
        tmpSizeString = [tmpSizeString stringByReplacingOccurrencesOfString:@"Size " withString:@""];
        searchItem.sizeOfItem = tmpSizeString;
        
        // seeders
        TFHppleElement *tmpSeeders = [tmpTDs objectAtIndex:2];
        searchItem.seeders = tmpSeeders.text;
        
        // leachers
        TFHppleElement *tmpLeecher = [tmpTDs objectAtIndex:3];
        searchItem.leechers = tmpLeecher.text;

        [results addObject:searchItem];
    }
    
    return [results copy];
}

+ (NSURL *) constructURLWithQueryString: (NSString *) query {
    NSString *searchURLString = [NSString stringWithFormat:@"%@/search/%@/0/7/0", thePirateBayUrl, [query stringByReplacingOccurrencesOfString:@" " withString:@"."]];
    return  [NSURL URLWithString:searchURLString];
}

-(void)performSearchWithString:(NSString *) searchString
{
    
        //create url string with search term in it
//    NSString *searchURLString = [NSString stringWithFormat:@"http://thepiratebay.com/search/%@/0/7/0", [searchString  stringByReplacingOccurrencesOfString:@" " withString:@"."]];
//    
//        // create the url
//    NSURL *searchURL = [NSURL URLWithString:searchURLString];
//    
//        // create the parser
//    NSError *error;
//    HTMLParser *parser = [[HTMLParser alloc] initWithContentsOfURL:searchURL error:&error];
//    
//
//    dispatch_queue_t main = dispatch_get_main_queue();
//    
//        // check if request had any errors
//    if (error) {
//        
//        dispatch_block_t update = ^{
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"statusUpdate" object:nil userInfo:[NSMutableDictionary dictionaryWithObject:@"Check your internet Connection." forKey:@"message"]];
//        };
//        
//        dispatch_async(main, update);
//        
//        return;
//    }
//    
//        // create the body node
//    HTMLNode *bodyNode = [parser body];
//    
//        //create the array of table rows
//    NSMutableArray *tr = [[bodyNode findChildTags:@"tr"] mutableCopy];
//    
//        //check if we have table rows
//    if([tr count] < 1){
//        dispatch_block_t update = ^{
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"statusUpdate" object:nil userInfo:[NSMutableDictionary dictionaryWithObject:@"No results found." forKey:@"message"]];
//        };
//        
//        dispatch_async(main, update);
//        return;
//    }
//    
//        //remove the table header
//    [tr removeObjectAtIndex:0];
//    [searchData removeAllObjects];

    
//        //begin parsing
//    for (HTMLNode *trnode in tr) {
//            //initialize pointer and GSSearchItem
//        HTMLNode *pointer;
//        GSSearchItem *newSearchItem = [[GSSearchItem alloc] init];
//        
//            //place pointer at beggining of dom
//        pointer = [trnode firstChild];
//        
//            //add to category
//        NSString *catagoryString = [[NSString alloc] initWithString:[[[pointer firstChild] firstChild] rawContents]];
//        [newSearchItem setCategory:[catagoryString stringByReplacingOccurrencesOfString:@"&gt;" withString:@"&"]];
//        
//            //move pointer to title
//        pointer = [[pointer nextSibling] nextSibling];
//        
//            // add title
//        [newSearchItem setTitle:[[[pointer firstChild] firstChild] rawContents]];
//        
//            //move pointer to upload date
//        pointer = [[pointer nextSibling] nextSibling];
//        
//            //add uploaded
//        [newSearchItem setUploaded:[[pointer firstChild] rawContents]];
//        
//            //move pointer to magnet
//        pointer = [[pointer nextSibling] nextSibling];
//        
//            //add magnet
//        [newSearchItem setMagnet:[[[pointer firstChild] firstChild] getAttributeNamed:@"href"]];
//        
//            //move pointer to size
//        pointer = [[pointer nextSibling] nextSibling];
//        
//            //add size
//        [newSearchItem setSizeOfItem:[[pointer firstChild] rawContents]];
//        
//            //move pointer to seeders
//        pointer = [[pointer nextSibling] nextSibling];
//        
//            // add size
//        [newSearchItem setSeeders:[[pointer firstChild] rawContents]];
//        
//            //move pointer to leechers
//        pointer = [[pointer nextSibling] nextSibling];
//        
//            // add leechers
//        [newSearchItem setLeechers:[[pointer firstChild] rawContents]];
//        
//            //add new search item to search data array
//        [searchData addObject:newSearchItem];
//        pointer = nil;
//        newSearchItem = nil;
//    }
    
}


@end