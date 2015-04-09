//
//  GSLinkItem.m
//  GSRSS
//
//  Created by George Stavrou on 4/12/14.
//  Copyright (c) 2014 icleversoft. All rights reserved.
//

#import "GSLinkItem.h"
@interface GSLinkItem ()
    @property (nonatomic, strong) NSMutableDictionary *attributes;
@end
@implementation GSLinkItem
- (id) initWithItem:(TBXMLElement *)elm{
    if (self = [super init]) {
        _type = ltOther;
        _attributes = [[NSMutableDictionary alloc] init];
        [TBXML iterateAttributesOfElement:elm withBlock:^(TBXMLAttribute *attr, NSString *name, NSString *value){
            [_attributes setObject:value forKey:name];
        }];
        if ([[_attributes allKeys] containsObject:@"type"] && [[_attributes objectForKey:@"type"] hasPrefix:@"image"]) {
            _type = ltImage;
        }else if ([[_attributes allKeys] containsObject:@"medium"] && [[_attributes objectForKey:@"medium"] hasPrefix:@"image"]){
            _type = ltImage;
        }else if ([[_attributes allKeys] containsObject:@"rel"] && [[_attributes allValues] containsObject:@"replies"]){
            _type = ltComments;
        }else if ([[_attributes allKeys] containsObject:@"term"]){
            _type = ltTerm;
        }
        if ( _type != ltImage) {
            if ([[_attributes allKeys] containsObject:@"url"]) {
                NSString *val = [self valueForKey:@"url"];
                if ([val hasSuffix:@".jpg"] || [val hasSuffix:@".JPG"] || [val hasSuffix:@".png"] || [val hasSuffix:@".PNG"]) {
                    _type = ltImage;
                }
            }
        }else if ([[_attributes allKeys] containsObject:@"href"]){
            NSString *val = [self valueForKey:@"href"];
            if ([val hasSuffix:@".jpg"] || [val hasSuffix:@".JPG"] || [val hasSuffix:@".png"] || [val hasSuffix:@".PNG"]) {
                _type = ltImage;
            }
        }
    }
    return self;
}
- (NSArray *)properties{
    return [_attributes allKeys];
}
- (id) valueForKey:(NSString *)key{
    if ([self.properties containsObject:key]) {
        return [_attributes objectForKey:key];
    }
    return nil;
}

- (int) linkType{
    return (int)_type;
}

@end
