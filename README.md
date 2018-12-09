# NikeNotifications

## Overview
A tool to automatically fetch updates from Nike's Launches site.

## How to setup (Mac only)
 * Clone the repo locally, and run the following commands inside the directory:
  * `swift package update`
  * `swift package -Xlinker -L/usr/local/lib generate-xcodeproj`
 * In this [file](https://github.com/RyanMKrol/NikeNotifications/blob/master/Sources/NikeNotificationsLib/Utils/EmailClient.swift) add the details of your preferred SMTP client to send you emails
  * This is very easy to setup using Gmail, just generate an App password [here](https://myaccount.google.com/apppasswords)
 * Set your preferred document location [here](https://github.com/RyanMKrol/NikeNotifications/blob/master/Sources/NikeNotificationsLib/DataCollection/FileInteractions.swift#L21)
  * Note: This will be relative to the doc root specified by xcode (Mine was in my Documents folder), you can change this if you like.
  * Note: Please create any required directories along your preferred doc root, this program will fail if it can't navigate to where it's expecting the file to be, but it will create it if the file itself doesn't exist
 * If you're not in the UK, change the Nike Launches URL found [here](https://github.com/RyanMKrol/NikeNotifications/blob/master/Sources/NikeNotificationsLib/DataCollection/PageScraper.swift#L14)
 * Build the project using `swift build`
 * The executable should be found here - `/.build/debug/NikeNotifications`
 * Setup a cron job to run the tool however often you like
 * Done!
