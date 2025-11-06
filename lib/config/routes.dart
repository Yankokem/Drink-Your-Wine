//employees
import 'package:drink_your_wine_pos/screens/employees/add_employee_screen.dart';
import 'package:drink_your_wine_pos/screens/employees/edit_employee_screen.dart';
import 'package:drink_your_wine_pos/screens/employees/employee_profile_screen.dart';
import 'package:drink_your_wine_pos/screens/employees/employees_screen.dart';
//inventory
import 'package:drink_your_wine_pos/screens/inventory/add_product_screen.dart';
import 'package:drink_your_wine_pos/screens/inventory/edit_product_screen.dart';
import 'package:drink_your_wine_pos/screens/inventory/inventory_screen.dart';
//menu
import 'package:drink_your_wine_pos/screens/menu/menu_screen.dart';
//pos
import 'package:drink_your_wine_pos/screens/pos/pos_screen.dart';
//reports
import 'package:drink_your_wine_pos/screens/reports/reports_screen.dart';
import 'package:drink_your_wine_pos/widgets/employees/activity_log_tab.dart';
import 'package:drink_your_wine_pos/widgets/employees/attendance_tab.dart';
import 'package:drink_your_wine_pos/widgets/employees/profile_tab.dart';
import 'package:drink_your_wine_pos/widgets/employees/sales_history_tab.dart';
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
  
  // MENU ROUTES
  static const String menu = '/menu';
  static const String addMenuItem = '/menu/add';
  static const String editMenuItem = '/menu/edit';
  
  // INVENTORY ROUTES
  static const String inventory = '/inventory';
  static const String addProduct = '/inventory/add';
  static const String editProduct = '/inventory/edit';

  // EMPLOYEE ROUTES
  static const String employees = '/employees';
  static const String addEmployee = '/employees/add';
  static const String editEmployee = '/employees/edit';
  static const String employeeProfile = '/employees/profile';
  static const String activityLog = '/employees/activity-log';
  static const String attendance = '/employees/attendance';
  static const String salesHistory = '/employees/sales-history';
  static const String profileTab = '/employees/profile-tab';

  // REPORTS & SETTINGS
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

      // MENU ROUTES
      case menu:
        return MaterialPageRoute(builder: (_) => const MenuScreen());

      case addMenuItem:
        // TODO: Create AddMenuItemScreen
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Add Menu Item Screen - Coming Soon'),
            ),
          ),
        );

      case editMenuItem:
        // TODO: Create EditMenuItemScreen
        final menuItemData = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Edit Menu Item Screen - Coming Soon'),
            ),
          ),
        );

      // INVENTORY ROUTES
      case inventory:
        return MaterialPageRoute(builder: (_) => const InventoryScreen());

      case addProduct:
        return MaterialPageRoute(builder: (_) => const AddProductScreen());

      case editProduct:
        final productData = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => EditProductScreen(productData: productData),
        );

      // EMPLOYEE ROUTES
      case employees:
        return MaterialPageRoute(builder: (_) => const EmployeesScreen());

      case addEmployee:
        return MaterialPageRoute(builder: (_) => const AddEmployeeScreen());

      case editEmployee:
        final employeeData = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => EditEmployeeScreen(employeeData: employeeData),
        );

      case employeeProfile:
        final employeeData = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => EmployeeProfileScreen(employeeData: employeeData),
        );

      case activityLog:
        final employeeData = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => ActivityLogTab(employeeData: employeeData),
        );

      case attendance:
        final employeeData = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => AttendanceTab(employeeData: employeeData),
        );

      case salesHistory:
        final employeeData = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => SalesHistoryTab(employeeData: employeeData),
        );

      case profileTab:
        final employeeData = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => ProfileTab(employeeData: employeeData),
        );

      // REPORTS ROUTES
      case reports:
        return MaterialPageRoute(builder: (_) => const ReportsScreen());

      case inventoryReport:
        return MaterialPageRoute(builder: (_) => const InventoryScreen());

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