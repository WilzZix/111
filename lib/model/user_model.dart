class Users {
  final String? id;
  final String? fio;
  final String? payment;
  final String? status;
  final data;

  final String? label;
  final String? count;

  Users({
    required this.id,
    required this.fio,
    required this.payment,
    required this.status,
    required this.label,
    required this.count,
    required this.data,
    // this.id,
    // this.fio,
    // this.payment,
    // this.status,
    // this.label,
    // this.count,
    // this.data,
  });
}

class UserInfo {
  final String? id;
  final String? profileId;
  final String? phoneFirst;
  final String? phoneSecond;
  final String? email;
  final String? cardDate;
  final String? cardNumber;
  final String? adress;
  final String? uy;
  final Country? country;
  final District? district;
  final Region? region;

  UserInfo({
    required this.id,
    required this.profileId,
    required this.phoneFirst,
    required this.phoneSecond,
    required this.email,
    required this.cardDate,
    required this.cardNumber,
    required this.adress,
    required this.uy,
    required this.country,
    required this.district,
    required this.region,
  });
}

class Country {
  final String? id;
  final String? code;
  final String? alpha2Code;
  final String? alpha3Code;
  final String? name;
  final String? currency;
  final String? localSign;
  final String? dateActiv;
  final String? dateDeact;
  final String? condition;
  final String? uzc;
  final String? uzl;
  final String? rus;

  Country({
    required this.id,
    required this.code,
    required this.alpha2Code,
    required this.alpha3Code,
    required this.name,
    required this.currency,
    required this.localSign,
    required this.dateActiv,
    required this.dateDeact,
    required this.condition,
    required this.uzc,
    required this.uzl,
    required this.rus,
  });
}

class District {
  final String? id;
  final String? code;
  final String? name;
  final String? region;
  final String? dateActiv;
  final String? dateDeact;
  final String? condition;
  final String? uzc;
  final String? uzl;
  final String? rus;

  District({
    required this.id,
    required this.code,
    required this.name,
    required this.region,
    required this.dateActiv,
    required this.dateDeact,
    required this.condition,
    required this.uzc,
    required this.uzl,
    required this.rus,
  });
}

class Region {
  final String? id;
  final String? code;
  final String? name;
  final String? order;
  final String? dateActiv;
  final String? dateDeact;
  final String? condition;
  final String? uzc;
  final String? uzl;
  final String? rus;

  Region({
    required this.id,
    required this.code,
    required this.name,
    required this.order,
    required this.dateActiv,
    required this.dateDeact,
    required this.condition,
    required this.uzc,
    required this.uzl,
    required this.rus,
  });
}

class Product {
  final String? id;
  final String? name;
  final String? category;
  final String? price;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
  });
}

class ShopProduct {
  final String? id;
  final String? price;
  final String? name;

  ShopProduct({
    required this.id,
    required this.price,
    required this.name,
  });
}

class FioReq {
  final String? code;
  final String? reqId;

  FioReq({
    required this.code,
    required this.reqId,
  });
}

class Month {
  int? pId;
  String? name;

  Month({
    required this.pId,
    required this.name,
  });
}

class Dogovor {
  String? id;
  String? title;
  String? subTitle;
  String? fsz;
  String? fw;
  String? summa;
  String? margin;

  Dogovor({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.fsz,
    required this.fw,
    required this.summa,
    required this.margin,
  });
}
