import 'package:core/core.dart';
import 'package:example/views/view_home/home_view_model.dart';
import 'package:example/views/view_home/module/events.dart';
import 'package:example/views/view_home/module/states.dart';
import 'package:flutter/material.dart';

class HomeView
    extends MasterView<HomeViewModel, HomeViewEvents, HomeViewStates> {
  HomeView({super.key, super.appBar, super.arguments, super.currentView});

  @override
  void initialContent(HomeViewModel viewModel, BuildContext context) {
    // Trigger the initial event to set up the view model
    viewModel.add(HomeViewInitialEvent());
  }

  // Builds the card for the maintenance view
  Widget _buildMaintenanceCard() {
    debugPrint("Current view: Maintenance");
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text("Maintenance", style: TextStyle(fontSize: 24)),
      ),
    );
  }

  // Builds the card for the content view, displaying title and description
  Widget _buildContentCard(BuildContext context) {
    debugPrint("Current view: Content");
    return SizedBox(
      width: MediaQuery.of(context).size.width *
          0.5, // Set card width to 70% of screen width
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.rocket_launch, size: 24), // Rocket icon
                  SizedBox(width: 8), // Space between icon and text
                  Text(arguments["cardType"], style: TextStyle(fontSize: 24)),
                ],
              ),
              SizedBox(height: 8), // Space between divider and description
              Text(arguments["description"]),
            ],
          ),
        ),
      ),
    );
  }

  // Builds the card for the default view
  Widget _buildDefaultCard() {
    debugPrint("Current view: Default");
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text("Default", style: TextStyle(fontSize: 24)),
      ),
    );
  }

  @override
  Widget viewContent(
      BuildContext context, HomeViewModel viewModel, HomeViewStates state) {
    List<Widget> contentWidgets = [];

    // Determine which card to display based on the current view type
    switch (currentView) {
      case MasterViewTypes.maintenance:
        contentWidgets.add(_buildMaintenanceCard());
        break;
      case MasterViewTypes.content:
        contentWidgets.add(_buildContentCard(context));
        break;
      default:
        contentWidgets.add(_buildDefaultCard());
        break;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...contentWidgets,
          TextButton(
              onPressed: () {
                navigateTo(context, "/"); // Navigate to the splash screen
              },
              child: Text("Navigate to Splash")),
        ],
      ),
    );
  }
}
