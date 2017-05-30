//
//  ServerManager.m
//  Home Work - Server API
//
//  Created by Mikhail Kozlyukov on 31.03.17.
//  Copyright © 2017 Chebahatt. All rights reserved.//

#import "ServerManager.h"
#import "AFNetworking.h"
#import "User.h"
#import "UserWall.h"

@interface ServerManager ()

@property (strong, nonatomic) AFHTTPRequestOperationManager* requestOperationManager;
@property (strong , nonatomic) User* user;
@end

@implementation ServerManager


+ (ServerManager*) sharedManager {
    
    static ServerManager* manager = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServerManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSURL* url = [NSURL URLWithString:@"https://api.vk.com/method/"];
        
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    }
    return self;
}

- (void) gerFriendsFromServerWithOffset:(NSInteger) offset
                                  count:(NSInteger) count
                              onSuccess:(void(^)(NSArray* friends)) success
                              onFailure:(void(^)(NSError* error)) failure {
    
    NSDictionary* parametrs = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"4356835",        @"user_id",
                               @"name",             @"order",
                               @(count),            @"count",
                               @(offset),           @"offset",
                               @"photo_100, online", @"fields",
                               @"nom",              @"name_case", nil];
    
    [self.requestOperationManager
     
      GET:@"friends.get"
      parameters:parametrs
      success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
          
          NSArray* dictionaryArray = [responseObject objectForKey:@"response"];
          
          NSMutableArray* objectsArray = [NSMutableArray array];
          
          for (NSDictionary* object in dictionaryArray) {
              User* user = [[User alloc] initWithServerResponse:object];
              
              [objectsArray addObject:user];
          }
          
          if (success) {
              success(objectsArray);
          }
             
      //  NSLog(@"JSON: %@", responseObject);
          
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
    }];
    
}

- (void) getUsers_ids:(NSString*) userID
            onSuccess:(void(^)(User* user)) success
            onFailure:(void(^)(NSError* error)) failure {
    
    NSDictionary* parametrs = [NSDictionary dictionaryWithObjectsAndKeys:
                               userID,                                       @"user_ids",
                               @"photo_100, online, city, country, online",  @"fields",
                               @"nom",                                       @"name_case", nil];
    
    [self.requestOperationManager
    
    
     GET:@"users.get"
     parameters:parametrs
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         
         NSArray* dictionaryArray = [responseObject objectForKey:@"response"];
         
         User* user = [[User alloc] initWithServerResponse:[dictionaryArray firstObject]];

         if (success) {
             success(user);
         }

         
         //NSLog(@"JSON: %@", responseObject);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"Error: %@", error);
         
     }];
    
}

- (void) getFollowers:(NSString*) userID
           withOffset:(NSInteger) offset
                count:(NSInteger) count
            onSuccess:(void(^)(NSArray* followersArray)) success
            onFailure:(void(^)(NSError* error)) failure {
    
    
    NSDictionary* parametrs = [NSDictionary dictionaryWithObjectsAndKeys:
                               userID,                  @"user_id",
                               @(offset),               @"offset",
                               @(count),                @"count",
                               @"photo_100, online",    @"fields", nil];
    
    
    [self.requestOperationManager
     
     GET:@"users.getFollowers"
     parameters:parametrs
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
         
         NSArray *dictionaryArray = [[responseObject objectForKey:@"response"] objectForKey:@"items"];
         
         NSMutableArray* array = [NSMutableArray array];
         
         for (NSDictionary* object in dictionaryArray) {
             
             User* follower = [[User alloc] initWithServerResponse:object];
             
             [array addObject:follower];
         }
         
         //NSLog(@"JSON: %@", array);
         
         success(array);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"Error: %@", error);
         
     }];
 
}

- (void) getSubscribers:(NSString*) userID
             withOffset:(NSInteger) offset
                  count:(NSInteger) count
              onSuccess:(void(^)(NSArray* subscribersArray)) success
              onFailure:(void(^)(NSError* error)) failure {
    
    NSDictionary* parametrs = [NSDictionary dictionaryWithObjectsAndKeys:
                               userID,              @"user_id",
                               @(offset),           @"offset",
                               @(count),            @"count",
                               @"photo_100",        @"fields",
                               @"1",                @"extended", nil];
    
    [self.requestOperationManager
     
     GET:@"users.getSubscriptions"
     parameters:parametrs
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
         
         NSArray *dictionaryArray = [responseObject objectForKey:@"response"];
         
         NSMutableArray* array = [NSMutableArray array];
         
         for (NSDictionary* objects in dictionaryArray) {
             
             User* sub = [[User alloc] initWithServerResponse:objects];
             
             [array addObject:sub];
         }
         
         
         success(array);

     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"Error: %@", error);
         
     }];

    
    
}

- (void) getCitiesById:(NSString*) cityID
            onSuccess:(void(^)(NSString* city)) success
            onFailure:(void(^)(NSError* error)) failure {
    
     NSDictionary* parametrs = [NSDictionary dictionaryWithObjectsAndKeys:
                               cityID, @"city_ids", nil];
    
     [self.requestOperationManager
     
     GET:@"database.getCitiesById"
     parameters:parametrs
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
         
         NSArray *dictionaryArray = [responseObject objectForKey:@"response"];
         
         NSString* city = [[dictionaryArray firstObject] objectForKey:@"name"];
     
         success(city);
 
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"Error: %@", error);
         
     }];
    
}

- (void) getCountriesById:(NSString*) countryID
             onSuccess:(void(^)(NSString* country)) success
             onFailure:(void(^)(NSError* error)) failure {
    
    NSDictionary* parametrs = [NSDictionary dictionaryWithObjectsAndKeys:
                               countryID, @"country_ids", nil];
    
    [self.requestOperationManager
     
     GET:@"database.getCountriesById"
     parameters:parametrs
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
         
         NSArray *dictionaryArray = [responseObject objectForKey:@"response"];
         
         NSString* country = [[dictionaryArray firstObject] objectForKey:@"name"];
         
         success(country);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"Error: %@", error);
         
     }];
    
}


- (void) getUserWall:(NSString*) userID
          withOffset:(NSInteger) offset
               count:(NSInteger) count
           onSuccess:(void(^)(NSArray* wallArray)) success
           onFailure:(void(^)(NSError* error)) failure {
    
    NSDictionary* parametrs = [NSDictionary dictionaryWithObjectsAndKeys:
                               userID,                              @"owner_id",
                               @(count),                            @"count",
                               @(offset),                           @"offset",
                               @"owner",                            @"filter", nil];
    
    [self.requestOperationManager
     
     
     GET:@"wall.get"
     parameters:parametrs
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         
         NSArray* dictionaryArray = [responseObject objectForKey:@"response"];
         
         if ([dictionaryArray count] > 1) {
             dictionaryArray = [dictionaryArray subarrayWithRange:NSMakeRange(1, [dictionaryArray count] - 1)];
         } else {
             
             dictionaryArray = nil;
         }
         
         NSMutableArray* array = [NSMutableArray array];
         
         for (NSDictionary* object in dictionaryArray) {
             
             UserWall* user = [[UserWall alloc] initWithServerResponse:object];
             
             [array addObject:user];
             
         }
         
         success(array);
         
         
       //  NSLog(@"JSON: %@", dictionaryArray);
         
         
            
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"Error: %@", error);
         
     }];

}

@end
