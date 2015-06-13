![](https://github.com/diwu/ui-markdown-store/blob/master/demo_1.gif)

#DWURecyclingAlert
[![](https://img.shields.io/badge/build-passing-green.svg)](https://github.com/diwu/LeetCode-Solutions-in-Swift)
[![](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/diwu/LeetCode-Solutions-in-Swift)

A dead simple drop-in code snippet that detects non-recycled UI elements inside your UITableViewCells.
#Usage
Step 1: Drop [DWURecyclingAlert.m](./RecyclingAlert/DWURecyclingAlert/DWURecyclingAlert.m) into your project.

Step 2: There's no step 2. 

Now launch your app, initialize a UITableView and observe. Anything that are marked with an ugly bold red border are UI stuff that are created on the fly while the user is scrolling. You should consider caching those UI stuff and reusing them whenever possible.

Once you start caching those UI stuff, the ugly red borders will be gone, for good. Because [DWURecyclingAlert.m](./RecyclingAlert/DWURecyclingAlert/DWURecyclingAlert.m) will intelligently detect which is cached and will only mark those that are not cached with a red border.
#How It Works
[DWURecyclingAlert.m](./RecyclingAlert/DWURecyclingAlert/DWURecyclingAlert.m) dynamically injects a property into every UIView instances so that it has a way to know which is recycled and which is not. 

For views that have an image property, [DWURecyclingAlert.m](./RecyclingAlert/DWURecyclingAlert/DWURecyclingAlert.m) will record and check the underlying CGImageRef value to decide whether the image is a recycled one or not.
#Disabled in Release Builds By Default
[DWURecyclingAlert.m](./RecyclingAlert/DWURecyclingAlert/DWURecyclingAlert.m) requires the DEBUG macro to compile and run. If you also want to disable it in debug builds, feel free to comment out the [DWURecyclingAlertEnabled](https://github.com/diwu/DWURecyclingAlert/blob/master/RecyclingAlert/DWURecyclingAlert/DWURecyclingAlert.m#L16) macro at the top of the file.
#Example Project
Inside this repo you can find the [RecyclingAlert](./RecyclingAlert.xcodeproj) example project. 