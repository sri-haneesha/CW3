import 'package:flutter/material.dart';
import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  TextEditingController _petNameController = TextEditingController();
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  Color petColor = Colors.yellow;
  String moodText = "Neutral";
  String petMoodImage = 'assets/neutral_dog.png'; // Initial neutral mood image
  Timer? hungerTimer;

  @override
  void initState() {
    super.initState();
    // Start the timer for automatic hunger increase
    hungerTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      _increaseHungerAutomatically();
    });
  }

  @override
  void dispose() {
    hungerTimer?.cancel();
    _petNameController.dispose();
    super.dispose();
  }

  // Function to increase happiness and update hunger when playing with the pet
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      hungerLevel = (hungerLevel + 5).clamp(0, 100);
      _updateHappiness();
      _updatePetColor();
      _updateMoodText();
    });
  }

  // Function to decrease hunger and update happiness when feeding the pet
  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 0);
      _updateHappiness();
      _updatePetColor();
      _updateMoodText();
    });
  }

  // Automatically increase hunger level
  void _increaseHungerAutomatically() {
    setState(() {
      hungerLevel = (hungerLevel + 5).clamp(0, 100);
      _updateHappiness();
      _updatePetColor();
      _updateMoodText();
      _checkGameOver();
    });
  }

  // Update happiness based on hunger level
  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
  }

  // Update pet color based on happiness level
  void _updatePetColor() {
    if (happinessLevel > 70) {
      petColor = Colors.green;
    } else if (happinessLevel >= 30) {
      petColor = Colors.yellow;
    } else {
      petColor = Colors.red;
    }
  }

  // Update mood text and mood image based on happiness level
  void _updateMoodText() {
    if (happinessLevel > 70) {
      moodText = "Happy 😊";
      petMoodImage = 'assets/happy_dog.png';
    } else if (happinessLevel >= 30) {
      moodText = "Neutral 😐";
      petMoodImage = 'assets/neutral_dog.png';
    } else {
      moodText = "Unhappy 😢";
      petMoodImage = 'assets/unhappy_dog.png';
    }
  }

  // Check for game over condition
  void _checkGameOver() {
    if (hungerLevel >= 100 && happinessLevel <= 10) {
      _showGameOverDialog();
      hungerTimer?.cancel();
    }
  }

  // Show game over dialog
  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Game Over"),
          content: Text("Your pet is too hungry and unhappy!"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                _resetPetStatus();
              },
            ),
          ],
        );
      },
    );
  }

  // Function to reset happiness and hunger levels
  void _resetPetStatus() {
    setState(() {
      happinessLevel = 50;
      hungerLevel = 50;
      petColor = Colors.yellow;
      moodText = "Neutral";
      petMoodImage = 'assets/neutral_dog.png'; // Reset to neutral dog image
    });
  }

  // Function to set a custom name for the pet
  void _setPetName(String name) {
    setState(() {
      petName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              petName, // Animating pet's name like Free Fire title
              textStyle: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              speed: Duration(milliseconds: 200),
            ),
          ],
          isRepeatingAnimation: true,
          repeatForever: true,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 150,
              height: 150,
              color: petColor,
              child: Center(
                child: Image.asset(petMoodImage), // Pet's mood-based image
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Happiness Level: $happinessLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Hunger Level: $hungerLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Mood: $moodText',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _resetPetStatus,
              child: Text('Reset Pet Status'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _petNameController,
              decoration: InputDecoration(labelText: "Enter Pet Name"),
              onChanged: _setPetName, // Update pet name instantly as typed
            ),
          ],
        ),
      ),
    );
  }
}
