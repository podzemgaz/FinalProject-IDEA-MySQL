package ua.nure.your_last_name.SummaryTask4;

public class Test {
    public static void main(String[] args) {
        m4();
    }
    static void m1() {
        m3();
    }

    static void m2() {
        m3();
    }

    static void m4() {
        m2();
    }

    static void m3() {
       StackTraceElement[] stackTraceElements = Thread.currentThread().getStackTrace();
        System.out.println(stackTraceElements[2].getMethodName());

        for (StackTraceElement el: stackTraceElements
             ) {
            System.out.println(el.getMethodName());
        }
    }
}
