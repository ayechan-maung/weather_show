import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_show/src/bloc/search_weather_bloc/search_weather_cubit.dart';
import 'package:weather_show/src/views/search_detail_view.dart';


class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
      // IconButton(
      //     onPressed: () {
      //       context.read<SearchWeatherCubit>().searchWeather(query);
      //     },
      //     icon: const Icon(Icons.search)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
            ),
          )
        ],
      );
    }

    context.read<SearchWeatherCubit>().searchWeather(query);

    return BlocBuilder<SearchWeatherCubit, SearchWeatherState>(builder: (context, state) {
      print("Status in Search:: ${state.status}");

      switch (state.status) {
        case SearchWeatherStatus.initial:
          return Container();

        case SearchWeatherStatus.loading:
          return const Center(
            child: CircularProgressIndicator(),
          );

        case SearchWeatherStatus.success:
          if (state.searchResult!.isEmpty) {
            return const Center(
              child: Text('There is no result the city you search'),
            );
          }
          return ListView.builder(
              itemCount: state.searchResult!.length,
              itemBuilder: (context, index) {
                final weather = state.searchResult![index];
                return InkWell(
                  onTap: () {
                    // close(context, weather.name);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SearchDetailView(queryCity: weather.name ?? "")));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          weather.name ?? "",
                          style: const TextStyle(fontSize: 17),
                        ),
                        Text(
                          "(${weather.region}, ${weather.country})",
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                );
              });
        case SearchWeatherStatus.failure:
          return const Center(child: Text("Something went wrong!."));
      }
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
