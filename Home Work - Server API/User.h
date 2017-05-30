//
//  User.h
//  Home Work - Server API
//
//  Created by Mikhail Kozlyukov on 31.03.17.
//  Copyright © 2017 Chebahatt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (assign, nonatomic) BOOL isOnline;
@property (strong, nonatomic) NSString* userID;
@property (assign, nonatomic) NSString* cityID;
@property (assign, nonatomic) NSString* countryID;
@property (strong, nonatomic) NSURL* imageURL_50;
@property (strong, nonatomic) NSURL* imageURL_100;
@property (strong, nonatomic) NSString* groupName;
@property (strong, nonatomic) NSString* groupType;



- (id) initWithServerResponse:(NSDictionary*) responseObject;

@end
