import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:store_app/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store_app/consts/global_consts.dart';
import 'package:store_app/models/product.dart';
import 'package:store_app/provider/dark_theme_provider.dart';
import 'package:store_app/provider/products.dart';
import 'package:store_app/services/global_method.dart';
import 'package:uuid/uuid.dart';

class UploadProductForm extends StatefulWidget {
  static const routeName = '/UploadProductForm';

  const UploadProductForm({super.key});

  @override
  _UploadProductFormState createState() => _UploadProductFormState();
}

class _UploadProductFormState extends State<UploadProductForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalMethods globalMethods = GlobalMethods();
  var _productTitle = '';
  var _productPrice = '';

  var _productDescription = '';
  var _productQuantity = '';
  final TextEditingController _categoryController =
      TextEditingController(text: "choose category");
  final TextEditingController _brandController =
      TextEditingController(text: "choose brand");

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalMethods _globalMethods = GlobalMethods();

  File? _pickedImage;
  bool _isLoading = false;
  String? url;

//________________ 1 ________________________
// function for upload new product to firebase
  Future uploadProduct(BuildContext ctx) async {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    if (isValid != null) {
      if (isValid) {
        if (_categoryController.text == "choose category") {
          _globalMethods.showAlertDialog(ctx, "Empty", "Enter Category field");
          return;
        }
        if (_brandController.text == "choose brand") {
          _globalMethods.showAlertDialog(ctx, "Empty", "Enter Brand field");
          return;
        }
        if (_pickedImage == null) {
          _globalMethods.showAlertDialog(ctx, "Empty", "Enter product Image");
          return;
        }
        _formKey.currentState!.save();
        final productName = _productTitle.trim().replaceAll(' ', '');
        try {
          if (_pickedImage == null) {
            _globalMethods.authErrorHandle('Please pick an image', context);
          } else {
            setState(() {
              _isLoading = true;
            });
            final ref = FirebaseStorage.instance
                .ref()
                .child('productsImages')
                .child('$productName.jpg');
            await ref.putFile(_pickedImage!);
            url = await ref.getDownloadURL();

            final User user = _auth.currentUser!;
            final uid = user.uid;
            final productId = const Uuid().v4();
            await FirebaseFirestore.instance
                .collection('products')
                .doc(productId)
                .set({
              'productId': productId,
              'productTitle': _productTitle,
              'price': double.parse(_productPrice),
              'productImage': url,
              'productCategory': _categoryController.text.trim(),
              'productBrand': _brandController.text.trim(),
              'productDescription': _productDescription,
              'productQuantity': int.parse(_productQuantity),
              'userId': uid,
              'createdAt': Timestamp.now(),
              'isPopular': false
            });
            // Navigator.canPop(context) ? Navigator.pop(context) : null;
          }
        } on FirebaseException catch (error) {
          _globalMethods.authErrorHandle(error.code, context);
          print('error occured ${error.message}');
        } on SocketException {
          _globalMethods.showAlertDialog(
              ctx, "NO internet", "Pleasee check your connection internet ! ");
        } catch (error) {
          _globalMethods.authErrorHandle(error.toString(), context);
        } finally {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Sucessfully"),
            backgroundColor: Colors.green,
          ));
          // final productsData = Provider.of<Products>(
          //   context,
          // );
          // productsData.fetchProducts();
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else if (isValid == null) {
      globalMethods.showDialogg("Empty", "enter empty fields", () {
        Navigator.canPop(context) ? Navigator.of(context).pop() : null;
      }, context);
    }
  }

/*
//________________ 2 ________________________
//________________________________________________
  Future addAllProducts(BuildContext ctx, List<Product> productsList) async {
    setState(() {
      _isLoading = true;
    });
    for (int i = 0; i < productsList.length; i++) {
      // final productName = productsList[i].title.trim();
      final productName = i + 1;
      try {
        final ref = FirebaseStorage.instance
            .ref()
            .child('productsImages')
            .child('$productName.jpg');
        // await ref.putFile(_pickedImage!);
        //await ref.putFile(File(productsList[i].imageUrl));
        final url = await ref.getDownloadURL();

        final User user = _auth.currentUser!;
        final uid = user.uid;
        final productId = const Uuid().v4();
        await FirebaseFirestore.instance
            .collection('products')
            .doc(productId)
            .set({
          'productId': productId,
          'productTitle': productsList[i].title.trim(),
          'price': productsList[i].price,
          'productImage': url, //productsList[i].imageUrl,
          'productCategory': productsList[i].productCategoryName.trim(),
          'productBrand': productsList[i].brand.trim(),
          'productDescription': productsList[i].description.trim(),
          'productQuantity': productsList[i].quantity,
          'userId': uid,
          'createdAt': Timestamp.now(),
          'isPopular': productsList[i].isPopular
        });
      } on FirebaseException catch (error) {
        _globalMethods.authErrorHandle(error.code, context);
        print('error occured ${error.message}');
      } on SocketException {
        _globalMethods.showAlertDialog(
            ctx, "NO internet", "Pleasee check your connection internet ! ");
      } catch (error) {
        _globalMethods.authErrorHandle(error.toString(), context);
      } finally {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Sucessfully"),
          backgroundColor: Colors.green,
        ));
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

*/

//________________ 3 ________________________
//------------------------------------------------------
// pick image for the new product from camera
  void _pickImageCamera() async {
    final picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 40,
    );
    if (pickedImage != null) {
      final pickedImageFile = File(pickedImage.path);
      setState(() {
        _pickedImage = pickedImageFile;
      });
    }
    // widget.imagePickFn(pickedImageFile);
  }

