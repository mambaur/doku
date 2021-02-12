import 'package:dompet_apps/blocs/transaction/transaction_bloc.dart';
import 'package:dompet_apps/models/transaction-model.dart';
import 'package:dompet_apps/screens/categories/category-screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:google_fonts/google_fonts.dart';

class AddPengeluaran extends StatefulWidget {
  @override
  _AddPengeluaranState createState() => _AddPengeluaranState();
}

class _AddPengeluaranState extends State<AddPengeluaran> {
  String title = 'Tambah Pengeluaran';
  final _key = new GlobalKey<FormState>();
  TransactionBloc _transactionBloc = TransactionBloc();
  DateTime selectedDate = DateTime.now();
  String tanggal, balance, categorySelected, description;
  int idCategory;

  //Menampilkan dialog calender
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2020, 1),
        lastDate: DateTime(2030));

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  //vallidate input Form edit & insert data to sql
  checkFormEditData() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      TransactionModel transactionModel = TransactionModel(
        date: tanggal,
        balance: int.parse(balance),
        description: description,
        rolecategory: idCategory.toString(),
        status: 'active',
      );

      _transactionBloc
          .add(InsertTransaction(transactionModel: transactionModel));
    }
  }

  @override
  void initState() {
    _transactionBloc = BlocProvider.of<TransactionBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    return BlocListener<TransactionBloc, TransactionState>(
      cubit: _transactionBloc,
      listener: (context, state) {
        if (state is TransactionInsert) {
          _messageDialog(context);
        }
      },
      child: Container(
        child: Form(
          key: _key,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            children: <Widget>[
              Text(title,
                  style: GoogleFonts.nunito(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600,
                      fontSize: 20)),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                readOnly: true,
                onTap: () {
                  _selectDate(context);
                },
                onSaved: (e) => tanggal = e,
                validator: (e) {
                  if (e.isEmpty) {
                    return "*Input tidak boleh kosong";
                  }
                },
                controller: TextEditingController(
                    text: selectedDate.toString().split(' ')[0]),
                style: GoogleFonts.nunito(color: Colors.grey[700]),
                decoration: InputDecoration(
                    labelText: 'Tanggal',
                    suffixIcon: Icon(Icons.date_range),
                    hintStyle: GoogleFonts.nunito(color: Colors.grey[400]),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[300]))),
              ),
              TextFormField(
                onChanged: (e) => balance = e,
                style: GoogleFonts.nunito(color: Colors.grey[700]),
                controller: TextEditingController(
                  text: balance,
                ),
                keyboardType: TextInputType.number,
                onSaved: (e) => balance = e,
                validator: (e) {
                  if (e.isEmpty || e == '0') {
                    return "*Input tidak boleh kosong";
                  }
                },
                decoration: InputDecoration(
                    labelText: 'Jumlah uang',
                    hintText: '0',
                    suffixIcon: GestureDetector(
                        onTap: () {
                          _calculatorDialog(context);
                        },
                        child: Icon(Icons.dialpad)),
                    hintStyle: GoogleFonts.nunito(color: Colors.grey[400]),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[300]))),
              ),
              Stack(
                children: <Widget>[
                  TextFormField(
                    style: GoogleFonts.nunito(color: Colors.grey[700]),
                    controller: TextEditingController(
                      text: categorySelected,
                    ),
                    onSaved: (e) => categorySelected = e,
                    validator: (e) {
                      if (e.isEmpty) {
                        return "*Input tidak boleh kosong";
                      }
                    },
                    decoration: InputDecoration(
                        hintText: 'Pilih Kategori',
                        contentPadding: EdgeInsets.symmetric(vertical: 17),
                        suffixIcon: Icon(Icons.keyboard_arrow_down),
                        hintStyle: GoogleFonts.nunito(color: Colors.grey[400]),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[300]))),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        _categoryDialog(context);
                      },
                      child: Container(
                        height: 60,
                        color: Colors.transparent,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Keterangan :',
                style:
                    GoogleFonts.nunito(fontSize: 14, color: Colors.grey[500]),
              ),
              Container(
                color: Colors.grey[100],
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  maxLines: 5,
                  style: GoogleFonts.nunito(color: Colors.grey[700]),
                  controller: TextEditingController(
                    text: description,
                  ),
                  onSaved: (e) => description = e,
                  onChanged: (e) => description = e,
                  validator: (e) {
                    if (e.isEmpty) {
                      return "*Input tidak boleh kosong";
                    }
                  },
                  decoration: InputDecoration(
                      hintText: 'Keterangan transaksi anda',
                      hintStyle: GoogleFonts.nunito(color: Colors.grey[400]),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[300]))),
                ),
              ),
              Container(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      margin: EdgeInsets.only(bottom: 15, top: 35),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.orange,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[400],
                                offset: Offset(2, 2),
                                blurRadius: 5)
                          ]),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(25),
                          splashColor: Colors.grey[800],
                          onTap: () {
                            checkFormEditData();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 13),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Tambah Transaksi',
                                  style: GoogleFonts.nunito(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ))),
            ],
          ),
        ),
      ),
    );
  }

  Future _calculatorDialog(context) async {
    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: 400,
                child: SimpleCalculator(
                  onChanged: (a, b, c) {
                    balance = b.toInt().toString();
                  },
                  theme: CalculatorThemeData(
                    commandColor: Colors.grey[300],
                    expressionColor: Colors.white,
                    operatorColor: Colors.grey[300],
                    displayColor: Colors.grey[100],
                    numStyle: GoogleFonts.nunito(),
                    commandStyle: GoogleFonts.nunito(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                    operatorStyle: GoogleFonts.nunito(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                    displayStyle:
                        GoogleFonts.nunito(fontSize: 80, color: Colors.green),
                  ),
                ),
              );
            },
          ),
          buttonPadding: EdgeInsets.all(0),
          actions: <Widget>[
            Container(
              color: Colors.green,
              child: FlatButton(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Text('ENTER',
                      style: GoogleFonts.nunito(
                          color: Colors.white, fontWeight: FontWeight.w700)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {});
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future _categoryDialog(context) async {
    _transactionBloc.add(GetListCategory(params: 'Pengeluaran'));

    String groupLabel = categorySelected;
    int idCategory = this.idCategory;

    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<TransactionBloc, TransactionState>(
          cubit: _transactionBloc,
          builder: (context, state) {
            if (state is TransactionCategory) {
              if (state.categoryModel.length == 0) {
                return AlertDialog(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Pilih Kategori',
                          style: GoogleFonts.nunito(color: Colors.grey[700])),
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CategoryScreen()));
                          },
                          child: Icon(Icons.add, color: Colors.grey[400]))
                    ],
                  ),
                  content: SingleChildScrollView(
                      child: Center(
                          child: Container(
                              padding: EdgeInsets.all(30),
                              child: Text('Kategori masih kosong',
                                  style: GoogleFonts.nunito(
                                      color: Colors.grey[300]))))),
                  actions: <Widget>[
                    FlatButton(
                      child: Row(
                        children: <Widget>[
                          Text('Batal',
                              style: GoogleFonts.nunito(
                                  color: Colors.grey[300],
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Row(
                        children: <Widget>[
                          Text('Tambah Kategori',
                              style: GoogleFonts.nunito(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryScreen()),
                        );
                      },
                    ),
                  ],
                );
              } else {
                return AlertDialog(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Pilih Kategori',
                          style: GoogleFonts.nunito(color: Colors.grey[700])),
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CategoryScreen()),
                            );
                          },
                          child: Icon(Icons.add, color: Colors.grey[400]))
                    ],
                  ),
                  content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Container(
                        height: 250,
                        child: ListView.builder(
                            itemCount: state.categoryModel.length,
                            itemBuilder: (context, index) {
                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      groupLabel = state
                                          .categoryModel[index].categoryName;
                                      idCategory =
                                          state.categoryModel[index].id;
                                    });
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Row(
                                      children: <Widget>[
                                        Radio(
                                            value: state.categoryModel[index]
                                                .categoryName,
                                            groupValue: groupLabel,
                                            onChanged: (value) {
                                              setState(() {
                                                groupLabel = value;
                                                idCategory = state
                                                    .categoryModel[index].id;
                                              });
                                            }),
                                        Text(
                                            state.categoryModel[index]
                                                .categoryName,
                                            style: GoogleFonts.nunito(
                                                color: Colors.grey[700])),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      );
                    },
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Row(
                        children: <Widget>[
                          Text('Batal',
                              style: GoogleFonts.nunito(
                                  color: Colors.grey[300],
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Row(
                        children: <Widget>[
                          Text('Pilih',
                              style: GoogleFonts.nunito(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          this.idCategory = idCategory;
                          this.categorySelected = groupLabel;
                        });
                      },
                    ),
                  ],
                );
              }
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        );
      },
    );
  }

  Future _messageDialog(context) async {
    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: <Widget>[
              Icon(Icons.check_circle, color: Colors.green, size: 40),
              SizedBox(
                width: 5,
              ),
              Text('Sukses!'),
            ],
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                child: SingleChildScrollView(
                    child: Text(
                  'Transaksi berhasil ditambahkan',
                  style: GoogleFonts.nunito(color: Colors.grey[700]),
                )),
              );
            },
          ),
          actions: <Widget>[
            FlatButton(
              child: Row(
                children: <Widget>[
                  Text('Oke',
                      style: GoogleFonts.nunito(
                          color: Colors.green, fontWeight: FontWeight.w700)),
                ],
              ),
              onPressed: () {
                setState(() {
                  tanggal = null;
                  description = null;
                  balance = null;
                  categorySelected = null;
                  idCategory = null;
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
