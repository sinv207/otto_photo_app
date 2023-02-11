# otto_photo_app

This is demo application that displays a list of photos as a gallery.

## Overview
This is a Sample Photo App that displays a list of photos as a gallery. It allows users can tap the photo to see a full-screen view of it.

There are 3 pages in this app: 
- Home page: Display all photos from random api (ex: https://dog.ceo/api/breeds/image/random/18) as gallery with 3 column format.
    - Support cache image on user's device.
    - Display favorite icon if that photo has been bookmarked.
    - Tap on any photo to open photo view page.
    - Tap on icon "Favorite" at AppBar to open all favorites on photo view page.
    - Infinite scroll to load more photos (in this demo: limit at 500 photos because of performance reasons).

- Photo viewer page (with all photos): Display photo as full-screen mode.
    - User can pinch to zoom in and out.
    - User can swipe to view prev/next photo.
    - User can tap on icon to toggle bookmark favorite on current photo.

- Photo viewer page (only favorite photos).
    - (same features as above)

State management solution is Bloc Pattern (flutter_bloc).

## FEATURES
- MUST HAVE FEATURES: 
    - ✅ Use of any public Photo API to get a list of photos and build a gallery of photos
    - ✅ The user can tap the photo and can see a full-screen view of the photo
    - ✅ The user has an infinite scroll on the gallery screen

- ADDITIONAL FEATURES:
    - ❌ User can login using SSO (Google/Microsoft)
    - ✅ Local Cache mechanism in the backend
    - ✅ User can bookmark their favourite photos
    - ✅ User can view all bookmark photos in a viewer

- OTHER FEATURES:
    - ✅ At gallery of photos page, pull down to refresh new photos.
    - ✅ Display favorite icon on photo at gallery page.
    - ✅ Handle error as common.


## CLI
Install package
```bash
flutter pub get
```
Run dev on connected device
```bash
flutter run
```

## Environment

- macOS: 13.1
- Flutter SDK version: 3.3.10
- Xcode: 14.2
- iOS: 16.2

- Android Studio Bumblebee | 2021.1.1 Patch 2
- Android SDK version: 32.1.0


## Libraries

```bash
bloc_concurrency: ^0.2.1
cached_network_image: ^3.2.3
equatable: ^2.0.5
flutter_bloc: ^8.1.2
http: ^0.13.5
photo_view: ^0.14.0
```

## Directory structures

```bash
...
/assets
/lib
    /blocs
        /[Name]
            [Name]_bloc.dart
            [Name]_state.dart
            [Name]_event.dart
    /configs
    /models
    /pages
    /repositories   
    /utils
    /services
    /widgets
...
```

## How to use Directories 

- lib/blocs: The blocs directory contains all blocs in this project that have logic code be used for state mananement.
- lib/configs: Contains all configs and constants for user or app settings. 
- lib/models: Contains all entry model.
- lib/pages: Contains UI of page, logic on presentation layer. ex: Home page, account page, login page, ...
- lib/repositories: Manage fetching data from service and convert it to model. 
- lib/utils: Contains common utility. ex: formatter, responsive helper, ...
- lib/services: Contains common source code that handle api services, firebase, database services, ...
- lib/widgets: Contains common widgets.
