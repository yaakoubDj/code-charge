import 'package:flutter/material.dart';

class CustomDropDownButtonString extends StatelessWidget {
  const CustomDropDownButtonString({
    super.key,
    required this.selectedItem,
    required this.listItems,
    required this.hint,
    this.onChanged,
    this.validator,
    this.onTap,
    this.width,
  });
  final double? width;
  final String? selectedItem;
  final List<String?>? listItems;
  final String hint;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: width,
      padding: EdgeInsets.all(size.width * 0.01),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(12)),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
            onTap: onTap,
            decoration: const InputDecoration(border: InputBorder.none),
            validator: validator,
            isExpanded: true,
            hint: selectedItem == null
                ? Center(child: Text(hint))
                : Text(selectedItem!),
            value: selectedItem,
            items: listItems != null
                ? listItems!
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item!,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ))
                    .toList()
                : null,
            onChanged: onChanged),
      ),
    );
  }
}

class CustomDropDownSelectLanguage extends StatelessWidget {
  const CustomDropDownSelectLanguage(
      {super.key, required this.selectedItem, required this.onChanged});
  final String? selectedItem;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: DropdownButton<String>(
          value: selectedItem,
          underline: Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.transparent)),
            ),
          ),
          items: [
            DropdownMenuItem(
                value: "fr",
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Image.asset(
                        "assets/images/flags/france.png",
                        width: 25,
                        height: 25,
                      ),
                    ),
                    const Text("fr")
                  ],
                )),
            DropdownMenuItem(
                value: "en",
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Image.asset(
                        "assets/images/flags/england.png",
                        width: 25,
                        height: 25,
                      ),
                    ),
                    const Text("en")
                  ],
                )),
            DropdownMenuItem(
                value: "de",
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Image.asset(
                        "assets/images/flags/germany.png",
                        width: 25,
                        height: 25,
                      ),
                    ),
                    const Text("de")
                  ],
                )),
            DropdownMenuItem(
                value: "es",
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Image.asset(
                        "assets/images/flags/spain.png",
                        width: 25,
                        height: 25,
                      ),
                    ),
                    const Text("es")
                  ],
                )),
            DropdownMenuItem(
                value: "pt",
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Image.asset(
                        "assets/images/flags/portugal.png",
                        width: 25,
                        height: 25,
                      ),
                    ),
                    const Text("pt")
                  ],
                )),
            DropdownMenuItem(
                value: "tr",
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Image.asset(
                        "assets/images/flags/turkey.png",
                        width: 25,
                        height: 25,
                      ),
                    ),
                    const Text("tr")
                  ],
                )),
            DropdownMenuItem(
                value: "el",
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Image.asset(
                        "assets/images/flags/greece.png",
                        width: 25,
                        height: 25,
                      ),
                    ),
                    const Text("el")
                  ],
                )),
            DropdownMenuItem(
                value: "ro",
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Image.asset(
                        "assets/images/flags/romania.png",
                        width: 25,
                        height: 25,
                      ),
                    ),
                    const Text("ro")
                  ],
                )),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// class CustomDropDownButtonPlanningDisponible extends StatelessWidget {
//   const CustomDropDownButtonPlanningDisponible({
//     super.key,
//     required this.selectedItem,
//     required this.listItems,
//     required this.hint,
//     this.onChanged,
//     this.validator,
//     this.onTap,
//   });

