//
//  JKWebImageView.h
//  webImage_test
//
//  Created by zadmin on 14-4-18.
//  Copyright (c) 2014年 zadmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

typedef void(^completeBlock) (UIImage *image, BOOL success);
typedef void(^errorBlock)(NSError *error);

@interface JKWebImageView : UIImageView<NSURLConnectionDataDelegate>

@property (nonatomic, strong, readonly) NSString *cachePath;

-(void)setImageWithUrl:(NSURL *)imageUrl placehoderImage:(UIImage *)pImage finish:(completeBlock)complete error:(errorBlock)error storagePath:(NSString *)path;

-(void)setASIImageUrl:(NSURL *)imageUrl placehoderImage:(UIImage *)pImage asiQueue:(ASINetworkQueue *)networkQueue storagePath:(NSString *)path progress:(id)progressView;
-(void)setASIImageUrl:(NSURL *)imageUrl placehoderImage:(UIImage *)pImage asiQueue:(ASINetworkQueue *)networkQueue storagePath:(NSString *)path;

-(void)setImageUrl:(NSURL *)imageUrl placehoderImage:(UIImage *)pImage storagePath:(NSString *)path progress:(id)progressView;

@end
