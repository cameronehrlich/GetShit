//
//  GSSearch.h
//  GetShit
//
//  Created by Cameron Ehrlich on 9/10/12.
//  Copyright (c) 2012 Cameron Ehrlich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "GSSearchItem.h"
#import "TFHpple.h"

@interface GSSearch : NSObject

@property (nonatomic, strong) NSMutableArray *searchData;

+ (NSArray *) searchWithQueryString:(NSString *)query;

@end
