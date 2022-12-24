import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/application/usecases/sync_transaction_usecase.dart';
import 'package:money_manager/domain/value_objects/user/value_objects.dart';
import 'package:money_manager/domain/value_objects/value_failure.dart';
import 'package:money_manager/infrastructure/repository/transaction_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../application/usecases/remove_all_transaction_usecase.dart';
import '../../../common/secure_storage.dart';
import '../../../infrastructure/repository/user_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository _userRepository;
  final SyncAllTransactionUseCase syncAllTransactionUseCase;
  final RemoveAllTransactionUseCase removeAllTransactionUseCase;

  AuthBloc(UserRepository userRepository, TransactionRepository transactionRepository)
      : _userRepository = userRepository,
        syncAllTransactionUseCase = SyncAllTransactionUseCase(transactionRepository: transactionRepository),
        removeAllTransactionUseCase = RemoveAllTransactionUseCase(transactionRepository: transactionRepository),
        super(AuthUnauthenticated(error:'')) {
    on<AuthInitialEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      if(prefs.getBool('pass')==true) {
        emit(AuthPassed());
        return;
      }
      SecureStorage secureStorage = SecureStorage();
      final hasToken = await secureStorage.hasToken();
      // print(hasToken);
      if (!hasToken) {
        emit(AuthUnauthenticated(error: ''));
        return;
      }
      if ((prefs.getBool("first_run"))!) {
        add(const SyncRemoteToLocal());
      } else {
        emit( AuthAuthenticated());
      }
    });
    on<SyncRemoteToLocal>((event, emit) async {
      emit(const AuthAuthenticated());
      await syncAllTransactionUseCase.executeRemoteToLocal();
    });
    on<SyncLocalToRemote>((event, emit) async {
      emit(const AuthAuthenticated());
      await syncAllTransactionUseCase.executeLocalToRemote();
    });
    on<RemoveLocal>((event, emit) async {
      // await removeAllTransactionUseCase.execute();
      add(const AuthInitialEvent());
    });
    on<AuthPass>((event, emit) async {
      emit(AuthPassed());
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('pass', true);
    });
    on<SignInEvent>((event, emit) async {
      // print('signin');
      emit(AuthLoading());
      Either<Failure,UserId> response = await _userRepository.signIn(email: event.email, password: event.password);
      if(response.isRight()) {
        await syncAllTransactionUseCase.executeLocalToRemote();
        await removeAllTransactionUseCase.execute();
        await syncAllTransactionUseCase.executeRemoteToLocal();
        emit(const AuthAuthenticated());
      }else{
        String message = response.fold((l) => l.message, (r) => 'null');
        emit(AuthUnauthenticated(error: message));
      }
    });
    on<SignUpEvent>((event, emit) async {
      // print('signup');
      emit(AuthLoading());
      Either<Failure,UserId> response = await _userRepository.signUp(email: event.email, password: event.password, name: event.name);
      debugPrint("RESPONSE ON SIGNUP EVENT BLOC: $response");
      if(response.isRight()) {
        add(SignInEvent(email: event.email, password: event.password));
      }else{
        String message = response.fold((l) => l.message, (r) => 'null');
        emit(AuthUnauthenticated(error: message));
      }
    });
  }
}
