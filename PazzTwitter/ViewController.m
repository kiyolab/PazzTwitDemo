//
//  ViewController.m
//  PazzTwitter
//
//  Created by LightCafe on 2014/01/03.
//  Copyright (c) 2014年 my.edu. All rights reserved.
//

#import "ViewController.h"
#import "TwitterAPI.h"
#import "TwitterSampleCell.h"

#define IMAGE_Q_SIZE 5

@interface ViewController (){
    NSArray *_timeLine;
    dispatch_queue_t _main_queue;
    dispatch_queue_t _image_queue[IMAGE_Q_SIZE];
}

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [TwitterAPI homeTimeLine:^(NSArray *timeLine) {
        _timeLine = timeLine;
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }];
}

- (UIImage *)getImage:(NSString *)url
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSHTTPURLResponse *response;
    NSError *error = nil;
    
    NSData *imageData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (imageData && response.statusCode == 200) {
        return [UIImage imageWithData:imageData];
    }
    else {
        NSLog(@"NSURLConnection error:%@ status:%ld", error, response.statusCode);
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_timeLine count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    TwitterSampleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    NSDictionary *tweet = _timeLine[indexPath.row];
    
//        cell.textLabel.text = tweet[@"text"];
//        cell.detailTextLabel.text = tweet[@"created_at"];
//        cell.imageView.image = [UIImage imageNamed:@"blank.png"];
    
    //セルのサイズを動的に変化させてみる↓
    
    //セルのサイズを動的に変化させてみる↑
    
    
    cell.tweetContent.text = tweet[@"text"];
    cell.tweetDate.text = tweet[@"created_at"];
    cell.tweetImage.image = [UIImage imageNamed:@"blank.png"];
    
    dispatch_async(_image_queue[[indexPath row] % IMAGE_Q_SIZE], ^{
        UIImage *icon = [self getImage:tweet[@"user"][@"profile_image_url"]];
        dispatch_async(_main_queue, ^{
//                        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//                        cell.imageView.image = icon;
            TwitterSampleCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.tweetImage.image = icon;
            
        });
    });
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _main_queue = dispatch_get_main_queue();
    char qLabel[256];
    for (int i = 0; i < IMAGE_Q_SIZE; i++) {
        sprintf(qLabel, "com.ey-office.gcd-sample.image%d", i);
        _image_queue[i] = dispatch_queue_create(qLabel, NULL);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
