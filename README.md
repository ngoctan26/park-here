# Group Project - *ParkHere*

![Appicon](parkhere.png)

**ParkHere** is our solution for finding the most suitable parking zone based on user's location & user's criteria.

## User Stories

We support these following required functions at our first version (1.0):  

**REQUIRED**  

- [x] HOME screen
   - [x] Display a map with the user's current location as the central point.
   - [x] Display all the suitable parking zones that are around the central point.
   - [x] Support 4 quick filter options on the map directly: type of transport (in this version they are: bicycle, motorbike and car), the parking zone with the lowest fee, the parking zone that is nearest the central point and the parking zones that are still opening.
   - [x] Support selecting one parking zone by 2 ways: input the address into search textfield or choosing one parking zone on the map directly.
   - [x] Draw the route from the user's current location to one selected parking zone.
   - [x] Show the detail information of one parking zone under the popup form by clicking on the corresponding maker on the map.
   
- [x] COMMENT screen
   - [x] Display the selected parking zone on the mini map at the top.
   - [x] List all corresponding comments.
   - [x] Add new comments with text.
   - [x] Add rating. 
   - [x] Support commenting in anonymous mode (no need to login).
   - [x] Support commenting in login mode (login by Google account).
   
- [X] FILTER SETTING screen 
   - [X] Set the default distance.
   - [X] Set the default time frame.
   
- [X] ADD PARKING ZONE screen (login required)
   - [X] Add new parking zone.  

**OPTIONAL**  

The following **optional** features will be considered in the first version:

- [X] Support multilingual.
- [ ] Save filter history of user.
- [ ] Update status of the parking zone on real time (for i.e: now the parking zone is full filled).
- [ ] Support for more transport types (for i.e: truck).
- [ ] Change theme.
- [ ] Support social log-in with Facebook/Google account (the current signed in user will be persisted across restarts).
- [ ] Support adding photo (taking directly from camera phone or choosing one from gallery) to comment.
- [ ] Set the default expected range of fee.

## Core Flow & Main Wireframes

![Wireframe](doc/WireframeDemo.gif)

## Object Models  

Now we have a draft version [@here](https://github.com/ngoctan26/park-here/tree/master/src/ParkHere/ParkHere/Model)

## Video Walkthrough (Not Available Now)

Here's a walkthrough of implemented user stories:

![Video Walkthrough](http://i.imgur.com/2fRz3lj.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

## License

    Copyright 2017 DPT

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
