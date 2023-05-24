import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;

import vo.*;



import service.PrimitiveMethod;

public class PrimitiveMain {
	
	public static void main(String[] args) {
		
		PrimitiveMethod pm = new PrimitiveMethod();
		
		//1)
		int maxIntValue = pm.voidParam();
		System.out.println("1번-->"+maxIntValue);
		
		//2)
		int birth = 1988;
		boolean result = pm.primitiveParam(birth);
		System.out.println("2번-->"+result);
		
		//2-1)
		int num1 = 10;
		int num2 = 15;
		int result2 = pm.primitive2Param(num1, num2);
		System.out.println("2-1번-->"+result2);
		
		//3)
		String firstName = "abcd";
		String lastName = "efg";
		int nameLength = pm.stringParam(firstName, lastName);
		System.out.println("3번-->"+nameLength);
		
		//4)
		int[] arr = {1, 2, 3, 4, 5};
		long sum = pm.arrayParam(arr);
		System.out.println("4번-->"+sum);
		
		//5)
		String[] names = {"루비","나미","쵸파"};
		boolean black = pm.strParam(names);
		System.out.println("5번-->"+black);
		
		//6)
		Student student1 = new Student();
		student1.setId(100);
		student1.setPw("2234");
		boolean result3 = pm.clsParam(student1);
		System.out.println("6번-->"+result3);
		
		//7)
		Student[] studentArr = new Student[3];
		studentArr[0] = new Student();
		studentArr[0].setBirth(1999);
		studentArr[0].setGender("여");
		  
		studentArr[1] = new Student();
		studentArr[1].setBirth(2002);
		studentArr[1].setGender("여");
		  
		studentArr[2] = new Student();
		studentArr[2].setBirth(2000);
		studentArr[2].setGender("남");
  
		System.out.println("7번 -->" + pm.ageParam(studentArr));
		
		//8)
		ArrayList<Subject> subjectList = new ArrayList<>();

		Subject s1 = new Subject();
		s1.setName("국어");
		s1.setScore(100);
		subjectList.add(s1);

		Subject s2 = new Subject();
		s2.setName("수학");
		s2.setScore(90);
		subjectList.add(s2);

		Subject s3 = new Subject();
		s3.setName("영어");
		s3.setScore(90);
		subjectList.add(s3);

		Subject s4 = new Subject();
		s4.setName("과학");
		s4.setScore(90);
		subjectList.add(s4);
		
		char grade = pm.listParam(subjectList);
		System.out.println("8번-->평균 학점: " + grade);
		
		
		// 9)
		HashMap<String,Object> map = new HashMap<String,Object>();
		ArrayList<Student> sList = new ArrayList<Student>();
		Student s = new Student();  
		s.setId(100);
		sList.add(s);

		    
		ArrayList<Emp> eList = new ArrayList<Emp>();
		Emp e = new Emp();
		e.setEmpId(100);
		eList.add(e);
		  
		  
		map.put("studentList", sList);
		map.put("empList",eList);
		  
		System.out.print("9번-->"+pm.mapParam(map));
	}
}
