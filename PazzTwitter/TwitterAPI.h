//
//  TwitterAPI.h
//  TwitterSample
//
//  Created by LightCafe on 2013/12/21.
//  Copyright (c) 2013年 my.edu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterAPI : NSObject

+ (void)homeTimeLine:(void(^)(NSArray *timeLine))doneProc;

@end
