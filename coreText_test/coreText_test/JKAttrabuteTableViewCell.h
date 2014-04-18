//
//  JKAttrabuteTableViewCell.h
//  coreText_test
//
//  Created by zadmin on 14-4-15.
//  Copyright (c) 2014年 zadmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTWeakSupport.h"
#import "DTAttributedTextContentView.h"

typedef NS_ENUM(int, DTAttributedTextContentViewPosition)
{
    DTAttributedTextContentViewPositionDefault = 0,//display html content at all cell
    DTAttributedTextContentViewPositionRight,//display html content at right
    DTAttributedTextContentViewPositionLeft,//display html content at left
    DTAttributedTextContentViewPositionMiddle//display html content at middle
};

/**
 *这个类用于补充DTAttributedTextCell功能，可以在左或者右添加其它视图
 */

@interface JKAttrabuteTableViewCell : UITableViewCell

/**
 @name Creating Cells
 */

/**
 Creates a tableview cell with a given reuse identifier.
 @param reuseIdentifier The reuse identifier to use for the cell
 @returns A prepared cell
 */
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

/**
 Creates a tableview cell with a given reuse identifier and position.
 @param reuseIdentifier The reuse identifier to use for the cell, position mark the DTAttributedTextContentView position
 @returns A prepared cell
 */
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier andDTAttributedTextContentViewPosition:(DTAttributedTextContentViewPosition)position;

/**
 @name Setting Attributed Content
 */

/**
 The attributed string content of the receiver
 */
@property (nonatomic, strong) NSAttributedString *attributedString;

/**
 A delegate implementing DTAttributedTextContentViewDelegate to provide custom subviews for images and links.
 */
@property (nonatomic, DT_WEAK_PROPERTY) IBOutlet id <DTAttributedTextContentViewDelegate> textDelegate;

/**
 This method allows to set HTML text directly as content of the receiver.
 
 This will be converted to an attributed string.
 @param html The HTML string to set as the receiver's text content
 */
- (void)setHTMLString:(NSString *)html;

/**
 This method allows to set HTML text directly as content of the receiver.
 
 This will be converted to an attributed string.
 @param html The HTML string to set as the receiver's text content
 @param options The options used for rendering the HTML
 */
- (void) setHTMLString:(NSString *)html options:(NSDictionary*) options;


/**
 @name Getting Information
 */

/**
 Determines the row height that is needed in a specific table view to show the entire text content.
 
 The table view is necessary because from this the method can know the style. Also the accessory type needs to be set before calling this method because this reduces the available space.
 @note This value is only useful for table views with variable row height.
 @param tableView The table view to determine the height for.
 */
- (CGFloat)requiredRowHeightInTableView:(UITableView *)tableView;

/**
 Determines whether the cells built-in contentView is allowed to dictate the size available for text. If active then attributedTextContextView's height always matches the cell height.
 
 Set this to `YES` for use in fixed row height table views, leave it `NO` for flexible row height table views.
 */
@property (nonatomic, assign) BOOL hasFixedRowHeight;

/**
 The attributed text content view that the receiver uses to display the attributed text content.
 */
@property (nonatomic, readonly) DTAttributedTextContentView *attributedTextContextView;

/**
 rightView and leftView default is nil, when cell's contentview has two or more than two subview,they are not nil
 */
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIView *leftView;

/**
 mark AttributedTextContentView position, default is DTAttributedTextContentViewPositionAll;
 */
@property (nonatomic, assign, readonly) DTAttributedTextContentViewPosition DTATCVPosition;
@end
