import 'package:flutter/material.dart';

enum DetectionClasses { battery, biological, cardboard, clothe, glass, metal, paper, plastic, other }

extension DetectionClassesExtension on DetectionClasses {
  String get label {
    switch (this) {
      case DetectionClasses.battery:
        return "Battery";
      case DetectionClasses.biological:
        return "Biological";
      case DetectionClasses.cardboard:
        return "Cardboard";
      case DetectionClasses.clothe:
        return "Clothe";
      case DetectionClasses.glass:
        return "Glass";
      case DetectionClasses.metal:
        return "Metal";
      case DetectionClasses.paper:
        return "Paper";
      case DetectionClasses.plastic:
        return "Plastic";
      case DetectionClasses.other:
        return "Other";
    }
  }

  String get prompt {
    switch (this) {
      case DetectionClasses.cardboard:
        return "Cardboard boxes and packaging can often be reused for storage, shipping, or moving purposes. They can also be creatively repurposed for arts and crafts projects or composted if they are made from uncoated, untreated cardboard.";
      case DetectionClasses.glass:
        return "Glass containers, such as jars and bottles, can be washed and reused for storing food, beverages, or other items. They can also be creatively repurposed into decorations, candle holders, or even DIY crafts.";
      case DetectionClasses.metal:
        return "Metal items like aluminum cans or steel containers can be cleaned and reused for their original purpose or repurposed into various DIY projects. Additionally, metal scraps can be collected and taken to scrap yards for recycling and reuse in manufacturing.";
      case DetectionClasses.paper:
        return "Paper materials such as newspapers, magazines, and office paper can be reused for various purposes before recycling. For example, they can be used as packing material, shredded for animal bedding or composting, or repurposed for arts and crafts projects.";
      case DetectionClasses.plastic:
        return "While recycling plastic is important, some types of plastic items can also be washed and reused multiple times before recycling. For example, reusable plastic containers or water bottles can be refilled and used again instead of being disposed of after a single use. Additionally, some plastic products can be repurposed for different functions, such as using plastic bags as bin liners or for storage.";
      default:
        return label;
    }
  }

  Widget get container {
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
          color: Colors.deepPurple.shade100,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.shade50,
              offset: const Offset(0, 20),
              blurRadius: 20,
            ),
          ]
      ),

      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(Icons.info),
          ),

          Flexible(child: Text(prompt)),
        ],
      ),
    );
  }
}