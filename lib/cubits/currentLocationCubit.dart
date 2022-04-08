import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_permission/data/locationRepository.dart';

abstract class CurrentLocationState {}

class CurrentLocationInitial extends CurrentLocationState {}

class CurrentLocationFetchInProgress extends CurrentLocationState {}

class CurrentLocationFetchSuccess extends CurrentLocationState {
  final Position currentPosition;

  CurrentLocationFetchSuccess(this.currentPosition);
}

class CurrentLocationFetchFailure extends CurrentLocationState {
  final String errorMessage;

  CurrentLocationFetchFailure(this.errorMessage);
}

class CurrentLocationCubit extends Cubit<CurrentLocationState> {
  late final LocationRepository locationRepository;
  CurrentLocationCubit() : super(CurrentLocationInitial()) {
    locationRepository = LocationRepository();
  }

  void getCurrentLocation() {
    emit(CurrentLocationFetchInProgress());

    locationRepository.getCurrentLocation().then((value) {
      emit(CurrentLocationFetchSuccess(value));
    }).catchError((e) {
      emit(CurrentLocationFetchFailure(e.toString()));
    });
  }
}
