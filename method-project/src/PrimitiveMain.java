import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;

import vo.*;



import service.PrimitiveMethod;

public class PrimitiveMain {
	
	//1)
	public static void main(String[] args) {
		PrimitiveMethod pm = new PrimitiveMethod();
		
		int maxIntValue = pm.voidParam();
		System.out.println(maxIntValue);
		
		//4)
		int[] arr = {1, 2, 3, 4, 5}; // 배열을 초기화해야 합니다.
		long sum = pm.arrayParam(arr);
		System.out.println(sum);
		
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
		System.out.println("평균 학점: " + grade);
		
		
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
	      
	      
	      System.out.println(pm.mapParam(map));
		
		
		
		
		
		
		
		
		
		
		
	}
}
