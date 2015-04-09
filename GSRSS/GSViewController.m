//
//  GSViewController.m
//  GSRSS
//
//  Created by George Stavrou on 4/7/14.
//  Copyright (c) 2014 icleversoft. All rights reserved.
//

#import "GSViewController.h"
#import "GSRSSParser.h"
#import "GSFeedItem.h"
#import "GSLinkItem.h"
#import "GSBriefFeedItem.h"
#import "GSFullFeedItem.h"

#import "CTView.h"
#import "MarkupParser.h"

@interface GSViewController ()<GSRSSParserDelegate>
@property (nonatomic, weak) IBOutlet CTView *mv;
@property(nonatomic, strong) GSRSSParser *parser;
@property (nonatomic, strong) NSMutableString *data;
@end

@implementation GSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    _parser = [[GSRSSParser alloc] initWithURL:[NSURL URLWithString:@"http://olympia.gr/feed/"] delegate:self];
//    _parser = [[GSRSSParser alloc] initWithURL:[NSURL URLWithString:@"http://kourdistoportocali.com/feeds/xml/category-newsdesk.xml"] delegate:self];
//    _parser = [[GSRSSParser alloc] initWithURL:[NSURL URLWithString:@"http://antinews.gr/feed/"] delegate:self];
//    _parser = [[GSRSSParser alloc] initWithURL:[NSURL URLWithString:@"http://feeds.feedburner.com/blogspot/hyMBI"] delegate:self];
//    _parser = [[GSRSSParser alloc] initWithURL:[NSURL URLWithString:@"http://resaltomag.blogspot.gr/rss.xml"] delegate:self];
//    _parser = [[GSRSSParser alloc] initWithURL:[NSURL URLWithString:@"http://feeds.feedburner.com/assoscoupa"] delegate:self];//WP Blog
//    _parser = [[GSRSSParser alloc] initWithURL:[NSURL URLWithString:@"http://www.newsit.gr/rss/artrss.php"] delegate:self];//WP Blog
    _parser = [[GSRSSParser alloc] initWithURL:[NSURL URLWithString:@"http://ksipnistere.blogspot.gr/rss.xml"] delegate:self];//WP Blog
    
//    _parser = [[GSRSSParser alloc] initWithURL:[NSURL URLWithString:@"http://www.enikos.gr/feeds/content_latest.xml"] delegate:self];//WP Blog
//    _parser = [[GSRSSParser alloc] initWithURL:[NSURL URLWithString:@"http://www.zougla.gr/rss/ola"] delegate:self];//WP Blog
//    _parser = [[GSRSSParser alloc] initWithURL:[NSURL URLWithString:@"http://www.gazzetta.gr/rssfeeds/allnewsfeed"] delegate:self];//WP Blog
    
    
    

    [_parser parse];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark GSRSSParserDelegate properties -
- (void) willStartParser:(GSRSSParser *)parser{
    
}
- (void) parser:(GSRSSParser *)parser parsedFeedInfo:(GSFeedInfo *)info{
    _data = @"";
}
- (void) parser:(GSRSSParser *)parser parsedFeedItem:(GSFeedItem *)item{
    GSFullFeedItem *brief = [[GSFullFeedItem alloc] initWithFeedItem:item];
    NSLog(@"%@", brief.title);
    NSLog(@"%@", [item properties]);
    NSLog(@"%@", brief.timeAgo);
    
    NSLog(@"%@", [item valueForKey:@"link"]);
    if ([item valueForKey:@"link"]) {
        if ([[item valueForKey:@"link"] isKindOfClass:[NSArray class]]) {
            for (GSLinkItem *li in (NSArray *)[item valueForKey:@"link"]) {
                if (li.type == ltImage) {
                    NSString *imageURL = [li valueForKey:@"href"];
                    if (imageURL == nil) {
                        imageURL = [li valueForKey:@"src"];
                    }
                    imageURL = [NSString stringWithFormat:@"<img src=\"%@\" width=\"80\" height=\"80\">", imageURL];
                    _data = [_data stringByAppendingString:imageURL];
                    NSLog(@"%@", li);
                }
            }
        }else{
            NSLog(@"%@", [item valueForKey:@"link"]);
        }
    }
    id x = [item valueForKey:@"pubDate"];
    if (x == nil) {
        x = [item valueForKey:@"published"];
    }
    if (x != nil) {
        NSString *dx = (NSString *)x;
        NSDate *dt1 = [NSDate dateFromInternetDateTimeString:dx formatHint:DateFormatHintRFC822];
    }
    NSString *title = [item valueForKey:@"title"];
    x = [item valueForKey:@"content:encoded"];
    if (x == nil) {
        x = [item valueForKey:@"description"];
    }
    if (x == nil) {
        x = [item valueForKey:@"content"];
    }
    if (x == nil) {
        x = [item valueForKey:@"atom:summary"];
    }
    
    if (x != nil) {
        NSString *article = [NSString stringWithFormat:@"<font color=\"red\" strokeColor=\"none\" face=\"ArialMT\">%@\n<font color=\"black\" strokeColor=\"blue\" face=\"ArialMT\">%@\n\n\n", title, x];
        _data = [_data stringByAppendingString:article];
        NSLog(@"%@", article);
    }
}
- (void) parserDidFinish:(GSRSSParser *)parser{
/*
    dispatch_sync(dispatch_get_main_queue(), ^{
        MarkupParser* p = [[MarkupParser alloc] init];
        NSAttributedString* attString = [p attrStringFromMarkup: _data];
        [_mv setAttString:attString withImages: p.images];
        [_mv buildFrames];
    });
*/
}
- (void) parser:(GSRSSParser *)parser didFailWithError:(NSError *)error{
    
}
- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
}
- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [_mv buildFrames];
    
}
@end
