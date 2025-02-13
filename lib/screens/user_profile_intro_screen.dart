import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:nutria/providers/user_profile_provider.dart';
import 'package:nutria/widgets/dropdown_field.dart';
import 'package:nutria/widgets/primary_button.dart';
import 'package:nutria/widgets/text_input_field.dart';
import 'package:provider/provider.dart';

class UserProfileIntroScreen extends StatefulWidget {
  const UserProfileIntroScreen({super.key});

  @override
  State<UserProfileIntroScreen> createState() => _UserProfileIntroScreenState();
}

class _UserProfileIntroScreenState extends State<UserProfileIntroScreen> {
  final PageController pageController = PageController();

  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController weightGoalController = TextEditingController();

  String? selectedGender;
  String? selectedActivity;
  String? selectedGoal;

  void _submitForm(UserProfileProvider profileProvider) {
    if (firstnameController.text.isEmpty ||
        lastnameController.text.isEmpty ||
        ageController.text.isEmpty ||
        selectedGender == null ||
        heightController.text.isEmpty ||
        weightController.text.isEmpty ||
        weightGoalController.text.isEmpty ||
        selectedActivity == null ||
        selectedGoal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("All fields are required!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    profileProvider.submitUserProfile(context, {
      "firstname": firstnameController.text,
      "lastname": lastnameController.text,
      "age": int.tryParse(ageController.text) ?? 0,
      "gender": selectedGender,
      "height": int.tryParse(heightController.text) ?? 0,
      "weight": int.tryParse(weightController.text) ?? 0,
      "weight_goal": int.tryParse(weightGoalController.text) ?? 0,
      "activity_level": selectedActivity,
      "goal": selectedGoal,
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<UserProfileProvider>(context);

    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          title: "Welcome to NutrIA",
          body: "Let's personalize your experience by setting up your profile.",
          // image: _buildImage('assets/images/brand.png'),
          image: const Center(
            child: Icon(Icons.waving_hand, size: 50.0),
          ),
        ),
        PageViewModel(
          title: "Personal Information",
          bodyWidget: _buildPersonalInformationForm(),
        ),
        PageViewModel(
          title: "Physical Attributes",
          bodyWidget: _buildPhysicalAttributesForm(),
        ),
        PageViewModel(
          title: "Lifestyle",
          bodyWidget: _buildLifestyleForm(),
        ),
      ],
      showBackButton: true,
      showNextButton: true,
      back: const Icon(Icons.arrow_back),
      next: const Icon(Icons.arrow_forward),
      done: profileProvider.isLoading
          ? const CircularProgressIndicator()
          : PrimaryButton(
              text: "Submit",
              onPressed: () => _submitForm(profileProvider),
            ),
      onDone: () => _submitForm(profileProvider),
    );
  }

  // Image Widget
  // Widget _buildImage(String path) {
  //   return Image.asset(path, width: 100, height: 100, fit: BoxFit.cover);
  // }

  // Personal Information Form
  Widget _buildPersonalInformationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextInputField(controller: firstnameController, label: "First Name"),
        const SizedBox(height: 12),
        TextInputField(controller: lastnameController, label: "Last Name"),
        const SizedBox(height: 12),
        TextInputField(
            controller: ageController,
            label: "Age",
            keyboardType: TextInputType.number),
        const SizedBox(height: 12),
        DropdownField(
          label: "Gender",
          items: [
            {"label": "Male", "value": "M"},
            {"label": "Female", "value": "F"},
          ],
          onChanged: (value) => setState(() => selectedGender = value),
        ),
      ],
    );
  }

  // Physical Attributes Form
  Widget _buildPhysicalAttributesForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextInputField(
            controller: heightController,
            label: "Height (cm)",
            keyboardType: TextInputType.number),
        const SizedBox(height: 12),
        TextInputField(
            controller: weightController,
            label: "Weight (kg)",
            keyboardType: TextInputType.number),
        const SizedBox(height: 12),
        TextInputField(
            controller: weightGoalController,
            label: "Weight Goal (kg)",
            keyboardType: TextInputType.number),
      ],
    );
  }

  // Lifestyle Form
  Widget _buildLifestyleForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownField(
          label: "Activity Level",
          items: [
            {"label": "Sedentary", "value": "SEDENTARY"},
            {"label": "Moderate", "value": "MODERATE"},
            {"label": "Active", "value": "ACTIVE"},
          ],
          onChanged: (value) => setState(() => selectedActivity = value),
        ),
        const SizedBox(height: 12),
        DropdownField(
          label: "Goal",
          items: [
            {"label": "Lose Weight", "value": "LOSS_MODERATE"},
            {"label": "Gain Muscle", "value": "GAIN_MODERATE"},
            {"label": "Maintain Weight", "value": "MAINTAIN"},
          ],
          onChanged: (value) => setState(() => selectedGoal = value),
        ),
      ],
    );
  }
}
