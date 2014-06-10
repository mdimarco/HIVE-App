//
//  Venue.h
//  CoffeeKit
//
//  Created by Scott McAlister on 1/21/14.
//  Copyright (c) 2014 4 Arrows Media, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Token : NSObject

@property (nonatomic, strong) NSString *access_token;
@property (nonatomic, strong) NSString *expires_in;
@property (nonatomic, strong) NSString *refresh_token;
@property (nonatomic, strong) NSString *token_type;

@end
