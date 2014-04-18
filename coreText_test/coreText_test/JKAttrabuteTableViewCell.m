//
//  JKAttrabuteTableViewCell.m
//  coreText_test
//
//  Created by zadmin on 14-4-15.
//  Copyright (c) 2014年 zadmin. All rights reserved.
//

#import "JKAttrabuteTableViewCell.h"
#import "DTCoreText.h"
#import "DTCSSStylesheet.h"
#import "DTLog.h"

@implementation JKAttrabuteTableViewCell
{
    DTAttributedTextContentView *_attributedTextContextView;
	
	DT_WEAK_VARIABLE id <DTAttributedTextContentViewDelegate> _textDelegate;
	
	NSUInteger _htmlHash; // preserved hash to avoid relayouting for same HTML
    
	BOOL _hasFixedRowHeight;
	DT_WEAK_VARIABLE UITableView *_containingTableView;
    
    float endOffsetX;
    float beginOffsetX;
    
}

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	
    if (self)
	{
		_DTATCVPosition = DTAttributedTextContentViewPositionDefault;
        endOffsetX = self.frame.size.width;
        beginOffsetX = 0;
    }
	
    return self;
}
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier andDTAttributedTextContentViewPosition:(DTAttributedTextContentViewPosition)position
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	
    if (self)
	{
		_DTATCVPosition = position;
        endOffsetX = self.frame.size.width;
        beginOffsetX = 0;
    }
	
    return self;
}

- (void)dealloc
{
	_textDelegate = nil;
	_containingTableView = nil;
}

- (void)awakeFromNib
{
    // Initialization code
}

-(void)setRightView:(UIView *)rightView
{
    if (_rightView == rightView) {
        return;
    }
    
    if (_DTATCVPosition == DTAttributedTextContentViewPositionDefault || _DTATCVPosition == DTAttributedTextContentViewPositionRight) {
        return;
    }
    if (_rightView)
    {
        [_rightView removeFromSuperview];
    }
    _rightView = rightView;
    [self.contentView addSubview:rightView];
    endOffsetX = rightView.frame.origin.x;
}

-(void)setLeftView:(UIView *)leftView
{
    if (_leftView == leftView)
    {
        return;
    }
    
    if (_DTATCVPosition == DTAttributedTextContentViewPositionDefault || _DTATCVPosition == DTAttributedTextContentViewPositionLeft) {
        return;
    }
    if (_leftView)
    {
        [_leftView removeFromSuperview];
    }
    _leftView = leftView;
    [self.contentView addSubview:leftView];
    beginOffsetX = leftView.frame.origin.x + leftView.frame.size.width;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	if (!self.superview)
	{
		return;
	}
	
	if (_hasFixedRowHeight)
	{
		self.attributedTextContextView.frame = CGRectMake(beginOffsetX, 0, endOffsetX - beginOffsetX, self.bounds.size.height);
	}
	else
	{
		CGFloat neededContentHeight = [self requiredRowHeightInTableView:_containingTableView];
        
        
        if (_rightView)
        {
            _rightView.center = CGPointMake(_rightView.center.x, neededContentHeight / 2);
        }
        
        if (_leftView)
        {
            _leftView.center = CGPointMake(_leftView.center.x, neededContentHeight / 2);
        }
		
		// after the first call here the content view size is correct
        CGRect frame = CGRectMake(beginOffsetX, 0, endOffsetX - beginOffsetX, neededContentHeight);//这句就是影响attributedTextContextView frame的关键
		self.attributedTextContextView.frame = frame;
	}
}

- (UITableView *)_findContainingTableView
{
	UIView *tableView = self.superview;
	
	while (tableView)
	{
		if ([tableView isKindOfClass:[UITableView class]])
		{
			return (UITableView *)tableView;
		}
		
		tableView = tableView.superview;
	}
	
	return nil;
}

- (void)didMoveToSuperview
{
	[super didMoveToSuperview];
	
	_containingTableView = [self _findContainingTableView];
	
	// on < iOS 7 we need to make the background translucent to avoid artefacts at rounded edges
	if (_containingTableView.style == UITableViewStyleGrouped)
	{
		if (NSFoundationVersionNumber < DTNSFoundationVersionNumber_iOS_7_0)
		{
			_attributedTextContextView.backgroundColor = [UIColor clearColor];
		}
	}
}

