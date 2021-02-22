package com.prodaft.clipwatch;

import android.annotation.SuppressLint;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.os.Bundle;

import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.android.material.snackbar.Snackbar;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;

import android.util.Log;
import android.view.View;

import android.view.Menu;
import android.view.MenuItem;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import org.w3c.dom.Text;

public class MainActivity extends AppCompatActivity {
    TextView tv;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        this.tv = findViewById(R.id.textView);
        this.tv.append("\n");
        ClipboardManager clipboardManager = (ClipboardManager) getSystemService(Context.CLIPBOARD_SERVICE);
        clipboardManager.addPrimaryClipChangedListener(new ClipboardMonitor(this.tv, clipboardManager));
    }


    class ClipboardMonitor implements ClipboardManager.OnPrimaryClipChangedListener {
        final ClipboardManager cp;
        TextView tv;
        ClipboardMonitor(TextView tv, ClipboardManager cp){
            this.tv = tv;
            this.cp = cp;
        }
        @Override
        public void onPrimaryClipChanged() {
            String charSequence = (String) this.cp.getPrimaryClip().getItemAt(0).getText();
            this.tv.append("getPrimaryClip: " + this.cp.getPrimaryClip().toString()+"\n");
            this.tv.append("New data: " + charSequence+"\n");
            if (charSequence.equals("com.prodaft.clipwatch")) {
                this.cp.setPrimaryClip(ClipData.newPlainText("packagename", "changed.my.packagename"));
            }

        }
    }
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }
}