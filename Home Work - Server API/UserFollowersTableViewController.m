//
//  UserFollowersTableViewController.m
//  Home Work - Server API
//
//  Created by Mikhail Kozlyukov on 31.03.17.
//  Copyright © 2017 Chebahatt. All rights reserved.
//

#import "UserFollowersTableViewController.h"
#import "ServerManager.h"
#import "UIKit+AFNetworking.h"
#import "User.h"


@interface UserFollowersTableViewController ()

@property (strong, nonatomic) NSMutableArray* followersArray;
@property (strong, nonatomic) NSMutableArray* subscribersArray;

@property (assign, nonatomic) BOOL loadingData;

@end

@implementation UserFollowersTableViewController

static NSInteger followersInRequest = 20;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loadingData = YES;
    
    self.followersArray = [NSMutableArray array];
    self.subscribersArray = [NSMutableArray array];
    
    if (self.getCase) {
        
        [self getUserFollowers];
        
        self.navigationItem.title = @"Followers";
        
    } else if (!self.getCase) {
    
        [self getUserSubscribers];
    
        self.navigationItem.title = @"Following";
    }

}

#pragma mark - APIs

- (void) getUserSubscribers {
    
    [[ServerManager sharedManager] getSubscribers:self.userID
                                         withOffset:[self.subscribersArray count]
                                         count:followersInRequest
                                         onSuccess:^(NSArray *subscribersArray) {
                                             
        [self.subscribersArray addObjectsFromArray:subscribersArray];
                                             
        [self.tableView reloadData];
        
        self.loadingData = NO;
        
        
    } onFailure:^(NSError *error) {
        
    }];
    
}

- (void) getUserFollowers {
    
    [[ServerManager sharedManager] getFollowers:self.userID
                                       withOffset:[self.followersArray count]
                                       count:followersInRequest
                                       onSuccess:^(NSArray *followersArray) {
        
        [self.followersArray addObjectsFromArray:followersArray];
                                       
        [self.tableView reloadData];
                                           
        self.loadingData = NO;
         
    } onFailure:^(NSError *error) {
        
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.getCase) {
        return [self.followersArray count];
    }
    
    return [self.subscribersArray count];

    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if (self.getCase) {
        
        static NSString* identifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        User* follower = [self.followersArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", follower.firstName, follower.lastName];
        
        if (follower.isOnline) {
            
            cell.detailTextLabel.text = @"Online";
            cell.detailTextLabel.textColor = [UIColor colorWithRed:(0/255.0) green:(153/255.0) blue:(51/255.0) alpha:1.0f];
            
        } else {
            
            cell.detailTextLabel.text = @"Offline";
            cell.detailTextLabel.textColor = [UIColor colorWithRed:(201/255.0) green:(95/255.0) blue:(74/255.0) alpha:1.0f];
            
        }
        
        NSURLRequest* request = [NSURLRequest requestWithURL:follower.imageURL_100];
        
        __weak UITableViewCell* weakCell = cell;
        
        cell.imageView.image = nil;
        
        [cell.imageView
         setImageWithURLRequest:request
         placeholderImage:nil
         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
             [UIView transitionWithView:weakCell.imageView
                               duration:0.3f
                                options:UIViewAnimationOptionTransitionCrossDissolve
                             animations:^{
                                 weakCell.imageView.image = image;
                                 [weakCell layoutSubviews];
                             } completion:NULL];
         }
         
         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
             
         }];
        
        
        
        return cell;
        
    } else if   (!self.getCase) {
        
        static NSString* identifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        User* subscribers = [self.subscribersArray objectAtIndex:indexPath.row];
        
        if ([subscribers.groupType isEqualToString:@"page"]) {
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@", subscribers.groupName];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", subscribers.groupType];

        }
        
        else if ([subscribers.groupType isEqualToString:@"profile"]) {
            
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", subscribers.firstName, subscribers.lastName];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", subscribers.groupType];
            
        }
        
        NSURLRequest* request = [NSURLRequest requestWithURL:subscribers.imageURL_100];
        
        __weak UITableViewCell* weakCell = cell;
        
        cell.imageView.image = nil;
        
        [cell.imageView
         setImageWithURLRequest:request
         placeholderImage:nil
         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
             [UIView transitionWithView:weakCell.imageView
                               duration:0.3f
                                options:UIViewAnimationOptionTransitionCrossDissolve
                             animations:^{
                                 weakCell.imageView.image = image;
                                 [weakCell layoutSubviews];
                             } completion:NULL];
         }
         
         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
             
         }];
        
        return cell;
        
        
    }
  
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
        if (!self.loadingData)
        {
            self.loadingData = YES;
            
            if (self.getCase) {
                [self getUserFollowers];
            } else
            
            [self getUserSubscribers];
        }
    }
}


@end
