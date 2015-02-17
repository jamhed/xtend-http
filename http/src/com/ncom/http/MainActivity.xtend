package com.ncom.http

import android.os.Bundle
import android.view.Menu
import android.widget.TextView
import android.app.Activity

public class MainActivity extends Activity {

    
    override void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        request()
    }


    override boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.main, menu)
        return true
    }
    
    def request() {
    	val http = new HTTP()
     	val v = findViewById(R.id.textview) as TextView
        http.Post("http://mnp.tele2.ru/gateway.php?9273193358", "",  [ String res | v.setText(res) ])
    }
}