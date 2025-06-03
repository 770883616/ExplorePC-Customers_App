import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:flutter/material.dart';

class Mystar extends StatefulWidget {
  Mystar({super.key, required this.rating});
  final double rating;
  @override
  State<Mystar> createState() => _MystarState();
}

class _MystarState extends State<Mystar> {
  double get rating => widget.rating;

  @override
  Widget build(BuildContext context) {
    return AnimatedRatingStars(
      initialRating: rating,
      minRating: 0.0,
      maxRating: 5.0,
      filledColor: Colors.amber,
      emptyColor: Colors.grey,
      filledIcon: Icons.star,
      halfFilledIcon: Icons.star_half,
      emptyIcon: Icons.star_border,
      onChanged: (double rating) {
        // Handle the rating change here
        print('Rating: $rating');
      },
      displayRatingValue: true,
      interactiveTooltips: true,
      customFilledIcon: Icons.star,
      customHalfFilledIcon: Icons.star_half,
      customEmptyIcon: Icons.star_border,
      starSize: 10.0,
      animationDuration: Duration(milliseconds: 300),
      animationCurve: Curves.easeInOut,
      readOnly: false,
    );
  }
}
