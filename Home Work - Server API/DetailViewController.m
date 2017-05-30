//
//  DetailViewController.m
//  Home Work - Server API
//
//  Created by Mikhail Kozlyukov on 31.03.17.
//  Copyright © 2017 Chebahatt. All rights reserved.
//

#import "DetailViewController.h"
#import "ServerManager.h"
#import "User.h"
#import "UserWall.h"
#import "UIKit+AFNetworking.h"
#import "User.h"
#import "UserFollowersTableViewController.h"
#import "UserDetalisTVC.h"
#import "WallCell.h"


@interface DetailViewController ()

@property (strong, nonatomic) UserDetalisTVC* userInfoCell;
@property (strong, nonatomic) WallCell* userWallCell;
@property (assign, nonatomic) NSInteger heightImage;

@property (assign, nonatomic) BOOL loadingData;


@property (strong, nonatomic) NSArray* userWallArray;
@end

@implementation DetailViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loadingData = YES;


    [self getUserDetail];
    
    [self getUserWall];
    
}

#pragma mark - APIs

- (void) getUserWall {
    
    [[ServerManager sharedManager] getUserWall:self.userID
                                      withOffset:[self.userWallArray count]
                                      count:15
                                      onSuccess:^(NSArray *wallArray) {
                                          
        
    self.userWallArray = [[NSArray alloc] initWithArray:wallArray];
        
        
                                          self.loadingData = NO;

                                          [self.tableView reloadData];

        
        
    } onFailure:^(NSError *error) {
        
    }];
    
}

- (void) getUserDetail {
    
    
    [[ServerManager sharedManager] getUsers_ids: self.userID
     
                                      onSuccess:^(User* user) {
                                          
                                          self.navigationItem.title = user.firstName;
                                          
                                          self.userInfoCell.userName.text = [[NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName] uppercaseString];
                                          
                                          [self.userInfoCell.userImage setImageWithURL:user.imageURL_100];
                                          
                                          
                                          if (user.isOnline) {
                                              
                                              self.userInfoCell.onlineStatus.text = @"Online";
                                              self.userInfoCell.onlineStatus.textColor = [UIColor colorWithRed:(0/255.0) green:(153/255.0) blue:(51/255.0) alpha:0.8f];
                                              
                                          } else {
                                              
                                              self.userInfoCell.onlineStatus.text = @"Offline";
                                              self.userInfoCell.onlineStatus.textColor = [UIColor colorWithRed:(201/255.0) green:(95/255.0) blue:(74/255.0) alpha:1.0f];
                                          
                                          }
                                      
     
     
     
     // GET User Followers ///////////////////////////////////
     
    [[ServerManager sharedManager] getFollowers:self.userID
                                      withOffset:0
                                           count:1000
                                       onSuccess:^(NSArray *followersArray) {
                                           
                                    self.userInfoCell.followersCountLabel.text = [NSString stringWithFormat:@"%ld", [followersArray count]];
                                           
                                       } onFailure:^(NSError *error) {
                                           
                                       
                                       }];
     
     
     
     // GET User Subscribers ///////////////////////////////////
     
     [[ServerManager sharedManager] getSubscribers:self.userID
                                        withOffset:0
                                             count:200
                                         onSuccess:^(NSArray *subscribersArray) {
                                             
                                             self.userInfoCell.subCountLabel.text = [NSString stringWithFormat:@"%ld", [subscribersArray count]];
                                             
                                         } onFailure:^(NSError *error) {
                                         
                                         }];
     
     
     // GET User Cities And Counties ///////////////////////////////////
     
     
     [[ServerManager sharedManager] getCitiesById:user.cityID onSuccess:^(NSString *city) {
        
        [[ServerManager sharedManager] getCountriesById:user.countryID onSuccess:^(NSString *country) {
            
            self.userInfoCell.cityLabel.text = [NSString stringWithFormat:@"%@ (%@)", country, city];
            
        } onFailure:^(NSError *error) {
            
        }];
    
      
    } onFailure:^(NSError *error) {
        
    }];
     
     } onFailure:^(NSError *error) {
         
         NSLog(@"Error");
         
     }];
    
}

#pragma mark - Navigation
    
    - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        
        if ([segue.identifier isEqualToString:@"userFollowers"]) {
            
            UserFollowersTableViewController* vc = [segue destinationViewController];
            
            vc.userID = self.userID;
            vc.getCase = 1;
            
        } else if   ([segue.identifier isEqualToString:@"userSubscribers"]) {
            
            UserFollowersTableViewController* vc = [segue destinationViewController];
            
            vc.userID = self.userID;
            vc.getCase = 0;
        }
        
    }
    
#pragma mark - Table view data source
    
    - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        
        
        
        if (indexPath.section == 0) {
            
            return 270.f;
            
        } else {
            
            UserWall* user = [self.userWallArray objectAtIndex:indexPath.row];
            
            WallCell *postCell = (WallCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
            
            return [postCell  heightForText:user.text] + postCell.postImage.frame.size.height / 2;
            
        }
    }
    
    - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        
        return 2;
    }
    
    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        
        if (section == 0) {
            
            return 1;
            
        } else
            
            return [self.userWallArray count];
        
        
    }
    
    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
        if (indexPath.section == 0) {
            
            static NSString* identifier = @"cellInfo";
            
            UserDetalisTVC* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            self.userInfoCell = cell;
            
            return cell;
            
        } else if (indexPath.section == 1) {
            
            static NSString* identifier = @"wallCell";
            
            WallCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            self.userWallCell = cell;
            
            [[ServerManager sharedManager] getUsers_ids:self.userID onSuccess:^(User *user) {
                cell.userNameLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
                [cell.userImage setImageWithURL:user.imageURL_100];
                
                
                
            } onFailure:^(NSError *error) {
                
            }];
            
            
            UserWall* user = [self.userWallArray objectAtIndex:indexPath.row];
            
            cell.wallTextLabel.text = [NSString stringWithFormat:@"%@", user.text];
            
            [cell.postImage setImageWithURL:user.postImageURL];
            
            self.heightImage = user.heightImage;
            
            
            
            
            
            
            return cell;
            
        }
        
        return nil;
    }
    
#pragma mark - Table view Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


    - (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
        if (!self.loadingData)
        {
            self.loadingData = YES;
            [self getUserWall];
        }
    }
}

@end
