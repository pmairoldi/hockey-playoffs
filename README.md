# hockey-playoffs

[![Build Status](https://travis-ci.org/petester42/hockey-playoffs.svg?branch=master)](https://travis-ci.org/petester42/hockey-playoffs)
[![Coverage Status](https://coveralls.io/repos/petester42/hockey-playoffs/badge.svg)](https://coveralls.io/r/petester42/hockey-playoffs)

iOS application that keeps track of the NHL playoffs. Requires iOS 17 or later.

## Setup Project

```sh
bundle install
```

## Run tests

```sh
bundle exec fastlane test
```

## Verify adaptive layouts

Build with Xcode 27.1 or later to get iPhone Duo's native vertical bars.
The UI follows [Apple's iPhone Duo preparation guidance](https://developer.apple.com/documentation/technologyoverviews/preparing-your-app-for-iphone-duo): container-relative sizing, dynamic layout invalidation, safe-area constraints, and system navigation controls.

```sh
# Use the installed Xcode 27.1 without changing the global Xcode selection
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
xcodebuild -project HockeyPlayoffs.xcodeproj -scheme Screenshots \
  -destination 'platform=iOS Simulator,name=iPhone Duo' \
  -only-testing:Screenshots/Screenshots/testResizableNavigation test
```

The UI tests check that navigation stays usable as content extends beneath the bars, along with pinned navigation titles, series and game navigation, game controls, and date-picker accessibility across requested orientations. Also manually test closing, opening, and partially folding Duo in Device Hub, including both inner-display orientations. Check bracket scrolling, connector alignment, game details, date selection and its popover, and that navigation and the selected date survive display transitions. Rotation commands alone do not switch Duo's display or pose.

## Interface conventions

The active screens follow Apple's [list guidance](https://developer.apple.com/design/human-interface-guidelines/lists-and-tables), [layout guidance](https://developer.apple.com/design/human-interface-guidelines/layout), and [Liquid Glass adoption guide](https://developer.apple.com/documentation/technologyoverviews/adopting-liquid-glass):

- Recent Games, series games, and period events use inset grouped tables while retaining the original named color palette, team-colored scores, and separator colors.
- Series/game summaries remain opaque content cards. The original TV-style highlights button, enabled/disabled colors, row highlight feedback, and Goals/Penalties interactions are retained; score content doesn't add custom glass effects.
- Recent Games retains the original push/back navigation at every width, without a split detail pane or persistent list selection. Dividers use 20-point side insets and appear only between game rows, never below the last row.
- Detail tables use the readable content guide instead of stretching text across a wide display. Scroll viewports extend to the view's top and bottom edges so content can pass beneath the navigation and tab bars. UIKit automatically keeps resting content and scroll indicators clear of the bars; horizontal safe/readable-width guides still protect content beside Duo's side controls. Event rows self-size and period headings are plain grouped-list labels. Game overviews are compact at standard text sizes and reflow into team rows at accessibility sizes.
- Series team totals and game scores share each row. Score grids fill their summaries with one physical pixel between cells. Series summaries inset their text 16 points at both outer edges while continuing each adjacent cell's background color to the edge. Numeric columns (including SOG) keep fixed, text-scaled widths while the team column takes the remaining space; narrow containers may compress numeric columns to preserve team readability. Recent Games puts its unlabeled date picker in the navigation header beside the title and uses one rounded game section, retaining its inline loading row.
- In Duo's vertical-bar layouts, navigation bars stay pinned while content scrolls beneath them. The policy follows UIKit's vertical-bar traits as the layout changes; ordinary horizontal bars retain their system behavior.
- The bracket remains a connected visualization rather than being converted into a list.

The UI regression also exercises Recent Games selection, the Penalties control, and returning to the date filter. Review screenshots in light/dark mode and with accessibility text sizes. To exercise regular width without changing the shipping iPhone-only device family, a local iPad simulator test build can override `TARGETED_DEVICE_FAMILY='1,2'`; that does not replace testing Duo's inner display and fold transitions.

## Regenerate screenshots

```sh
bundle exec fastlane snapshot
```

## Update App Store Metadata

```sh
# without regenerating screenshots
bundle exec fastlane marketing

# with regenerating screenshots
bundle exec fastlane marketing screenshots:true
```

## Publish a beta build

```sh
# without regenerating screenshots
bundle exec fastlane beta

# with regenerating screenshots
bundle exec fastlane beta screenshots:true
```

## Publish an AppStore build

```sh
# without regenerating screenshots
bundle exec fastlane deploy

# with regenerating screenshots
bundle exec fastlane deploy screenshots:true
```
