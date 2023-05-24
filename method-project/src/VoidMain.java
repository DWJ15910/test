import java.util.ArrayList;
import java.util.HashMap;

import service.VoidMethod;
import vo.*;

public class VoidMain {

	public static void main(String[] args) {
		VoidMethod vm = new VoidMethod();
		vm.voidParm();
		
		int num = 8;
		vm.intParam(num);
		
		String name = "구철수";
		vm.stringParam(name);
		
		int a = 18;
		int b = 20;
		vm.int2Param(a, b);
		
		int[] arr = {10,2,404,5,1,2,777,8,12};
		vm.intArrayParam(arr);
		
		int value = 100;
		vm.valueTypeParam(value);
		System.out.println(value);
		
		int[] refer = {1,2,3};
		vm.referTypeParam(refer);
		System.out.println(refer[0]);
		
		String[] names = {"김이나","김아나","나아나"};
		vm.strArrParam(names);
		
		Student student = new Student();
		student.setId(1);
		student.setName("조동욱");
		student.setBirth(1999);
		student.setGender("남");
		vm.clsParam(student);
		
		Student student1 = new Student();
		student1.setId(2);
		student1.setName("조동욱");
		student1.setBirth(1999);
		student1.setGender("남");
		
		Student student2 = new Student();
		student2.setId(3);
		student2.setName("조동욱");
		student2.setBirth(1999);
		student2.setGender("남");
		
		Student[] students = new Student[3];
		students[0] = student;
		students[1] = student1;
		students[2] = student2;
		vm.clsArrayParam(students);
		
		ArrayList<Student> list = new ArrayList<Student>();
			Student s = new Student();
			Student s1 = new Student();
			Student s2 = new Student();
			s.setId(1);
			s.setName("조동욱");;
			s.setBirth(1999);;
			s.setGender("남");
			
			s1.setId(2);
			s1.setName("조동욱1");;
			s1.setBirth(2010);;
			s1.setGender("남");
			
			s2.setId(3);
			s2.setName("조동욱2");;
			s2.setBirth(2003);;
			s2.setGender("남");
			
			list.add(s);
			list.add(s1);
			list.add(s2);
		vm.clsArrListParam(list);
		
		Emp emp = new Emp();
		emp.setEmpName("루피");
		Student hkd = new Student();
		hkd.setName("홍길동");
		HashMap<String,Object> map = new HashMap<>();
		map.put("e1", emp);
		map.put("s1", hkd);
		vm.mapParam(map);
	
	
	
	}
}
