import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:print_system/controller/blocs/user_cubit/user_cubit.dart';
import 'package:print_system/model/person/Splash_model.dart';
import 'package:print_system/model/person/admin.dart';
import 'package:print_system/model/person/person.dart';
import 'package:print_system/model/person/release_station.dart';
import 'package:print_system/model/person/user.dart';
import 'package:print_system/view/components/app_theme.dart';

import 'controller/blocs/admin_cubit/admin_cubit.dart';
import 'controller/blocs/observer.dart';
import 'model/shared_preferences/shared_preferences.dart';

late int? personId;
late String type = "";
late bool? onBoarding;

String findPersonType(int? id) {
  if (id != null) {
    if (id > 0 && id < 100) {
      return "admin";
    } else if (id > 99 && id < 200) {
      return "user";
    } else {
      return "release_man";
    }
  } else {
    return "";
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CachHelper.inti();
  //late Widget widget;
   Person ?person;
   MainScrean ?mainScrean;
  personId = CachHelper.getData(key: "pid");
  onBoarding = CachHelper.getData(key: 'boarding');
  type = findPersonType(personId);
  if (onBoarding != null) {
    if (personId != null) {
      if (type == "admin") {
        person=Admin("", 0, 0, "");
        //widget = const AdminMainScreen();
      } else if (type == "user") {
        person=User("", 0, 0, "", 0, 0);
        //widget = const UserMainScreen();
      } else if (type == "release_man") {
        //widget = const ReleaseManScreen();
        person=ReleaseMan("", 0, 0, "");
      } else {
        //widget = LoginScreen();
        person=Person("", 0, 0, "");
      }
    } else {
      person=Person("", 0, 0, "");
      //widget = LoginScreen();
    }
  } else {
    mainScrean=SplashModel();
    //widget = const SplashScreen();
  }

  BlocOverrides.runZoned(() {
    runApp(AppRoot(
      widget:person!=null? person.getMainScrean():mainScrean!.getMainScrean(),
    ));
  }, blocObserver: MyBlocObserver());
}

class AppRoot extends StatelessWidget {
  final Widget widget;
  const AppRoot({Key? key, required this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AdminCubit>(
          create: (context) => AdminCubit()..createDataBase(),
        ),
        BlocProvider<UserCubit>(
          create: (context) => UserCubit()..createDataBase(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: LightTheme,
        home: widget,
      ),
    );
  }
}
