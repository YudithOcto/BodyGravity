import 'package:bodygravity/data/auth/auth_repository.dart';
import 'package:bodygravity/ui/dashboard/bloc/dashboard_event.dart';
import 'package:bodygravity/ui/dashboard/bloc/dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final AuthRepository authRepository;
  LoadedState? _loadedState;

  DashboardBloc(this.authRepository) : super(DashboardInitialState()) {
    on<LoadDataEvent>((event, emit) async {
      emit(LoadingState());
      final profileResult = await authRepository.getProfile();
      if (profileResult.isSuccess == true) {
        _loadedState = LoadedState(profileResult.data!);
        emit(_loadedState!);
      } else {
        emit(ErrorState(
            message: profileResult.message ??
                "Telah Terjadi Kesalahan. Silahkan coba lagi."));
      }
    });
  }
}
