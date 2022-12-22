#  CrossSum

CrossSum is a math facts practice game.  It shows a grid of numbers separated by math operators and a target number.  
Your job is to find a math fact that equals the target number in the grid.

This was a project I was working on in 2018. It never became a real product, but there's a a lot in there that might be interesting for someone llooking for novel ways to deal with UIKit.

## Architecture

CrossSum is at its core an MVC app, but it uses several ideas that were floating around in Swift architecture back in 2018.  It's 100% programmatic UI, using a Router to determine which view controller to show at any given time.  View layout is not done in the view controller, but instead in custom UIView subclasses that vend their compoenents to their hosting view controllers.  Views implement a presenter protocol (not the same idea as Presenters in VIPER, but sort of inspired by it) that is called by client code.  The view controller's main responsibility becomes tying updates from the model into presenters in its views.

## Model layer

CrossSum implements a custom Rational data type in order to allow for fraction computations without losing precision.  A Statement type allows for very simple expression evaluation. Grids store the grid of numbers and operators that are shown on screen. A set of types allow for the creation of progressively harder Grids as the user finds more and more answers.