//   final PlanningDisponibleModel? selectedItem;
//   final List<PlanningDisponibleModel> listItems;
//   final String hint;
//   final void Function()? onTap;
//   final String? Function(PlanningDisponibleModel?)? validator;
//   final void Function(PlanningDisponibleModel?)? onChanged;
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.all(size.width * 0.01),
//         decoration: BoxDecoration(
//             color: Colors.white,
//             border: Border.all(color: Colors.grey, width: 0),
//             borderRadius: BorderRadius.circular(20)),
//         child: DropdownButtonHideUnderline(
//           child: DropdownButtonFormField<PlanningDisponibleModel>(
//               // onTap: onTap,
//               decoration: const InputDecoration(border: InputBorder.none),
//               validator: validator,
//               isExpanded: true,
//               hint: selectedItem == null
//                   ? Center(child: Text(hint))
//                   : Text(selectedItem!.MONTH_NAME!),
//               value: selectedItem,
//               items: listItems
//                   .map((item) => DropdownMenuItem<PlanningDisponibleModel>(
//                       value: item,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Text(
//                             item.MONTH_NAME!,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                                 fontSize: 18,
//                                 //fontFamily: 'BebasNeue',
//                                 fontWeight: FontWeight.w500),
//                           ),
//                         ],
//                       )))
//                   .toList(),
//               onChanged: onChanged),
//         ),
//       ),
//     );
//   }
// }

// class CustomDropDownButtonTypeMessage extends StatelessWidget {
//   const CustomDropDownButtonTypeMessage({
//     super.key,
//     required this.selectedItem,
//     required this.listItems,
//     required this.hint,
//     this.onChanged,
//     this.validator,
//     this.onTap,
//     this.width,
//   });
//   final double? width;
//   final String? selectedItem;
//   final List<String?>? listItems;
//   final String hint;
//   final void Function()? onTap;
//   final String? Function(String?)? validator;
//   final void Function(String?)? onChanged;
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Container(
//       width: width,
//       padding: EdgeInsets.all(size.width * 0.01),
//       decoration: BoxDecoration(
//           color: GbsSystemStrings.str_primary_color.withOpacity(0.5),
//           border: Border.all(color: Colors.black, width: 1),
//           borderRadius: BorderRadius.circular(12)),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButtonFormField<String>(
//             onTap: onTap,
//             decoration: const InputDecoration(border: InputBorder.none),
//             validator: validator,
//             isExpanded: true,
//             hint: selectedItem == null
//                 ? Center(
//                     child: Text(
//                     hint,
//                     style: TextStyle(color: Colors.black),
//                   ))
//                 : Text(selectedItem!, style: TextStyle(color: Colors.black)),
//             value: selectedItem,
//             items: listItems != null
//                 ? listItems!
//                     .map((item) => DropdownMenuItem<String>(
//                           value: item,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 item!,
//                                 style: const TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w500),
//                               ),
//                             ],
//                           ),
//                         ))
//                     .toList()
//                 : null,
//             onChanged: onChanged),
//       ),
//     );
//   }
// }


// class CustomDropDownButtonNombreJourMax extends StatelessWidget {
//   const CustomDropDownButtonNombreJourMax({
//     super.key,
//     required this.selectedItem,
//     required this.listItems,
//     required this.hint,
//     this.onChanged,
//     this.validator,
//     this.onTap,
//     this.width,
//   });
//   final double? width;
//   final NombreJourMaxModel? selectedItem;
//   final List<NombreJourMaxModel?>? listItems;
//   final String hint;
//   final void Function()? onTap;
//   final String? Function(NombreJourMaxModel?)? validator;
//   final void Function(NombreJourMaxModel?)? onChanged;
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Container(
//       width: width,
//       padding: EdgeInsets.all(size.width * 0.01),
//       decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border.all(color: Colors.black, width: 1),
//           borderRadius: BorderRadius.circular(12)),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButtonFormField<NombreJourMaxModel>(
//             onTap: onTap,
//             decoration: const InputDecoration(border: InputBorder.none),
//             validator: validator,
//             isExpanded: true,
//             hint: selectedItem == null
//                 ? Center(child: Text(hint))
//                 : Text(selectedItem!.),
//             value: selectedItem,
//             items: listItems != null
//                 ? listItems!
//                     .map((item) => DropdownMenuItem<String>(
//                           value: item,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 item!,
//                                 style: const TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.w500),
//                               ),
//                             ],
//                           ),
//                         ))
//                     .toList()
//                 : null,
//             onChanged: onChanged),
//       ),
//     );
//   }
// }
