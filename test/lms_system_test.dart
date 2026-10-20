import 'dart:math';

import 'package:lms_layered_architecture_example/model/course_result.dart';
import 'package:test/test.dart';
import '../lib/service/lms_system.dart';

void main() {
  test('creates a student', () {
    final lms = LmsSystem();
    // Create a student
    lms.addStudent(studentId: 'S1', studentName: "ronan");

    expect(lms.students.first.name, 'ronan');

    // Remove the student
    lms.removeStudent(studentId: 'S1');
    expect(lms.students.length, 0);
  });

  test('Test create and remove coures course', () {
    final lms = LmsSystem();
    lms.addCourse(courseName: "Flutter G4", courseId: "IDTFlutter");
    expect(lms.courses.first.name, "Flutter G4");

    // duplicate courseId
    expect(
        () => lms.addCourse(courseName: "Flutter G3", courseId: "IDTFlutter"),
        throwsException);

    // remove course that not exist
    expect(() => lms.removeCourse(courseId: "G5"), throwsException);
  });

  test("Remove coure that have student iside", () {
    final lms = LmsSystem();
    lms.addStudent(studentId: "IDTB110074", studentName: "Ly Srongchhay");

    lms.addCourse(courseId: "FLutter gen11 G4", courseName: "G4 is the best");

    lms.enrollStudent(studentId: "IDTB110074", courseId: "FLutter gen11 G4");

    expect(
        () => lms.removeCourse(courseId: "Flutter gen11 G4"), throwsException);
  });

  test("Enroll student to a course", () {
    final lms = LmsSystem();
    // student does not exist in system
    expect(
        () =>
            lms.enrollStudent(studentId: "IDTB110074", courseId: "Flutter G4"),
        throwsException);

    // student exist but the course does not exist
    lms.addStudent(studentId: "IDTB110074", studentName: "Ly Srongchhay");
    expect(
        () =>
            lms.enrollStudent(studentId: "IDTB110074", courseId: "Flutter G4"),
        throwsException);

    // succes enroll when both student and course are exist
    lms.addCourse(courseName: "The Best", courseId: "Flutter G4");
    lms.enrollStudent(studentId: "IDTB110074", courseId: "Flutter G4");
    expect(lms.courses.first.studentIds.first, "IDTB110074");

    // entroll to the same course
    expect(
        () =>
            lms.enrollStudent(studentId: "IDTB110074", courseId: "Flutter G4"),
        throwsException);
  });

  test("Test remove enrollment", () {
    //     Remove an existing enrollment.
    final lms = LmsSystem();
    lms.addStudent(studentId: "IDTB110074", studentName: "Ly Srongchhay");
    lms.addCourse(courseName: "Flutter", courseId: "Flutter Gen11 G4");
    lms.enrollStudent(studentId: "IDTB110074", courseId: "Flutter Gen11 G4");
    lms.discardStudentFromCourse(studentId: "IDTB110074", courseId: "Flutter Gen11 G4");
    expect(lms.courses.first.studentIds.isEmpty, true);

    // ✓ Reject removal of a nonexistent enrollment.
    expect(
      () => lms.discardStudentFromCourse(studentId: "IDTB110074", courseId: "Flutter Gen11 G4"),
      throwsException
    );

    // ✓ Verify that the student and course still exist after the enrollment is removed.
    expect(lms.courses.first.name, "Flutter");
    expect(lms.students.first.name, "Ly Srongchhay");

    // ✓ Verify the chosen policy for associated results.
    lms.enrollStudent(studentId: "IDTB110074", courseId: "Flutter Gen11 G4");
    lms.results.add(Course_result(id: "11", courseId: "Flutter Gen11 G4", studentId: "IDTB110074", score: 100));
    lms.discardStudentFromCourse(studentId: "IDTB110074", courseId: "Flutter Gen11 G4");
    expect(lms.results.isEmpty, true); // delete the course and the result 
    
    // ✓ Test removing a student who has enrollments in multiple courses
    lms.addCourse(courseName: "Game Dev", courseId: "Game Gen11 G4");
    lms.enrollStudent(studentId: "IDTB110074", courseId: "Game Gen11 G4");
    lms.enrollStudent(studentId: "IDTB110074", courseId: "Flutter Gen11 G4");
    lms.results.add(Course_result(id: "123", courseId: "Flutter Gen11 G4", studentId: "IDTB110074",score: 100));
    lms.removeStudent(studentId: "IDTB110074");
    expect(lms.students.isEmpty, true);
    expect(lms.courses.first.studentIds.isEmpty, true);
    expect(lms.students.isEmpty, true);
    expect(lms.results.isEmpty, true);
  });

  test("A result", (){
    
    // ✓ Add a valid result.
    final lms = LmsSystem();
    lms.addStudent(studentId: "IDTB110074", studentName: "Ly Srongchhay");
    lms.addCourse(courseName: "Flutter", courseId: "Flutter Gen11 G4");
    lms.enrollStudent(studentId: "IDTB110074", courseId: "Flutter Gen11 G4");
    lms.addResult(id: "flutter-test-w1", studentId: "IDTB110074", courseId: "Flutter Gen11 G4", score: 100);
    expect(lms.results.first.score, 100);

    // ✓ Reject a result for a nonexistent student or course.
    expect(
      () => lms.addResult(id: "AI-1", studentId: "IDTB1", courseId: "AI", score: 100), 
      throwsException
    );

    // ✓ Reject a result for a student who is not enrolled, if enrollment is required.
    lms.addCourse(courseName: "Game", courseId: "Game Dev Gen11 G4");
    expect(
      () => lms.addResult(id: "Game-1", studentId: "IDTB110074", courseId: "Game Dev Gen11 G4", score: 100), 
      throwsException
    );

    // ✓ Reject an invalid score.
    expect(
      () => lms.addResult(id: "Flutter-2", studentId: "IDTB110074", courseId: "Flutter Gen11 G4", score: -100), 
      throwsException
    );

    // ✓ Test the chosen policy for duplicate results
    expect(
      () => lms.addResult(id: "Flutter-test-w1", studentId: "IDTB110074", courseId: "Flutter Gen11 G4", score: -100), 
      throwsException
    );
  });

  test("Remove result", (){

    // Remove an existing result.
    final lms = LmsSystem();
    lms.addStudent(studentId: "IDTB110074", studentName: "Ly Srongchhay");
    lms.addCourse(courseName: "Flutter", courseId: "Flutter Gen11 G4");
    lms.enrollStudent(studentId: "IDTB110074", courseId: "Flutter Gen11 G4");
    lms.addResult(id: "flutter-test-w1", studentId: "IDTB110074", courseId: "Flutter Gen11 G4", score: 100);
    lms.removeResult("flutter-test-w1");
    expect(lms.results.length, 0);

    //     Reject removal of a nonexistent result.
    expect(
      () => lms.removeResult("flutter-test-w1"),
      throwsException
    );

    // ✓ Verify that the result is no longer available.
    expect(lms.results.length, 0);

    // ✓ Verify that the student, course, and unrelated results remain unchanged.
    lms.addResult(id: "flutter-test-w1", studentId: "IDTB110074", courseId: "Flutter Gen11 G4", score: 90);
    lms.addResult(id: "flutter-test-w2", studentId: "IDTB110074", courseId: "Flutter Gen11 G4", score: 90);
    lms.removeResult("flutter-test-w1");
    expect(lms.students.first.name, "Ly Srongchhay");
    expect(lms.courses.first.name, "Flutter");
    expect(lms.results.first.id, "flutter-test-w2");
  });

}
