import 'package:cargo/fragments/MyQuoteFragment.dart';
import 'package:cargo/fragments/RequestQuoteFragment.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShExtension.dart';
import 'package:cargo/utils/ShStrings.dart';
import 'package:flutter/material.dart';

class QuoteFragment extends StatefulWidget {
  @override
  _QuoteFragmentState createState() => _QuoteFragmentState();
}

class _QuoteFragmentState extends State<QuoteFragment>
    with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2,initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: sh_background_color,
        height: height - 74,
        child: Stack(
          children: <Widget>[
            Container(
              height: 70,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24)),
                  shape: BoxShape.rectangle,
                  color: sh_app_background),
            ),
            Container(
                height: height,
                padding: EdgeInsets.fromLTRB(0, 16, 0, 84),
                child: DefaultTabController(
                  length: 2,
                  child: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverPersistentHeader(
                          delegate: _SliverAppBarDelegate(
                            TabBar(
                              controller: _tabController,
                              labelColor: sh_white,
                              indicatorColor: sh_white,
                              unselectedLabelColor: sh_textColorPrimary,
                              tabs: [
                                Tab(
                                  text: cargo_my_quotes,
                                ),
                                Tab(
                                  text: cargo_reqst_quotes,
                                ),
                              ],
                            ),
                          ),
                          pinned: true,
                        ),
                      ];
                    },
                    body: Container(
                      margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          MyQuoteFragment(),
                          RequestQuoteFragment(),
                        ],
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}


class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      color: sh_app_background,
      child: Container(child: _tabBar),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
