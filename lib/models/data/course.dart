class Course {
  final name;
  final totalCourse;
  final image;
  final price;
  final star;
  final students;
  final List<CourseContent> courseContent;

  Course(
    this.name,
    this.totalCourse,
    this.image,
    this.price,
    this.star,
    this.students,
    this.courseContent,
  );
}

class CourseContent {
  final time;
  final title;
  CourseContent(this.time, this.title);
}

final List<CourseContent> _courseContents = [
  CourseContent("5:35 mins", "Welcome to the Course"),
  CourseContent("7:35 mins", "Design Thinking - Intro"),
  CourseContent("10:35 mins", "Design Thinking Process"),
  CourseContent("5:35 mins", "Customer Perspective"),
];

List<Course> courseList = [
  Course(
    "Biceps Workout",
    "25",
    "assets/images/work1.png",
    "50",
    "4.3",
    "10",
    _courseContents,
  ),
  Course(
    "Cardio",
    "20",
    "assets/images/work2.png",
    "50",
    "4.1",
    "55",
    _courseContents,
  ),
  Course(
    "Meditation",
    "10",
    "assets/images/work3.png",
    "50",
    "4.3",
    "10",
    _courseContents,
  ),
  Course(
    "Abs Exercises",
    "7",
    "assets/images/work4.png",
    "50",
    "4.2",
    "35",
    _courseContents,
  ),
];
