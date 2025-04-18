class TotalReturnOrdersCount {
  Data? data;

  TotalReturnOrdersCount({this.data});

  TotalReturnOrdersCount.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? totalReturnedOrders;

  Data({this.totalReturnedOrders});

  Data.fromJson(Map<String, dynamic> json) {
    totalReturnedOrders = json['total_returned_orders'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_returned_orders'] = totalReturnedOrders;
    return data;
  }
}