//
//  XMLReader.m
//  IMXMPPDemo
//
//  Created by Civet on 2020/5/6.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "XMLReader.h"

@interface XMLReader ()<NSXMLParserDelegate>

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation XMLReader
static XMLReader *xmlReader = nil;

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToke;
    dispatch_once(&onceToke, ^{
        xmlReader = [[self alloc] init];
    });
    return xmlReader;
}

- (NSMutableArray *)arrayWithXMLString:(NSString *)xmlString{
    self.dataArr = [[NSMutableArray alloc] init];
    NSData *data = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    NSMutableArray *arr = [self dictionaryWithParser:parser];
    return arr;
}

- (NSMutableArray *)dictionaryWithParser:(NSXMLParser *)parser
{
    parser.delegate = self;
    [parser parse];
//    id result = _root;
//    _root = nil;
//    _stack = nil;
//    _text = nil;
    return self.dataArr;
}

- (void)parser:(__unused NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(__unused NSString *)namespaceURI qualifiedName:(__unused NSString *)qName attributes:(NSDictionary *)attributeDict{
    if ([elementName isEqualToString:@"item"]) {
        RosterListModel *model = [[RosterListModel alloc] init];
        model.uid = [attributeDict objectForKey:@"jid"];
        model.name = [attributeDict objectForKey:@"name"];
        model.ask = [attributeDict objectForKey:@"ask"];
        model.subscription = [attributeDict objectForKey:@"subscription"];
        model.current_date = [CommonMethods setDateFormat:[NSDate date]];
        [self.dataArr addObject:model];
    }
}

@end
