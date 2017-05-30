//
//  ViewController.m
//  Home Work - Server API
//
//  Created by Mikhail Kozlyukov on 31.03.17.
//  Copyright © 2017 Chebahatt. All rights reserved.
//

#import "ViewController.h"
#import "ServerManager.h"
#import "User.h"
#import "UIKit+AFNetworking.h"
#import "DetailViewController.h"

@interface ViewController ()
@property (strong, nonatomic) NSMutableArray* friendsArray;
@property (assign, nonatomic) BOOL sw;
@property (assign, nonatomic) BOOL loadingData;
@end

@implementation ViewController

static NSInteger friendsInRequest = 15;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.friendsArray = [NSMutableArray array];
    
    [self getFriendsFromServer];
    
    self.loadingData = YES;
    
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API

- (void) getFriendsFromServer {
    
    [[ServerManager sharedManager]
     gerFriendsFromServerWithOffset:[self.friendsArray count]
     count:friendsInRequest
     onSuccess:^(NSArray *friends) {
         
         [self.friendsArray addObjectsFromArray:friends];
         
         [self.tableView reloadData];
         
         self.loadingData = NO;
     }
     onFailure:^(NSError *error) {
         NSLog(@"error = %@", [error localizedDescription]);
     }];
    
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  [self.friendsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    User* friend = [self.friendsArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName];
    
    if (friend.isOnline) {
        
        cell.detailTextLabel.text = @"Online";
        cell.detailTextLabel.textColor = [UIColor colorWithRed:(0/255.0) green:(153/255.0) blue:(51/255.0) alpha:1.0f];
        
    } else {
    
        cell.detailTextLabel.text = @"Offline";
        cell.detailTextLabel.textColor = [UIColor colorWithRed:(201/255.0) green:(95/255.0) blue:(74/255.0) alpha:1.0f];

    }
    
    NSURLRequest* request = [NSURLRequest requestWithURL:friend.imageURL_100];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"userDetail"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        User* user = [self.friendsArray objectAtIndex:indexPath.row];
        
        DetailViewController* vc = [segue destinationViewController];
        
        vc.userID = user.userID;
 }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
        if (!self.loadingData)
        {
            self.loadingData = YES;
            [self getFriendsFromServer];
        }
    }
}

@end
