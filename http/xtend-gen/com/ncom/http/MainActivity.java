package com.ncom.http;

import android.app.Activity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.View;
import android.widget.TextView;
import com.ncom.http.HTTP;
import com.ncom.http.R;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;

@SuppressWarnings("all")
public class MainActivity extends Activity {
  public void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    this.setContentView(R.layout.activity_main);
    this.request();
  }
  
  public boolean onCreateOptionsMenu(final Menu menu) {
    MenuInflater _menuInflater = this.getMenuInflater();
    _menuInflater.inflate(com.ncom.http.R.menu.main, menu);
    return true;
  }
  
  public void request() {
    final HTTP http = new HTTP();
    View _findViewById = this.findViewById(R.id.textview);
    final TextView v = ((TextView) _findViewById);
    final Procedure1<String> _function = new Procedure1<String>() {
      public void apply(final String res) {
        v.setText(res);
      }
    };
    http.Post("http://mnp.tele2.ru/gateway.php?9273193358", "", _function);
  }
}
