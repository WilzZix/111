// -------  QUERY  -------

const String getAllUsersQuery = """
query (\$keyword:String,\$page:Int!,\$size:Int!) {
  getClaimsList(claims_list_input:{keyword:\$keyword,page:\$page, size:\$size}) {
   code
   data {
     count
     list {
      id
      name
      state
      status
      summ
     }
   }
   msg
  }
}

""";

const String getClaimsListGrouped = """
query (\$keyword:String,\$page:Int!,\$size:Int!) {
  getClaimsListGrouped(claims_list_input:{keyword:\$keyword,page:\$page, size:\$size}) {
    code
    msg
    data {
      count
      list {
        count
        label
        data {
          id
          name
          state
          status
          summ
          date
        }
      }
    }
  }
}

""";

const String getUserInfoQuery = """
query getClientInfo(\$id:Float!) {
  getClientInfo(client_claimId:\$id) {
   code
   data {
     address
     cardDate
     cardNumber
     country
     district
     email
     id
     phoneFirst
     phoneSecond
     profileId
     region
   }
   msg
  }
  getClientInfoRefs(ref_types: [COUNTRY, DISTRICT, REGION]){
    code
    msg
    data
  }
}

""";

const String getClientInfoQueryRefs = """
query getClientInfo(\$id:Float!) {
  getClientInfo(client_claimId:\$id) {
   code
   data {
     address
     cardDate
     cardNumber
     country
     district
     email
     id
     phoneFirst
     phoneSecond
     profileId
     region
   }
   msg
  }
  getClientInfoRefs(ref_types: [COUNTRY, DISTRICT, REGION]){
    code
    msg
    data
  }
}

""";

const String getProductsQuery = """
query GetProducts(\$id:Int!) {
  getProduct(claimsId:\$id) {
   code
   data {
     amount
     count
     products {
      id
      name
      category
      price
     }
   }
  }
}

""";

const String searchProductQuery = """
query searchProd(\$input:String!) {
  searchProduct(searchVal_input:\$input) {
   price
   category
   id
   name
  }
}

""";

const String getTermRefsQuery = """
query getTermRefs {
  getTermRefs {
   code
   data {
    name
    pId
   }
   msg
  }
}
""";

const String getOfertaQuery = """
query getOferta {
  getOferta {
   code
   data
   msg
  }
}
""";

const String getClientProcess = """
query getProcess(\$id:Float!) {
  getClaimsProcess(claimsId_input:\$id) {
   code
   msg
   data
  }
}
""";

const String getAutoPayStatusItem = """
query getAutoPayStatus(\$claimsId:Float!) {
  getAutoPayStatus(claimsId:\$claimsId) {
   code
   msg
   data{
    cardDate
    cardNumber
    confirmed
   }
  }
}
""";

const String getChartByClaims = '''
query getChartByClaims(\$claimsId:Int!) {
  getChartByClaims(claims_chart_input: { claimsId:\$claimsId }) {
   code
   msg
   data{
      monthly
      overpay
      period
      productTotal
      reportUrl
      total
   }
  }
}
''';

const String getMerchNotes = '''
query getMerchNotes (\$claimsId_inpt:Int!) {
  getMerchNotes(claimsId_inpt:\$claimsId_inpt) {
  code
  data {
    action
    createdAt
    id
    note
  }
  msg
  }
}
''';

// -------  MUTATIONS  -------
const addMyCode = '''
mutation (\$code: String!) {
  getClientData(myid_input:{ code: \$code }) {
    code
     data {
      claimsId
      code 
      msg
      process {
        message
        id
      }
    }
    getClaimsProcess
    msg
  }
}
''';

const editClientInfo = '''
mutation (\$id: Int, \$address: String, \$cardDate: String, \$cardNumber: String, \$country: String, \$district: String, \$email: String, \$phoneFirst: String, \$phoneSecond: String, \$region: String, \$profileId: Int!) {
  editClientInfo(client_info_input:{id:\$id,address:\$address,cardDate:\$cardDate,cardNumber:\$cardNumber,country:\$country,district:\$district,email:\$email,phoneFirst:\$phoneFirst,phoneSecond:\$phoneSecond,region:\$region, profileId: \$profileId}) {
    code
    data {
      address
      cardDate
      cardNumber
      country
      district
      email
      id
      phoneFirst
      phoneSecond
      profileId
      region
    }
    msg
  }
}
''';

const deleteProduct = '''
mutation DelProd(\$claimsId: Int!, \$productId: Int!) {
  removeProduct(rProduct_input:{claimsId:\$claimsId, productId:\$productId}) {
    code
    msg
    data {
      amount
      count
      products {
        id
        name
        category
        price
      }
    }
  }
}
''';

const clearProduct = '''
mutation (\$claimsId: Int!) {
  cleanProduct(claimsId:\$claimsId) {
    code
    msg
    data {
      amount
      count
      products {
        id
        name
        category
        price
      }
    }
  }
}
''';

const getScoreLimit = '''
mutation (\$claimsId: Int!, \$pId: Int!) {
  getScoreLimit(get_score_input: {claimsId:\$claimsId, pId: \$pId}) {
    code
    msg
    data {
      monthly
      overpay
      totalInsSum
    }
  }
}
''';

const setScoreLimit = '''
mutation (\$claimsId: Int!, \$pId: Int!) {
  setScoreLimit(set_score_input: {claimsId:\$claimsId, pId: \$pId}) {
    code
    msg
  }
}
''';

const autoPayment = '''
mutation (\$cardDate: String!, \$cardNumber: String!, \$claimsId: Int!) {
  autoPayment(auto_pay_input: {cardDate:\$cardDate, cardNumber: \$cardNumber, claimsId: \$claimsId}) {
    code
    msg
  }
}
''';

const autoPayConfirm = '''
mutation (\$claimsId: Int!, \$smsCode: Int!) {
  autoPaymentConfirm(auto_pay_cfrm_input: {claimsId:\$claimsId, smsCode: \$smsCode}) {
    code
    msg
  }
}
''';

const setOfertaDecisions = '''
mutation (\$claimsId: Int!, \$decision: YESNO!) {
  setOfertaDecision(oferta_input: {claimsId:\$claimsId, decision: \$decision}) {
    code
    msg
  }
}
''';

const addCustomProducts = '''
mutation (\$claimsId: Int!, \$name: String!, \$price: Int!) {
  addCustomProduct (aCustProduct_input: {claimsId:\$claimsId, name:\$name, price:\$price}) {
    code
    msg
  }
}
''';
const addProduct = '''
mutation AddProd(\$claimsId: Int!, \$productId: Int!) {
  addProduct(aProduct_input:{claimsId:\$claimsId, productId:\$productId}) {
    code
    msg
  }
}
''';

const setMerchNote = '''
mutation (\$claimsId: Int!, \$note: String!, \$action: Int!) {
   setMerchNote(merchNote_inpt: { action: \$action, claimsId: \$claimsId, note: \$note }) {
    code
    msg
    data {
      action
      createdAt
      id
      note
    }
  }
}
''';
