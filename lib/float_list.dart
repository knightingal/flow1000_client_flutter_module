import 'package:blur/blur.dart';
import 'package:flutter/material.dart';

class FloadApp extends StatelessWidget {
  const FloadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Floating App Bar',
      home: Scaffold(
        // No app bar property provided yet.
        body: CustomScrollView(
          // Add the app bar and list of items as slivers in the next steps.
          slivers: [
            SliverAppBar(
              // Provide a standard title.
              title: Text('Floating App Bar'),
              // Pin the app bar when scrolling.
              pinned: true,
              // Display a placeholder widget to visualize the shrinking size.
              flexibleSpace: Placeholder(),
              // Make the initial height of the SliverAppBar larger than normal.
              expandedHeight: 200,
            ),
            SliverList.builder(
              // The builder function returns a ListTile with a title that
              // displays the index of the current item.
              itemBuilder:
                  (context, index) => ListTile(title: Text('Item #$index')),
              // Builds 50 ListTiles
              itemCount: 50,
            ),
          ],
        ),
      ),
    );
  }
}
