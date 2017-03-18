# Saturn

![enter image description here](https://s18.postimg.org/iwf3m0up5/IMG_2016_11_08_19_25_16.jpg)

[![Version](https://img.shields.io/cocoapods/v/Saturn.svg?style=flat)](http://cocoapods.org/pods/Saturn)
[![License](https://img.shields.io/cocoapods/l/Saturn.svg?style=flat)](http://cocoapods.org/pods/Saturn)
[![Platform](https://img.shields.io/cocoapods/p/Saturn.svg?style=flat)](http://cocoapods.org/pods/Saturn)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

ios 8.0 +

## Installation

Saturn is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Saturn"
```

# Description

**Saturn gives you reliable date despite of time on user's device.**

# Setup

To activate Saturn - call method below in applicationDidFinishLaunchingWithOptions method in the AppDelegate.
After this you will be able to ask Saturn to calculate reliable date and time for you.
Pass ```true``` to ```ownServerProvided``` argument if you are going to synchronise Saturn with your own server time.

```SWIFT
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
  Saturn.protect(ownServerProvided: false)

  return true
}
```
It also strongly recommended to perform saving of required time information bafore your application will be terminated:

```SWIFT
func applicationWillTerminate(_ application: UIApplication) {
  Saturn.performSavingOfTimeData()
}
```

***


> Check example project to understand the idea of using Saturn. You can
> try to change the time on device (or Mac if you use simulator) to see
> Saturn in action.


***

# Retrieving date from Saturn

Saturn was made for calculating right date and time in your application despite changing date and time on device.
If Saturn was activated with ```protect``` method, you can always ask it to calculate reliable date and time by calling:

```SWIFT
Saturn.date { (date, craftResult) in
  print(date)
  print(craftResult)
}
```

In provided closure you have a crafted by Saturn date and crafting result. Crafting result has an enum type and you can follow it in code to see the documentation.
The main idea is that result can have **3 different values**, which tell you if can you rely on crafted date or not.

1. type ``` CraftedDateIsReliable ``` means that you can rely on crafted date and use it in your app
2. type ``` CraftedDateIsUnreliable ``` means that crafted date in most cases is correct, but sometimes it can be not. For example if user will perform several device reboots associated with changing device time and switching internet connection off - crafted date possibly might be incorrect. It will become reliable right after next successful synchronisation.
3. type ``` CraftingReliableDateIsImpossible ``` means that there wasn't any synchronisation with remote server yet and it is impossible to craft date and time. So Saturn returns just the date which is set up on user's device

# Synchronisation

## A. Sync with remote server

To do it's work properly, Saturn requires periodically perform synchronisation with some remote server's timestamp (timeInterval).

Saturn will perform synchronisation with default server if it is required and you should not think about it. But! If you've told Saturn that you will sync it with your own server in "protect" method, you should perform synchronisation by your own with following method:

```SWIFT
Saturn.syncWith(serverTime: yourServerTimeStamp)
```

It is enough to perform only one successful synchronisation during each app session.

Anyway you can always ask Saturn to try perform synchronisation with default server in background by calling:

```SWIFT
Saturn.tryToMakeNewSyncPoint()
```

## B. Periodical saving device's time information

For more reliability and detecting device reboots Saturn requires periodically save some information from your device. All data is stored in NSUserDefaults.
By default Saturn performs periodical saving each 2.5 min. You can change this loop with your own period between savings with following method:

```SWIFT
Saturn.relaunchAutoSavingProcess(withInterval: yourTimeIntervalInSeconds)
```

# Author

Aleksey Getman, getmanag@gmail.com

# License

Saturn is available under the MIT license. See the LICENSE file for more info.
