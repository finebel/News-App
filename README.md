# News App

This App fetches the Top-Headlines for Germany from [News-API](https://newsapi.org/) and displays the articles through a `UITableView` to the user. 
The user can then select one of the articles to get a detail view with further information. Due to some restrictions of the used API, only the beginning of an articles content is displayed to the user. The full article can be read by visiting the linked website, which can be accessed during a `SFSafariViewController`.
In addition, the user can skip through articles by using the arrows in the upper right corner of the detail view.
Furthermore, articles can be marked as favorites. These articles are stored by using `UserDefaults` and they are displayed in the second tab.

## API-Key
To run the project it's required to register at [News-API](https://newsapi.org/) in order to receive your own API-Key.

## Screenshots

![screenshots](https://user-images.githubusercontent.com/46824694/111910667-a1bedb80-8a62-11eb-8da1-604a428f4bd5.png)
