import 'package:bloc/bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    print('onEvent $event');
    super.onEvent(bloc, event);
  }

  @override
  onTransition(Bloc bloc, Transition transition) {
    print('onTransition $transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase cubit, Object error, StackTrace stackTrace) {
    print('onErroe $error');
    super.onError(cubit, error, stackTrace);
  }
}
