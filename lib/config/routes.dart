import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/pos/pos_screen.dart';
import '../screens/inventory/inventory_screen.dart';
import '../screens/inventory/add_product_screen.dart';
import '../screens/inventory/edit_product_screen.dart';
import '../screens/employees/employees_screen.dart';
import '../screens/employees/add_employee_screen.dart';
import '../screens/employees/edit_employee_screen.dart';
import '../screens/reports/reports_screen.dart';

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
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      
      case pos:
        return MaterialPageRoute(builder: (_) => const POSScreen());
      
      case checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutScreen());
      
      case inventory:
        return MaterialPageRoute(builder: (_) => const InventoryScreen());
      
      case addProduct:
        return MaterialPageRoute(builder: (_) => const AddProductScreen());
      
      case editProduct:
        return MaterialPageRoute(builder: (_) => const EditProductScreen());
      
      case employees:
        return MaterialPageRoute(builder: (_) => const EmployeesScreen());
      
      case addEmployee:
        return MaterialPageRoute(builder: (_) => const AddEmployeeScreen());
      
      case editEmployee:
        return MaterialPageRoute(builder: (_) => const EditEmployeeScreen());
      
      case reports:
        return MaterialPageRoute(builder: (_) => const ReportsScreen());
      
      
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