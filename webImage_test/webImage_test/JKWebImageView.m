//
//  JKWebImageView.m
//  webImage_test
//
//  Created by zadmin on 14-4-18.
//  Copyright (c) 2014年 zadmin. All rights reserved.
//

#import "JKWebImageView.h"

@interface JKWebImageView ()<ASIHTTPRequestDelegate>
{
    NSMutableData *allData;
    
    UIProgressView *pView;
    
    NSInteger allLength;
}

@end
@implementation JKWebImageView
@synthesize cachePath = _cachePath;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _cachePath = nil;
    }
    return self;
}

-(void)setImageWithUrl:(NSURL *)imageUrl placehoderImage:(UIImage *)pImage finish:(completeBlock)complete error:(errorBlock)error storagePath:(NSString *)path
{
    self.image = pImage;
    _cachePath = path;
    if (!imageUrl) {
        return;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:imageUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    
    NSOperationQueue *que = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:que completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        if (data)
        {
            UIImage *image = [UIImage imageWithData:data];
            if (image)
            {
                self.image = image;
                complete(image, YES);
            }
            else
            {
                complete(nil, NO);
            }
            [data writeToFile:path atomically:YES];
        }
        else{
            error(connectionError);
        }
    }];

}


-(void)setASIImageUrl:(NSURL *)imageUrl placehoderImage:(UIImage *)pImage asiQueue:(ASINetworkQueue *)networkQueue storagePath:(NSString *)path progress:(id)progressView
{
    self.image = pImage;
    _cachePath = path;
    if (!imageUrl) {
        return;
    }
    
    if (!progressView)
    {
        progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 3, 0)];
        [(UIProgressView *)progressView setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)];
        
    }
    
    [self addSubview:progressView];
    if (!networkQueue)
    {
		networkQueue = [[ASINetworkQueue alloc] init];
        [networkQueue reset];
	}
	
    [networkQueue setShowAccurateProgress:YES];
    
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:imageUrl];
	[request setDownloadDestinationPath:path];
	[request setDownloadProgressDelegate:progressView];
	[networkQueue addOperation:request];
    request.delegate = self;
    [networkQueue go];
    
}

-(void)setASIImageUrl:(NSURL *)imageUrl placehoderImage:(UIImage *)pImage asiQueue:(ASINetworkQueue *)networkQueue storagePath:(NSString *)path
{
    self.image = pImage;
    _cachePath = path;  
    if (!imageUrl) {
        return;
    }
    
    if (!networkQueue)
    {
		networkQueue = [[ASINetworkQueue alloc] init];
        [networkQueue reset];
	}
	
    [networkQueue setShowAccurateProgress:YES];
    
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:imageUrl];
	[request setDownloadDestinationPath:path];
	[request setDownloadProgressDelegate:nil];
	[networkQueue addOperation:request];
    request.delegate = self;
    [networkQueue go];

}

-(void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    if (!allData)
    {
        allData = [NSMutableData data];
    }
    
    [allData appendData:data];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    self.image = [UIImage imageWithData:allData];
    if (request.downloadProgressDelegate)
    {
        [request.downloadProgressDelegate removeFromSuperview];
    }
    
    [allData writeToFile:request.downloadDestinationPath atomically:YES];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    
}

-(void)setImageUrl:(NSURL *)imageUrl placehoderImage:(UIImage *)pImage storagePath:(NSString *)path progress:(id)progressView
{
    self.image = pImage;
    _cachePath = path;
    if (!imageUrl) {
        return;
    }
    
    if (!progressView)
    {
        progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 3, 0)];
        [(UIProgressView *)progressView setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)];
        pView = progressView;
        
        
    }

    pView = progressView;
    [self addSubview:pView];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:imageUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    NSURLConnection *_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [_connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    [_connection start];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [allData appendData:data];
    pView.progress =  (float)allData.length / allLength;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    allData = nil;
    allData = [[NSMutableData alloc] init];
    
    allLength = (NSUInteger)[response expectedContentLength];
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.image = [UIImage imageWithData:allData];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
