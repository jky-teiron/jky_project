//
//  DACircularProgressView.h
//  DACircularProgress
//
//  Created by Daniel Amitay on 2/6/12.
//  Copyright (c) 2012 Daniel Amitay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DACircularProgressView : UIView

@property(nonatomic, strong) UIColor *trackTintColor;//为加载部分颜色
@property(nonatomic, strong) UIColor *progressTintColor;//已经加载部分颜色
@property (nonatomic) float progress;

@end
