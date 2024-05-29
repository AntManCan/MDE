package com.unl.fct.httpmaven;

import java.util.ArrayList;

/**
 *
 * @author faf
 */
public class FactsList {

    public static void printFactsList(ArrayList<ArrayList<Students>> factsList){
        int endFacts = 1;
        System.out.print("[");
        for (ArrayList<Students> innerList : factsList) {
            printStudents(innerList);
            endFacts++;
            if (endFacts <= factsList.size()){
                System.out.print(",");
            }
        }
        System.out.println("]");
    }

    public static void printStudents(ArrayList<Students> students){
        int end = 1;
        System.out.print("[{");
        for (Students student : students) {
            System.out.print(student.getName() + "," + student.getAge() + "}");
            end++;
            if (end <= students.size()){
                System.out.print(",{");
            }
        }
        System.out.print("]");
    }
    
}
