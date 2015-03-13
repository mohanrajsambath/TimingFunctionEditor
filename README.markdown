# TimingFunctionEditor 

Simple swift based editor for bezier based media timing functions

Here's a video showing a slightly older version: [Preview Video](https://www.dropbox.com/s/dqyp1xuroetdnl1/Timing%20Function%20Editor.mp4?dl=0)

![Screenshot](Documentation/Screenshot.png)

## How to use

Choose a timing function from the table.

Edit the timing function by moving the bezier handles.

Preview the function by tapping on the preview bar.

Copy & paste the code for the function from the code snippet text field.

## How to build

This project depends on my [SwiftGraphics](https://github.com/schwa/SwiftGraphics) framework you'll need to use [Carthage](https://github.com/Carthage/Carthage) to download and build SwiftGraphics. You can install Carthage via [homebrew](http://github.com/Homebrew/homebrew).

	carthage bootstrap

After bootstrapping carthage the project should build normally.
