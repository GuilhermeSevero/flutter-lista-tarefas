import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';

import 'package:lista_tarefas/services/toDoService.dart';
import 'package:lista_tarefas/models/toDo.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ToDoService toDoService = ToDoService();

  final _toDoController = TextEditingController();

  List _toDoList = [];

  ToDo _lastRemoved;
  int _lastRemovedPos;

  @override
  void initState() {
    super.initState();

    toDoService.readData().then((data) {
      setState(() {
        if (data.isNotEmpty) {
          _toDoList = json
              .decode(data)
              .map((element) => ToDo.fromJson(element))
              .toList();
        }
      });
    });
  }

  void _addToDo() {
    setState(() {
      ToDo newToDo = ToDo(title: _toDoController.text, ok: false);
      _toDoController.text = '';
      _toDoList.add(newToDo);

      toDoService.saveData(_toDoList);
    });
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _toDoList.sort((a, b) {
        if (a.ok && !b.ok)
          return 1;
        else if (!a.ok && b.ok)
          return -1;
        else
          return 0;
      });

      toDoService.saveData(_toDoList);
    });

    return null;
  }

  _onToDoCheck(int index, bool checked) {
    setState(() {
      _toDoList[index].ok = checked;
      toDoService.saveData(_toDoList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                  controller: _toDoController,
                  decoration: InputDecoration(
                      labelText: 'Nova Tarefa',
                      labelStyle: TextStyle(color: Colors.blueAccent)),
                )),
                RaisedButton(
                  color: Colors.blueAccent,
                  child: Text('ADD'),
                  textColor: Colors.white,
                  onPressed: _addToDo,
                )
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 10.0),
                  itemCount: _toDoList.length,
                  itemBuilder: buildItem),
            ),
          )
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context, int index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_toDoList[index].title),
        value: _toDoList[index].ok,
        secondary: CircleAvatar(
          child: Icon(_toDoList[index].ok ? Icons.check : Icons.error),
        ),
        onChanged: (checked) => _onToDoCheck(index, checked),
      ),
      onDismissed: (direction) {
        setState(() {
          _lastRemoved = _toDoList[index];
          _lastRemovedPos = index;
          _toDoList.removeAt(index);

          toDoService.saveData(_toDoList);

          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Tarefa "${_lastRemoved.title}" removida!'),
            action: SnackBarAction(
                label: 'Desfazer',
                onPressed: () {
                  setState(() {
                    _toDoList.insert(_lastRemovedPos, _lastRemoved);
                    toDoService.saveData(_toDoList);
                  });
                }),
            duration: Duration(seconds: 5),
          ));
        });
      },
    );
  }
}
