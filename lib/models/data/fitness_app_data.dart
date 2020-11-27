class Exercise {
  final String title;
  final String level;
  final String equipment;
  final String category;
  final int duration;
  final String imageUrl;
  final String totalSubscription;
  final String stars;
  final List<WorkOutContent> workoutContent;

  Exercise({
    this.title,
    this.level,
    this.equipment,
    this.category,
    this.duration,
    this.imageUrl,
    this.stars,
    this.totalSubscription,
    this.workoutContent,
  });
}

class WorkOutContent {
  final time;
  final title;
  WorkOutContent({this.title, this.time});
}

final List<WorkOutContent> _workoutContent = [
  WorkOutContent(time: "5:35 mins", title: "Welcome to the Course"),
  WorkOutContent(time: "7:35 mins", title: "Full body workout"),
  WorkOutContent(time: "10:35 mins", title: "abs workout"),
  WorkOutContent(time: "5:35 mins", title: "Legs workout"),
];

List<Exercise> exercises = [
  Exercise(
    title: "Strong and Big Chest",
    level: "Advanced Level",
    equipment: "Full Equipment",
    category: "Strength",
    duration: 45,
    imageUrl: 'https://wallpaperplay.com/walls/full/3/5/c/32728.jpg',
    stars: "4.3",
    totalSubscription: "10",
    workoutContent: _workoutContent,
  ),
  Exercise(
    title: "Back Workout",
    level: "Beginner Level",
    equipment: "Full Equipment",
    category: "Strength",
    duration: 55,
    imageUrl:
        'https://c4.wallpaperflare.com/wallpaper/150/221/189/man-back-workout-bodybuilding-wallpaper-preview.jpg',
    stars: "4.3",
    totalSubscription: "10",
    workoutContent: _workoutContent,
  ),
  Exercise(
    title: "The Total Attack",
    level: "Advanced Level",
    equipment: "Basic Equipment",
    category: "Endurance",
    duration: 45,
    imageUrl: 'https://wallpaperplay.com/walls/full/6/1/7/32744.jpg',
    stars: "4.3",
    totalSubscription: "10",
    workoutContent: _workoutContent,
  ),
];

List<String> trainers = ['Robert\nBlazevic', 'Jeff\nShid', 'Kris\nGethin'];
