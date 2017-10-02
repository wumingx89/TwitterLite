# Project 3 - *TwitterLite*

**TwitterLite** is a basic twitter app to read and compose tweets from the [Twitter API](https://apps.twitter.com/).

Time spent: **20** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign in using OAuth login flow.
- [x] User can view last 20 tweets from their home timeline.
- [x] The current signed in user will be persisted across restarts.
- [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.  In other words, design the custom cell with the proper Auto Layout settings.  You will also need to augment the model classes.
- [x] User can pull to refresh.
- [x] User can compose a new tweet by tapping on a compose button.
- [x] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.

The following **optional** features are implemented:

- [x] When composing, you should have a countdown in the upper right for the tweet limit. (Although I moved this to be above the keyboard)
- [x] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [x] Retweeting and favoriting should increment the retweet and favorite count.
- [x] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [x] Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
- [x] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

The following **additional** features are implemented:

- [x] Using SwiftyJSON for easier json deserialization
- [x] Added loading hud to home timeline view
- [x] If the user is typing a tweet and hits cancel, app will prompt user to confirm exiting
- [x] The character countdown while tweeting changes to red when there are 20 or less characters left, like in the real Twitter app.
- [x] Retweeting and favoriting animations, similar to what's in the real app
- [x] Retweeting will show an action sheet similar to what's in the real app
- [x] Added app icon and launch screen image


Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Both the tweet cell and the tweet detail views allow the user to reply/retweet/favorite a tweet. So there seems to be a lot of shared functionality. I'm wondering if there's a good way to reuse code here?
2. I'm interested in learning more about how to embed video playback/images into table view cell.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='https://i.imgur.com/4VOolRE.gif' title='Login/Logout' width='' alt='Login/Logout' />

<img src='https://i.imgur.com/qFS5Qav.gif' title='Tweet Details' alt='Tweet Details' />

<img src='https://i.imgur.com/v6Q8pZB.gif' title='Compose Tweet' alt='Compose Tweet' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

For me, some of the difficulties surrounding this project was the inconsistencies of the Twitter API itself. And the shear size of the responses made it somewhat hard to find/debug certain things. Other than that, I also spent some time thinking about how best to share functionality between different views (ie: retweeting, and favoriting). I'm not sure if the solution I came up with is the best way to do it.

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
