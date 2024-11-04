import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Measurementprovider with ChangeNotifier{
  List<dynamic> _shalwarQameez = [];
  List<dynamic> _coat = [];
  List<dynamic> _Waskit = [];
  List<dynamic> _pants = [];
  List<dynamic> _sherwani = [];
  bool _isLoading = false;
  final ref = FirebaseDatabase.instance.ref('measurements');
  List<dynamic> get shalwarQameez => _shalwarQameez;
  List<dynamic> get coat => _coat;
  List<dynamic> get Waskit => _Waskit;
  List<dynamic> get pants => _pants;
  List<dynamic> get sherwani => _sherwani;
  bool get  isLoading => _isLoading;


  Future<void> FetchMeausurements( String path )async {

    final snapshot = await ref.child(path).get();
    if(snapshot.exists){
      _isLoading = true;
      notifyListeners();
      final map = snapshot.value as Map<dynamic, dynamic>;

      if(path.toLowerCase() == 'coat'){
        _coat.clear();
        _coat = map.values.toList();
        _isLoading = false;
        notifyListeners();
      }else if(path.toLowerCase() == 'pants'){
        _pants.clear();
        _pants = map.values.toList();
        _isLoading = false;
        notifyListeners();
      }else if(path.toLowerCase() == 'shalwarqameez'){
        _shalwarQameez.clear();
        _shalwarQameez = map.values.toList();
        _isLoading = false;
        notifyListeners();
      }else if(path.toLowerCase() == 'sherwani'){
        _sherwani.clear();
        _sherwani = map.values.toList();
        _isLoading = false;
        notifyListeners();
      }else{
        _Waskit.clear();
        _Waskit = map.values.toList();
        _isLoading = false;
        notifyListeners();
      }

    }else{

    }
  }





}