import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/constants/constants.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/viewmodel/tasks_viewmodel.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondary,
      appBar: AppBar(
        title: const Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.check,
                size: 20,
                color: primary,
              ),
            ),
            SizedBox(width: 10),
            Text(
              'To Do List',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: primary,
      ),
      body: Consumer<TaskViewModel>(
        builder: (context, taskProvider, _) {
          return ListView.separated(
            itemBuilder: (context, index) {
              final task = taskProvider.tasks[index];
              return _taskWidget(task, context, index);
            },
            separatorBuilder: (context, index) {
              return const Divider(
                color: primary,
                height: 1,
                thickness: 1,
              );
            },
            itemCount: taskProvider.tasks.length,
          );
        },
      ),
      floatingActionButton: _customFAB(context),
    );
  }

  Widget _taskWidget(Task task, BuildContext context, int index) {
    final taskProvider = Provider.of<TaskViewModel>(context, listen: false);

    return Dismissible(
      key: UniqueKey(), // Sử dụng UniqueKey để đảm bảo khóa duy nhất
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red, // Màu nền khi vuốt
        child: const Icon(Icons.delete, color: Colors.white), // Icon hiển thị khi vuốt
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
      ),
      onDismissed: (direction) {
        // Xóa task khi item bị vuốt
        taskProvider.deleteTask(index);
        // Hiển thị thông báo
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${task.taskName} has been deleted!')),
        );
      },
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        title: Text(
          task.taskName,
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${task.date}, ${task.time}',
          style: TextStyle(color: textBlue),
        ),
      ),
    );
  }

  Widget _customFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return _customDialog(context);
            });
      },
      child: const Icon(
        Icons.add,
        size: 40,
      ),
    );
  }

  Widget _customDialog(BuildContext context) {
    double sh = MediaQuery.sizeOf(context).height;
    double sw = MediaQuery.sizeOf(context).width;
    final taskProvider = Provider.of<TaskViewModel>(context, listen: false);
    return Dialog(
      backgroundColor: secondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
      child: SizedBox(
        height: sh * 0.6,
        width: sw * 0.8,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: sw * 0.05, vertical: sh * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'New Task',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'What has to be done?',
                style: TextStyle(color: textBlue),
              ),
              _customTextField('Enter a Task', null, null, false, (value) {
                taskProvider.setTaskName(value);
              }, null),
              const SizedBox(height: 50),
              const Text(
                'Due Date',
                style: TextStyle(color: textBlue),
              ),
              _customTextField(
                  'Enter a Date', Icons.calendar_month, () async {
                DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2017),
                    lastDate: DateTime(2030));
                taskProvider.setDate(date);
              }, true, (value) {}, taskProvider.dateCont),
              _customTextField(
                  'Enter a Time', Icons.timer, () async {
                TimeOfDay? time = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());
                taskProvider.setTime(time);
              }, true, (value) {}, taskProvider.timeCont),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                    onPressed: () async {
                      await taskProvider.addTask();
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    child: const Text(
                      'Create',
                      style: TextStyle(color: primary),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _customTextField(String hint, IconData? icon, Function? ontap,
      bool readOnly, Function(String)? onChanged, TextEditingController? controller) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: TextField(
        readOnly: readOnly,
        onChanged: onChanged,
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: InkWell(
              onTap: () {
                if (ontap != null) {
                  ontap!(); // Gọi hàm ontap khi nhấn vào icon
                }
              },
              child: Icon(
                icon,
                color: Colors.grey,
              )),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
