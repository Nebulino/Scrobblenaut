## 2.0.5+1
### Fix dio/adapters

- Removed proxy support from dio.
- Fixed support to Dart | Native & Js.
- Updated dependencies.

## 2.0.5
### Small version bump

- Add support to Dart | Native & Js.
- Preparing for null-safety support.

## 2.0.4
### Small version bump

- Add the possibility to login with already a md5 password.
- Removed deprecation.
- Update example.

## 2.0.3

- Updated Copyright headline for a bump to Dart 2.8.0.
- Updated the README.md.
- Updated the pubspec.yaml.

## 2.0.2
### Small bug-fix

- Remove remained print().
- Fix README.md.
- Fix CHANGELOG.md.
- Fix build.ps1.
- Fix clean.ps1.  

## 2.0.1

  - Fix Artists in Tracks gained from user.getRecentTracks().

## 2.0.0
### Major Update
#### In some objects You can apply object-related methods
##### Status

- Album object supported.
- Artist object supported.
- Tag object supported. (TagMethods.getTopTags not supported because is useless, no Tag attribute used)
- Track object supported.
- User object supported.

##### Dev Changelog

- Add capability of applying UserMethods in User.
- Created example-related. Watch them on *./example*.
- Fixed clean.sh.
- Added .g.dart to make possible the usage from *git* in pubspec.yaml 
- Updated the **README.md** for Major Update.
- Updated the **CHANGELOG.md**. *This thing You're reading right now*

## 1.0.5
### Add capability of applying TrackMethods in Track

- Created new track example.
- Fixed TrackMethods.getTags.
- Changed *lang* in Methods into *language*
- Updated **CHANGELOG.md**.
- *TrackMethods.scrobbleOnce()* **into** *TrackMethods.scrobble()*
- *TrackMethods.scrobbleOnceFromObject()* **into** *TrackMethods.scrobbleFromObject()*
- *TrackMethods.scrobble()* **into** *TrackMethods.multiScrobble()*

## 1.0.4
### Add capability of applying TagMethods in Tag

- Created new tag example.
- Changed *lang* in Methods into *language*
- Updated **CHANGELOG.md**.

## 1.0.3
### Add capability of applying ArtistMethods in Artist

- Created new artist example.
- Fixed some Future<dynamic> left.
- Fixed some *examples*.
- Updated **CHANGELOG.md**.

## 1.0.2
### Add capability of applying AlbumMethods in Albums

- Created new album example.
- Fixed version number
- Updated **CHANGELOG.md**.

## 1.0.1
### Fix Documentation

- Created lastfm_methods library.

## 1.0.0
### Finally! First Release!
#### All methods implemented
##### Status

- Auth and No Auth method supported.
- Album Methods supported.
- Artist Methods supported.
- Chart Methods supported.
- Geo Methods supported.
- Library Methods supported.
- Tag Methods supported.
- Track Methods supported.
- User Methods supported.

##### Dev Changelog

- Fixed Exception Handling on **Spaceship**.
- Created **ScrobbleObject()** for helping in scrobbling.
- Fixed **linksExtractor()** Helper.
- Added **timestampToSecondsSinceEpoch()** for **TrackMethods.scrobble()** and derivatives.
- Fixed **Track.topTags**.
- Fixed **LastFMException.generate()**.
- Created POSTResponse Helper and ScrobbleResponseHelper.
- Added a 'FIXME' bypass on duration parsing in Tracks.
- Fixed **Geo.getTopTracks()** for the Track Duration problem.
- Fixed **Tag.count**.
- Created **Taggings** for **User.getPersonalTags**.
- Modified some examples. Watch them on *./example*.
- Updated the **README.md** for First Release.
- Updated the **CHANGELOG.md**. *This thing You're reading right now*

## 0.1.6
### Huge update
#### Seventh Pre-Release. One more to go...

- Implemented Track Methods.
- Fixed Artist toJson() missing method.
- Updated the changelog.
- Created NowPlayed Track helper.
- Created NowPlaying Object.
- Created Scrobble Response (renamed from Scrobble Response Helper).
- Created Scrobbled Track helper.
- Created helper library.
- Created Track Result Object.
- Added track example.
- Added scrobble example.
- Updated the README.

## 0.1.5
### Sixth Pre-Release. Still, a long way...

- Implemented Tag Methods.
- Fixed Tag attributes.
- Updated the changelog.
- Added tag example.
- Updated the README.

## 0.1.4
### Fifth Pre-Release. Still, a long way...

- Implemented Library Methods.
- Updated the changelog.
- Added library example.
- Updated the README.

## 0.1.3
### Fourth Pre-Release. Still, a long way...

- Implemented Geo Methods.
- Updated the changelog.
- Fixed the README.
- Added geo example.

## 0.1.2
### Third Pre-Release. Still, a long way...

  - Implemented Chart Methods.
  - Updated the changelog.
  - Added chart example.

## 0.1.1
### Second Pre-Release. Still, a long way...

- Implemented Artist Methods.
- More documentation.
- Created and modified the examples.
- Fixed the CHANGELOG.md.
- Fixed some objects.
- Added ArtistSearchResults.
- Added more Helpers.

## 0.1.0
### First Pre-Release. Still, a long way...

- Created a solid base for request. Now it's just a copy-paste, I hope.
- Only Album Methods implemented.
- Fixed the methods that uses authentication in album_methods.dart.
- Created first LastFM objects.
- Modified the example.
- Implemented a way to manage XML response.
- Added some documentation.

## 0.0.1

- Initial version. Created the Package's repo structure.
