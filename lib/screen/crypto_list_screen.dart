import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/constant/constant.dart';
import 'package:flutter_application_1/data/model/crypyo_model.dart';

class CoinCryptoScreen extends StatefulWidget {
  final List<Crypto>? cryptoList;
  const CoinCryptoScreen({super.key, this.cryptoList});
  @override
  State<CoinCryptoScreen> createState() => _CoinCryptoScreenState();
}

class _CoinCryptoScreenState extends State<CoinCryptoScreen> {
  List<Crypto>? cryptoList;
  bool loadingVisible = false;

  @override
  void initState() {
    super.initState();
    cryptoList = widget.cryptoList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blackColor,
        centerTitle: true,
        automaticallyImplyLeading: false, //برای اینکه دکمه بک رو نشون نده
        title: Text(
          'کریپتو بازار',
          style: TextStyle(color: Colors.white, fontFamily: 'morabee'),
        ),
      ),
      backgroundColor: blackColor,
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    onChanged: (value) {
                      _searchFilter(value);
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'نام رمز ارز معتبر خود را وارد کنید',
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontFamily: 'morabee',
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: greenColor,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: loadingVisible,
                child: Text(
                  'درحال اپدیت قیمت رمز ارز ها',
                  style: TextStyle(color: greenColor, fontFamily: 'morabee'),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  backgroundColor: greenColor,
                  color: blackColor,
                  strokeWidth: 2,
                  onRefresh: () async {
                    List<Crypto> fereshData = await _getData(context);
                    setState(() {
                      cryptoList = fereshData;
                    });
                  },
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: cryptoList!.length,
                    itemBuilder: (context, index) {
                      return _getListTileItem(cryptoList![index]);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getListTileItem(Crypto crypto) {
    return ListTile(
      title: Text(crypto.name, style: TextStyle(color: greenColor)),
      subtitle: Text(crypto.symbol, style: TextStyle(color: greyColor)),
      leading: SizedBox(
        width: 30,
        child: Center(
          child: Text(
            crypto.rank.toString(),
            style: TextStyle(color: greyColor),
          ),
        ),
      ),
      trailing: SizedBox(
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  crypto.priceUsd.toStringAsFixed(3),
                  style: TextStyle(color: greyColor, fontSize: 14),
                ),
                Text(
                  crypto.changePercent24Hr.toStringAsFixed(3),
                  style: TextStyle(
                    color: _textChangeColor(crypto.changePercent24Hr),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 50,
              child: Center(child: _iconChangeColor(crypto.changePercent24Hr)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconChangeColor(double changePercent) {
    return changePercent <= 0
        ? Icon(Icons.trending_down, size: 30, color: redColor)
        : Icon(Icons.trending_up, size: 30, color: greenColor);
  }

  Color _textChangeColor(double changePercent) {
    return changePercent <= 0 ? redColor : greenColor;
  }

  Future<List<Crypto>> _getData(context) async {
    var response = await Dio().get(
      'https://rest.coincap.io/v3/assets?apiKey=e9bdb4d77f65c6e71957c233f65c40a585d6209aff09742c6edacb4305132e31',
    );

    List<Crypto> cryptoList = response.data['data']
        .map<Crypto>((jsonMapObject) => Crypto.fromMapJson(jsonMapObject))
        .toList();
    return cryptoList;
  }

  Future<void> _searchFilter(String enteredKeyword) async {
    List<Crypto> resultList = [];

    if (enteredKeyword.isEmpty) {
      setState(() {
        loadingVisible = true;
      });
      var result = await _getData(context);
      setState(() {
        cryptoList = result;
        loadingVisible = false;
      });
      return;
    }

    resultList = cryptoList!.where((element) {
      return element.name.toLowerCase().contains(enteredKeyword.toLowerCase());
    }).toList();

    setState(() {
      cryptoList = resultList;
    });
  }
}
