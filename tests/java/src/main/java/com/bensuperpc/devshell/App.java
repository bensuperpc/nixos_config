package com.bensuperpc.devshell;

public class App {
    static int add(int a, int b) {
        return a + b;
    }

    public static void main(String[] args) {
        int result = add(2, 2);
        if (result != 4) {
            throw new AssertionError("expected 4, got " + result);
        }
        System.out.println("Java devshell OK: 2 + 2 = " + result);
    }
}
