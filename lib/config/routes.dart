import 'package:drink_your_wine_pos/screens/employees/add_employee_screen.dart';
import 'package:drink_your_wine_pos/screens/employees/edit_employee_screen.dart';
import 'package:drink_your_wine_pos/screens/employees/employees_screen.dart';
import 'package:drink_your_wine_pos/screens/pos/pos_screen.dart';
import 'package:flutter/material.dart';

import '../screens/auth/login_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';

class Routes {
  // Route names
  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String pos = '/pos';
  static const String checkout = '/checkout';
  static const String inventory = '/inventory';
  static const String addProduct = '/inventory/add';
  static const String editProduct = '/inventory/edit';
  static const String employees = '/employees';
  static const String addEmployee = '/employees/add';
  static const String editEmployee = '/employees/edit';
  static const String reports = '/reports';
  static const String salesReport = '/reports/sales';
  static const String inventoryReport = '/reports/inventory';
  static const String settings = '/settings';

  // Route generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());

      case pos:
      return MaterialPageRoute(builder: (_) => const POSScreen());

      case employees:
        return MaterialPageRoute(builder: (_) => const EmployeesScreen());
      
      case addEmployee:
        return MaterialPageRoute(builder: (_) => const AddEmployeeScreen());

      case editEmployee:
        return MaterialPageRoute(builder: (_) => const EditEmployeeScreen());

      

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
