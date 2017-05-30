//
//  WallCell.m
//  Home Work - Server API
//
//  Created by Mikhail Kozlyukov on 31.03.17.
//  Copyright © 2017 Chebahatt. All rights reserved.
//

#import "WallCell.h"
@implementation WallCell



- (void)awakeFromNib {
    
    self.userImage.layer.cornerRadius = 18.f;
    self.userImage.clipsToBounds = YES;
//    self.userImage.layer.borderWidth = 2.0f;
//    self.userImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    
    CGRect rect = CGRectMake(0, 0, 320.f, 640.f);
    
    self.postImage.frame = rect;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGFloat) heightForText:(NSString*) text {
    
    CGFloat offset = 5.0;
    
    UIFont* font = [UIFont fontWithName:@"Georgia" size:13.f];
    
    
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraph setAlignment:NSTextAlignmentLeft];
    
    NSDictionary* attributes =
    [NSDictionary dictionaryWithObjectsAndKeys:
     font, NSFontAttributeName,
     paragraph, NSParagraphStyleAttributeName, nil];
    
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(320 - 2 * offset, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    
    
    return CGRectGetHeight(rect);
}

@end
