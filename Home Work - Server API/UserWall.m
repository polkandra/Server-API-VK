//
//  UserWall.m
//  Home Work - Server API
//
//  Created by Mikhail Kozlyukov on 31.03.17.
//  Copyright © 2017 Chebahatt. All rights reserved.
//

#import "UserWall.h"

@implementation UserWall

- (id) initWithServerResponse:(NSDictionary*) responseObject

{
    self = [super init];
    if (self) {
        self.text = [responseObject objectForKey:@"text"];
        self.imageURL_50 = [responseObject objectForKey:@"photo_50"];
        
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
        [dateFormater setDateFormat:@"dd MMM yyyy "];
        NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:[[responseObject objectForKey:@"date"] floatValue]];
        NSString *date = [dateFormater stringFromDate:dateTime];
        self.date = date;
        
        NSDictionary *dict = [[responseObject objectForKey:@"attachment"] objectForKey:@"photo"];
        
        self.postImageURL = [NSURL URLWithString:[dict objectForKey:@"src_big"]];
        
        self.heightImage = [[dict objectForKey:@"height"] integerValue] / 2;

        
            }
    
    return self;
}

@end
