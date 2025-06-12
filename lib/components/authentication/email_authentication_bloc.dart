//Event
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app.dart';
import '../../utils/pref/pref_manager.dart';

abstract class EmailAuthEvent {}

class OnLoadEmailAuth extends EmailAuthEvent {}

class OnAuthenticationClicked extends EmailAuthEvent {
  final String email;
  final String password;
  OnAuthenticationClicked({required this.email, required this.password});
}

class OnResetLinkSent extends EmailAuthEvent {
  final String email;
  OnResetLinkSent({required this.email});
}

//State
abstract class EmailAuthState {}

class EmailAuthLoading extends EmailAuthState {}

class EmailAuthSuccess extends EmailAuthState {}

class EmailAuthLoaded extends EmailAuthState {}

class EmailAuthError extends EmailAuthState {
  final String errorMsg;
  EmailAuthError({required this.errorMsg});
}

class OnResetLinkProcessing extends EmailAuthState {}

//Bloc
class EmailAuthBloc extends Bloc<EmailAuthEvent, EmailAuthState> {
  EmailAuthBloc() : super(EmailAuthLoading()) {
    on<OnLoadEmailAuth>((event, emit) async {
      emit(EmailAuthLoaded());
    });
    on<OnAuthenticationClicked>((event, emit) async {
      emit(EmailAuthLoading());
      try {
        final auth = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: event.email, password: event.password);
        final user = auth.user;
        App.instance.userId = user!.uid;
        App.instance.token = (await user.getIdToken())!;
        //Set login true
        await PrefManager.db.init();
        await PrefManager.db.setIsLoggedIn(true);
        emit(EmailAuthSuccess());
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case 'user-disabled':
            {
              emit(EmailAuthError(errorMsg: 'User is disabled'));
              break;
            }
          case 'invalid-email':
            {
              emit(EmailAuthError(errorMsg: 'Invalid email'));
              break;
            }
          case 'invalid-credential':
            {
              emit(EmailAuthError(errorMsg: 'Invalid Credentials'));
              break;
            }
          case 'wrong-password':
            {
              emit(EmailAuthError(errorMsg: 'Invalid password'));
              break;
            }
          case 'user-not-found':
            {
              emit(EmailAuthError(errorMsg: 'Invalid email'));
              break;
            }
          default:
            {
              emit(
                EmailAuthError(errorMsg: 'Failed with error code: ${e.code}'),
              );
              break;
            }
        }
      }
    });

    on<OnResetLinkSent>((event, emit) async {
      String email = event.email;
      try {
        emit(EmailAuthLoading());
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        emit(EmailAuthLoaded());
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case 'user-disabled':
            {
              emit(EmailAuthError(errorMsg: 'User is disabled'));
              break;
            }
          case 'invalid-email':
            {
              emit(EmailAuthError(errorMsg: 'Invalid email'));
              break;
            }
          case 'invalid-credential':
            {
              emit(EmailAuthError(errorMsg: 'Invalid Credentials'));
              break;
            }
          case 'wrong-password':
            {
              emit(EmailAuthError(errorMsg: 'Invalid password'));
              break;
            }
          case 'user-not-found':
            {
              emit(EmailAuthError(errorMsg: 'Invalid email'));
              break;
            }
          default:
            {
              emit(
                EmailAuthError(errorMsg: 'Failed with error code: ${e.code}'),
              );
              break;
            }
        }
      }
    });
  }
}
