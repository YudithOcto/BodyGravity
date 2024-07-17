import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {}

class LoadSearchEvent extends SearchEvent {
  final String? query;
  LoadSearchEvent({this.query});
  @override
  List<Object?> get props => [query];
}

class InitialLoadEvent extends SearchEvent {
  @override
  List<Object?> get props => [];
}
