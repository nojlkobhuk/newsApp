//
//  NODJSONParser.m
//  radioNOD
//
//  Created by in5630 on 16.01.15.
//  Copyright (c) 2015 zhurbenko inc. All rights reserved.
//

#import "NODJSONParser.h"

@implementation NODJSONParser

+ (NSMutableArray *) jsonParser

{
    NSURL * url=[NSURL URLWithString:@"http://rusnod.ru/rss/mitn.php"];
    
    NSData * data=[NSData dataWithContentsOfURL:url];
    
    NSError * error;
    
    NSMutableDictionary * json=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    NSMutableArray* elements = [json valueForKey:@"title"];
    //NSMutableArray* json_desc = [json valueForKey:@"desc"];
    
    return elements;
}


@end
