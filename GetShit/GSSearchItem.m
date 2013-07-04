//
//  GSSearchItem.m
//  GetShit
//
//  Created by Cameron Ehrlich on 9/10/12.
//  Copyright (c) 2012 Cameron Ehrlich. All rights reserved.
//

#import "GSSearchItem.h"

@implementation GSSearchItem

-(NSString *)description{

    NSMutableString *output = [@"\n" mutableCopy];
    
    [output appendFormat:@" - Title: %@", _title];
    [output appendFormat:@"\n"];
    
    [output appendFormat:@" - Category: %@", _category];
    [output appendFormat:@"\n"];
    
    [output appendFormat:@" - Magnet: %@", _magnet];
    [output appendFormat:@"\n"];
    
    [output appendFormat:@" - Uploaded: %@", _uploaded];
    [output appendFormat:@"\n"];
    
    [output appendFormat:@" - Size: %@", _sizeOfItem];
    [output appendFormat:@"\n"];
    
    [output appendFormat:@" - Seeders: %@", _seeders];
    [output appendFormat:@"\n"];
    
    [output appendFormat:@" - Leachers: %@", _leechers];
    [output appendFormat:@"\n"];
    
    return output;
}

@end