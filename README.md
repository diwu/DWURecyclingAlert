![][demo]

#DWURecyclingAlert
[![](https://img.shields.io/badge/build-passing-green.svg)][project]
[![](https://img.shields.io/badge/license-MIT-blue.svg)][project]
[![](https://img.shields.io/badge/swift-compatible-orange.svg)][project]

A dead simple drop-in code snippet that detects non-recycled UI elements inside your UITableViewCells.
#Usage
Step 1: Drop [DWURecyclingAlert.m][code] into your Obj-C or Swift project.

Step 2: There's no step 2. 

Now launch your app, initialize a UITableView and observe. Anything that are marked with an ugly bold red border are UI stuff that are created on the fly while the user is scrolling. You should consider caching those UI stuff and reusing them whenever possible.

Once you start caching those UI stuff, the ugly red borders will be gone, for good. Because [DWURecyclingAlert.m][code] will intelligently detect which is cached and will only mark those that are not cached with a red border.
#How It Works
[DWURecyclingAlert.m][code] dynamically injects a property into every UIView instances so that it has a way to know which is recycled and which is not. 

For views that have an image property, [DWURecyclingAlert.m][code] will record and check the underlying CGImageRef values to decide whether the image is a recycled one or not.
#Disabled in Release  By Default
[DWURecyclingAlert.m][code] requires the DEBUG macro to compile and run. If you also want to disable it in debug builds, feel free to comment out the [DWURecyclingAlertEnabled][code_line_16] macro at the top of the file.
#Example Project
Inside this repo you can find the RecyclingAlert example project. 
#License
DWURecyclingAlert is released under the MIT license. See LICENSE for details.

[code]: https://raw.githubusercontent.com/diwu/DWURecyclingAlert/master/RecyclingAlert/DWURecyclingAlert/DWURecyclingAlert.m
[code_line_16]: https://github.com/diwu/DWURecyclingAlert/blob/master/RecyclingAlert/DWURecyclingAlert/DWURecyclingAlert.m#L22
[project]: https://github.com/diwu/DWURecyclingAlert
[demo]: https://github.com/diwu/ui-markdown-store/blob/master/demo_1.gif