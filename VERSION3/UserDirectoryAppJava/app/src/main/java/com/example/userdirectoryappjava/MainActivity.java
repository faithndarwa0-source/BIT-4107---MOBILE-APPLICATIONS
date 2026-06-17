package com.example.userdirectoryappjava;

import android.os.Bundle;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.List;

import model.User;
import model.UserAdapter;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

import model.User;
import model.UserAdapter;
import network.ApiService;
import network.RetrofitClient;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_main);
        RecyclerView recyclerView =
                findViewById(R.id.recyclerView);

        recyclerView.setLayoutManager(
                new LinearLayoutManager(this)
        );

        ApiService apiService =
                RetrofitClient
                        .getRetrofitInstance()
                        .create(ApiService.class);

        Call<List<User>> call =
                apiService.getUsers();

        call.enqueue(new Callback<List<User>>() {

            @Override
            public void onResponse(Call<List<User>> call,
                                   Response<List<User>> response) {

                if (response.isSuccessful() && response.body() != null) {

                    List<User> users = response.body();

                    UserAdapter adapter =
                            new UserAdapter(users);

                    recyclerView.setAdapter(adapter);
                }
            }

            @Override
            public void onFailure(Call<List<User>> call,
                                  Throwable t) {

                t.printStackTrace();
            }
        });

        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main), (v, insets) -> {
            Insets systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars());
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom);
            return insets;
        });
    }
}