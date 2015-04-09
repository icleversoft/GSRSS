//
//  GSLinkItem.h
//  GSRSS
//
//  Created by George Stavrou on 4/12/14.
//  Copyright (c) 2014 icleversoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"
typedef enum {ltImage, ltOther, ltComments, ltTerm} LinkType;
@interface GSLinkItem : NSObject
- (id) initWithItem:(TBXMLElement *)elm;
@property(nonatomic, readonly) LinkType type;
- (NSArray *)properties;
- (id) valueForKey:(NSString *)key;
- (int) linkType;

@end
