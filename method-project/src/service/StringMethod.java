package service;

public class StringMethod {
	// 8)) 매개변수 : String
	// a. 어떤값을 입력 받을 것인가? 파일이름(확장자 포함)
	// b. 어떻게 처리 (구현)할 것인가? 확장자를 추출
	// c. 어떤 값을 반환 할 것인가? 확장자만 반환
	public String stringParam(String filename) {
		String add = filename.substring(filename.lastIndexOf(".")+1);
		if(filename==null || add.equals(filename)) {
			return "";
		}
		
		return add;
	}
	
}