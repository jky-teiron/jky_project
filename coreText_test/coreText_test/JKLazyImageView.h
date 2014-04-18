//
//  JKLazyImageView.h
//  coreText_test
//
//  Created by zadmin on 14-4-18.
//  Copyright (c) 2014年 zadmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKLazyImageView;

// Notifications
extern NSString * const JKLazyImageViewWillStartDownloadNotification;
extern NSString * const JKLazyImageViewDidFinishDownloadNotification;

/**
 Protocol for delegates of <DTLazyImageView> to inform them about the downloaded image dimensions.
 */
@protocol JKLazyImageViewDelegate <NSObject>
@optional

/**
 Method that informs the delegate about the image size so that it can re-layout text.
 @param lazyImageView The image view
 @param size The image size that is now known
 */
- (void)lazyImageView:(JKLazyImageView *)lazyImageView didChangeImageSize:(CGSize)size;
@end

/**
 This `UIImageView` subclass lazily loads an image from a URL and informs a delegate once the size of the image is known.
 */

@interface JKLazyImageView : UIImageView

/**
 @name Providing Content
 */

/**
 The URL of the remote image
 */
@property (nonatomic, strong) NSURL *url;

/**
 The URL Request that is to be used for downloading the image. If this is left `nil` the a new URL Request will be created
 */
@property (nonatomic, strong) NSMutableURLRequest *urlRequest;

/**
 @name Getting Information
 */

/**
 Set to `YES` to support progressive display of progressive downloads
 */
@property (nonatomic, assign) BOOL shouldShowProgressiveDownload;

/**
 The delegate, conforming to <DTLazyImageViewDelegate>, to inform when the image dimensions were determined
 */
@property (nonatomic, weak) id<JKLazyImageViewDelegate> delegate;


/**
 @name Cancelling Download
 */

/**
 Cancels the image downloading
 */
- (void)cancelLoading;

@end
