import 'package:flutter/material.dart';

enum DetectionClasses { battery, biological, cardboard, clothes, glass, metal, paper, plastic, other }

extension DetectionClassesExtension on DetectionClasses {
  String get label {
    switch (this) {
      case DetectionClasses.battery:
        return "Battery";
      case DetectionClasses.biological:
        return "Biological";
      case DetectionClasses.cardboard:
        return "Cardboard";
      case DetectionClasses.glass:
        return "Glass";
      case DetectionClasses.metal:
        return "Metal";
      case DetectionClasses.paper:
        return "Paper";
      case DetectionClasses.plastic:
        return "Plastic";
      case DetectionClasses.clothes:
        return "Plastic";
      case DetectionClasses.other:
        return "Other";
    }
  }

  String get prompt {
    switch (this) {
      case DetectionClasses.cardboard:
        return "Cardboard boxes and packaging can be reused for storage, shipping, or crafts. They can also be composted if untreated.";
      case DetectionClasses.glass:
        return "Glass containers like jars and bottles can be washed and reused for storage or repurposed for decorations and crafts.";
      case DetectionClasses.metal:
        return "Metal items like cans and containers can be reused or repurposed for DIY projects. Metal scraps can be recycled at scrap yards for manufacturing.";
      case DetectionClasses.paper:
        return "Paper materials like newspapers, magazines, and office paper can be reused before recycling. They can serve as packing material, animal bedding, or be repurposed for arts and crafts.";
      case DetectionClasses.plastic:
        return "Reusable plastic containers and bottles can be washed and reused multiple times. Plastic items like bags can be repurposed for storage or as bin liners.";
      default:
        return label;
    }
  }

  Widget get labelContainer {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
          color: Colors.green.shade100,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }

  Widget get promptContainer {
    return Container(
      height: 110,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.blueGrey.shade100,
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
            padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
            child: Icon(Icons.info),
          ),

          Flexible(child: Text(prompt)),
        ],
      ),
    );
  }
}