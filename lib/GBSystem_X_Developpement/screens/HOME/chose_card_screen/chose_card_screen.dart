import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/models/example_candidate_model.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/screens/HOME/home_page.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/screens/HOME/RECHARGE_CARD_SCANNER/recharge_card_scanner_screen.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/widgets/example_card.dart';
import 'package:scan_cart_mobilis/_RessourceStrings/GBSystem_Application_Strings.dart';

class ChoseCardScreen extends StatefulWidget {
  const ChoseCardScreen({super.key});

  @override
  State<ChoseCardScreen> createState() => _ChoseCardScreenState();
}

class _ChoseCardScreenState extends State<ChoseCardScreen> {
  final CardSwiperController controller = CardSwiperController();

  List<ExampleCard> cards = [
    ExampleCard(onTap: () {
      // Get.to(HomePage(
      //   typeCard: 1,
      //   isCommingFromOut: true,
      // ));

      Get.to(RechargeCodeScanner());
    },
        ExampleCandidateModel(
            name: "Mobilis 1000 da / 2000 da",
            job: "Flexy",
            city: "Mobilis",
            color: [
              Colors.green,
              Colors.greenAccent,
              // Colors.lightGreen,
            ])),
    ExampleCard(onTap: () {
      // Get.to(HomePage(
      //   typeCard: 2,
      //   isCommingFromOut: true,
      // ));
      Get.to(RechargeCodeScanner());
    },
        ExampleCandidateModel(
            name: "Mobilis 100 da / 200 da",
            job: "Flexy",
            city: "Mobilis (Type 1)",
            color: [
              Colors.red,
              Colors.redAccent,
              // Colors.red.shade300,
            ])),
    ExampleCard(onTap: () {
      // Get.to(HomePage(
      //   typeCard: 3,
      //   isCommingFromOut: true,
      // ));
      Get.to(RechargeCodeScanner());
    },
        ExampleCandidateModel(
            name: "Mobilis 100 da / 200 da",
            job: "Flexy",
            city: "Mobilis (Type 2)",
            color: [
              Colors.blue,
              Colors.blueAccent,
              // Colors.red.shade300,
            ])),
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        centerTitle: true,
        elevation: 4.0,
        shadowColor: GbsSystemStrings.str_primary_color,
        toolbarHeight: 80,
        backgroundColor: GbsSystemStrings.str_primary_color,
        title: const Text(
          GbsSystemStrings.str_chose_carte,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: CardSwiper(
                controller: controller,
                cardsCount: cards.length,
                onSwipe: _onSwipe,
                onUndo: _onUndo,
                numberOfCardsDisplayed: 3,
                backCardOffset: const Offset(40, 40),
                padding: const EdgeInsets.all(24.0),
                cardBuilder: (
                  context,
                  index,
                  horizontalThresholdPercentage,
                  verticalThresholdPercentage,
                ) =>
                    cards[index],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    heroTag: "undoButton",
                    onPressed: controller.undo,
                    child: const Icon(Icons.rotate_left),
                  ),
                  FloatingActionButton(
                    heroTag: "leftButton",
                    onPressed: () => controller.swipe(CardSwiperDirection.left),
                    child: const Icon(Icons.keyboard_arrow_left),
                  ),
                  FloatingActionButton(
                    heroTag: "rightButton",
                    onPressed: () =>
                        controller.swipe(CardSwiperDirection.right),
                    child: const Icon(Icons.keyboard_arrow_right),
                  ),
                  FloatingActionButton(
                    heroTag: "upButton",
                    onPressed: () => controller.swipe(CardSwiperDirection.top),
                    child: const Icon(Icons.keyboard_arrow_up),
                  ),
                  FloatingActionButton(
                    heroTag: "downButton",
                    onPressed: () =>
                        controller.swipe(CardSwiperDirection.bottom),
                    child: const Icon(Icons.keyboard_arrow_down),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint(
      'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',
    );
    return true;
  }

  bool _onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint(
      'The card $currentIndex was undod from the ${direction.name}',
    );
    return true;
  }
}
