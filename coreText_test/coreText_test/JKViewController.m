//
//  JKViewController.m
//  coreText_test
//
//  Created by zadmin on 14-4-15.
//  Copyright (c) 2014年 zadmin. All rights reserved.
//

#import "JKViewController.h"
#import "JKAttrabuteTableViewCell.h"
#import "JKDetailViewController.h"

@interface JKViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSCache *cellCache;
    NSArray *_snippets;
}
@property (strong, nonatomic) IBOutlet UITableView *tView;

@end

@implementation JKViewController
@synthesize tView = _tView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tView.delegate = self;
    _tView.dataSource = self;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Snippets" ofType:@"plist"];
    _snippets = [NSArray arrayWithContentsOfFile:path];
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _snippets.count;
}

- (void)configureCell:(JKAttrabuteTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *snippet = [_snippets objectAtIndex:indexPath.row];
	
	NSString *title = [snippet objectForKey:@"Title"];
	NSString *description = [snippet objectForKey:@"Description"];
	
	NSString *html = [NSString stringWithFormat:@"<h3>%@</h3><p><font color=\"gray\">%@</font></p>", title, description];
	
	[cell setHTMLString:html];
	
	cell.attributedTextContextView.shouldDrawImages = YES;
}

-(JKAttrabuteTableViewCell *)tableView:(UITableView *)tableView preparedCellForIndexPath:(NSIndexPath *)indexPath
{
    if (!cellCache)
    {
        cellCache = [[NSCache alloc] init];
    }
    
    NSString *key = [NSString stringWithFormat:@"%d-%d", indexPath.section, indexPath.row];
    JKAttrabuteTableViewCell *cell = [cellCache objectForKey:key];
    
    if (indexPath.row % 2 == 0)
    {
        static NSString *cellIdentifier = @"cell";
        if (!cell)
        {
            cell = (JKAttrabuteTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (!cell)
            {
                cell = [[JKAttrabuteTableViewCell alloc] initWithReuseIdentifier:cellIdentifier andDTAttributedTextContentViewPosition:DTAttributedTextContentViewPositionRight];
                
                cell.leftView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 50, 44)];
                cell.leftView.backgroundColor = [UIColor redColor];
                
                cell.rightView = [[UIImageView alloc] initWithFrame:CGRectMake(320 - 40, 7, 40, 40)];
                cell.rightView.backgroundColor = [UIColor clearColor];
                
                
                cell.backgroundColor = [UIColor clearColor];
            }
            
            
        }
        
        UIImageView *iv = (UIImageView *)cell.leftView;
        iv.image = [UIImage imageNamed:@"Oliver.jpg"];
        
        UIImageView *iv1 = (UIImageView *)cell.rightView;
        iv1.image = [UIImage imageNamed:@"play"];
        
        
    }
    else
    {
        static NSString *cellIdentifier = @"cell1";
        if (!cell)
        {
            cell = (JKAttrabuteTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (!cell)
            {
                cell = [[JKAttrabuteTableViewCell alloc] initWithReuseIdentifier:cellIdentifier andDTAttributedTextContentViewPosition:DTAttributedTextContentViewPositionDefault];
                cell.backgroundColor = [UIColor clearColor];
            }
            
            
        }

    }
    
    [cellCache setObject:cell forKey:key];
    
    [self configureCell:cell forIndexPath:indexPath];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JKAttrabuteTableViewCell *cell = (JKAttrabuteTableViewCell *)[self tableView:tableView preparedCellForIndexPath:indexPath];
    return [cell requiredRowHeightInTableView:tableView];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JKAttrabuteTableViewCell *cell = (JKAttrabuteTableViewCell *)[self tableView:tableView preparedCellForIndexPath:indexPath];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    JKAttrabuteTableViewCell *cell = (JKAttrabuteTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    if (cell.attributedTextContextView)
//    {
//        NSLog(@"---->%@", [NSValue valueWithCGRect:cell.attributedTextContextView.frame]);
//    }
    JKDetailViewController *dVC = [[JKDetailViewController alloc] initWithNibName:@"JKDetailViewController" bundle:nil];
    
    NSDictionary *rowSnippet = [_snippets objectAtIndex:indexPath.row];

	dVC.fileName = [rowSnippet objectForKey:@"File"];
	dVC.baseURL = [NSURL URLWithString:[rowSnippet  objectForKey:@"BaseURL"]];
    
    [self.navigationController pushViewController:dVC animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
