//
//  TestFeedController.m
//  GSRSS
//
//  Created by George Stavrou on 4/21/14.
//  Copyright (c) 2014 icleversoft. All rights reserved.
//

#import "TestFeedController.h"
#import "GSRSSParser.h"
#import "GSFeedItem.h"
#import "GSLinkItem.h"
#import "GSFullFeedItem.h"

#import "SVProgressHUD.h"

@interface TestFeedController ()<GSRSSParserDelegate>
@property(nonatomic, strong) NSMutableArray *items;

@property(nonatomic, strong) GSRSSParser *parser;

@end

@implementation TestFeedController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    _items = [[NSMutableArray alloc] init];
    [self getFeed];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) getFeed{
    [_items removeAllObjects];
    [self.tableView reloadData];
//    _parser = [[GSRSSParser alloc] initWithURL:[NSURL URLWithString:@"http://www.newsit.gr/rss/artrss.php"] delegate:self];
//    _parser = [[GSRSSParser alloc] initWithURL:[NSURL URLWithString:@"http://ksipnistere.blogspot.gr/rss.xml"] delegate:self];//WP Blog
//    _parser = [[GSRSSParser alloc] initWithURL:[NSURL URLWithString:@"http://www.iokh.gr/rss.xml"] delegate:self];
//    _parser = [[GSRSSParser alloc] initWithURL:[NSURL URLWithString:@"http://tro-ma-ktiko.blogspot.gr/rss.xml"] delegate:self];
//    _parser = [[GSRSSParser alloc] initWithURL:[NSURL URLWithString:@"http://olympia.gr/feed/"] delegate:self];
    _parser = [[GSRSSParser alloc] initWithURL:[NSURL URLWithString:@"http://feeds.feedburner.com/gataros/xcQy"] delegate:self];
    
//    _parser = [[GSRSSParser alloc] initWithURL:[NSURL URLWithString:@"http://www.antinews.gr/feed/"] delegate:self];
//    _parser = [[GSRSSParser alloc] initWithURL:[NSURL URLWithString:@"http://popaganda.gr/feed/"] delegate:self];
//    _parser = [[GSRSSParser alloc] initWithURL:[NSURL URLWithString:@"http://www.newsit.gr/rss/artrss.php"] delegate:self];
    [_parser parse];
    
}
#pragma mark GSRSSParser Delegate methods - 
- (void) willStartParser:(GSRSSParser *)parser{
    dispatch_sync(dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:@"Loading..."];
    });
}
- (void) parser:(GSRSSParser *)parser parsedFeedInfo:(GSFeedInfo *)info{
    
}
- (void) parser:(GSRSSParser *)parser parsedFeedItem:(GSFeedItem *)item{
    GSFullFeedItem *fi = [[GSFullFeedItem alloc] initWithFeedItem:item];
    NSLog(@"----------------------------");
    NSLog(@"Title.......:%@", fi.title);
    NSLog(@"Image.......:%@", fi.image == nil ? @"-" : fi.image);
    NSLog(@"Link........:%@", fi.fullLink);
    NSLog(@"Time Ago....:%@", fi.timeAgo);
    if ([fi.author isKindOfClass:[NSString class]]) {
        NSLog(@"Authors.....:%@", fi.author);
    }else{
        NSArray *arr = (NSArray *)fi.author;
        NSLog(@"Authors.....:%@", [arr componentsJoinedByString:@" / "]);
    }
    NSLog(@"Comments....:%@", fi.commentsURL == nil ? @"-" : fi.commentsURL);
    NSLog(@"Description.:%@", fi.description);
    [_items addObject:fi];
}
- (void) parserDidFinish:(GSRSSParser *)parser{
    dispatch_sync(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
    });
}
- (void) parser:(GSRSSParser *)parser didFailWithError:(NSError *)error{
    dispatch_sync(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

#pragma mark -

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedItem" forIndexPath:indexPath];
    GSFullFeedItem *fi = [_items objectAtIndex:indexPath.row];
    cell.textLabel.text = fi.title;
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
