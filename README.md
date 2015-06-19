![][demo]

#DWURecyclingAlert
> Your code usually has less than ten milliseconds to run before it causes a frame drop.<sup>[1](#myfootnote1)</sup>
>

[![Build Status](https://travis-ci.org/diwu/DWURecyclingAlert.svg?branch=master)](https://travis-ci.org/diwu/DWURecyclingAlert)
[![](https://img.shields.io/badge/license-MIT-blue.svg)][license]
[![](https://img.shields.io/badge/swift-compatible-orange.svg)][project]

A drop-in tool that monitors UITableViewCell & UICollectionViewCell rendering performance on the fly.

* Detects non-recycled UI elements inside the UITableViewCells.
* Displays the time it takes to render each UITableViewCell, in milliseconds.

#Usage
Step 1: Drop [DWURecyclingAlert.m][code] into your project.

Step 2: There's no step 2. 

Now launch your app, initialize a UITableView or a UICollectionView and observe. Anything that are marked with an ugly bold red border are UI stuff that are created on the spot while the user is scrolling. You should consider caching those UI stuff and reusing them whenever possible.

Once you start caching them, the ugly red borders will be gone, for good. Because [DWURecyclingAlert.m][code] will intelligently detect which is cached and will only mark those that are not cached with a red border.

In addition, [DWURecyclingAlert.m][code] calculates the time your code uses to assemble each cell and presents the results in black labels at the top left corner, so that you can easily spot the heaviest ones and refactor them to free up the UI thread.
#How It Works
[DWURecyclingAlert.m][code] dynamically injects a property into every UIView instances so that it has a way to know which is recycled and which is not. 

For views that have an image property, [DWURecyclingAlert.m][code] will record and check the underlying CGImageRef values to decide whether the image is a recycled one or not.

To calculate the cell rendering time, [DWURecyclingAlert.m][code] hacks into the heart of UITableViewDataSource & UICollectionViewDataSource and injects a simple time counting logic inside each data sources' implementation of [tableView:cellForRowAtIndexPath:] & [collectionView:cellForItemAtIndexPath:].
#Disabled in Release  By Default
[DWURecyclingAlert.m][code] requires the DEBUG macro to compile and run. If you also want to disable it in debug builds, feel free to comment out the [DWURecyclingAlertEnabled][code_line_23] macro at the top of the file.

There will be times when you want to keep an eye on the non-recycled UI elements but prefer the time counting label hidden, if that's the case, comment out the [DWUMillisecondCounterEnabled][code_line_26] right below [DWURecyclingAlertEnabled][code_line_23].
#Example Project
Inside this repo you can find the RecyclingAlert example project. 
#License
DWURecyclingAlert is released under the MIT license. See LICENSE for details.

[code]: ./RecyclingAlert/DWURecyclingAlert/DWURecyclingAlert.m
[code_line_23]: ./RecyclingAlert/DWURecyclingAlert/DWURecyclingAlert.m#L23
[code_line_26]: ./RecyclingAlert/DWURecyclingAlert/DWURecyclingAlert.m#L26
[project]: https://github.com/diwu/DWURecyclingAlert
[demo]: https://github.com/diwu/ui-markdown-store/blob/master/demo_3.gif
[license]: ./LICENSE
<a name="myfootnote1">1</a>: Facebook AsyncDisplayKit Guide. (http://asyncdisplaykit.org/guide)