//________________ 4 ________________________
//-----------------------------------------
  void _pickImageGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    final pickedImageFile = pickedImage == null ? null : File(pickedImage.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    // widget.imagePickFn(pickedImageFile);
  }

//________________ 5 ________________________
//---------------------------------------
  void _removeImage() {
    setState(() {
      _pickedImage = null;
    });
  }

//----------------------------------------
  @override
  void initState() {
    super.initState();
    _pickedImage = null;
  }

  @override
  void dispose() {
    _brandController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    Size size = MediaQuery.of(context).size;
    final productsProvider = Provider.of<Products>(context, listen: false);
    List<Product> productsList = productsProvider.products;
    return Scaffold(
      bottomSheet: Container(
        height: kBottomNavigationBarHeight * 0.8,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsConsts.white,
          border: const Border(
            top: BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
        ),
        child: Material(
          color: Theme.of(context).backgroundColor,
          child: InkWell(
            onTap: () {
              uploadProduct(context);
              //addAllProducts(context, productsList);
            },
            splashColor: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(right: 2),
                  child: Text('Upload',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center),
                ),
                GradientIcon(
                  Ionicons.cloud_upload,
                  20,
                  LinearGradient(
                    colors: <Color>[
                      Colors.green,
                      Colors.yellow,
                      Colors.deepOrange,
                      Colors.orange,
                      Colors.yellow.shade800
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Center(
                  child: Card(
                    margin: const EdgeInsets.all(15),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 9),
                                    child: TextFormField(
                                      key: const ValueKey('Title'),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a Title';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: const InputDecoration(
                                        labelText: 'Product Title',
                                      ),
                                      onSaved: (value) {
                                        _productTitle = value ?? "";
                                      },
                                    ),
                                  ),
                                ),
                                //   FormField(builder: builder)
                                Flexible(
                                  flex: 1,
                                  child: TextFormField(
                                    key: const ValueKey('Price'),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a Title';
                                      }
                                      return null;
                                    },
                                    // inputFormatters: <TextInputFormatter>[
                                    //   FilteringTextInputFormatter.allow(
                                    //       RegExp(r'[0-9]')),
                                    // ],
                                    decoration: const InputDecoration(
                                      labelText: 'Price \$',
                                      //  prefixIcon: Icon(Icons.mail),
                                      // suffixIcon: Text(
                                      //   '\n \n \$',
                                      //   textAlign: TextAlign.start,
                                      // ),
                                    ),
                                    //obscureText: true,
                                    onSaved: (value) {
                                      if (value != null) {
                                        _productPrice = value;
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            /* Image picker here ***********************************/

                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  //  flex: 2,
                                  child: _pickedImage == null
                                      ? Container(
                                          margin: const EdgeInsets.all(10),
                                          height: 200,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 1),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: Theme.of(context)
                                                .backgroundColor,
                                          ),
                                        )
                                      : Container(
                                          margin: const EdgeInsets.all(10),
                                          height: 200,
                                          width: 200,
                                          child: Container(
                                            height: 200,
                                            // width: 200,
                                            decoration: BoxDecoration(
                                              // borderRadius: BorderRadius.only(
                                              //   topLeft: const Radius.circular(40.0),
                                              // ),
                                              color: Theme.of(context)
                                                  .backgroundColor,
                                            ),
                                            child: _pickedImage != null
                                                ? Image.file(
                                                    _pickedImage!,
                                                    fit: BoxFit.contain,
                                                    alignment: Alignment.center,
                                                  )
                                                : Image.asset(
                                                    //"assets/images/exclamation_mark.png",
                                                    "assets/images/person.jpg",
                                                    fit: BoxFit.contain,
                                                    alignment: Alignment.center,
                                                  ),
                                          ),
                                        ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FittedBox(
                                      child: TextButton.icon(
                                        onPressed: _pickImageCamera,
                                        icon: const Icon(Icons.camera,
                                            color: Colors.purpleAccent),
                                        label: Text(
                                          'Camera',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: themeChange.darkTheme
                                                ? ColorsConsts.white
                                                : ColorsConsts.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      child: TextButton.icon(
                                        //  textColor: Colors.white,
                                        onPressed: _pickImageGallery,
                                        icon: const Icon(Icons.image,
                                            color: Colors.purpleAccent),
                                        label: Text(
                                          'Gallery',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: themeChange.darkTheme
                                                ? ColorsConsts.white
                                                : ColorsConsts.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      child: TextButton.icon(
                                        //textColor: Colors.white,
                                        onPressed: _removeImage,
                                        icon: const Icon(
                                          Icons.remove_circle_rounded,
                                          color: Colors.red,
                                        ),
                                        label: const Text(
                                          'Remove',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  // flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 9),
                                    child: Container(
                                      child: InkWell(
                                        onTap: () {
                                          showTaskCategoryDialog(context, size);
                                        },
                                        child: TextFormField(
                                          controller: _categoryController,

                                          key: const ValueKey('Category'),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter a Category';
                                            }
                                            return null;
                                          },
                                          enabled: false,
                                          //keyboardType: TextInputType.emailAddress,
                                          decoration: const InputDecoration(
                                            labelText: 'Category',
                                          ),
                                          // onSaved: (value) {
                                          //   _productCategory = value ?? "";
                                          // },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 9),
                                    child: Container(
                                      child: TextFormField(
                                        controller: _brandController,
                                        enabled: false,
                                        key: const ValueKey('Brand'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Brand is missed';
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                          labelText: 'Brand',
                                        ),
                                        onSaved: (value) {
                                          _brandController.text = value ?? "";
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                DropdownButton(
                                  hint: const Text('Select a Brand'),
                                  value: 'Brandless', //_brandController.text,
                                  items: const [
                                    DropdownMenuItem<String>(
                                      value: 'Brandless',
                                      child: Text('Brandless'),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'Addidas',
                                      child: Text('Addidas'),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'Apple',
                                      child: Text('Apple'),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'Dell',
                                      child: Text('Dell'),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'H&M',
                                      child: Text('H&M'),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'Nike',
                                      child: Text('Nike'),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'Samsung',
                                      child: Text('Samsung'),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'Huawei',
                                      child: Text('Huawei'),
                                    ),
                                  ],
                                  onChanged: (String? value) {
                                    if (value != null) {
                                      setState(() {
                                        _brandController.text = value;
                                      });
                                    } else if (value == null) {
                                      setState(() {
                                        _brandController.text = "brand";
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                                key: const ValueKey('Description'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'product description is required';
                                  }
                                  return null;
                                },
                                //controller: this._controller,
                                maxLines: 10,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: const InputDecoration(
                                  labelText: 'Description',
                                  hintText: 'Product description',
                                  border: OutlineInputBorder(),
                                ),
                                onSaved: (value) {
                                  _productDescription = value ?? "";
                                },
                                onChanged: (text) {
                                  // setState(() => charLength -= text.length);
                                }),
                            //    SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  //flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 9),
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      key: const ValueKey('Quantity'),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Quantity is missed';
                                        }
                                        return null;
                                      },
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]')), // or
                                        //  FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: const InputDecoration(
                                        labelText: 'Quantity',
                                      ),
                                      onSaved: (value) {
                                        _productQuantity = value ?? "";
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            ),

            ///
            _isLoading
                ? const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.pink,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  //______________________

  void showTaskCategoryDialog(context, size) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Choose Category",
              style: TextStyle(color: Colors.pink.shade400, fontSize: 20),
            ),
            content: SizedBox(
              width: size.width * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Constants.categories.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _categoryController.text =
                              Constants.categories[index]['categoryName'];
                        });

                        Navigator.canPop(context)
                            ? Navigator.pop(context)
                            : null;
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: Colors.red.shade400,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Constants.categories[index]['categoryName'],
                              style: const TextStyle(
                                  //color: Color(0xFF00325A), //0xFF00325A
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: const Text('Close')),
            ],
          );
        });
  }

  //______________________
}

class GradientIcon extends StatelessWidget {
  const GradientIcon(
    this.icon,
    this.size,
    this.gradient,
  );

  final IconData icon;
  final double size;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: SizedBox(
        width: size * 1.2,
        height: size * 1.2,
        child: Icon(
          icon,
          size: size,
          color: Colors.white,
        ),
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, size, size);
        return gradient.createShader(rect);
      },
    );
  }
}
