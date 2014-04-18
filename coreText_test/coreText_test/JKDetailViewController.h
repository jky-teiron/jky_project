//
//  JKDetailViewController.h
//  coreText_test
//
//  Created by zadmin on 14-4-15.
//  Copyright (c) 2014年 zadmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTAttributedTextView.h"
#import "DTLazyImageView.h"

@interface JKDetailViewController : UIViewController
<
DTAttributedTextContentViewDelegate,
DTLazyImageViewDelegate
>

@property (nonatomic, strong) NSString *fileName;

@property (nonatomic, strong) NSURL *lastActionLink;

@property (nonatomic, strong) NSURL *baseURL;

@end
