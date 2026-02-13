import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('tasksBox');
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
    debugShowCheckedModeBanner: false,
      home:ToDoApp() ,
    );
  }
}
class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Box box = Hive.box('tasksBox');
    return  Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.blue,
        title:Text("Flutter ToDo App",style: TextStyle(fontSize: 24),),  
      ),
      backgroundColor:Colors.blue.shade100,
      body:ValueListenableBuilder(
        
        valueListenable: box.listenable(),
         builder: (context, Box tasksBox,_){
          if(tasksBox.isEmpty){
            return Center(
              child: Text("there are no tasks",style: TextStyle(fontSize: 24),),
            );
          }
          return ListView.builder(
            itemCount: tasksBox.length,
            itemBuilder:(context, index){
            final task = tasksBox.getAt(index);
            return ListTile(
              title: Text(task),
              trailing: IconButton(
                icon:Icon(Icons.delete,color:Colors.red),
                onPressed: (){
                  final removeTask = task;
                  final removeIndex = index;
                  tasksBox.deleteAt(index);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:Text("the mission has been deleted"),
                      action: SnackBarAction(
                        label:"to retreat" ,
                         onPressed:(){
                          box.add(removeTask);
                         } 
                         ),
                      ),
                  );
                }, 
                ),
            );
            }, 
            );
         },
         ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.black,
          
          onPressed:() {
             Navigator.push(context, MaterialPageRoute(builder: (context) => const AddTaskPage()),
             );
          },
          child: Icon(Icons.add),
         ),
        
    );
  }
}
class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController controller = TextEditingController();
  final Box box = Hive.box('tasksBox');
  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }
  void addTask(){
    final text = controller.text.trim();
    if(text.isNotEmpty){
      box.add(text);
      controller.clear();
      Navigator.pop(context);
      
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a new task",style: TextStyle(fontSize: 24),),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.blue.shade100,
      body: Padding(padding: EdgeInsets.all(16),
      
      child: Column(
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText:"Write your task here",labelStyle: TextStyle(fontSize: 24),
              border: OutlineInputBorder(),
            ),
            onSubmitted:  (_) =>addTask(),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed:addTask ,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.black,
              textStyle: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),
              padding: EdgeInsets.symmetric(horizontal: 30,vertical: 13),
            
            ),
             child: Text("Addition"),
             ),
        ],
      ),
      ),
    );
  }
}
