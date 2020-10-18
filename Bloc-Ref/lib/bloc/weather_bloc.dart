import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_cubit_bloc_tutorial/data/model/weather.dart';
import 'package:flutter_cubit_bloc_tutorial/data/weather_repository.dart';
import 'package:meta/meta.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc(this._weatherRepository) : super(WeatherInitial());

  final WeatherRepository _weatherRepository;

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    if (event is GetWeather) {
      try {
        emit(WeatherLoading());
        final weather = await _weatherRepository.fetchWeather(event.cityName);
        emit(WeatherLoaded(weather));
      } catch (e) {
        emit(WeatherError("Kya Bhai"));
      }
    }
  }
}
