//
//  Person.m
//  HandOff
//
//  Created by BourbonZ on 15/9/29.
//  Copyright © 2015年 BourbonZ. All rights reserved.
//

#import "Person.h"

@implementation Person

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@,%@,%@",_name,_title,_image];
}

@end
