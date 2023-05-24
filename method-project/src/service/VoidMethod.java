package service;


import java.util.*;


import vo.*;



//1)리턴 타입: void
public class VoidMethod {
	private HashMap<String, Object>[] empList;
	//1)매개변수 : 없음
	public void voidParm() {
		System.out.println("안녕하세요 구디 아카데미 입니다");
	}
	
	//2)매개변수 : 기본타입
	public void intParam(int num) {
		if(num % 2 == 0) {
			System.out.println("입력한"+num+"은 짝수입니다");
			return;
		}
		System.out.println("입력한"+num+"은 홀수입니다");
	}
	
	//2-1) 두개의 숫자 int 를 입력 받아 21을 넘기지 않으면서 21에 더 가까운 수를 출력하는 메서드
	public void int2Param(int a,int b) {
		//a,b중 
		if(a > 21 && b > 21) {
	         System.out.println("없음");
	      } else if (a > 21) {
	         System.out.println(b);
	      } else if (b > 21) {
	         System.out.println(a);
	      } else if (a > b){
	         System.out.println(a);
	      } else {
	         System.out.println(b);
	      }
	}
	
	//3)매개변수 : String
	public void stringParam(String name) {
		if(name.startsWith("김")||name.startsWith("이")||name.startsWith("박")) {
			System.out.println(name.substring(0,1)+"씨 입니다");
		} else {
			System.out.println("김/이/박이 아닙니다");
		}
	}
	
	//4)매개변수(참조타입) : int 배열
	public void intArrayParam(int[] arr) {
		if(arr == null || arr.length==0) {
			System.out.println("입력 ERROR");
			return;
		}
		int max = arr[0];
		for(int i = 0; i<arr.length; i++) {
			if(arr[i] > max) {
				max=arr[i];
			}
		}
		System.out.println(max+" 입니다");
	}
	// #기본타입 매개변수 vs 참조타입 매개변수
	public void valueTypeParam(int value) {
		value = 777;
	}
	public void referTypeParam(int[] refer) {
		refer[0] = 777;
	}
	
	// 5) 매개변수 : 배열(Stirng 배열)
	
	// a. 어떤값을 입력 받을 것인가? 사람이름 배열 입력
	// b. 어떻게 처리 (구현)할 것인가? "김"씨 성의 인원을 출력
	// c. 어떤 값을 반환 할 것인가? void
	public void strArrParam(String[] names) {
		if(names==null || names.length == 0) {
			System.out.println("입력이 없습니다");
			return;
		}
		
		int nameCnt = 0;
		for(String n : names) {
			if(n.startsWith("김")) {
				nameCnt++;
			}
		}
		System.out.printf("전체 %d명 중 김씨는 %d명 입니다\n", names.length,nameCnt);
	}
	
	// 6) 매개변수 : 클래스 
	
	// a. 어떤값을 입력 받을 것인가? 한 학생의 정보
	// b. 어떻게 처리 (구현)할 것인가? 한 학생의 정보를 출력(이름은 성) + 유효성검사
	// c. 어떤 값을 반환 할 것인가? void
	public void clsParam(Student student) {
		if(student==null
				||student.getName()==null
				||student.getGender()==null) {
			System.out.println("값을 입력해주세요");
			return;
		}
		Calendar today = Calendar.getInstance();
		int todayDate = today.get(Calendar.YEAR);
		
		int id = student.getId();
		String name = (student.getName()).substring(0,1);
		int birth = todayDate-student.getBirth();
		String gender = student.getGender();
		
		System.out.printf("%d번,%sXX,%s자,만%d살\n", id,name,gender,birth);
	}
	
	// 7) 매개변수 : 배열(클래스 배열)
	// a. 어떤값을 입력 받을 것인가? 여러 학생의 정보(Student[])
	// b. 어떻게 처리 (구현)할 것인가? 남자x명, 여자x명 + 유효성검사
	// c. 어떤 값을 반환 할 것인가? void
	public void clsArrayParam(Student[] students) {
		if(students==null || students.length == 0) {
			System.out.println("입력이 없습니다");
			return;
		}
		
		int manCnt = 0;
		int womanCnt = 0;
		for(Student s : students) {
			if(s == null || s.getGender()==null) {
				return;
			}
			
			if(s.getGender()=="남") {
				manCnt++;
			}else if(s.getGender()=="여"){
				womanCnt++;
			}
		}
		System.out.printf("남자 %d명, 여자 %d명 입니다\n", manCnt,womanCnt);
		
		
	}
	
	// 8)) 매개변수 : ArrayList
	// a. 어떤값을 입력 받을 것인가? 여러 학생의 정보(List<Student>)
	// b. 어떻게 처리 (구현)할 것인가? 전체 x명,10대x명, 20대x명,30대x명 + 유효성검사
	// c. 어떤 값을 반환 할 것인가? void
	public void clsArrListParam(ArrayList<Student> list) {
		
		Calendar today = Calendar.getInstance();
		int todayDate = today.get(Calendar.YEAR);
		
		if(list==null || list.size() == 0) {
			System.out.println("입력이 없습니다");
			return;
		}
		int age10 = 0;
		int age20 = 0;
		int age30 = 0;
		
		
		for(Student s : list) {
			if(s == null) {
				System.out.println("값없음");
				return;
			}
			int age = todayDate-s.getBirth()+1;
			if(age/10*10==10) {
				age10++;
			}else if(age/10*10==20){
				age20++;
			}else if(age/10*10==30){
				age30++;
			}else {
				System.out.println("10,20,30대가 아닙니다");
				return;
			}
		}
		System.out.printf("전체 %d 명,10대 %d명, 20대 %d명 ,30대 %d명 입니다\n",list.size(), age10,age20,age30);
		
		
	}
	// 8)) 매개변수 : HashMap
	// a. 어떤값을 입력 받을 것인가? Student1명, Emp 1명 --> HashMap 하나를 입력
	// b. 어떻게 처리 (구현)할 것인가? 학생이름 xxx이고, 담당직원의 이름은 xxx입니다 + 유효성검사
	// c. 어떤 값을 반환 할 것인가? void
	public void mapParam(HashMap<String,Object> map) {
		
		if(map==null || map.size() == 0) {
			System.out.println("입력이 없습니다");
			return;
		}
		
		Emp emp = (Emp)(map.get("e1"));
		Student student = (Student)(map.get("s1"));
		
		System.out.printf("학생 %s의 담당직원은 %s 입니다\n",student.getName(),emp.getEmpName());

	}
	
	
	
	
	
	
	
}
