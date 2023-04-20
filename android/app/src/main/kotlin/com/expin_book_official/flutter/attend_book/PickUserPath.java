package com.expin_book_official.flutter.attend_book;

import android.os.Build;
import android.os.Environment;

import java.io.File;


public class PickUserPath {

    public static String getPdfPath(){
        File file = new File(Environment.getExternalStorageDirectory() + "/AttendBook","PDF");
        if (!file.exists()){
            file.mkdirs();
        }
        return file.getAbsolutePath();
    }

    public static String getExcelPath(){
        File file = new File(Environment.getExternalStorageDirectory() + "/AttendBook","Excel");
        if (!file.exists()){
            file.mkdirs();
        }
        return file.getAbsolutePath();
    }

    public static String getBackupPath(){
        File file = new File(Environment.getExternalStorageDirectory() + "/AttendBook","Backup");
        if (!file.exists()){
            file.mkdirs();
        }
        return file.getAbsolutePath();
    }

    public static int getAndroidVersion(){
        return Build.VERSION.SDK_INT;
    }
}