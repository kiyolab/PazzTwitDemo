//
//  TwitterSampleCell.h
//  TwitterSample
//
//  Created by LightCafe on 2014/01/01.
//  Copyright (c) 2014年 my.edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterSampleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *tweetImage;
@property (weak, nonatomic) IBOutlet UILabel *tweetContent;
@property (weak, nonatomic) IBOutlet UILabel *tweetDate;

@end
