import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  // create credentials
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "xpens-388011",
  "private_key_id": "d75613438a21dd5276ada1b6d2fdd280cefcd574",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQCv7ZWv4+5B0Zhq\nwZN6Y2w36N0GFEPqcvT20xzavgp9HaBiQ3Zj4f9RxKH9zqvs6+YuAIVEP2VZSJ5z\nlWRRHkmhcpTjBe7NWd5f/UxBiyfd0dLyU/8MJr4cwevri2KNlH/pWKlsBMq48E0f\n52Sj3vVhXMSKY2lm+p9XxmPdbr70ziymgB6oYEdk35w1jwSSj1GloPH9EeKNlGRd\nQgtVjT1I6msB/gvllzhHpUyQH+qeVOqHhlq7Oeq5Dbx6l+HsYqitxcpBWGYUK9Z6\nv0LqdSAwmRD1OdvWTryiPR3TMUwNbvl8N+B8IMCsnG6TMw1JAOfcx/H1zFZTU9wY\nFSlPd9f1AgMBAAECggEAB8ZT4mdMCPgaiINAAX1h07G0jNd57eNBLKRFRux1mbRk\nuVr6YS0kY6hxMT6ALhL5w+gte4fisnipWfnM6mHQhrRB3KuPM1+Imoze4RmlfCHQ\n9Pkd0RtoNOykAK+S/idFJNqQeC/ZBqXF/sYy1iQdC322SNheWNj0EES59pf1k+ty\n3z8T8Xmjztb9wHfiw2vLTVdsvnWE3mHJrqkcIN4oOC9a2erD4/sdtKEeuoIj7T2d\n5oF7RTIFUqPAlkZGWXYRKkqX97FJxF55MxmMfV0TJUOIDXjl5kwwuTaYBRrOufl7\nr7OBW1usxOoMNWW8eqDyiMJVADYfUumeNOiyVPO3aQKBgQDVMfLE9e8DDp/yyESu\nTfiHNydmae81O14VWWqNoHRL01KvR0AjvBnnvBwUdKisw/pk5qRRZjkcD1uEZ1f0\nYqUGTzzZN8gDNDPDEiaa1v6majypv7lrFrf1jZKbx3gMF6h/TWJCi0Hw2Dy2eng/\n5jEisow8eUo8M84xQB+uiuzIGQKBgQDTQCQmOih/LzhW5WwrgRCd6kRqSLW1Crwg\nLDt6naBwBqJnOf3DgKnpv2oS/oHro3Wfibw0AkQuWmdPeV/qBplnvCOq8NYbh7Za\nBp2v1wrcH4ft7/cSQ50jz36q/0D3O/XttvXfzbuCxICAQs7sBm2kh99ReBPrq8fF\nzNo2Rjq6PQKBgQCkjIu7N7LFokkT4z0XZ7jV7Fztr//gDzVbtwsFyv1X9QBRpuW7\nbxhzgv4NT8lMp2qg7F+RMBwOK1BQjk8VofmLOCdX5LTsvCLjgiPnyN79ZOvzfLZJ\nEFzmGuI4eCmQ88Wqk/iuMbuwf8XEdhxP/YSZKkQQ/PCuLLIN01dgqXt+KQKBgQDQ\nu6v8abLiGNJeakq7oce9gWEgc7+3p2fDknEi8uU4TBXkUZTAvD0nzg8NvZS6NMVg\nYkQoT6T2+DTkflWbc/HYYjoMCfRFN4+i3K6qtJzya+Vv4ZAL5+s5GylZ5OVYZVLX\nE9VW0n3Y9DjUgy7aYG+uBuNOKIvmbdHzTDrBLhuRMQKBgQCssi7Lg8Bia8ruw66J\n/AZvluwdtCtxHw1vMp+VSrCZCpVgxAO0XG6vHut/FR2aEjLVl4aV4zEsMhjli8JE\ngwrUj3hT3GtOQ2d5rjgV8m4xUhcnIMiAd//GF6Z3NeLh5I/5bbOQMht3T7hy8nnG\nIDSU/vt7kN9uv+YemH2/9N6vHg==\n-----END PRIVATE KEY-----\n",
  "client_email": "xpens-732@xpens-388011.iam.gserviceaccount.com",
  "client_id": "107459565321141616164",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/xpens-732%40xpens-388011.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}

  ''';

  // set up & connect to the spreadsheet
  static final _spreadsheetId = '1G6DrhsmLMsIAGXPxvXGmaBpuvbWvdS8O9l1cSQ5RGyY';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  // some variables to keep track of..
  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

  // initialise the spreadsheet!
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Worksheet1');
    print(_worksheet?.values.value(column: 1, row: 2));
    countRows();
  }

  // count the number of notes
  static Future countRows() async {
    while ((await _worksheet!.values
        .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }
    // now we know how many notes to load, now let's load them!
    loadTransactions();
  }

  // load existing notes from the spreadsheet
  static Future loadTransactions() async {
    if (_worksheet == null) return;

    for (int i = 1; i < numberOfTransactions; i++) {
      final String transactionName =
      await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmount =
      await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType =
      await _worksheet!.values.value(column: 3, row: i + 1);

      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions.add([
          transactionName,
          transactionAmount,
          transactionType,
        ]);
      }
    }
    print(currentTransactions);
    // this will stop the circular loading indicator
    loading = false;
  }

  // insert a new transaction
  static Future insert(String name, String amount, bool _isIncome) async {
    if (_worksheet == null) return;
    numberOfTransactions++;
    currentTransactions.add([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
    await _worksheet!.values.appendRow([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
  }

  // CALCULATE THE TOTAL INCOME!
  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'income') {
        totalIncome += double.parse(currentTransactions[i][1]);
      }
    }
    return totalIncome;
  }

  // CALCULATE THE TOTAL EXPENSE!
  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'expense') {
        totalExpense += double.parse(currentTransactions[i][1]);
      }
    }
    return totalExpense;
  }
}