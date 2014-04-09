//
//  GSFeedItem.m
//  GSRSS
//
//  Created by George Stavrou on 4/7/14.
//  Copyright (c) 2014 icleversoft. All rights reserved.
//

#import "GSFeedItem.h"

@interface GSFeedItem ()

@end

@implementation GSFeedItem
- (id) initWithElement:(TBXMLElement *)elm andType:(GSFeedType)fieldType{
    if (self = [super initWithElement:elm]) {
        [self processItem:elm forKeys:fieldType == ftATOM ? ATOM_ITEM_KEYS : RSS_ITEM_KEYS];
    }
    return self;
}
- (void) processItem:(TBXMLElement *)elm forKeys:(NSArray *)keys{
    for (NSString *attr in keys) {
        NSLog(@"--->%@", attr);
        if ([attr isMultiple]) {
            NSString *realKey = [attr substringFromIndex:1];
            NSString *rxx = [realKey parentElementName];
            TBXMLElement *px = [TBXML childElementNamed:rxx parentElement:elm];
            while (px != nil) {
                [self setElement:px forKey:attr];
                px = [TBXML nextSiblingNamed:rxx searchFromElement:px];
            }
        }else{
            [self setElement:elm forKey:attr];
        }
    }
}

@end
