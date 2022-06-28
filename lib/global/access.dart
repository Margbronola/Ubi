import 'package:internapp/model/cartdetails_model.dart';
import 'package:internapp/model/customer_model.dart';
import 'package:internapp/model/order_model.dart';
import 'package:internapp/model/product_model.dart';
import 'package:internapp/model/producttoprepare_model.dart';
import 'package:internapp/model/todaysorder_model.dart';
import 'package:internapp/model/user_model.dart';

UserModel? loggedUser;
ProductModel? productDetails;
CustomerModel? customerDetails;
CartDetailsModel? cartlist;
ProductToPrepareModel? topreparelist;
TodaysOrderModel? todaysOrderlist;
OrderModel? orderlist;


String? accessToken;