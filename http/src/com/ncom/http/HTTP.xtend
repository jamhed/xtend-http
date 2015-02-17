package com.ncom.http

import android.os.Handler
import android.os.Message
import android.util.Log
import java.io.BufferedReader
import java.io.InputStream
import java.io.InputStreamReader
import java.util.Timer
import java.util.TimerTask
import org.apache.http.client.methods.HttpPost
import org.apache.http.entity.StringEntity
import org.apache.http.impl.client.DefaultHttpClient
import org.apache.http.params.HttpConnectionParams
import org.apache.http.protocol.BasicHttpContext

class HTTP {

	val MSG_DONE = 1

	int socketTimeout
	int requestTimeout	
	BasicHttpContext localContext
		
	new(int socketTimeout, int requestTimeout) {
		this.socketTimeout = socketTimeout
		this.requestTimeout = requestTimeout
		localContext = new BasicHttpContext()
	}
		
	new() {
		this(5000, 25000)
	}
	
	def Log(String s) {
		Log.d("HTTP", s)
	}

	static class Param {
		(String) => void callback
		String result
		
		new((String) => void callback, String result) {
			this.callback = callback
			this.result = result
		}
	}
	
	val cbHandler = new Handler() {
		override handleMessage(Message m) {
            val r = m.obj as Param
            Log("RES: " + r.result)
            r.callback.apply(r.result)
        }
		
	}

    static class TimeOutTask extends TimerTask {   
		String url
		Thread t
		new(Thread t, String url) {
        	this.t = t
        	this.url = url
        }
        override run() {
            if (t.isAlive()) {
                t.interrupt()
            }
        }
    }
    
    def String convertInputStreamToString(InputStream inputStream) {
        val builder = new StringBuilder()
        val reader = new BufferedReader(new InputStreamReader(inputStream))
        
        var line = ""
        while( (line = reader.readLine()) != null) {
        	builder.append(line)
        }
        return builder.toString()
    }

    def Post(String url, String body, (String) => void callback) {
        Log("REQ: " + url)
        
        val r = new Thread() {
            
            override run() {
            
                val client = new DefaultHttpClient()
                val param = client.getParams()

                HttpConnectionParams.setConnectionTimeout(param, socketTimeout)
                HttpConnectionParams.setSoTimeout(param, socketTimeout)

                val req = new HttpPost(url)

                if (body.length() > 0) {
                    req.setEntity(new StringEntity(body))
                    req.setHeader("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8")
                }

                val inputStream = client.execute(req, new BasicHttpContext()).getEntity().getContent()

                val result = convertInputStreamToString(inputStream)

                cbHandler.obtainMessage(MSG_DONE, new Param(callback, result)).sendToTarget()
            }
        }

        new Timer(true).schedule(new TimeOutTask(r, url), requestTimeout)
        r.start()
    }
}