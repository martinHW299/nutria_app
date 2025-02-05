import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:nutria/widgets/form_fields.dart';

class UserProfileIntroScreen extends StatefulWidget {
  const UserProfileIntroScreen({super.key});

  @override
  State<UserProfileIntroScreen> createState() => _UserProfileIntroScreenState();
}

class _UserProfileIntroScreenState extends State<UserProfileIntroScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController weightGoalController = TextEditingController();

  String selectedGender = "Male";
  String selectedActivityLevel = "SEDENTARY";
  String selectedGoal = "GAIN_MODERATE";

  void _onIntroEnd(BuildContext context) {
    // Save user information and navigate to the home screen
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Enter Your Name",
          bodyWidget: Column(
            children: [
              InputField(controller: firstNameController, label: "First Name"),
              InputField(controller: lastNameController, label: "Last Name"),
            ],
          ),
        ),
        PageViewModel(
          title: "Personal Information",
          bodyWidget: Column(
            children: [
              InputField(
                  controller: ageController, label: "Age", isNumeric: true),
              DropdownField(
                label: "Gender",
                items: ["Male", "Female"],
                selectedValue: selectedGender,
                onChanged: (value) => setState(() => selectedGender = value!),
              ),
            ],
          ),
        ),
        PageViewModel(
          title: "Body Measurements",
          bodyWidget: Column(
            children: [
              InputField(
                  controller: heightController,
                  label: "Height (cm)",
                  isNumeric: true),
              InputField(
                  controller: weightController,
                  label: "Current Weight (kg)",
                  isNumeric: true),
              InputField(
                  controller: weightGoalController,
                  label: "Target Weight (kg)",
                  isNumeric: true),
            ],
          ),
        ),
        PageViewModel(
          title: "Activity & Goal",
          bodyWidget: Column(
            children: [
              DropdownField(
                label: "Activity Level",
                items: [
                  "SEDENTARY",
                  "LIGHTLY_ACTIVE",
                  "MODERATELY_ACTIVE",
                  "VERY_ACTIVE"
                ],
                selectedValue: selectedActivityLevel,
                onChanged: (value) =>
                    setState(() => selectedActivityLevel = value!),
              ),
              DropdownField(
                label: "Goal",
                items: [
                  "GAIN_MODERATE",
                  "GAIN_INTENSE",
                  "LOSE_MODERATE",
                  "LOSE_INTENSE"
                ],
                selectedValue: selectedGoal,
                onChanged: (value) => setState(() => selectedGoal = value!),
              ),
            ],
          ),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: true,
      skip: const Text("Skip"),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size.square(8.0),
        activeSize: Size(16.0, 8.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
