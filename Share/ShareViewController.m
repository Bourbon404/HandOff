//
//  ShareViewController.m
//  Share
//
//  Created by BourbonZ on 15/9/29.
//  Copyright © 2015年 BourbonZ. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    
    ///计算剩余字符
    self.charactersRemaining = [NSNumber numberWithInteger:(10 - self.contentText.length)];
    return YES;
}

- (void)didSelectPost {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    
    ///获取图片或url 等类型
    ///获取的图片是图片的地址，不是图片对象
    NSArray *array = self.extensionContext.inputItems;
    NSExtensionItem *item = array.firstObject;
    for (NSItemProvider *provider in item.attachments)
    {
        NSString *dataType = provider.registeredTypeIdentifiers.firstObject;
        if ([dataType isEqualToString:@"public.jpeg"])
        {
            [provider loadItemForTypeIdentifier:dataType options:nil completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                
                
            }];
        }
        else if ([dataType isEqualToString:@"public.plain-text"])
        {
            [provider loadItemForTypeIdentifier:dataType options:nil completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
               
                
            }];
        }
        else if ([dataType isEqualToString:@"public.url"])
        {
            [provider loadItemForTypeIdentifier:dataType options:nil completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                
                
            }];

        }
        else
        {
            NSLog(@"don't support data type:%@",dataType);
        }
    }
    
    
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}

@end
