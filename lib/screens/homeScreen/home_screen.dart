import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_banking_pay_responsive/components/app_bar_complete.dart';
import 'package:flutter_banking_pay_responsive/components/app_floating_button_speed_dial.dart';
import 'package:flutter_banking_pay_responsive/components/card_widget.dart';
import 'package:flutter_banking_pay_responsive/components/google_list_decorations.dart';
import 'package:flutter_banking_pay_responsive/components/transaction_widget.dart';
import 'package:flutter_banking_pay_responsive/data_providers.dart';
import 'package:flutter_banking_pay_responsive/generated/l10n.dart';
import 'package:flutter_banking_pay_responsive/main.dart';
import 'package:flutter_banking_pay_responsive/models/enums.dart';
import 'package:flutter_banking_pay_responsive/responsive.dart';
import 'package:flutter_banking_pay_responsive/screens/homeScreen/recent_transactions_section.dart';
import 'package:flutter_banking_pay_responsive/screens/homeScreen/user_cards_section.dart';
import 'package:flutter_banking_pay_responsive/screens/settingsScreen/settings_screen.dart';
import 'package:flutter_banking_pay_responsive/screens/setupScreen/setup_screen.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import 'categories_cards.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static EdgeInsets desiredPadding = const EdgeInsets.only(
      left: kDefaultPadding, right: kDefaultPadding, top: kHalfPadding);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isFloatingButtonVisible = true;
  final ValueNotifier<bool> openCloseState = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    final providerSetup = Provider.of<SetupScreen>(context, listen: false);

    SchedulerBinding.instance?.addPostFrameCallback((duration) {
      providerSetup.quickActionsList.initialize((String type) {
        // TODO: add other types
        if (type == QuickActionState.transactionsOptions.toString()) {
          // providerSetup.keySetupScreen.currentState?.changeSelectedMenu(0);
          print("Should've open FAB");
          openFAB();
        }
      });
    });
  }

  void openFAB() {
    _isFloatingButtonVisible = true;
    setState(() {
      ValueNotifier(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    MyApp.changeWebAppTabName(label: null);

    return WillPopScope(
      onWillPop: () async {
        /// close speed dial FAB
        // if (openCloseState.value == true) {
        openCloseState.value = false;
        // TODO: this is not working

        return false;
      },
      child: Scaffold(
        appBar: AppBarComplete(
          // key: // TODO,
          title: S.of(context).homeScreen_first_tabBarTitle,
          hasSearchField: true,
          hasDarkThemeToggle: true,
        ),
        // Cards
        floatingActionButton: _isFloatingButtonVisible
            ? AppFloatingButtonSpeedDial(
                label: S.of(context).homeScreen_fab_title,
                icon: Icons.read_more_rounded,
                tooltip: S.of(context).homeScreen_TOOLTIP_fab_options,
                openCloseState: openCloseState,
              )
            : AppFloatingButtonSpeedDial(
                label: null,
                icon: Icons.read_more_rounded,
                tooltip: S.of(context).homeScreen_TOOLTIP_fab_options,
                openCloseState: openCloseState,
              ),
        floatingActionButtonLocation: kFloatingButtonLocationFixed(context),
        body: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            // Get screen page scroll and block children widget listviews scroll notifications
            if (notification.metrics.axis != Axis.vertical) {
              return true;
            }
            if (notification.direction == ScrollDirection.forward) {
              if (!_isFloatingButtonVisible)
                setState(() => _isFloatingButtonVisible = true);
            } else if (notification.direction == ScrollDirection.reverse) {
              if (_isFloatingButtonVisible)
                setState(() => _isFloatingButtonVisible = false);
            }
            return true;
          },
          // Un focus keyboard/textfield
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            behavior: HitTestBehavior.translucent,
            excludeFromSemantics: true,
            child: Scrollbar(
              isAlwaysShown: WebProvider.isWebPlatform,
              // showTrackOnHover: WebProvider.isWebPlatform,
              child: ListView(
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                // padding: const EdgeInsets.symmetric
                children: [
                  Padding(
                    padding: !WebProvider.isWebPlatform
                        ? EdgeInsets.zero
                        : HomeScreen.desiredPadding.copyWith(top: 0, bottom: 0),
                    child: ResponsiveWidthConstrained(
                      child: Semantics(
                        child: UserCardsSection(
                            desiredPadding: HomeScreen.desiredPadding),
                        label: S
                            .of(context)
                            .homeScreen_userCardSection_pageSubtitle,
                        slider: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: kHalfPadding),
                  Padding(
                      padding: HomeScreen.desiredPadding,
                      child: ResponsiveWidthConstrained(
                          child: Semantics(child: const CategoriesSection()))),
                  const SizedBox(height: kHalfPadding),
                  Padding(
                      padding: HomeScreen.desiredPadding,
                      child: ResponsiveWidthConstrained(
                        child:
                            Semantics(child: const RecentTransactionsSection()),
                      )),
                  const SizedBox(height: kDefaultPadding),
                  const SizedBox(height: kDefaultPadding),
                  ResponsiveWidthConstrained(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                          maxWidth: kMaxButtonConstraintWidth),
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: kHugePadding * 2.5),
                        color: Theme.of(context).primaryColorLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: kDefaultBorderRadius,
                          side: BorderSide(width: 2, color: kLightGrayColor),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: kHalfPadding, horizontal: 3),
                          child: BuildGoogleListButton(
                            icon: Icons.settings_rounded,
                            label: S
                                .of(context)
                                .googleAccountDialog_settings_button_title,
                            alignment: MainAxisAlignment.center,
                            onPress: () {
                              // do not .pop
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const SettingsScreen()),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ShimmerHomeScreen extends StatelessWidget {
  const ShimmerHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: ShimmerProgressIndicator(
      //   child: FloatingActionButton.extended(
      //     clipBehavior: Clip.antiAlias,
      //     onPressed: () {},
      //     label: const Text('hahahahaha'),
      //     icon: const Icon(Icons.send),
      //     backgroundColor:
      //         ShimmerProgressIndicator.themeDependentBaseColor(context),
      //     shape: RoundedRectangleBorder(borderRadius: kDefaultBorderRadius),
      //   ),
      // ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: kBottomNavigationHeight(context),
        color: Colors.transparent,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // AppBar
            ShimmerProgressIndicator(
              child: Container(
                width: double.infinity,
                height: const AppBarComplete().preferredSize.height,
                color: Colors.black,
              ),
            ),
            ResponsiveWidthConstrained(
              /// hide scroll bar on loading shimmer
              child: Scrollbar(
                interactive: false,
                showTrackOnHover: false,
                isAlwaysShown: false,
                thickness: 0.0,
                hoverThickness: 0.0,
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  children: [
                    // AppBar safe area
                    SizedBox(
                        height: const AppBarComplete().preferredSize.height),
                    // CardWidget List
                    Padding(
                      padding: HomeScreen.desiredPadding.copyWith(right: 0),
                      child: SizedBox(
                        height: 220,
                        child: ListView.separated(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (_, index) {
                            return const SizedBox(width: kHalfPadding);
                          },
                          itemCount: 5,
                          itemBuilder: (_, index) => ShimmerProgressIndicator(
                              child: CardWidget.defaultDimensionColored),
                        ),
                      ),
                    ),
                    // Categories List
                    Padding(
                      padding: HomeScreen.desiredPadding
                          .copyWith(top: kHugePadding, bottom: kHugePadding),
                      child: SizedBox(
                        height: 70,
                        child: ListView.separated(
                          clipBehavior: Clip.antiAlias,
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (_, index) => const SizedBox(
                              width: kHalfPadding * 1.1, height: kHalfPadding),
                          itemCount: 5,
                          itemBuilder: (_, index) => ShimmerProgressIndicator(
                            child: CategoryCard.defaultDimensionColored,
                          ),
                        ),
                      ),
                    ),
                    // Transactions List
                    Padding(
                      padding: HomeScreen.desiredPadding.copyWith(right: 170),
                      child: ShimmerProgressIndicator(
                        child: Container(
                          height: kHalfPadding * 1.2,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: HomeScreen.desiredPadding,
                      child: SizedBox(
                        height: 800,
                        child: ListView.separated(
                          clipBehavior: Clip.antiAlias,
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (_, index) {
                            return const SizedBox(height: kHalfPadding);
                          },
                          itemCount: ksMaxRecentTransactionsCount,
                          itemBuilder: (_, index) => ShimmerProgressIndicator(
                            child: TransactionCard.defaultDimensionColored,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: CircularProgressIndicator(
                  strokeWidth: 6, color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}
