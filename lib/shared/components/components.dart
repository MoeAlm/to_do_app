import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';

Widget buildTaskItem(Map model, context) {
  return Dismissible(
    key: Key(model['id'].toString()),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.blue[400],
                borderRadius: BorderRadius.circular(15)),
            child: Expanded(
              child: Card(
                color: Colors.transparent,
                elevation: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${model['title']}',
                      style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Time:',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text('${model['time']}',
                            style: const TextStyle(
                                fontSize: 15, color: Colors.white)),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text('Date:',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        const SizedBox(
                          width: 5,
                        ),
                        Text('${model['date']}',
                            style: const TextStyle(
                                fontSize: 15, color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    AppCubit.get(context)
                        .updateData(status: 'done', id: model['id']);
                  },
                  icon: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.blue,
                  )),
              IconButton(
                  onPressed: () {
                    AppCubit.get(context)
                        .updateData(status: 'archive', id: model['id']);
                  },
                  icon: const Icon(
                    Icons.archive_outlined,
                    color: Colors.blue,
                  )),
            ],
          ),
        ],
      ),
    ),
    onDismissed: (direction) {
      AppCubit.get(context).deleteData(id: model['id']);
    },
  );
}

Widget tasksBuilder({
  required List<Map> tasks,
}) {
  return ConditionalBuilder(
    condition: tasks.length > 0,
    builder: (BuildContext context) => ListView.separated(
        itemBuilder: (context, index) =>
            buildTaskItem(tasks[index], context),
        separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsetsDirectional.only(
                  start: 20.0, end: 20.00),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
            ),
        itemCount: tasks.length),
    fallback: (BuildContext context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.menu,
            color: Colors.grey,
            size: 35,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'No Tasks Yet, Please Add Some Task!',
            style: TextStyle(color: Colors.grey, fontSize: 20),
          )
        ],
      ),
    ),
  );
}
