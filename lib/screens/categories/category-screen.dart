import 'package:dompet_apps/blocs/category/category_bloc.dart';
import 'package:dompet_apps/home-screen.dart';
import 'package:dompet_apps/models/category-model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  CategoryBloc _categoryBloc = CategoryBloc();

  CategoryModel categoryModel = CategoryModel();

  Future<void> refresh() async {
    await Future.delayed(Duration(seconds: 1));
    _categoryBloc.add(GetListCategory());
  }

  _backPress() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  void initState() {
    _categoryBloc = BlocProvider.of<CategoryBloc>(context);
    _categoryBloc.add(GetListCategory());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    return BlocListener<CategoryBloc, CategoryState>(
      cubit: _categoryBloc,
      listener: (context, state) {
        if (state is AddLoadCategory) {
          _categoryBloc.add(GetListCategory());
        }
      },
      child: Scaffold(
        body: WillPopScope(
          onWillPop: () => _backPress(),
          child: SafeArea(
            child: Stack(
              children: <Widget>[
                Container(
                  child: DefaultTabController(
                    length: 2,
                    child: Scaffold(
                      appBar: AppBar(
                        automaticallyImplyLeading: false,
                        leading: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.black,
                            onTap: () => _backPress(),
                            child: Container(
                              child: Icon(Icons.arrow_back,
                                  color: Colors.grey[700]),
                            ),
                          ),
                        ),
                        backgroundColor: Colors.white,
                        bottom: TabBar(
                          indicatorColor: Colors.green,
                          tabs: [
                            Tab(
                                icon: Text('Pemasukan',
                                    style: GoogleFonts.nunito(
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w600))),
                            Tab(
                                icon: Text('Pengeluaran',
                                    style: GoogleFonts.nunito(
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w600))),
                          ],
                        ),
                        title: Text('Tambah Kategori',
                            style: GoogleFonts.nunito(color: Colors.grey[700])),
                        actions: <Widget>[
                          Container(
                            padding: EdgeInsets.only(right: 10),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  _addCategoryDialog(context);
                                },
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Icon(Icons.add,
                                        color: Colors.grey[700])),
                              ),
                            ),
                          )
                        ],
                      ),
                      body: TabBarView(
                        children: [
                          BlocBuilder<CategoryBloc, CategoryState>(
                            cubit: _categoryBloc,
                            builder: (context, state) {
                              if (state is CategoryList) {
                                return RefreshIndicator(
                                  displacement: 10,
                                  onRefresh: () {
                                    return refresh();
                                  },
                                  child: ListView.builder(
                                      itemCount: state.listCategory.length,
                                      itemBuilder: (context, index) {
                                        if (state.listCategory[index]
                                                .categoryPart ==
                                            'Pemasukan') {
                                          return Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(state.listCategory[index]
                                                    .categoryName, style: GoogleFonts.nunito(color:Colors.grey[700])),
                                                Row(
                                                  children: <Widget>[
                                                    Material(
                                                        color:
                                                            Colors.transparent,
                                                        child: InkWell(
                                                            onTap: () {
                                                              _editCategoryDialog(
                                                                  context,
                                                                  state
                                                                      .listCategory[
                                                                          index]
                                                                      .categoryName,
                                                                  state
                                                                      .listCategory[
                                                                          index]
                                                                      .categoryPart,
                                                                  state
                                                                      .listCategory[
                                                                          index]
                                                                      .id);
                                                            },
                                                            child: Icon(
                                                                Icons.edit,
                                                                color:
                                                                    Colors.grey[
                                                                        700]))),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Material(
                                                        color:
                                                            Colors.transparent,
                                                        child: InkWell(
                                                            onTap: () {
                                                              _deleteCategoryDialog(
                                                                  context,
                                                                  state
                                                                      .listCategory[
                                                                          index]
                                                                      .id);
                                                            },
                                                            child: Icon(
                                                                Icons.delete,
                                                                color:
                                                                    Colors.grey[
                                                                        700]))),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      }),
                                );
                              }

                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                          BlocBuilder<CategoryBloc, CategoryState>(
                            cubit: _categoryBloc,
                            builder: (context, state) {
                              if (state is CategoryList) {
                                return RefreshIndicator(
                                  displacement: 20,
                                  onRefresh: () {
                                    return refresh();
                                  },
                                  child: ListView.builder(
                                      itemCount: state.listCategory.length,
                                      itemBuilder: (context, index) {
                                        if (state.listCategory[index]
                                                .categoryPart ==
                                            'Pengeluaran') {
                                          return Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(state.listCategory[index]
                                                    .categoryName, style: GoogleFonts.nunito(color:Colors.grey[700])),
                                                Row(
                                                  children: <Widget>[
                                                    Material(
                                                        color:
                                                            Colors.transparent,
                                                        child: InkWell(
                                                            onTap: () {
                                                              _editCategoryDialog(
                                                                  context,
                                                                  state
                                                                      .listCategory[
                                                                          index]
                                                                      .categoryName,
                                                                  state
                                                                      .listCategory[
                                                                          index]
                                                                      .categoryPart,
                                                                  state
                                                                      .listCategory[
                                                                          index]
                                                                      .id);
                                                            },
                                                            child: Icon(
                                                                Icons.edit,
                                                                color:
                                                                    Colors.grey[
                                                                        700]))),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Material(
                                                        color:
                                                            Colors.transparent,
                                                        child: InkWell(
                                                            onTap: () {
                                                              _deleteCategoryDialog(
                                                                  context,
                                                                  state
                                                                      .listCategory[
                                                                          index]
                                                                      .id);
                                                            },
                                                            child: Icon(
                                                                Icons.delete,
                                                                color:
                                                                    Colors.grey[
                                                                        700]))),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      }),
                                );
                              }

                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _addCategoryDialog(context) async {
    final _keyData = new GlobalKey<FormState>();
    String namaKategori;
    String jenisKategori = "Pemasukan";

    //vallidate input Form edit
    checkFormEditData() {
      final form = _keyData.currentState;
      if (form.validate()) {
        form.save();
        Navigator.pop(context);
        categoryModel = CategoryModel(
            categoryName: namaKategori, categoryPart: jenisKategori);
        _categoryBloc.add(AddCategory(categoryModel: categoryModel));
      }
    }

    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        // int selectedRadio = 0;
        return AlertDialog(
          title: Text('Tambah Kategori'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Form(
                  key: _keyData,
                  child: ListBody(
                    children: <Widget>[
                      TextFormField(
                        style: GoogleFonts.nunito(color: Colors.grey[700]),
                        onSaved: (e) => namaKategori = e,
                        validator: (e) {
                          if (e.isEmpty) {
                            return "*Input tidak boleh kosong";
                          }
                        },
                        decoration: InputDecoration(
                            hintText: "Nama Kategori",
                            hintStyle:
                                GoogleFonts.nunito(color: Colors.grey[400]),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey[300]))),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButton<String>(
                        isExpanded: true,
                        onChanged: (String value) {
                          setState(() {
                            jenisKategori = value;
                            print(value);
                          });
                        },
                        value: jenisKategori,
                        items: <String>['Pemasukan', 'Pengeluaran']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: GoogleFonts.nunito(
                                    color: Colors.grey[700])),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                ),
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
                  Text('Tambah Kategori',
                      style: GoogleFonts.nunito(
                          color: Colors.green, fontWeight: FontWeight.w700)),
                ],
              ),
              onPressed: () {
                checkFormEditData();
              },
            ),
          ],
        );
      },
    );
  }

  Future _editCategoryDialog(
      context, String namaKategori, String jenisKategori, int id) async {
    final _keyData = new GlobalKey<FormState>();

    //vallidate input Form edit
    checkFormEditData() {
      final form = _keyData.currentState;
      if (form.validate()) {
        form.save();
        Navigator.pop(context);
        categoryModel = CategoryModel(
            id: id, categoryName: namaKategori, categoryPart: jenisKategori);
        _categoryBloc.add(UpdateCategory(categoryModel: categoryModel, id: id));
      }
    }

    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ubah Kategori'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Form(
                  key: _keyData,
                  child: ListBody(
                    children: <Widget>[
                      TextFormField(
                        style: GoogleFonts.nunito(color: Colors.grey[700]),
                        onSaved: (e) => namaKategori = e,
                        initialValue: namaKategori,
                        validator: (e) {
                          if (e.isEmpty) {
                            return "*Input tidak boleh kosong";
                          }
                        },
                        decoration: InputDecoration(
                            hintText: "Nama Kategori",
                            hintStyle:
                                GoogleFonts.nunito(color: Colors.grey[400]),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey[300]))),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButton<String>(
                        isExpanded: true,
                        onChanged: (String value) {
                          setState(() {
                            jenisKategori = value;
                            print(value);
                          });
                        },
                        value: jenisKategori,
                        items: <String>['Pemasukan', 'Pengeluaran']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: GoogleFonts.nunito(
                                    color: Colors.grey[700])),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                ),
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
                  Text('Ubah Kategori',
                      style: GoogleFonts.nunito(
                          color: Colors.green, fontWeight: FontWeight.w700)),
                ],
              ),
              onPressed: () {
                checkFormEditData();
              },
            ),
          ],
        );
      },
    );
  }

  Future _deleteCategoryDialog(context, int id) async {
    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                child: SingleChildScrollView(
                    child: Text(
                  'Apakah anda yakin ingin menghapus kategori?',
                  style: GoogleFonts.nunito(color: Colors.grey[700]),
                )),
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
                  Text('Ya, hapus',
                      style: GoogleFonts.nunito(
                          color: Colors.green, fontWeight: FontWeight.w700)),
                ],
              ),
              onPressed: () {
                Navigator.pop(context);
                _categoryBloc.add(DeleteCategory(id: id));
              },
            ),
          ],
        );
      },
    );
  }
}
