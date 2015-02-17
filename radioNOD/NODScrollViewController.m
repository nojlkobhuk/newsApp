//
//  NODScrollViewController.m
//  radioNOD
//
//  Created by in5630 on 22.01.15.
//  Copyright (c) 2015 zhurbenko inc. All rights reserved.
//

#import "NODScrollViewController.h"
#import "AllAroundPullView.h"
#import "NODObjectManager.h"
#import "GDCellThumbnailView.h"
#import "News.h"
#import "NODDetailScrollViewController.h"


@interface NODScrollViewController ()
{
	NSInteger numberOfCharacters;
	AllAroundPullView *bottomPullView;
	BOOL noRequestsMade;
    UIActivityIndicatorView *activityIndicator;
}

@end

@implementation NODScrollViewController

#pragma mark - Private Methods

- (void)animateActivityIndicator:(BOOL)animate {
    activityIndicator.hidden = !animate;
    if (animate) {
        [self.view bringSubviewToFront:activityIndicator];
        [activityIndicator startAnimating];
    }
    else
        [activityIndicator stopAnimating];
}

- (void)showDetailsForCharacterID:(NSInteger)charInnerID
{
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MUST_SHOW_DETAILS object:@(charInnerID)];
}

- (void)saveToStore
{
	// Saving to persistent store for further usage.
	NSError *saveError;
	if (![[[NODObjectManager manager] managedObjectContext] saveToPersistentStore:&saveError])
		NSLog(@"%@", [saveError localizedDescription]);
}

- (void)loadThumbnail:(GDCellThumbnailView *)view fromURLString:(NSString *)urlString forNews:(News *)news
{
	// Download thumbnail image for selected character.
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Image downloaded successfully.
        news.thumbnailImageData = responseObject;
        [self saveToStore];
        [view setImage:[UIImage imageWithData:responseObject]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Image download failure.
        NSLog(@"%@", [error localizedDescription]);
    }];
	[operation start];
}

- (void)loadCharacters
{
	numberOfCharacters = [News allCharsCountWithContext:[[NODObjectManager manager] managedObjectContext]];
    News *lastCharacter = nil;
    NSDictionary *offset = nil;
    
	if (numberOfCharacters == 0)
		[self animateActivityIndicator:YES];
	else if (noRequestsMade && numberOfCharacters > 0) {
		noRequestsMade = NO;
		bottomPullView.hidden = NO;
		return;
	} else if (numberOfCharacters > 0) {
        lastCharacter = [News charWithManagedObjectContext:[[NODObjectManager manager] managedObjectContext]
                                                andInnerID:(numberOfCharacters - 1)];
        offset = @{@"plast" : lastCharacter.npubDate};
        NSLog(@"Я заснял %@", lastCharacter);
    }
    
	noRequestsMade = NO;
    
    
	// Get an array of remote "character" objects. Specify the offset.
	[[NODObjectManager manager] getNODObjectsAtPath:NOD_API_CHARACTERS_PATH_PATTERN
	                                               parameters:offset
	                                                  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                          // Characters loaded successfully.
                                                          [self animateActivityIndicator:NO];
                                                          
                                                          NSInteger newInnerID = numberOfCharacters;
                                                          if (lastCharacter == mappingResult.array[1]) {
                                                              NSLog(@"Я заснял");
                                                          }
                                                          for (News * curCharacter in mappingResult.array)
                                                          {
                                                              if ([curCharacter isKindOfClass:[News class]])
                                                              {
                                                                  curCharacter.innerID = @(newInnerID);
                                                                  newInnerID++;
                                                                  // Saving every character one by one (not after the loop) to prevent losing a bunch of characters if program terminates inside a loop.
                                                                  [self saveToStore];
                                                              }
                                                          }
                                                          
                                                          numberOfCharacters = newInnerID;
                                                          [self.tableView reloadData];
                                                          
                                                          bottomPullView.hidden = NO;
                                                          [bottomPullView finishedLoading];
                                                      }
	                                                  failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                          // Failed to load characters.
                                                          [self animateActivityIndicator:NO];
                                                          [bottomPullView finishedLoading];
                                                          [[[UIAlertView alloc] initWithTitle:@"NOD API Error" message:operation.error.localizedDescription delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil] show];
                                                      }];
}

