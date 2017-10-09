# Project 4 - *TwitterLite*

Time spent: **18.5** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] Hamburger menu
   - [x] Dragging anywhere in the view should reveal the menu.
   - [x] The menu should include links to your profile, the home timeline, and the mentions view.
   - [x] The menu can look similar to the example or feel free to take liberty with the UI.
- [x] Profile page
   - [x] Contains the user header view
   - [x] Contains a section with the users basic stats: # tweets, # following, # followers
- [x] Home Timeline
   - [x] Tapping on a user image should bring up that user's profile page

The following **optional** features are implemented:

- [ ] Profile Page
   - [ ] Implement the paging view for the user description.
   - [ ] As the paging view moves, increase the opacity of the background screen. See the actual Twitter app for this effect
   - [x] Pulling down the profile page should blur and resize the header image.
- [ ] Account switching
   - [ ] Long press on tab bar to bring up Account view with animation
   - [ ] Tap account to switch to
   - [ ] Include a plus button to Add an Account
   - [ ] Swipe to delete an account


The following **additional** features are implemented:

- [x] Opening the hamburger menu disables the content view. You can tap or drag to close menu
- [x] Dragging/Opening/Closing the content view to reveal the hamburger menu has animation to gray out the content view.
- [x] When the hamburger menu is open, the content view is disabled. It can be closed by tapping anywhere in the content view
- [x] Dragging/Opening/Closing the content view will animate certain things. For example on the timelines the profile image icon will slowly disappear as the menu opens
- [x] Scrolling on the profile page will animate the user profile image and appear to slide under the banner image. Scrolling down will reverse the effect
- [x] Added a custom back button to the profile page
- [x] When the name goes under the banner, a new one will show up in the banner. Same effect as in the real app.


Features carried over from last project:
- [x] Favorite and retweet icon animations
- [x] Retweet opens a confirmation action sheet like in the real app
- [x] Trying to leave the compose tweet view will prompt the user if the tweet isn't empty
- [x] Tweet character count changes as you type. Turns red when there are 20 characters or less remaining
- [x] Tweet button is disabled when text is empty or over 140 characters

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

  1. Some of the animations in modern iOS apps are really slick, but they seem really difficult to implement without some type of tool to help. Is there such a tool? Or are there any great resources to learn more about animations?
  2. I think it would be worth while to spend some time to discuss how we can architect this app so that it has more reusable components? Like there's a small profile card in the hamburger menu, and a larger version exists on the profile page. Is there anyway to share code between those to UI views?
  3. With the addition of the profile page, there are many places a user can interact with Tweets. How can we effectively manage messaging between multiple layers of view controllers?  Like if I went home timeline -> New York Times profile -> like or retweet something from their profile page -> go back to home timeline and have it show up as liked


## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='https://i.imgur.com/9dLAeXY.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Animations are really fun to make and can make the app look really well polished, but they are also hard to get right sometimes.

## License

    Copyright [2017] [Wuming Xie]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
