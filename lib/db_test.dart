import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
class Student{
    final String email;
    final String name;
    final int age;
    final String rollNo;
//constructor
    Student({
        required this.email,
        required this.name,
        required this.age,
        required this.rollNo,
    });
    Map<String, dynamic> mapStudent() {
      return {
        'email': email,
        'name': name,
        'age': age,
        'rollNo':rollNo,
      };
    }
     @override
    String toString() {
      return 'Student{id: $email, name: $name, age: $age}';
   }
}
class StudentDatabase{
   static final StudentDatabase instance = StudentDatabase._init();
   static Database? _database;
   StudentDatabase._init();
   Future<Database> get database async{
    if(_database!=null) return _database!;
    _database = await _initDB('Students.db');
    return _database!;
   }
   Future<Database> _initDB(String filepath) async {
    Directory dPath = await getApplicationDocumentsDirectory();
    final dbPath = dPath.path;
    final path = join(dbPath,filepath);
    return await openDatabase(path,version: 1, onCreate: _createDB);
   }
   Future _createDB(Database db, int version)async{
      await db.execute(
        '''Create Table Student (email TEXT, name TEXT, age INTEGER, rollNo TEXT)'''
      );
   }
   Future close()async{
    final db = await instance.database;
    db.close();
   }


  //Insert
  //the 'future' keyword defines a function that works asynchronously
Future<void> insertStudent(Student student) async{
  //local database variable
  final curDB = await instance.database;
  //insert function
  await curDB.insert(
    //first parameter is Table name
    'Student',
    //second parameter is data to be inserted
    student.mapStudent(),
    //replace if two same entries are inserted
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}
//Read
Future<List<Student>> getStudents() async {
  final curDB = await instance.database;
  //query to get all students into a Map list
  final List<Map<String, dynamic>> studentMaps = await curDB.query('Student');
  //converting the map list to student list
  return List.generate(studentMaps.length, (i) {
    //loop to traverse the list and return student object
    return Student(
      email: studentMaps[i]['email'],
      name: studentMaps[i]['name'],
      age: studentMaps[i]['age'],
      rollNo: studentMaps[i]['rollNo'],
    );
  });
}
//Update
Future<void> updateStudent(Student student) async {
  final curDB = await instance.database;
  //update a specific student
  await curDB.update(
    //table name
    'Student',
    //convert student object to a map
    student.mapStudent(),
    //ensure that the student has a matching email
    where: 'email = ?',
    //argument of where statement(the email we want to search in our case)
    whereArgs: [student.email],
  );
}
//Delete
Future<void> deleteStudent(String email) async {
  final curDB = await instance.database;
  // Delete operation
  await curDB.delete(
    //table name
    'Student',
    //'where statement to identify a specific student'
    where: 'email = ?',
    //arguments to the where statement(email passed as parameter in our case)
    whereArgs: [email],
  );
}
}

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  StudentDatabase db = StudentDatabase._init();
  //Student x =  Student(email: "educative@io.com", name: "EDU", age: 20, rollNo: "0101");
  //db.insertStudent(x);
  //db.getStudents();
  //Student y =  Student(email: "educative@io.com", name: "EDU", age: 20, rollNo: "0000");
  //db.updateStudent(y);
  //db.getStudents();
  //db.deleteStudent("educative@io.com");
  print("object");
}