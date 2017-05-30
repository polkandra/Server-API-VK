//
//  WallCell.h
//  Home Work - Server API
//
//  Created by Roman Bogomolov on 16/10/14.
//  Copyright (c) 2014 Roman Bogomolov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WallCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* wallTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;

- (CGFloat) heightForText:(NSString*) text;


@end
