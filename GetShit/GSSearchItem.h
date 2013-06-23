//
//  GSSearchItem.h
//  GetShit
//
//  Created by Cameron Ehrlich on 9/10/12.
//  Copyright (c) 2012 Cameron Ehrlich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSSearchItem : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *uploaded;
@property (strong, nonatomic) NSString *magnet;
@property (strong, nonatomic) NSString *sizeOfItem;
@property (strong, nonatomic) NSString *seeders;
@property (strong, nonatomic) NSString *leechers;


@end
