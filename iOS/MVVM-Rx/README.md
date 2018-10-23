# MVVM-Rx

An iOS sample project showcasing 2 structured reactive programming approaches using ReactiveX.

[](media/mvvm.png)

## Background
* A ViewModel...
  * takes a central role in the architecture: It takes care of the business logic and talks to both the model and the view.
  * should follow a clear Input -> Output pattern for proper testing of predefined inputs and expected outputs
  * should be pluggable to any View (remember: View does not stand for ViewController)
  * is completely separated from the presentation layer and, when necessary, can be re-used between platforms
* it is not the way a View is built that is going to define the public contract of a ViewModel
* it’s the View that owns the ViewModel, meaning; the View is aware of the ViewModel, not the other way around

## Approaches

### 1: Continuous input feeding: subjects and observables
* Explain this boy ...

### 2: Single input -> output transformation: observables
* Explain this boy ...
