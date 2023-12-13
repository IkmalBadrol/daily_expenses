import 'package:daily_expenses/Controller/request_controller.dart';
import '../Controller/sqlite_db.dart';
import '../Controller/request_controller.dart';

class Expense {
  static const String SQLiteTable = "expense";
  int? id;
  String desc;
  double amount;
  String dateTime;

  Expense(this.amount, this.desc, this.dateTime);

  Expense.update(this.id, this.amount, this.desc, this.dateTime);


  Expense.fromJson(Map<String, dynamic> json)
      :desc = json['desc'] as String,
        amount = double.parse(json['amount'] as dynamic),
        dateTime = json['dateTime'] as String,
        id = json['id'] as int?;
  // toJson will be automatically called by jsonEncode when necessary

  // To JSON convert Expense object to JSON map
  Map<String, dynamic> toJson() =>
      {'id' : id, 'desc' : desc, 'amount' : amount, 'dateTime' : dateTime};

  Future<bool> save() async{
    // Save to local SQLite
    await SQLiteDB().insert(SQLiteTable, toJson());
    // API operation
    RequestController req = RequestController(path: "/api/expenses.php");
    req.setBody(toJson());
    await req.post();

    if(req.status() == 200 ){
      return true;
    }
    else{
      if(await SQLiteDB().insert(SQLiteTable, toJson()) != 0){
        return true;
      }else {
        return false;
      }
    }
  }


  Future<bool> update() async {

    await SQLiteDB().update(SQLiteTable, 'id' ,toJson());
    // Check if the expense has an ID
    if (id != null) {
      // Update API endpoint based on user ID
      //String apiEndpoint = "/api/expenses.php?id=$id";


      // API operation for updating
      RequestController req = RequestController(path: "/api/expenses.php");
      req.setBody(toJson());
      await req.put();
      // Check the status of the API request
      if (req.status() == 200) {
        return true;
      }
      else{
        if(await SQLiteDB().insert(SQLiteTable, toJson()) != 0){
          return true;
        }else {
          return false;
        }
      }
    }
    return false;
  }

  // Future<bool> delete() async {
  //
  //   //await SQLiteDB().delete(SQLiteTable, 'id' ,toJson());
  //   // Check if the expense has an ID
  //   if (id != null) {
  //     // Update API endpoint based on user ID
  //     //String apiEndpoint = "/api/expenses.php?id=$id";
  //
  //
  //     // API operation for updating
  //     RequestController req = RequestController(path: "/api/expenses.php");
  //     //req.setBody(toJson());
  //     await req.delete();
  //     // Check the status of the API request
  //     if (req.status() == 200) {
  //       return true;
  //     }
  //     else{
  //       if(await SQLiteDB().insert(SQLiteTable, toJson()) != 0){
  //         return true;
  //       }else {
  //         return false;
  //       }
  //     }
  //   }
  //   return false;
  // }

  Future<bool> delete() async {
    // Check if the expense has an ID

    await SQLiteDB().delete(SQLiteTable, 'id' ,toJson());

    if (id != null) {
      // Local SQLite delete
      await SQLiteDB().delete(SQLiteTable, 'id', id!);
      // API operation for deleting
      RequestController req = RequestController(path: "/api/expenses.php");
      // Compulsary
      req.setBody({'id': id});
      await req.delete();
      // Check the status of the API request
      if (req.status() == 200) {
        return true;
      } else {
        // If API request fails, insert the record back to SQLite
        if (await SQLiteDB().insert(SQLiteTable, toJson()) != 0) {
          return true;
        } else {
          return false;
        }
      }
    }
    return false;
  }


  static Future<List<Expense>> loadAll() async {
    List<Expense> result = [];
    RequestController req = RequestController(path: "/api/expenses.php");
    await req.get();
    if(req.status() == 200 && req.result() !=null) {
      for(var item in req.result()){
        result.add(Expense.fromJson(item));
      }
    }
    else{
      List<Map<String, dynamic>> result = await SQLiteDB().queryAll(SQLiteTable);
      List<Expense> expenses = [];
      for(var item in result) {
        result.add(Expense.fromJson(item) as Map<String, dynamic>);
      }
    }
    return result;
  }
}