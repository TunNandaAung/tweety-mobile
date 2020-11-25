<p align="center"><img src="https://ik.imagekit.io/tunnandaaung/tweety-logo_JEwSguOGK.svg" width="300"></p>

# Tweety

Mobile app for [Tweety](https://github.com/TunNandaAung/tweety) written in Flutter.

## Screenshots (in dark mode)

|                                                Login Screen                                                 |                                                 Register Screen                                                  |                                                Tweets Screen                                                 |                                                  Explore Screen                                                  |                                                  Profile Screen                                                  |
| :---------------------------------------------------------------------------------------------------------: | :--------------------------------------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------------------------------: | :--------------------------------------------------------------------------------------------------------------: | :--------------------------------------------------------------------------------------------------------------: |
| ![Login Screen](https://ik.imagekit.io/tunnandaaung/tweety-mobile-screenshots/tweety-login_kWIthjPzKFI.png) | ![Register Screen](https://ik.imagekit.io/tunnandaaung/tweety-mobile-screenshots/tweety-register_44xfatrLBZ.png) | ![Tweets Screen](https://ik.imagekit.io/tunnandaaung/tweety-mobile-screenshots/tweety-tweets_8pVRKv2dVm.png) | ![Explore Screen](https://ik.imagekit.io/tunnandaaung/tweety-mobile-screenshots/tweety-explore_6QUuoWsQ9TL6.png) | ![Explore Screen](https://ik.imagekit.io/tunnandaaung/tweety-mobile-screenshots/tweety-explore_6QUuoWsQ9TL6.png) | ![Profile Screen](https://ik.imagekit.io/tunnandaaung/tweety-mobile-screenshots/tweety-profile_ki1kqpn3Po.png) |

|                                                   Publish Tweet/Reply Form                                                    |                                                    Mention Users                                                     |                                                  Nav Drawer                                                  |                                                      Account Settings Screen                                                      |                                                    Theme Settings Screen                                                     |
| :---------------------------------------------------------------------------------------------------------------------------: | :------------------------------------------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------------------------------------------: | :--------------------------------------------------------------------------------------------------------------------------: |
| ![Publish Tweet/Reply Form](https://ik.imagekit.io/tunnandaaung/tweety-mobile-screenshots/tweety-publish-tweet_pAHg0lOIv.png) | ![Mention Users](https://ik.imagekit.io/tunnandaaung/tweety-mobile-screenshots/tweety-menton-users_1HVtsEmhsgNK.png) | ![Nav Drawer](https://ik.imagekit.io/tunnandaaung/tweety-mobile-screenshots/tweety-nav-drawer_QtafIf5Y8.png) | ![Account Settings Screen](https://ik.imagekit.io/tunnandaaung/tweety-mobile-screenshots/tweet-account-settings_-NLiBymxRVal.png) | ![Theme Settings Screen](https://ik.imagekit.io/tunnandaaung/tweety-mobile-screenshots/tweety-theme-settings_Bnq6UXUhqJ.png) |

|                                                    Single Tweet Screen                                                     |                                                 User Search Result                                                 |                                            Edit Profile Screen                                             |                                                    Follow/Follower List Screen                                                    |                                                   Notificaitons Screen                                                    |
| :------------------------------------------------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------------------------------------: | :--------------------------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------------------------: |
| ![Single Tweet Screen](https://ik.imagekit.io/tunnandaaung/tweety-mobile-screenshots/single-tweet-screen_PgGXbu7pGnz5.png) | ![User Search Result](https://ik.imagekit.io/tunnandaaung/tweety-mobile-screenshots/search-result_3PZWnIGZ-WW.png) | ![Edit Profile](https://ik.imagekit.io/tunnandaaung/tweety-mobile-screenshots/edit-profile_LIPNGMkq3g.png) | ![Follow/Follower List Screen](https://ik.imagekit.io/tunnandaaung/tweety-mobile-screenshots/follow-follower-list_9OpruswVZg.png) | ![Notifications Screen](https://ik.imagekit.io/tunnandaaung/tweety-mobile-screenshots/notifications-screen_RcVW6E0tL.png) |

|                                                 Messages Screen                                                  |                                                 Chat Screen                                                  |                                                Empty Chat Screen                                                |
| :--------------------------------------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------------------------: |
| ![Messages Screen](https://ik.imagekit.io/tunnandaaung/tweety-mobile-screenshots/mesages-screen_oUt2zuGR8co.png) | ![Chat Screen](https://ik.imagekit.io/tunnandaaung/tweety-mobile-screenshots/mesages-screen_oUt2zuGR8co.png) | ![Empty Chat](https://ik.imagekit.io/tunnandaaung/tweety-mobile-screenshots/empty-chat-screen_hhNPjdfXn1LV.png) |

## Installation

### Prerequisites

- To run this project, you must have [Dart](https://dart.dev) Programming Language and [Flutter](https://flutter.dev) SDK installed in your machine.
- You must also set up the backend server for [Tweety](https://github.com/TunNandaAung/tweety). You can find the instructions [here](https://github.com/TunNandaAung/tweety).

### Step 1

- Begin by cloning this repository to your machine.
- To install dependencies, run this command in your terminal

```bash
flutter pub get
```

### Step 2

- Next, boot up a server and reference you localhost url in `lib/constants/api_constants.dart` file as below. For this, you can also user services like [Laravel Valet](https://laravel.com/docs/7.x/valet) or [Expose](https://beyondco.de/docs/expose) to get a shareable sites.

```properties
static const BASE_URL = 'YOUR_LOCALHOST_URL_OR_SHARED_SITES_URL/api';
```

### Realtime chat

For realtime chat, to use **_localhost url_** generated with `php artisan serve` (10.0.3.2 for Genymotion, 10.0.2.2 for official android emulator) because websocket port `6001` cannot be set up on **_Expose_** or **_Ngrok_**.

## Features

[All the features](https://github.com/TunNandaAung/tweety/#extended-functionalities) avaiable in web app are also available in mobile app.
