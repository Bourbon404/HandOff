//
//  DataSource.m
//  HandOff
//
//  Created by BourbonZ on 15/9/29.
//  Copyright © 2015年 BourbonZ. All rights reserved.
//

#import "DataSource.h"
#import <CoreSpotlight/CoreSpotlight.h>
@implementation DataSource

-(void)initDataSource
{
    dataArray = [NSMutableArray array];
    for (int i = 0; i < 10; i++)
    {
        Person *person = [[Person alloc] init];
        person.name = [NSString stringWithFormat:@"personName%d",i];
        person.title = [NSString stringWithFormat:@"personTitle%d",i];
        person.image = [UIImage imageNamed:@"1.png"];
        
        [dataArray addObject:person];
    }
}

-(Person *)searchPersonWithName:(NSString *)name
{
    for (Person *tmp in dataArray)
    {
        if ([tmp.name isEqualToString:name])
        {
            return tmp;
        }
    }
    return nil;
}

-(void)saveData
{
    NSMutableArray *searchAbleItems = [NSMutableArray array];
    for (Person *tmp in dataArray)
    {
        CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:@"views"];
        attributeSet.title = tmp.name;
        attributeSet.contentDescription = tmp.title;
        attributeSet.thumbnailData = UIImagePNGRepresentation(tmp.image);
        CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:tmp.name domainIdentifier:@"cn.bourbonz.HandOff" attributeSet:attributeSet];
        [searchAbleItems addObject:item];
        
        
        
    }
    
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:searchAbleItems completionHandler:^(NSError * _Nullable error) {
       
        if (error != nil)
        {
            NSLog(@"%@",error.description);
        }
        
    }];
}
@end
