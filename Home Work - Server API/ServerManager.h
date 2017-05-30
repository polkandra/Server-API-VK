//
//  ServerManager.h
//  Home Work - Server API
//
//  Created by Mikhail Kozlyukov on 31.03.17.
//  Copyright © 2017 Chebahatt. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface ServerManager : NSObject

+ (ServerManager*) sharedManager;

- (void) gerFriendsFromServerWithOffset:(NSInteger) offset
                              count:(NSInteger) count
                              onSuccess:(void(^)(NSArray* friends)) success
                              onFailure:(void(^)(NSError* error)) failure;

- (void) getCitiesById:(NSString*) cityID
             onSuccess:(void(^)(NSString* city)) success
             onFailure:(void(^)(NSError* error)) failure;

- (void) getCountriesById:(NSString*) cityID
                              onSuccess:(void(^)(NSString* country)) success
                              onFailure:(void(^)(NSError* error)) failure;

- (void) getUsers_ids:(NSString*) userID
                              onSuccess:(void(^)(User* user)) success
                              onFailure:(void(^)(NSError* error)) failure;

- (void) getFollowers:(NSString*) userID
                              withOffset:(NSInteger) offset
                              count:(NSInteger) count
                              onSuccess:(void(^)(NSArray* followersArray)) success
                              onFailure:(void(^)(NSError* error)) failure;

- (void) getSubscribers:(NSString*) userID
           withOffset:(NSInteger) offset
                count:(NSInteger) count
            onSuccess:(void(^)(NSArray* subscribersArray)) success
            onFailure:(void(^)(NSError* error)) failure;

- (void) getUserWall:(NSString*) userID
                              withOffset:(NSInteger) offset
                              count:(NSInteger) count
                              onSuccess:(void(^)(NSArray* wallArray)) success
                              onFailure:(void(^)(NSError* error)) failure;

@end
