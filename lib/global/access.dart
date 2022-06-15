import 'package:internapp/model/cartdetails_model.dart';
import 'package:internapp/model/category_model.dart';
import 'package:internapp/model/customer_model.dart';
import 'package:internapp/model/order_model.dart';
import 'package:internapp/model/orders_model.dart';
import 'package:internapp/model/paidorders.dart';
import 'package:internapp/model/payment_model.dart';
import 'package:internapp/model/pendingorderdetails_model.dart';
import 'package:internapp/model/product_model.dart';
import 'package:internapp/model/toprepare_model.dart';
import 'package:internapp/model/user_model.dart';

UserModel? loggedUser;
ProductModel? productDetails;
CustomerModel? customerDetails;
CategoryModel? categorylist;
CartDetailsModel? cartlist;
ToPrepareModel? topreparelist;
PaymentModel? payment;
OrderModel? orderlist;
PendingOrderDetailsModel? pendingorder;
PaidOrderModel? paidOrderList;
OrdersModel? order;

String? accessToken;