//
//  User.m
//  Home Work - Server API
//
//  Created by Mikhail Kozlyukov on 31.03.17.
//  Copyright © 2017 Chebahatt. All rights reserved.
//

#import "User.h"

@implementation User

- (id) initWithServerResponse:(NSDictionary*) responseObject

{
    self = [super init];
    if (self) {
        self.firstName = [responseObject objectForKey:@"first_name"];
        self.lastName =  [responseObject objectForKey:@"last_name"];
        self.groupName =  [responseObject objectForKey:@"name"];
        self.groupType =  [responseObject objectForKey:@"type"];
        self.cityID =    [responseObject objectForKey:@"city"];
        self.countryID = [responseObject objectForKey:@"country"];
        self.isOnline =  [[responseObject objectForKey:@"online"] boolValue];
        self.userID =    [responseObject objectForKey:@"user_id"];
        self.imageURL_50 = [NSURL URLWithString:[responseObject objectForKey:@"photo_50"]];
        self.imageURL_100 = [NSURL URLWithString:[responseObject objectForKey:@"photo_100"]];
 }
    
    return self;
}

@end
