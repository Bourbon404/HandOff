//
//  Person.h
//  HandOff
//
//  Created by BourbonZ on 15/9/29.
//  Copyright © 2015年 BourbonZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Person : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) UIImage *image;

@end
