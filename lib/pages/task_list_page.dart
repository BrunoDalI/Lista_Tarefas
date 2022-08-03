import 'package:flutter/material.dart';
import 'package:todo_list/repositories/task_repository.dart';
import '../models/task.dart';
import '../widgets/task_list_item.dart';



class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController tasksController = TextEditingController();
  final TaskRepository taskRepository = TaskRepository();

  List<Task> tasks = [];
  Task? deletedTask;
  // POSIÇÃO DA TAREFA DELETADA
  int? deletedTaskPos;

  String? errorText;


  @override
  void initState(){
    super.initState();

    taskRepository.getTaskList().then((value){
      setState((){
        tasks = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // CAMPO TEXTO E BOTÃO SUPERIOR
                Row(
                  children: [
                    Expanded(
                      // CAMPO PARA ESCREVER TAREFA
                      child: TextField(
                        controller: tasksController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Adicione uma tarefa',
                          hintText: 'Ex. Estudar',
                          errorText: errorText,
                          // labelStyle: TextStyle(
                          //   color: Colors.greenAccent,
                          // ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8,),

                    // BOTÃO PARA ADICIONAR TAREFA
                    ElevatedButton(
                        onPressed: (){
                          String text = tasksController.text;
                          if(text.isEmpty){
                            setState(() {
                              errorText =
                              'O nome da tarefa não pode estar vazia';
                            });
                            return;
                          }
                          setState((){
                            Task newTask = Task(title: text, dateTime: DateTime.now());
                            tasks.add(newTask);
                            errorText = null;
                          });
                          tasksController.clear();
                          // SALVA LISTA ATUALIZADA
                          taskRepository.saveTaskList(tasks);
                        },
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xff00d7f3),
                        padding: const EdgeInsets.all(16),
                      ),
                        child: const Icon(Icons.add, size: 30,),
                    ),

                  ],
                ),

                const SizedBox(height: 16,),

                // LISTA DAS TAREFAS
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for(Task task in tasks)
                        TaskListItem(task: task, onDelete: onDelete),
                    ],
                  ),
                ),

                const SizedBox(height: 16,),

                // CAMPO TEXTO E BOTÃO INFERIOR
                Row(
                  children: [
                    Expanded(
                       // TEXTO DA PARTE INFERIOR
                        child: Text('Você possui ${tasks.length} tarefas pendentes'),
                    ),

                    const SizedBox(width: 8,),

                    // BOTÃO PARA EXCLUIR TODAS AS TAREFAS
                    ElevatedButton(
                      onPressed: showDeleteTasksConfirmationDialog,
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xffCD5C5C),
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Text('Limpar tudo'),
                    ),

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(Task task){
    deletedTask = task;
    deletedTaskPos = tasks.indexOf(task);

    setState((){
      tasks.remove(task);
    });
    taskRepository.saveTaskList(tasks);


    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Tarefa ${task.title} foi removida com sucesso!'),
          action: SnackBarAction(
            label: 'Desfazer',
            onPressed: (){
              setState((){
                tasks.insert(deletedTaskPos!, deletedTask!);
              });
              taskRepository.saveTaskList(tasks);
            },
          ),
        duration: const Duration(seconds: 5),
      ),
    );
  }


  void showDeleteTasksConfirmationDialog(){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar Tudo'),
        content: const Text('Você tem certeza que deseja apagar todas as tarefas?'),
        actions: [
          TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
          ),
          TextButton(
              onPressed:(){
                Navigator.of(context).pop();
                deleteAllTasks();
              },
              style: TextButton.styleFrom(primary: Colors.redAccent),
              child: const Text('Limpar'),
          ),
        ],
      ),
    );
  }

  // DELETA TODAS AS TAREFAS
  void deleteAllTasks(){
    setState((){
      tasks.clear();
    });
    taskRepository.saveTaskList(tasks);
  }
}






// class TodoListPage extends StatelessWidget {
//   TodoListPage({Key? key}) : super(key: key);
//
//   final TextEditingController emailController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // CAMPO PARA COLOCAR O EMAIL DO USUÁRIO
//               TextField(
//                 controller: emailController,
//                 decoration: const InputDecoration(
//                   labelText: 'E-mail',
//                 ),
//                 onChanged: onChanged,
//                 onSubmitted: onSubmitted,
//               ),
//
//               // BOTÃO PARA REALIZAR LOGIN
//               ElevatedButton(
//                 onPressed: login,
//                 child: Text('Entrar'),
//               ),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   void login(){
//     String text = emailController.text;
//     print(text);
//     emailController.clear();
//     //emailController.text = 'Enviado';
//   }
//
//   void onChanged(String text){
//     print(text);
//   }
//
//   void onSubmitted(String text){
//     print(text);
//   }
//
// }