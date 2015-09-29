//
//  DataSource.h
//  HandOff
//
//  Created by BourbonZ on 15/9/29.
//  Copyright © 2015年 BourbonZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
@interface DataSource : NSObject
{
    NSMutableArray *dataArray;
}

-(void)initDataSource;
-(Person *)searchPersonWithName:(NSString *)name;
-(void)saveData;


@end