#pragma mark - UITableView Delegate Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
	//NSInteger row = indexPath.row;
	//NSString *reusableIdentifier = [NSString stringWithFormat:@"%d", indexPath.row % 2];
    
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
    
	[[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
	BOOL charHasDescription = NO;
	if (numberOfCharacters > indexPath.row)
	{
		News *curCharacter = [News charWithManagedObjectContext:
		                           [[NODObjectManager manager] managedObjectContext]
		                                                       andInnerID:indexPath.row];
		if (curCharacter)
		{
			charHasDescription = ![curCharacter.ndesc isEqualToString:@""];
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, CGRectGetWidth(cell.contentView.frame) - 70 - (charHasDescription ? 10 : 0), 60)];
			label.backgroundColor = [UIColor clearColor];
			label.text = curCharacter.ntitle;
			label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
			[cell.contentView addSubview:label];
            
			GDCellThumbnailView *thumbnail = [GDCellThumbnailView thumbnail];
			if (curCharacter.thumbnailImageData)
				[thumbnail setImage:[UIImage imageWithData:curCharacter.thumbnailImageData]];
			else
				[self loadThumbnail:thumbnail fromURLString:curCharacter.thumbnailURLString forCharacter:curCharacter];
            
			[cell.contentView addSubview:thumbnail];
		}
	}
    
	cell.accessoryType = charHasDescription ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellSelectionStyleNone;
	cell.userInteractionEnabled = charHasDescription;
    
	return cell;
}

- (void)loadThumbnail:(GDCellThumbnailView *)view fromURLString:(NSString *)urlString forCharacter:(News *)character
{
	// Download thumbnail image for selected character.
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Image downloaded successfully.
        character.thumbnailImageData = responseObject;
        [self saveToStore];
        [view setImage:[UIImage imageWithData:responseObject]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Image download failure.
        NSLog(@"%@", [error localizedDescription]);
    }];
	[operation start];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return numberOfCharacters;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	[self showDetailsForCharacterID:indexPath.row];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	[self showDetailsForCharacterID:indexPath.row];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	cell.backgroundColor = [UIColor colorWithWhite:indexPath.row % 2 ? 0.9:0.95 alpha:1];
}

#pragma mark - UIAlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1)
		[self loadCharacters];
}

#pragma mark - UIViewController-derived

- (id)init
{
	self = [super init];
	if (self)
		noRequestsMade = YES;
    
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), CGRectGetHeight(self.tableView.frame))];
	activityIndicator.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
	activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
	[self.view addSubview:activityIndicator];
    
	self.title = @"Новости";
    
	bottomPullView = [[AllAroundPullView alloc] initWithScrollView:self.tableView position:AllAroundPullViewPositionBottom action:^(AllAroundPullView *view){
        [self loadCharacters];
    }];
	bottomPullView.hidden = YES;
	[self.tableView addSubview:bottomPullView];
    
	// Configure CoreData managed object model.
	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"newsdata" withExtension:@"momd"];
    //NODObjectManager *NODmanager = [[NODObjectManager alloc] init];
	[[NODObjectManager manager] configureWithManagedObjectModel:[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL]];
    
	// Add mapping between the "Character" CoreData entity and the "Character" class. Specify the mapping between entity attributes and class properties.
	[[NODObjectManager manager] addMappingForEntityForName:@"News"
	                           andAttributeMappingsFromDictionary:@{
                                                                    @"title" : @"ntitle",
                                                                    @"id" : @"unique",
                                                                    @"desc" : @"ndesc",
                                                                    @"picture" : @"thumbnailURLString",
                                                                    @"category" : @"ncategory",
                                                                    @"country" : @"ncountry",
                                                                    @"region" : @"nregion",
                                                                    @"city" : @"ncity",
                                                                    @"link" : @"nlink",
                                                                    @"pream" : @"npream",
                                                                    @"video" : @"nvideo",
                                                                    @"videopicture" : @"nvideopicture",
                                                                    @"readflag" : @"nreadFlag",
                                                                    @"pubDate" : @"npubDate"
                                                                    }
	                                  andIdentificationAttributes:@[@"unique"]
	                                               andPathPattern:NOD_API_CHARACTERS_PATH_PATTERN];
    
	[self loadCharacters];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"pushJSONSegue"]) {
        
        NODDetailScrollViewController *detailViewController = [segue destinationViewController];
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        detailViewController.detailIndexPath = indexPath;
        //detailViewController.detailList = self.list;
        
        //[[segue destinationViewController] setList:list];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
