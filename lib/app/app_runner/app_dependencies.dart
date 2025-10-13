import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:injectable/injectable.dart';
import 'app_dependencies.config.dart';

@InjectableInit(
  initializerName: 'setup',
  asExtension: true,
  preferRelativeImports: true,
)
void setupDependencies() => GetIt.I.setup();

@module
abstract class Modules {
  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @lazySingleton
  Dio get dio => Dio();

  @lazySingleton
  FirebaseFirestore get firebaseFirestore => FirebaseFirestore.instance;

  @lazySingleton
  HiveInterface get hive => Hive;

  @lazySingleton
  Connectivity get connectivity => Connectivity();

  @lazySingleton
  Stopwatch get stopWatch => Stopwatch();
}
