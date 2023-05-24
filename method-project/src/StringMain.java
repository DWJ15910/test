import service.StringMethod;

public class StringMain {

	public static void main(String[] args) {
		
		//4)
		StringMethod sm = new StringMethod();
		String filename = "dkdk.pdf"; // 배열을 초기화해야 합니다.
		String add = sm.stringParam(filename);
		System.out.println("4번-->"+add);

	}

}
