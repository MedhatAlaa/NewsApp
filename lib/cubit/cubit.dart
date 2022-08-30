import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/components/dio_helper.dart';
import 'package:news/components/shared_helper.dart';
import 'package:news/cubit/states.dart';
import 'package:news/modules/business_screen.dart';
import 'package:news/modules/science_screen.dart';
import 'package:news/modules/sport_screen.dart';


class NewsCubit extends Cubit<NewsStates> {
  NewsCubit() : super(NewsInitialState());

  static NewsCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  void changeBottomNavBar(index) {
    currentIndex = index;
    emit(ChangeBottomNavBarState());
  }

  List screens = [
    const BusinessScreen(),
    const SportsScreen(),
    const ScienceScreen(),
  ];
  List<BottomNavigationBarItem> bottomNavigationBar = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.business),
      label: 'business',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.sports_baseball),
      label: 'sports',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.science_rounded),
      label: 'science',
    ),
  ];

  bool isDark = false;
  void changeAppMode({ bool? fromShared}) {
    if(fromShared!=null)
    {
      isDark=fromShared;
      emit(ChangeNewsAppModeState());
    }else
    {
      isDark = !isDark;
      CacheHelper.setBoolean(
        key: 'isDark',
        value: isDark,
      ).then((value) => {
        emit(ChangeNewsAppModeState()),
      });
    }
  }

  List business = [];

  void getBusiness() {
    DioHelper.getData(
      path: 'v2/top-headlines',
      query: {
        'country': 'eg',
        'category': 'business',
        'apiKey': 'dd8745ec8f2a46cbb9256997ffb9268d',
      },
    )
        .then((value) => {
              business = value.data['articles'],
              emit(NewsBusinessSuccessState()),
            })
        .catchError((error) {
      print('error is = ${error.toString()}');
      emit(NewsBusinessErrorState());
    });
  }

  List sports = [];

  void getSports() {
    DioHelper.getData(
      path: 'v2/top-headlines',
      query: {
        'country': 'eg',
        'category': 'sports',
        'apiKey': 'dd8745ec8f2a46cbb9256997ffb9268d',
      },
    )
        .then((value) => {
              sports = value.data['articles'],
              emit(NewsSportsSuccessState()),
            })
        .catchError((error) {
      print('error is = ${error.toString()}');
      emit(NewsSportsErrorState());
    });
  }

  List science = [];

  void getScience() {
    DioHelper.getData(
      path: 'v2/top-headlines',
      query: {
        'country': 'eg',
        'category': 'science',
        'apiKey': 'dd8745ec8f2a46cbb9256997ffb9268d',
      },
    )
        .then((value) => {
              science = value.data['articles'],
              emit(NewsScienceSuccessState()),
            })
        .catchError((error) {
      print('error is = ${error.toString()}');
      emit(NewsScienceErrorState());
    });
  }

  List search = [];

  void getSearch({required String value}) {
    DioHelper.getData(
      path: 'v2/everything',
      query: {
        'q': value,
        'apiKey': 'dd8745ec8f2a46cbb9256997ffb9268d',
      },
    )
        .then((value) => {
              search = value.data['articles'],
              emit(NewsSearchSuccessState()),
            })
        .catchError((error) {
      print('error is = ${error.toString()}');
      emit(NewsSearchErrorState());
    });
  }
}
