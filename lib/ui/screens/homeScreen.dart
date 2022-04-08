import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_permission/cubits/currentLocationCubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      context.read<CurrentLocationCubit>().getCurrentLocation();
    });
    super.initState();
  }

  void showSelectLocationDialog() {
    showDialog(
        context: context,
        builder: (_) => WillPopScope(
              onWillPop: () => Future.value(false),
              child: AlertDialog(
                title: const Text("Please select location"),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text("Enter you location manually"),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Delivery address"),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Madhapar")
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<CurrentLocationCubit, CurrentLocationState>(
        listener: (context, state) {
          if (state is CurrentLocationFetchSuccess) {
            print("Exectute other api calls based on current position");
          } else if (state is CurrentLocationFetchFailure) {
            showSelectLocationDialog();
          }
        },
        bloc: context.read<CurrentLocationCubit>(),
        builder: (context, state) {
          if (state is CurrentLocationInitial ||
              state is CurrentLocationFetchInProgress) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is CurrentLocationFetchFailure) {
            return Center(
              child: Text(state.errorMessage),
            );
          }
          final currentPosition = (state as CurrentLocationFetchSuccess);
          return Center(
              child: Text(
            "(${currentPosition.currentPosition.latitude},${currentPosition.currentPosition.longitude})",
            style: const TextStyle(fontSize: 20),
          ));
        },
      ),
    );
  }
}
