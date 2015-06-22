#import "SnapshotHelper.js"

var target = UIATarget.localTarget()

target.frontMostApp().tabBar().buttons()[0].tap()
target.delay(3)
captureLocalizedScreenshot("1-Bracket")

target.frontMostApp().mainWindow().collectionViews()[0].cells()[2].tap()
target.delay(3)
captureLocalizedScreenshot("2-Series")

target.frontMostApp().mainWindow().tableViews()[0].cells()[3].tap()
target.delay(3)
captureLocalizedScreenshot("3-Game")

target.frontMostApp().mainWindow().tableViews()[0].groups()[0].buttons()[0].tap()
target.setDeviceOrientation(UIA_DEVICE_ORIENTATION_PORTRAIT)
target.delay(3)
captureLocalizedScreenshot("4-Video")

target.frontMostApp().mainWindow().buttons()["Done"].tap()
target.frontMostApp().tabBar().buttons()[1].tap()
target.delay(3)
captureLocalizedScreenshot("5-Recents")
