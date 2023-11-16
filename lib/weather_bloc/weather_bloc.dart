import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather/weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/data/my_data.dart';

part 'weather_event.dart';

part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherBlocInitial()) {
    on<FetchWeather>((event, emit) async {
      // TODO: implement event handler
      emit(WeatherBlocLoading());
      try {
        WeatherFactory wf =
            new WeatherFactory(MY_API_KEY, language: Language.ENGLISH);

        // When we reach here, we have the permission to access the location.
        // continue accessing the position of the device
        Position position = await Geolocator.getCurrentPosition();
        Weather weather = await wf.currentWeatherByLocation(
            position.latitude, position.longitude);
        print(weather.areaName);
        emit(WeatherBlocSuccess(weather));
      } catch (e) {
        emit(WeatherBlocFailure());
      }
    });
  }
}
