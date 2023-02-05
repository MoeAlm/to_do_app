import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/shared/cubit/states.dart';
import 'package:intl/intl.dart';
import '../shared/cubit/cubit.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'drawer.dart';

class HomeLayout extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final timeController = TextEditingController();
  final dateController = TextEditingController();

  HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.blue),
              title: Text(
                cubit.titles[cubit.currentIndex],
                style: const TextStyle(color: Colors.blue),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0.0,
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                      title: titleController.text,
                      date: dateController.text,
                      time: timeController.text,
                    );
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        elevation: 10.0,
                        (context) => Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: TextFormField(
                                  controller: titleController,
                                  keyboardType: TextInputType.text,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'title must not be empty';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                              width: 1.0, color: Colors.blue)),
                                      labelText: 'Task Title',
                                      prefix: const Icon(Icons.title)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: TextFormField(
                                  controller: timeController,
                                  keyboardType: TextInputType.datetime,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'time must not be empty';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                            width: 1.0, color: Colors.blue)),
                                    labelText: 'Task Time',
                                    prefix: const Padding(
                                      padding: EdgeInsets.only(
                                          bottom: 8.0, right: 8.0),
                                      //EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.watch_later_outlined,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      timeController.text =
                                          value!.format(context).toString();
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: TextFormField(
                                  controller: dateController,
                                  keyboardType: TextInputType.datetime,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'date must not be empty';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                            width: 1.0, color: Colors.blue),
                                    ),
                                    labelText: 'Task Date',
                                    prefix: const Padding(
                                      padding: EdgeInsets.only(
                                          bottom: 8.0, right: 8.0),
                                      child: Icon(
                                        Icons.calendar_month,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime.parse('2050-12-31'),
                                    ).then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                        isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (BuildContext context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => const Center(child: CircularProgressIndicator(),),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.task_alt), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: 'Archive'),
              ],
              onTap: (index) {

                cubit.changeIndex(index);
              },
              currentIndex: cubit.currentIndex,
            ),
            drawer: const MyDrawer(),
          );
        },
      ),
    );
  }
}