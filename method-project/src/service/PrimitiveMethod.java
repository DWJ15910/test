package service;
import vo.*;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;

import vo.*;

public class PrimitiveMethod {
	/*
	 2. 리턴타입
	 */
	
	// 1) 매개변수 : 없음
	// a. 어떤값을 입력 받을 것인가? void
	// b. 어떻게 처리 (구현)할 것인가? 0~int최대값 중에 하나를 리턴
	// c. 어떤 값을 반환 할 것인가? int
	public int voidParam() {
		//최솟값 0, 최대값 int타입의 최대값 : Integer랩퍼타입 이용
		double rNum = Math.random(); //0.0000~0.9999x
		long intMax = (long)Integer.MAX_VALUE+1;
		int returnValue = (int)(Math.floor(intMax * rNum));
		return returnValue;
	}
	
	// 2) 매개변수 : 기본타입
	// a. 어떤값을 입력 받을 것인가? 태어난 년도
	// b. 어떻게 처리 (구현)할 것인가? 성인 true/ 아니면 false
	// c. 어떤 값을 반환 할 것인가? boolean
	public boolean primitiveParam(int birth) {
		int currentYear = Calendar.getInstance().get(Calendar.YEAR);
		if(birth<0 || birth>currentYear) {
			System.out.println("잘못된 입력입니다");
			return false;
		}
		if(currentYear-birth>18) {
			return true;
		}
		
		return false;
	}
	
	// 2-1) 매개변수 : 기본타입
	// a. 어떤값을 입력 받을 것인가? int, int int값 2개
	// b. 어떻게 처리 (구현)할 것인가? 두 입력값 중 더 큰 값
	// c. 어떤 값을 반환 할 것인가? int값 반환
	public int primitive2Param(int num1, int num2) {
		if(num2>num1) {
			return num2;
		}
		return num1;
	}
	
	// 3) 매개변수 : String
	// a. 어떤값을 입력 받을 것인가? 문자열 두개
	// b. 어떻게 처리 (구현)할 것인가? firstName, lastName의 길이
	// c. 어떤 값을 반환 할 것인가? int
	public int stringParam(String firstName,String lastName) {
		int a = firstName.length();
		int b = lastName.length();
		
		return a+b;
	}
	
	// 4) 매개변수 : 배열(기본타입 배열)
	// a. 어떤값을 입력 받을 것인가? int[]
	// b. 어떻게 처리 (구현)할 것인가? 배열의 합
	// c. 어떤 값을 반환 할 것인가? int
	public long arrayParam(int[] arr) {
		if(arr==null || arr.length==0) {
			System.out.println("값 없음");
			return 0;
		}
		long sum = 0;
		for(int i = 0; i<arr.length; i++) {
			sum += arr[i];
		}
		return sum;
	}
	
	// 5) 매개변수 : 배열(String 배열)
	// a. 어떤값을 입력 받을 것인가? String[]
	// b. 어떻게 처리 (구현)할 것인가? 입력된 이름중 한명이라도 블랙리스트 명단에 있으면 트루
	// c. 어떤 값을 반환 할 것인가? int
	public boolean strParam(String[] names) {
		final String[] blackList = {"루피","상디","조로"};
		
		if(names == null) {
			return false;
		}
		for(String n : names) {
			for(String b : blackList) {
				if(n.equals(b)) {
					return false;
				}
			}
			
		}
		return true;
	}
	
	// 6) 매개변수 : 클래스
	// a. 어떤값을 입력 받을 것인가? 학생타입의 id,pw 속성만 입력
	// b. 어떻게 처리 (구현)할 것인가? 로그인
	// c. 어떤 값을 반환 할 것인가? boolean
	public boolean clsParam(Student student) {
		Student[] db = new Student[3];

		db[0] = new Student();
		db[0].setId(100); db[0].setPw("1234");
		db[1] = new Student();
		db[1].setId(200); db[1].setPw("1234");
		db[2] = new Student();
		db[2].setId(300); db[2].setPw("1234");
		

		for(Student s : db) {
	         if(s.getId() == student.getId() && s.getPw().equals(student.getPw())) {
	            return true;
	         }
	      }
	      return false;
	   
	}
	
	// 7) 매개변수 : 배열(클래스 배열
	// a. 어떤값을 입력 받을 것인가? 학생배열 Student[]
	// b. 어떻게 처리 (구현)할 것인가? 성별이 여자인분들의 평균나이(소숫점 2자리)
	// c. 어떤 값을 반환 할 것인가? double
	public double ageParam(Student[] students) {
		
		//오늘 기준의 년도
		int currentYear = Calendar.getInstance().get(Calendar.YEAR);
		
		if(students==null || students.length == 0) {
			System.out.println("입력이 없습니다");
			return 0;
		}
		double avg = 0;
		for(Student s : students) {
		int age = currentYear-s.getBirth()+1;
		int sumAge = 0;
		int count = 0;
			if(s.getGender().equals("여")) {
				sumAge += age;
				count++;
			}else {
				return 0;
			}
			
			avg = (double)sumAge / (double)count;
			avg = Math.round(avg*100)/100;
		}
		return avg;
	}
	
	// 8) 매개변수 : ArrayList
	// a. 어떤값을 입력 받을 것인가? 성적데이터 4과목
	// b. 어떻게 처리 (구현)할 것인가? 4과목이 안되면 0점 평균 90이상 A 80이상 b 70이상 c
	// c. 어떤 값을 반환 할 것인가? char A,b,c,d
	public char listParam(ArrayList<Subject> list) {
	      int subjectCnt = 4;
	      int scoreSum = 0;
	      
	      if(list == null || list.size() == 0) {
	         System.out.println("입력값이 없습니다.");
	         return '\0';
	      }
	      
	      for(Subject s : list) {
	         scoreSum += s.getScore();
	      }
	      
	      double avg = (double)scoreSum / subjectCnt;
	      
	      if(avg >= 90) {
	         return 'A';
	      }
	      if(avg >= 80) {
	         return 'B';
	      }
	      if(avg >= 70) {
	         return 'C';
	      }
	      
	      return 'F';
	   }
	
	// 9) 매개변수 : HashMap
	// a. 어떤값을 입력 받을 것인가? 두개의 리스트(Student, Emp)
	// b. 어떻게 처리 (구현)할 것인가? 총인원(리스트사이즈의 합)을 계산
	// c. 어떤 값을 반환 할 것인가? int
	public int mapParam(HashMap<String,Object> map) {
		//null유효성 검사
		ArrayList<Student> studentList = (ArrayList<Student>)map.get("studentList");
		ArrayList<Emp> empList = (ArrayList<Emp>)map.get("empList");
		
		int studentCnt = studentList.size();
		int empCnt = studentList.size();
		
		return empCnt+empCnt;
	}
}
