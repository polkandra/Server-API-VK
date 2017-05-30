//
//  UserWall.h
//  Home Work - Server API
//
//  Created by Mikhail Kozlyukov on 31.03.17.
//  Copyright © 2017 Chebahatt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserWall : NSObject

@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSURL* imageURL_50;

@property (strong,nonatomic) NSString *date;
@property (strong,nonatomic) NSURL *postImageURL;
@property (assign, nonatomic) NSInteger heightImage;




- (id) initWithServerResponse:(NSDictionary*) responseObject;

@end
