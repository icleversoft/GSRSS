//
//  GSBriefFeedItem.m
//  GSRSS
//
//  Created by George Stavrou on 4/13/14.
//  Copyright (c) 2014 icleversoft. All rights reserved.
//

#import "GSBriefFeedItem.h"
#import "GSLinkItem.h"
#import "NSString+HTML.h"
#import "TFHpple.h"
/*
 #define RSS_ITEM_KEYS  @[@"title", @"link", @"comments", @"pubDate", @"dc:creator", @"*category", \
 @"guid", @"description", @"content:encoded", @"wfw:commentRss", \
 @"*media:content@url", @"*media:thumbnail@url", @"feedburner:origLink", @"author", \
 @"atom:summary"]
 
 #define ATOM_ITEM_KEYS  @[@"title", @"*link@href", @"published", @"updated", @"id", \
 @"author|name", @"content", @"summary", @"*category@term", \
 @"*media:thumbnail@url", @"author|email"]
*/
 
@implementation GSBriefFeedItem
@synthesize image = _image, title = _title, description = _description, author = _author, timeAgo = _timeAgo;
@synthesize fullLink = _fullLink;

- (id) initWithFeedItem:(GSFeedItem *)item{
    if (self = [super init]) {
        _timeAgo = @"";
        _description = @"";
        _author = @"";
        _image = @"";
        _title = [item valueForKey:@"title"];
        
        id val = nil;
        NSString *imageURL = nil;
        if (item.type == ftRSS) {
            //Publication Date
            val = [item valueForKey:@"pubDate"];
            if (val != nil) {
                NSDate *date = [NSDate dateFromInternetDateTimeString:(NSString *)val formatHint:DateFormatHintRFC822];
                if (date != nil) {
                    _timeAgo = [date timeAgo];
                }
            }

            //Description
            val = [item valueForKey:@"description"];
            if (val == nil) {
                val = [item valueForKey:@"atom:summary"];
            }
            if (val != nil) {
                _description = (NSString *)val;
            }
            
            //Author
            val = [item valueForKey:@"dc:creator"];
            if (val == nil) {
                val = [item valueForKey:@"author"];
            }
            if (val != nil) {
                _author = (NSString *)val;
            }
            
            //FullLink
            val = [item valueForKey:@"link"];
            if (val != nil) {
                _fullLink = (NSString *)val;
            }

            //Image
            imageURL = [self getImageURLFromItem:item andKey:@"media:content"];

            if (imageURL == nil) {
                imageURL = [self getImageURLFromItem:item andKey:@"media:thumbnail"];
            }
            //If no image found, try to find any image from item content / description
            if (imageURL == nil) {
                imageURL = [self getImageURLFromDescriptionOrItem:item andKeys:@[@"description", @"content:encoded"]];
            }

        }else{
            //Published Date
            val = [item valueForKey:@"updated"];
            if (val == nil) {
                val = [item valueForKey:@"published"];
            }
            if (val != nil) {
                NSDate *date = [NSDate dateFromInternetDateTimeString:(NSString *)val formatHint:DateFormatHintRFC822];
                _timeAgo = [date timeAgo];
            }
            
            //Description
            val = [item valueForKey:@"summary"];
            if (val == nil) {
                val = [item valueForKey:@"content"];
            }
            if (val != nil) {
                _description = (NSString *)val;
            }
            
            //Author
            val = [item valueForKey:@"author"];
            if (val != nil) {
                _author = (NSString *)val;
            }
            
            //FullLink
            val = [item valueForKey:@"id"];
            if (val != nil) {
                _fullLink = (NSString *)val;
            }

            //Image
            imageURL = [self getImageURLFromItem:item andKey:@"link"];

            //If no image found, try to find any image from item content / description
            if (imageURL == nil) {
                imageURL = [self getImageURLFromDescriptionOrItem:item andKeys:@[@"summary", @"content"]];
            }
        }
        _image = imageURL;
        _description = [_description stringByConvertingHTMLToPlainText];
        if ([_description length] > 150) {
            _description = [NSString stringWithFormat:@"%@...", [_description substringToIndex:149]];
        }
    }
    return self;
}

- (NSString *) getImageURLFromDescriptionOrItem:(GSFeedItem *)item andKeys:(NSArray *)keys{
    NSString *imageURL = nil;
    if ([_description length] > 0) {
        imageURL = [self imageURLFromContent:_description];
    }
    if (imageURL == nil) {
        id val = nil;
        for (NSString * key in keys) {
            val = [item valueForKey:key];
            if (val != nil) {
                imageURL = [self imageURLFromContent:(NSString *)val];
                if (imageURL != nil) {
                    break;
                }
            }
        }
    }
    return imageURL;
}
- (NSString *)imageURLFromContent:(NSString *)content{
    NSString *imageURL = nil;
    NSData *data = [NSData dataWithBytes:[content UTF8String] length:[content length]];
    TFHpple * doc = [[TFHpple alloc] initWithHTMLData:data];
    NSArray * elements  = [doc searchWithXPathQuery:@"//img"];
    if ([elements count] > 0) {
        TFHppleElement *elm = [elements objectAtIndex:0];
        imageURL = [elm objectForKey:@"src"];
    }

    return imageURL;
}
- (NSString *) getImageURLFromItem:(GSFeedItem *)item andKey:(NSString *)key{
    id val = nil;
    NSString *imageURL = nil;
    val = [item valueForKey:key];
    if (val != nil) {
        if ([val isKindOfClass:[NSArray class]]) {
            for (GSLinkItem *li in (NSArray *)val) {
                if (li.type == ltImage) {
                    imageURL = [li valueForKey:@"href"];
                    if (imageURL == nil) {
                        imageURL = [li valueForKey:@"url"];
                    }
                }
            }
        }else if ([val isKindOfClass:[GSLinkItem class]]){
            GSLinkItem *li = (GSLinkItem *)val;
            if (li.type == ltImage) {
                imageURL = [li valueForKey:@"href"];
                if (imageURL == nil) {
                    imageURL = [li valueForKey:@"url"];
                }
            }
        }
    }
    
    return imageURL;
}
@end
