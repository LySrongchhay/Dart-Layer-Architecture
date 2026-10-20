import 'package:lms_layered_architecture_example/model/course.dart';
import 'package:lms_layered_architecture_example/model/course_result.dart';

import '../model/student.dart';

class LmsSystem {
  final List<Student> students = [];
  final List<Course> courses = [];
  final List<Course_result> results = [];
 
  void addStudent({required String studentId, required String studentName}) {
    // ! Student shall not exist already
    Student? student = _findStudentOrNull(studentId);
    if (student != null) {
      throw Exception('Student $student already exists');
    }

    students.add(Student(id: studentId, name: studentName));
  }
 
 
  void removeStudent({required String studentId}) {
    Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }
    // 1- Remove student from the students list
    results.removeWhere((result) => result.studentId == studentId);
    courses.forEach((course) {
      course.studentIds.removeWhere((sId) => sId == studentId );
    });
    students.removeWhere((student) => student.id == studentId);
 
  }

  Student? _findStudentOrNull(String studentId) {
    for (Student s in students) {
      if (s.id == studentId) {
        return s;
      }
    }
    return null; // not found
  } 

  Course? _findCourseOrNull(String courseId) {
    for (Course c in courses) {
      if(c.id == courseId) {
        return c;
      }
    }
    return null;
  }

  void addCourse({ required courseName, required String courseId }) {
    Course? course = _findCourseOrNull(courseId);
    if(course != null ){
      throw Exception("Course $courseId already exist.");
    }
    courses.add(Course(name: courseName, id: courseId));
  }

  void removeCourse({required courseId}) {
    Course? course = _findCourseOrNull(courseId);
    if(course == null) {
      throw Exception("Course $courseId does not exist to remove");
    }
    if (course.studentIds.isEmpty == false) {
      throw Exception("Cannot remove $courseId which have student enrolled");
    }
    courses.removeWhere((course) => courseId == course.id);
  }

  void enrollStudent({required String studentId, required String courseId} ) {
    Student? student = _findStudentOrNull(studentId);
    Course? course =_findCourseOrNull(courseId);
    final bool isExistInCourse;
    if ( student == null ) {
      throw Exception("The student $studentId is not exist in the system.");
    }

    if ( course == null) {
      throw Exception("The course $courseId is not exist in the system.");
    }
    
    isExistInCourse = _isExistInCourse(course: course, student: student);
    if(isExistInCourse) {
      throw Exception("The Student $studentId already enroll to this course.");
    }
    course.studentIds.add(studentId);
  }

  bool _isExistInCourse({required Course course, required Student student}) {
    bool exist =  course.studentIds.contains(student.id);
    return exist;
  }

  void discardStudentFromCourse({required String studentId, required String courseId}){
    Student? student = _findStudentOrNull(studentId);
    Course? course = _findCourseOrNull(courseId);
    if (student == null) {
      throw Exception("Student does not exist in the system");
    }
    if (course == null) {
      throw Exception("The course does not exist in the system.");
    }
    final bool isExistInCourse = _isExistInCourse(course: course, student: student);

    if (isExistInCourse == false) {
      throw Exception("Cannot remove unexisting student.");
    }
    results.removeWhere((result) => result.studentId == studentId);
    course.studentIds.remove(student.id);

  }

  void addResult({required String id, required String studentId, required String courseId, required int score}){
    Course? course = _findCourseOrNull(courseId);
    Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception("Student does not exist in the system");
    }
    if (course == null) {
      throw Exception("The course does not exist in the system.");
    }

    final bool isExistInCourse = _isExistInCourse(course: course, student: student);
    if (isExistInCourse == false) {
      throw Exception("The Student must enroll in that course!");
    }
    
    if (score > 100 || score < 0) {
      throw Exception("The score must be integer that between 0 to 100");
    }
    if ( _isIdExist(id) == true ) {
      throw Exception("The id already exist, please choose a new one");
    }
    results.add(Course_result(id: id, courseId: courseId, studentId: studentId, score: score));
  }

  bool _isIdExist(String id) {
    for ( Course_result result in results) {
      if ( result.id == id) {
        return true;
      }
    }
    return false;
  }

  void removeResult(resultId){
    if (_isIdExist(resultId) == false) {
      throw Exception("Cannot remove unexisting result");
    }
    results.removeWhere((result) => result.id == resultId);

  }

  



  
}
