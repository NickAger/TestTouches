# TestTouches
Draw tracking touch events

Based on: https://code.tutsplus.com/tutorials/smooth-freehand-drawing-on-ios--mobile-13164

## Notes:
* Discovered that drawing the bitmap in `UIView:draw` could be very slow, unless it matched display see `SmoothedBezierInterpolationView0`, ``SmoothedBezierInterpolationView1` vs `SmoothedBezierInterpolationView4` 
* Final solution `SmoothedBezierInterpolationView5` uses a layer to hold the `incrementalImage` and another layer to draw the current touch session's bezier curves. Couldn't use `UIView:draw`  in conjunction with layers as it appears to override content provided by layers. 
* In addition the `SmoothedBezierInterpolationView5` uses `coalescedTouches` and makes sure remaining points are drawn from `touchesEnded`

## See also
 * https://developer.apple.com/library/content/samplecode/SpeedSketch/Introduction/Intro.html#//apple_ref/doc/uid/TP40017333-Intro

## Links

* [WWDC 2012 iOS App Performance: Graphics and Animations Session 238](https://developer.apple.com/videos/wwdc2012/)
* https://code.tutsplus.com/tutorials/smooth-freehand-drawing-on-ios--mobile-13164
* https://developer.apple.com/library/content/samplecode/TouchCanvas/Introduction/Intro.html
* https://developer.apple.com/videos/play/wwdc2016/220
* https://developer.apple.com/videos/play/wwdc2015/233/
* https://spin.atomicobject.com/2014/05/28/ios-interpolating-points/
* https://developer.apple.com/library/prerelease/content/samplecode/SpeedSketch
* https://developer.apple.com/videos/play/wwdc2016/220
* http://ilya.puchka.me/freehand-drawing/

