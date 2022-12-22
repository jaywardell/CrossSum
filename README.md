#  CrossSum

<img src="https://raw.githubusercontent.com/jaywardell/CrossSum/master/CrossSum/Assets.xcassets/AppIcon.appiconset/icon.png" alt="icon"/ width=256 height=256>

CrossSum is a math facts practice game.  It shows a grid of numbers separated by math operators.  Your job is to find a math fact in the grid that equals the target number at the top of the screen before time runs out. 

The longer it takes you to find an expression, the fewer points it's worth. If you find the expression quickly, your time gets passed on to the next try.  When you find all the target numbers on one grid, you're presented with a new grid that's harder than the last. 

Exactly how the new grid is harder is randomly determined to be different every time. Sometimes it uses larger numbers. Sometimes it adds new operators. Sometimes it adds negative numbers or fractions. Sometimes more numbers are added to the grid.

This was a project I was working on in 2018. It never became a real product, but there's a lot in it that might be interesting to someone looking for novel ways to work with UIKit, especially in a game.

<img src="https://github.com/jaywardell/CrossSum/raw/master/promotional/screenshots/example.png" alt="screenshot" width=295 height=639 />

## Architecture

CrossSum is at its core an MVC app written with protocol-driven-development, but it uses several ideas that were floating around in Swift architecture back in 2018.  It's 100% programmatic UI, using a Router to determine which view controller to show at any given time.  View layout is not done in the view controller, but instead in custom UIView subclasses that vend their compoenents to their hosting view controllers.  Views implement a presenter protocol (not the same idea as Presenters in VIPER, but sort of inspired by it) that is called by client code.  The view controller's main responsibility becomes tying updates from the model to presenters in its views.

## Model layer

CrossSum implements a custom `Rational` data type in order to allow for fraction computations without losing precision.  A `Statement` type allows for very simple expression evaluation. A `RationalParser` translates a given string into a `Rational`. 

A `Grid` stores the grid of numbers and operators that are shown on screen. A set of types allow for the creation of progressively harder Grids as the user finds more and more answers. A `TimeKeeper` type and `HighScore` type wrap basic gameplay logic.  

A single `Game` object is created each time the user starts a new game and handles most game play business logic.

## View Layer

The most interesting view in the app is `GamePlayView`, which contains all the controls and labels that are used in the game.  `GamePlayView` inherits from `FlexibleLayoutView`, a `UIView` subclass that keeps track of the layout of the screen (portrait or landscape, iPad or iPhone, etc.) and chooses based on that which autolayout constraints to use. GamePlayView also vends its subviews as properties to be used by client code.

`ExpressionChooserView` presents the grid to the user and handles user selection of the grid.

Several other UIView subclasses support specific domains, like tallying the number of hints left to the user.

## Presenters

CrossSum uses presenters to present the data in the model layer to the view layer.  There are multiple presenter protocols, usually with just one method: `present(someType:)`. Views implement the protocol in the way most appropriate to their role. For example, a UILabel can implement `TextPresenter` to set its text property. Other presenters are implemented as separate structs that alter the properties of objects they refer to based on various criteria, or combine other presenters in unique ways.  Model objects, like the `Game` class, contain properties that are typed to specific presenter protocols. They then call the given properties' `present()` methods when appropriate.


## View Controller Layer
 A key job of the view controller is to connect the appropriate presenter in its model to its own views. It also ties actions attached to views to methods on the model.
 
 
 ## User Interface
 
 The layout of the app is defined by the grid, which makes up most of the screen.  The game supports portrait and landscape layouts on iPhone and iPad.
 
 The feel of the game is meant to be stark and serious.  A black background and neon accent color are meant to give a throwback, arcade-style appearance.  A custom serif font reinforces this feeling. 
 
 
