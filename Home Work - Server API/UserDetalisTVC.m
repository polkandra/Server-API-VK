//
//  UserDetalisTVC.m
//  Home Work - Server API
//
//  Created by Mikhail Kozlyukov on 31.03.17.
//  Copyright © 2017 Chebahatt. All rights reserved.
//

#import "UserDetalisTVC.h"

@implementation UserDetalisTVC

- (void)awakeFromNib {
    // Initialization code

    self.userImage.frame = CGRectMake(0, 0, 100, 100);
    self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2;
    self.userImage.clipsToBounds = YES;
    self.userImage.layer.borderWidth = 3.0f;
    self.userImage.layer.borderColor = [[UIColor whiteColor] CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
