//
//  TwitterAPI.m
//  TwitterSample
//
//  Created by LightCafe on 2013/12/21.
//  Copyright (c) 2013年 my.edu. All rights reserved.
//

#import "TwitterAPI.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@implementation TwitterAPI

#define TWITTER_HOME_TIME_LINE_URL @"https://api.twitter.com/1/statuses/home_timeline.json"
#define TWITTER_USER_TIME_LINE_URL @"https://api.twitter.com/1/statuses/user_timeline.json"


+ (void)homeTimeLine:(void (^)(NSArray *))doneProc
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if (!granted) {
            NSLog(@"Not Granted");
        }
        else {
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
            ACAccount *twitterAccount = accountsArray[0];
//          SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:TWITTER_HOME_TIME_LINE_URL] parameters:@{@"include_rts" : @"1", @"count" : @"100"}];
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:TWITTER_USER_TIME_LINE_URL] parameters:@{@"screen_name" : @"pazubot", @"count": @"100"}];
            
            [request setAccount:twitterAccount];
            
            [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                if ([urlResponse statusCode] == 200) {
                    NSError *jsonParsingError = nil;
                    NSArray *twitterResponse = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
                    doneProc(twitterResponse);
                }
                else {
                    NSLog(@"Twitter get error %ld", [urlResponse statusCode]);
                }
            }];
            
        }
        
    }];
}

@end
