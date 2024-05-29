package com.unl.fct.httpmaven;

import com.google.gson.Gson;
import com.google.gson.JsonParser;
import com.google.gson.reflect.TypeToken;

import java.io.IOException;
import java.lang.reflect.Type;
import java.util.ArrayList;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

/**
 *
 * @author adroc
 * 
 */
public class HttpMaven {

    public static void main(String[] args) throws IOException {
        //Call service hello
        System.out.println("HELLO SERVICE");
        String myName = "Andre";
        OkHttpClient clientHello = new OkHttpClient().newBuilder()
                .build();
        Request requestHello = new Request.Builder()
                .url("http://localhost:8001/hello?name=" + myName)
                .method("GET", null)
                .build();
        Response responseHello = clientHello.newCall(requestHello).execute();
        String stringHello = responseHello.body().string();
        System.out.println("Received String: " + stringHello);
        System.out.println("-------------------------------------\n");
        
        /*
        //Call service numbers
        System.out.println("NUMBERS SERVICE");
        OkHttpClient clientNumbers = new OkHttpClient().newBuilder()
                .build();
        Request requestNumbers = new Request.Builder()
                .url("http://localhost:8001/numbers")
                .method("GET", null)
                .build();
        Response responseNumbers = clientNumbers.newCall(requestNumbers).execute();
        String stringNumbers = responseNumbers.body().string();
        System.out.println("Received String: " + stringNumbers);
        //Create the Java object from the received JSON
        Gson gsonNumbers = new Gson();
        Numbers numbersObject = gsonNumbers.fromJson(JsonParser.parseString(stringNumbers), Numbers.class);
        System.out.println("Array within the Numbers object: " + numbersObject.getMyNumbers());
        System.out.println("-------------------------------------\n");
        
        //Call service atoms
        System.out.println("ATOMS SERVICE");
        OkHttpClient clientAtoms = new OkHttpClient().newBuilder()
                .build();
        Request requestAtoms = new Request.Builder()
                .url("http://localhost:8001/atoms")
                .method("GET", null)
                .build();
        Response responseAtoms = clientAtoms.newCall(requestAtoms).execute();
        String stringAtoms = responseAtoms.body().string();
        System.out.println("Received String: " + stringAtoms);
        //Create the Java object from the received JSON
        Gson gsonAtoms = new Gson();
        Atoms atomsObject = gsonAtoms.fromJson(JsonParser.parseString(stringAtoms), Atoms.class);
        System.out.println("Array within the Atoms object: " + atomsObject.getMyAtoms());
        System.out.println("-------------------------------------\n");

        
        //Call service facts
        System.out.println("FACTS SERVICE");
        OkHttpClient clientFacts = new OkHttpClient().newBuilder()
                .build();
        Request requestFacts = new Request.Builder()
                .url("http://localhost:8001/facts")
                .method("GET", null)
                .build();
        Response responseFacts = clientFacts.newCall(requestFacts).execute();
        String stringFacts = responseFacts.body().string();
        //stringFacts = stringFacts.replace("\"", "'");
        System.out.println("Received String: " + stringFacts);
        //Create the Java object from the received JSON
        Gson gsonFacts = new Gson();
        // Define the type of the ArrayList<Students>
        Type listType = new TypeToken<Facts>(){}.getType();
        // Deserialize JSON string to Facts object
        Facts factsObject = gsonFacts.fromJson(stringFacts, listType);   
        System.out.println("Array within Facts object: ");
        factsObject.printListOfStudents();
        System.out.println("-------------------------------------\n");

        //Call service factslist
        System.out.println("FACTSLIST SERVICE");
        OkHttpClient clientFactsList = new OkHttpClient().newBuilder()
                .build();
        Request requestFactsList = new Request.Builder()
                .url("http://localhost:8001/factslist")
                .method("GET", null)
                .build();
        Response responseFactsList = clientFactsList.newCall(requestFactsList).execute();
        String stringFactsList = responseFactsList.body().string();
        System.out.println("Received String: " + stringFactsList);
        //In this case our JSON does not have the name of the value, so we can assert directly to an ArrayList
        Gson gsonFactsList = new Gson();
        // Define the type of the ArrayList<ArrayList<Students>>
        Type listListType = new TypeToken<ArrayList<ArrayList<Students>>>(){}.getType();
        ArrayList<ArrayList<Students>> myArray = gsonFactsList.fromJson(stringFactsList, listListType);
        System.out.print("Array within the list of Facts: "); FactsList.printFactsList(myArray);
        System.out.print("First position of the list: "); FactsList.printStudents(myArray.get(0)); System.out.println();
        System.out.print("Second position of the list: "); FactsList.printStudents(myArray.get(1)); System.out.println();
        System.out.println("-------------------------------------\n");    
        */          
    }
}
