![][demo]

# DWURecyclingAlert
> Your code usually has less than ten milliseconds to run before it causes a frame drop.<sup>[1](#myfootnote1)</sup>
>

[![Build Status](https://travis-ci.org/diwu/DWURecyclingAlert.svg?branch=master)](https://travis-ci.org/diwu/DWURecyclingAlert)
[![](https://img.shields.io/badge/license-MIT-blue.svg)][license]
[![](https://img.shields.io/badge/swift-compatible-orange.svg)][project]

# Visualize Bad Drawings On The Fly

Injects 4 classes:
 
 * `UITableViewCell`
 * `UICollectionViewCell`
 * `UITableViewHeaderFooterView`
 * `UICollectionReusableView` (as footers/headers)
 
Monitors 6 time sensitive API calls:

 * `[UIView drawRect:]`
 * `tableView:cellForRowAtIndexPath:`
 * `tableView:viewForHeaderInSection:`
 * `tableView:viewForFooterInSection:`
 * `collectionView:cellForItemAtIndexPath:`
 * `collectionView:viewForSupplementaryElementOfKind:atIndexPath:`

Visualizes bad drawing code in 2 ways:

* Displays non-recycled UIView, CALayer and UIImage objects with bold red bolders.
* Displays the time it takes to complete each time sensitive API calls, in milliseconds.

# Usage
Step 1: Drop [DWURecyclingAlert.m][code] into your project, Swift or ObjC.

Step 2: There's no step 2. 

(Optionally) Using CocoaPods and manually start the injection:

`pod 'DWURecyclingAlert'` 

Then manually start injection by running the following function anywhere in your project:

`void Inject_DWURecyclingAlert();`

# UI Configuration
It's likely that your project happens to use lots of `[UIColor redColor]` here and there. Or, maybe you want to localize the millisecond warning string with your team's first language. Take a look at the [UI Configuration][code_line_39] section and customize them the way you like.
# How It Works
Method swizzling and associated objects. You could always read the [source][code].

# Disabled in Release By Default
[DWURecyclingAlert.m][code] requires the DEBUG macro to compile and run. As a result, it's disabled in Release by default. If you also want to disable it in debug builds, comment out the [DWURecyclingAlertEnabled][code_line_23] macro at the top of the file.
# Misc
* Whether your cell / header / footer are created by code or by nib/storyboard, [DWURecyclingAlert.m][code] has a way to scan it.
* It's perfectly normal for a cell to have multiple subviews that override `drawRect:`, if that's the case, [DWURecyclingAlert.m][code] will calculate the sum for all the time it takes to go through each `drawRect:` call.
* [DWURecyclingAlert.m][code] requires iOS 6 or higher to compile.

# Example Project
Inside this repo you can find the RecyclingAlert example project. 
# License
DWURecyclingAlert is released under the MIT license. See [LICENSE][license] for details.

[code]: ./RecyclingAlert/DWURecyclingAlert/DWURecyclingAlert.m
[code_line_23]: ./RecyclingAlert/DWURecyclingAlert/DWURecyclingAlert.m#L23
[code_line_39]: ./RecyclingAlert/DWURecyclingAlert/DWURecyclingAlert.m#L39
[project]: https://github.com/diwu/DWURecyclingAlert
[demo]: https://raw.githubusercontent.com/diwu/ui-markdown-store/master/demo_11.png
[license]: ./LICENSE
<a name="myfootnote1">1</a>: Facebook AsyncDisplayKit Guide. (http://asyncdisplaykit.org/guide)