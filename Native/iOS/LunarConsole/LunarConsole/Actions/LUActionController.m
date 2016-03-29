//
//  LUActionController.m
//  LunarConsole
//
//  Created by Alex Lementuev on 2/23/16.
//  Copyright © 2016 Space Madness. All rights reserved.
//

#import "Lunar.h"

#import "LUActionController.h"

@interface LUActionController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, LUActionRegistryFilterDelegate>
{
    LUActionRegistryFilter * _actionRegistryFilter;
}

@property (nonatomic, assign) IBOutlet UIView       * noActionsWarningView;
@property (nonatomic, assign) IBOutlet UILabel      * noActionsWarningLabel;
@property (nonatomic, assign) IBOutlet UITableView  * tableView;
@property (nonatomic, assign) IBOutlet UISearchBar  * filterBar;

@end

@implementation LUActionController

+ (instancetype)controllerWithActionRegistry:(LUActionRegistry *)actionRegistry
{
    return LU_AUTORELEASE([[self alloc] initWithActionRegistry:actionRegistry]);
}

- (instancetype)initWithActionRegistry:(LUActionRegistry *)actionRegistry
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self)
    {
        if (actionRegistry == nil)
        {
            NSLog(@"Can't create action controller: action register is nil");
            
            LU_RELEASE(self);
            self = nil;
            return nil;
        }
        
        _actionRegistryFilter = [[LUActionRegistryFilter alloc] initWithActionRegistry:actionRegistry];
        _actionRegistryFilter.delegate = self;
    }
    return self;
}

- (void)dealloc
{
    LU_RELEASE(_actionRegistryFilter);
    LU_SUPER_DEALLOC
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    LUTheme *theme = [LUTheme mainTheme];
    
    // title
    self.title = @"Actions";
    
    // background
    self.view.opaque = YES;
    self.view.backgroundColor = theme.tableColor;
    
    // table view
    _tableView.backgroundColor = theme.tableColor;
    
    // no actions warning
    _noActionsWarningView.backgroundColor = theme.tableColor;
    _noActionsWarningView.opaque = YES;
    _noActionsWarningLabel.font = theme.actionsWarningFont;
    _noActionsWarningLabel.textColor = theme.actionsWarningTextColor;
    
    [self updateNoActionWarningView];
    
    // accessibility
    LU_SET_ACCESSIBILITY_IDENTIFIER(_noActionsWarningView, @"No Actions Warning View");
    
//    // "status bar" view
//    UITapGestureRecognizer *statusBarTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self                                                                                                    action:@selector(onStatusBarTap:)];
//    [_statusBarView addGestureRecognizer:statusBarTapGestureRecognizer];
//    LU_RELEASE(statusBarTapGestureRecognizer);
//    
//    _statusBarView.text = [NSString stringWithFormat:@"Lunar Console v%@", _version ? _version : @"?.?.?"];
    
    
    // filter text
    // _filterBar.text = _console.entries.filterText;
}

#pragma mark -
#pragma mark Status bar

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark -
#pragma mark Filtering

- (void)filterByText:(NSString *)text
{
    BOOL changed = [_actionRegistryFilter setFilterText:text];
    if (changed)
    {
        [_tableView reloadData];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _actionRegistryFilter.groupCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    LUActionGroup *group = [self groupAtIndex:section];
    return group.actionCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self groupAtIndex:section].name;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LUAction *action = [self actionAtIndexPath:indexPath];
    
    LUTheme *theme = [LUTheme mainTheme];
    
    LUActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"action"];
    if (cell == nil)
    {
        cell = [LUActionTableViewCell cellWithReuseIdentifier:@"action"];
    }
    cell.title = action.name;
    cell.cellColor = indexPath.row % 2 == 0 ? theme.actionsBackgroundColorDark : theme.actionsBackgroundColorLight;
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]])
    {
        LUTheme *theme = [LUTheme mainTheme];
        
        UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
        headerView.textLabel.font = theme.actionsGroupFont;
        headerView.textLabel.textColor = theme.actionsGroupTextColor;
        headerView.contentView.backgroundColor = theme.actionsGroupBackgroundColor;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if ([_delegate respondsToSelector:@selector(actionController:didSelectActionWithId:)])
    {
        LUAction *action = [self actionAtIndexPath:indexPath];
        [_delegate actionController:self didSelectActionWithId:action.actionId];
    }
}

#pragma mark -
#pragma mark UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self filterByText:searchText];
    
    if (searchText.length == 0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [searchBar resignFirstResponder];
        });
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark -
#pragma mark LUActionRegistryFilterDelegate

- (void)actionRegistryFilter:(LUActionRegistryFilter *)registryFilter didAddGroup:(LUActionGroup *)group atIndex:(NSUInteger)index
{
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:index];
    [_tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    LU_RELEASE(indexSet);
    
    [self updateNoActionWarningView];
}

- (void)actionRegistryFilter:(LUActionRegistryFilter *)registryFilter didRemoveGroup:(LUActionGroup *)group atIndex:(NSUInteger)index
{
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:index];
    [_tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    LU_RELEASE(indexSet);
    
    [self updateNoActionWarningView];
}

- (void)actionRegistryFilter:(LUActionRegistryFilter *)registryFilter didAddAction:(LUAction *)action atIndex:(NSUInteger)index groupIndex:(NSUInteger)groupIndex
{
    NSArray *array = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:groupIndex]];
    [_tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
    
    [self updateNoActionWarningView];
}

- (void)actionRegistryFilter:(LUActionRegistryFilter *)registryFilter didRemoveAction:(LUAction *)action atIndex:(NSUInteger)index groupIndex:(NSUInteger)groupIndex
{
    NSArray *array = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:groupIndex]];
    [_tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
    
    [self updateNoActionWarningView];
}

#pragma mark -
#pragma mark Groups

- (LUAction *)actionAtIndexPath:(NSIndexPath *)indexPath
{
    LUActionGroup *actionGroup = [self groupAtIndex:indexPath.section];
    return actionGroup.actions[indexPath.row];
}

- (LUActionGroup *)groupAtIndex:(NSUInteger)index
{
    return [_actionRegistryFilter groupAtIndex:index];
}

- (NSInteger)groupCount
{
    return _actionRegistryFilter.groupCount;
}

#pragma mark -
#pragma mark No actions warning view

- (void)updateNoActionWarningView
{
    [self setNoActionsWarningViewHidden:_actionRegistryFilter.registry.groupCount > 0];
}

- (void)setNoActionsWarningViewHidden:(BOOL)hidden
{
    _tableView.hidden = !hidden;
    _filterBar.hidden = !hidden;
    _noActionsWarningView.hidden = hidden;
}

@end
