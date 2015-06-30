![][demo]

#DWURecyclingAlert
> Your code usually has less than ten milliseconds to run before it causes a frame drop.<sup>[1](#myfootnote1)</sup>
>

[![Build Status](https://travis-ci.org/diwu/DWURecyclingAlert.svg?branch=master)](https://travis-ci.org/diwu/DWURecyclingAlert)
[![](https://img.shields.io/badge/license-MIT-blue.svg)][license]
[![](https://img.shields.io/badge/swift-compatible-orange.svg)][project]

A drop-in tool that monitors UITableViewCell, UICollectionViewCell and UITableViewHeaderFooterView rendering performance on the fly.

* Detects non-recycled UIView, CALayer and UIImage objects inside UITableViewCell, UICollectionViewCell and UITableViewHeaderFooterView.
* Displays the time it takes to go through `cellForRowAtIndexPath:` in each UITableViewCell, UICollectionViewCell and UITableViewHeaderFooterView, in milliseconds.
* Displays the time it takes to go through customized `[UIView drawRect:]` in each UITableViewCell, UICollectionViewCell and UITableViewHeaderFooterView, in milliseconds.
* Support for UICollectionReusableView coming soon. Stay tuned.

#Usage
Step 1: Drop [DWURecyclingAlert.m][code] into your project.

Step 2: There's no step 2. 

Now launch your app, initialize a UITableView or a UICollectionView, scroll it fast and observe. Anything that are marked with an ugly bold red border are UIView or CALayer or UIImage objects that are created on the fly while the user is scrolling. You should consider caching and reusing them whenever possible.

Once you start caching them, the ugly red borders will be gone, for good. Because [DWURecyclingAlert.m][code] will intelligently detect which is cached and will only mark those that are not cached with a red border.

In addition, [DWURecyclingAlert.m][code] calculates the time your code uses to assemble each cell / header / footer and presents the results in black labels at the top left corner, so that you can easily spot the heaviest ones and refactor them to free up the UI thread.
#UI Configuration
It's not unlikely that your project happens to use lots of `[UIColor redColor]` here and there. Or, maybe you want to localize the millisecond warning string with your team's first language. Take a look at the [UI Configuration][code_line_39] section and customize them the way you like.
#How It Works
[DWURecyclingAlert.m][code] dynamically injects a property into every CALayer instances so that it has a way to know which is recycled and which is not. 

For views that have an image property, [DWURecyclingAlert.m][code] will record and check the underlying CGImageRef values to decide whether the image is a recycled one or not.

In order to count the cell / header / footer rendering time, [DWURecyclingAlert.m][code] hacks into the heart of UITableViewDataSource, UICollectionViewDataSource and UITableViewDelegate and injects a simple time counting logic inside them.

When [DWURecyclingAlert.m][code] finds a UIView subclass that overrides `[UIView drawRect:]`, [DWURecyclingAlert.m][code] swizzles its customized drawRect: implementation and injects the time counting logic there.

Since `[UIView drawRect:]` and `cellForRowAtIndexPath:` rarely happens in the same runloop, [DWURecyclingAlert.m][code] uses KVO to observe the latest time count and updates the time count label whenever a KVO event fires.

It's perfectly normal for a cell to have multiple subviews that override `drawRect:`, if that's the case, [DWURecyclingAlert.m][code] will calculate the sum for all the time it takes to go through each `drawRect:` call.

#Disabled in Release By Default
[DWURecyclingAlert.m][code] requires the DEBUG macro to compile and run. As a result, it's disabled in Release by default. If you also want to disable it in debug builds, feel free to comment out the [DWURecyclingAlertEnabled][code_line_23] macro at the top of the file.
#Misc
Whether your cell / header / footer are created by code or by nib/storyboard, [DWURecyclingAlert.m][code] has a way to scan it.

[DWURecyclingAlert.m][code] requires iOS 6 or higher to compile due to an implementation detail (NSMapTable).

#Example Project
Inside this repo you can find the RecyclingAlert example project. 
#License
DWURecyclingAlert is released under the MIT license. See LICENSE for details.

[code]: ./RecyclingAlert/DWURecyclingAlert/DWURecyclingAlert.m
[code_line_23]: ./RecyclingAlert/DWURecyclingAlert/DWURecyclingAlert.m#L23
[code_line_39]: ./RecyclingAlert/DWURecyclingAlert/DWURecyclingAlert.m#L39
[project]: https://github.com/diwu/DWURecyclingAlert
[demo]: https://raw.githubusercontent.com/diwu/ui-markdown-store/master/demo_8.gif
[license]: ./LICENSE
<a name="myfootnote1">1</a>: Facebook AsyncDisplayKit Guide. (http://asyncdisplaykit.org/guide)