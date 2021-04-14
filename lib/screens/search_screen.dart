import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tweety_mobile/blocs/search/tweet_search/tweet_search_bloc.dart';
import 'package:tweety_mobile/blocs/search/user_search/user_search_bloc.dart';
import 'package:tweety_mobile/constants/constants.dart';
import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/preferences/preferences.dart';
import 'package:tweety_mobile/widgets/loading_indicator.dart';
import 'package:tweety_mobile/widgets/cards/tweet_card.dart';
import 'package:tweety_mobile/widgets/cards/user_card.dart';

class SearchScreen extends SearchDelegate<User> {
  final Bloc<UserSearchEvent, UserSearchState> userSearchBloc;
  final Bloc<TweetSearchEvent, TweetSearchState> tweetSearchBloc;

  SearchScreen(this.userSearchBloc, this.tweetSearchBloc);

  List<String> recentSearches =
      Prefer.prefs.getStringList("recent_searches") ?? [];

  String searchType = 'user';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return theme.copyWith(
      primaryColor: Theme.of(context).cardColor,
      primaryIconTheme: Theme.of(context).appBarTheme.iconTheme,
      primaryColorBrightness: Brightness.light,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Theme.of(context).textSelectionTheme.cursorColor,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Theme.of(context).textSelectionTheme.cursorColor,
        hintStyle: TextStyle(color: Colors.grey[400]),
        suffixStyle: TextStyle(fontSize: 18.0),
      ),
    );
  }

  @override
  String get searchFieldLabel => 'Search tweety...';

  @override
  List<Widget> buildActions(BuildContext context) {
    // action for app bar
    return [
      Padding(
        padding: EdgeInsets.only(right: 10.0),
        child: SizedBox(
          width: 25.0,
          child: RawMaterialButton(
              shape: CircleBorder(),
              elevation: 1.0,
              fillColor: Color(0xFF4A5568),
              child: Icon(Icons.clear, color: Colors.white, size: 20.0),
              onPressed: () {
                query = '';
              }),
        ),
      ),
      StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return PopupMenuButton<String>(
          icon: Icon(
            Icons.sort,
            color: Theme.of(context).appBarTheme.iconTheme.color,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          color: Theme.of(context).popupMenuTheme.color,
          onSelected: (type) {
            setState(() {
              searchType = type.toLowerCase();
            });
          },
          itemBuilder: (BuildContext context) {
            return Constants.searchTypes.map((String type) {
              return PopupMenuItem<String>(
                value: type,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      type,
                    ),
                    searchType == type.toLowerCase()
                        ? Icon(Icons.check)
                        : SizedBox(width: 0.0)
                  ],
                ),
              );
            }).toList();
          },
        );
      }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: BackButtonIcon(),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    searchType == 'user'
        ? userSearchBloc.add(UserSearchEvent(query))
        : tweetSearchBloc.add(TweetSearchEvent(query));

    return searchType == 'user' ? userResults() : tweetResults();
  }

  Widget userResults() {
    return BlocBuilder(
      bloc: userSearchBloc,
      builder: (BuildContext context, UserSearchState state) {
        if (state.isLoading) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  searchType == 'user'
                      ? 'Searching for users...'
                      : 'Searching for tweets..',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Center(
                child: LoadingIndicator(),
              ),
            ],
          );
        }
        if (state.hasError) {
          return Center(
            child: Container(
              child: Text('Error', style: TextStyle(color: Colors.red)),
            ),
          );
        }
        return state.users.length > 0
            ? Padding(
                padding: EdgeInsets.all(12.0),
                child: ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, counter) {
                    return SizedBox(height: 0.0);
                  },
                  itemBuilder: (context, index) =>
                      UserCard(user: state.users[index]),
                  itemCount: state.users.length,
                ),
              )
            : Center(
                child: Container(
                  child: Text(
                    'No result match your search.',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              );
      },
    );
  }

  Widget tweetResults() {
    return BlocBuilder(
      bloc: tweetSearchBloc,
      builder: (BuildContext context, TweetSearchState state) {
        if (state.isLoading) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  searchType == 'user'
                      ? 'Searching for users...'
                      : 'Searching for tweets..',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Center(
                child: LoadingIndicator(),
              ),
            ],
          );
        }
        if (state.hasError) {
          return Center(
            child: Container(
              child: Text('Error', style: TextStyle(color: Colors.red)),
            ),
          );
        }
        return state.tweets.length > 0
            ? Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 5.0,
                ),
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 5.0,
                  ),
                  shrinkWrap: true,
                  separatorBuilder: (context, counter) {
                    return SizedBox(height: 10.0);
                  },
                  itemBuilder: (context, index) =>
                      TweetCard(tweet: state.tweets[index]),
                  itemCount: state.tweets.length,
                ),
              )
            : Center(
                child: Container(
                  child: Text(
                    'No result match your search.',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              );
      },
    );
  }
  // @override
  // Widget buildSuggestions(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty && searchType == 'user') {
      userSearchBloc.add(UserSearchEvent(query));
    }

    return BlocBuilder(
      bloc: userSearchBloc,
      builder: (BuildContext context, UserSearchState state) {
        if (state.isLoading) {
          return Center(
            child: LoadingIndicator(),
          );
        }
        if (state.hasError) {
          return Center(
            child: Container(
              child: Text(
                'Error',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          );
        }

        if (recentSearches.length > 0 && query.isEmpty) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: EdgeInsets.all(12.0),
                child: Container(
                  height: double.infinity,
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Recent Searches',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 21.0,
                              letterSpacing: 1.0,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              await Prefer.prefs
                                  .setStringList('recent_searches', []);
                              setState(() {
                                print("CALLED");
                                recentSearches = [];
                              });
                              print(recentSearches.length);
                            },
                            child: Container(
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                color: Color(0xFF4A5568),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Text(
                                'Clear',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.separated(
                          separatorBuilder: (context, counter) {
                            return SizedBox(
                              height: 0.0,
                            );
                          },
                          itemBuilder: (context, index) => ListTile(
                            onTap: () {
                              query = recentSearches[index];

                              searchType == 'user'
                                  ? userSearchBloc.add(
                                      UserSearchEvent(recentSearches[index]))
                                  : tweetSearchBloc.add(
                                      TweetSearchEvent(recentSearches[index]));
                            },
                            title: RichText(
                              text: TextSpan(
                                  text: recentSearches[index],
                                  style: Theme.of(context).textTheme.bodyText2),
                            ),
                          ),
                          itemCount: recentSearches?.length,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        var suggestionList = state.users
            .where((p) =>
                p.name.toLowerCase().startsWith(query.toLowerCase()) ||
                p.username.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

        return searchType == 'user'
            ? Padding(
                padding: EdgeInsets.all(12.0),
                child: Container(
                  height: double.infinity,
                  color: Colors.transparent,
                  child: ListView.separated(
                    separatorBuilder: (context, counter) {
                      return SizedBox(height: 10.0);
                    },
                    itemBuilder: (context, index) => Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context).canvasColor,
                                offset: Offset(0, 10),
                                blurRadius: 10.0),
                          ]),
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed('/profile',
                              arguments: suggestionList[index]);
                        },
                        title: RichText(
                          text: TextSpan(
                              text: suggestionList[index]
                                  .name
                                  .substring(0, query.length),
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context)
                                    .textSelectionTheme
                                    .cursorColor,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: suggestionList[index]
                                      .name
                                      .substring(query.length),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black26,
                                  ),
                                )
                              ]),
                        ),
                        subtitle: RichText(
                          text: TextSpan(
                              text: '@' +
                                  suggestionList[index]
                                      .username
                                      .substring(0, query.length),
                              style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context)
                                    .textSelectionTheme
                                    .cursorColor,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: suggestionList[index]
                                      .username
                                      .substring(query.length),
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black26,
                                  ),
                                )
                              ]),
                        ),
                      ),
                    ),
                    itemCount: suggestionList.length,
                  ),
                ),
              )
            : Container();
      },
    );
  }
}
