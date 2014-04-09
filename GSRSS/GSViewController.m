//
//  GSViewController.m
//  GSRSS
//
//  Created by George Stavrou on 4/7/14.
//  Copyright (c) 2014 icleversoft. All rights reserved.
//

#import "GSViewController.h"
#import "GSRSSParser.h"

@interface GSViewController ()<GSRSSParserDelegate>

@property(nonatomic, strong) GSRSSParser *parser;
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
    _parser = [[GSRSSParser alloc] initWithURL:[NSURL URLWithString:@"http://feeds.feedburner.com/blogspot/nJOIs"] delegate:self];

    [_parser parse];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark GSRSSParserDelegate properties -
- (void) parser:(GSRSSParser *)parser parsedFeedInfo:(GSFeedInfo *)info{
    
}
- (void) parser:(GSRSSParser *)parser parsedFeedItem:(GSFeedItem *)item{
    
}
- (void) parserDidFinish:(GSRSSParser *)parser{
    
}
- (void) parser:(GSRSSParser *)parser didFailWithError:(NSError *)error{
    
}

@end
