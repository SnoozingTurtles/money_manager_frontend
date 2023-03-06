import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/application/usecases/sync_transaction_usecase.dart';
import 'package:money_manager/domain/value_objects/user/value_objects.dart';
import 'package:money_manager/domain/value_objects/value_failure.dart';
import 'package:money_manager/infrastructure/repository/transaction_repository.dart';

import '../../../application/usecases/remove_all_transaction_usecase.dart';
import '../../../infrastructure/repository/user_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository _userRepository;
  final SyncAllTransactionUseCase syncAllTransactionUseCase;
  final RemoveAllTransactionUseCase removeAllTransactionUseCase;

  AuthBloc({required UserRepository userRepository,required TransactionRepository transactionRepository})
      : _userRepository = userRepository,
        syncAllTransactionUseCase = SyncAllTransactionUseCase(transactionRepository: transactionRepository),
        removeAllTransactionUseCase = RemoveAllTransactionUseCase(transactionRepository: transactionRepository),
        super(const AuthUnauthenticated(error:'')) {

    on<SyncRemoteToLocal>((event, emit) async {
      await syncAllTransactionUseCase.executeRemoteToLocal();
      emit(AuthAuthenticated(remoteId: event.remoteId));
    });
    on<SyncLocalToRemote>((event, emit) async {
      await syncAllTransactionUseCase.executeLocalToRemote();
      emit(AuthAuthenticated(remoteId: event.remoteId));
    });
    on<RemoveLocal>((event, emit) async {
      // await removeAllTransactionUseCase.execute();
      // add(const AuthInitialEvent());
    });
    on<SignInEvent>((event, emit) async {
      // print('signin');
      emit(AuthLoading());
      Either<Failure,UserId> response = await _userRepository.signIn(email: event.email, password: event.password);
      if(response.isRight()) {
        var id = response.fold((l) => null, (r) => r);
        debugPrint(id!.toString());
        await syncAllTransactionUseCase.executeLocalToRemote(remoteId: id);
        await removeAllTransactionUseCase.execute();
        await syncAllTransactionUseCase.executeRemoteToLocal(remoteId: id);
        emit(AuthAuthenticated(remoteId: id));
      }else{
        String message = response.fold((l) => l.message??"Error Occurred", (r) => 'null');
        emit(AuthUnauthenticated(error: message));
      }
    });
    on<SignUpEvent>((event, emit) async {
      emit(AuthLoading());
      Either<Failure,UserId> response = await _userRepository.signUp(email: event.email, password: event.password, name: event.name);
      if(response.isRight()) {
        add(SignInEvent(email: event.email, password: event.password));
      }else{
        String message = response.fold((l) => l.message??"Error Occurred", (r) => 'null');
        emit(AuthUnauthenticated(error: message));
      }
    });
  }
}
