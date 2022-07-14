
import 'package:annonce/model/country/code_countrys.dart';
import 'package:annonce/model/country/code_country.dart';
import 'package:flutter/material.dart';
import 'package:annonce/model/country/selection_list.dart';


class CountryList extends StatefulWidget {
  CountryList(
      {this.onChanged,
      this.isShowFlag,
      this.isDownIcon,
      this.isShowCode,
      this.isShowTitle,
      this.initialSelection});
  final bool isShowTitle;
  final bool isShowFlag;
  final bool isShowCode;
  final bool isDownIcon;
  final String initialSelection;
  final ValueChanged<CountryCode> onChanged;

  @override
  _CountryListState createState() {
    List<Map> jsonList = codes;

    List<CountryCode> elements = jsonList
        .map((s) => CountryCode(
              name: s['name'],
              code: s['code'],
              dialCode: s['dial_code'],
              flag: 'flags/${s['code'].toLowerCase()}.png',
            ))
        .toList();
    return _CountryListState(elements);
  }
}

class _CountryListState extends State<CountryList> {
  CountryCode selectedItem;
  List<CountryCode> elements = [];
  _CountryListState(this.elements);

  @override
  void initState() {
    if (widget.initialSelection != null) {
      selectedItem = elements.firstWhere(
          (e) =>
              (e.code.toUpperCase() == widget.initialSelection.toUpperCase()) ||
              (e.dialCode == widget.initialSelection.toString()),
          orElse: () => elements[0]);
    } else {
      selectedItem = elements[0];
    }

    super.initState();
  }

  void getSelectItem(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectionList(elements, selectedItem),
        ));

    setState(() {
      selectedItem = result ?? selectedItem;
      widget.onChanged(result ?? selectedItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        getSelectItem(context);
      },
      child: Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (widget.isShowFlag == true)
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Image.asset(
                  selectedItem.flag,
                  width: 32.0,
                ),
              ),
            ),
          if (widget.isShowCode == true)
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(selectedItem.toString()),
              ),
            ),
          if (widget.isShowTitle == true)
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(selectedItem.toCountryStringOnly()),
              ),
            ),
          if (widget.isDownIcon == true)
            Flexible(
              child: Icon(Icons.keyboard_arrow_down),
            )
        ],
      ),
    );
  }
}
