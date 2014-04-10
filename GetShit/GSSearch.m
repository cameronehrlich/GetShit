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

+ (NSArray *)searchWithQueryString:(NSString *)query{
    
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

+ (NSURL *)constructURLWithQueryString: (NSString *) query {
    NSString *searchURLString = [NSString stringWithFormat:@"%@/search/%@/0/7/0", thePirateBayUrl, [query stringByReplacingOccurrencesOfString:@" " withString:@"."]];
    return  [NSURL URLWithString:searchURLString];
}


@end