// http://stackoverflow.com/questions/4708085/how-to-determine-margin-of-a-grouped-uitableview-or-better-how-to-set-it/4872199#4872199
- (CGFloat)_groupedCellMarginWithTableWidth:(CGFloat)tableViewWidth
{
    CGFloat marginWidth;
    if(tableViewWidth > 20)
    {
        if(tableViewWidth < 400 || [UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)
        {
            marginWidth = 10;
        }
        else
        {
            marginWidth = MAX(31.f, MIN(45.f, tableViewWidth*0.06f));
        }
    }
    else
    {
        marginWidth = tableViewWidth - 10;
    }
    return marginWidth;
}

- (CGFloat)requiredRowHeightInTableView:(UITableView *)tableView
{
	if (_hasFixedRowHeight)
	{
		DTLogWarning(@"You are calling %s even though the cell is configured with fixed row height", (const char *)__PRETTY_FUNCTION__);
	}
	
    //NSLog(@"%p", self.attributedTextContextView);
//	BOOL ios6Style = (NSFoundationVersionNumber < DTNSFoundationVersionNumber_iOS_7_0);
	//CGFloat contentWidth = tableView.frame.size.width;
	CGFloat contentWidth = endOffsetX - beginOffsetX;
	// reduce width for grouped table views
//	if (ios6Style && tableView.style == UITableViewStyleGrouped)
//	{
//		contentWidth -= [self _groupedCellMarginWithTableWidth:contentWidth] * 2;
//	}
//	
//	// reduce width for accessories
//	
//	switch (self.accessoryType)
//	{
//		case UITableViewCellAccessoryDisclosureIndicator:
//		{
//			contentWidth -= ios6Style ? 20.0f : 10.0f + 8.0f + 15.0f;
//			break;
//		}
//			
//		case UITableViewCellAccessoryCheckmark:
//		{
//			contentWidth -= ios6Style ? 20.0f : 10.0f + 14.0f + 15.0f;
//			break;
//		}
//			
//		case UITableViewCellAccessoryDetailDisclosureButton:
//		{
//			contentWidth -= ios6Style ? 33.0f : 10.0f + 42.0f + 15.0f;
//			break;
//		}
//			
//#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
//		case UITableViewCellAccessoryDetailButton:
//		{
//			contentWidth -= 10.0f + 22.0f + 15.0f;
//			break;
//		}
//#endif
//			
//		case UITableViewCellAccessoryNone:
//		{
//			break;
//		}
//			
//		default:
//		{
//			DTLogWarning(@"AccessoryType %d not implemented on %@", self.accessoryType, NSStringFromClass([self class]));
//			break;
//		}
//	}
	
	CGSize neededSize = [self.attributedTextContextView suggestedFrameSizeToFitEntireStringConstraintedToWidth:contentWidth];
	// note: non-integer row heights caused trouble < iOS 5.0
	return neededSize.height;
}

#pragma mark Properties

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}

- (void)setHTMLString:(NSString *)html
{
	[self setHTMLString:html options:nil];
}

- (void) setHTMLString:(NSString *)html options:(NSDictionary*) options {
	
	NSUInteger newHash = [html hash];
	
	if (newHash == _htmlHash)
	{
		return;
	}
	
	_htmlHash = newHash;
	
	NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
	NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:options documentAttributes:NULL];
	self.attributedString = string;
	
	[self setNeedsLayout];
	
}

- (void)setAttributedString:(NSAttributedString *)attributedString
{
	// passthrough
	self.attributedTextContextView.attributedString = attributedString;
}

- (NSAttributedString *)attributedString
{
	// passthrough
	return _attributedTextContextView.attributedString;
}

- (DTAttributedTextContentView *)attributedTextContextView
{
	if (!_attributedTextContextView)
	{
		// don't know size jetzt because there's no string in it
		_attributedTextContextView = [[DTAttributedTextContentView alloc] initWithFrame:self.bounds];//这句可以设置attributedTextContextView的frame
		
		_attributedTextContextView.edgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
		_attributedTextContextView.layoutFrameHeightIsConstrainedByBounds = _hasFixedRowHeight;
		_attributedTextContextView.delegate = _textDelegate;
		
		[self.contentView addSubview:_attributedTextContextView];
        
        //NSLog(@"%@", [NSValue valueWithCGRect:_attributedTextContextView.frame]);
	}
	
	return _attributedTextContextView;
}

- (void)setHasFixedRowHeight:(BOOL)hasFixedRowHeight
{
	if (_hasFixedRowHeight != hasFixedRowHeight)
	{
		_hasFixedRowHeight = hasFixedRowHeight;
		
		[self setNeedsLayout];
	}
}

- (void)setTextDelegate:(id)textDelegate
{
	_textDelegate = textDelegate;
	_attributedTextContextView.delegate = _textDelegate;
}

@synthesize attributedTextContextView = _attributedTextContextView;
@synthesize hasFixedRowHeight = _hasFixedRowHeight;
@synthesize textDelegate = _textDelegate;
@synthesize rightView = _rightView;
@synthesize leftView = _leftView;
@synthesize DTATCVPosition = _DTATCVPosition;

@end
