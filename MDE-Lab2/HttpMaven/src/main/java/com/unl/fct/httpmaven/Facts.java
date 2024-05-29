/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.unl.fct.httpmaven;

import java.util.ArrayList;


public class Facts {
    
    ArrayList<Students> students = new ArrayList<>();

    public ArrayList<Students> getStudent() {
        return this.students;
    }
    
    public void printListOfStudents() {
        for(int i = 0; i < students.size(); i++) {
            System.out.println("student(" + students.get(i).name + "," + students.get(i).age + ")");
        }
    }

    public void setStudents(ArrayList<Students> student) {
        this.students = student;
    }
    
}


