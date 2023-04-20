package com.expin_book_official.flutter.attend_book;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.biometric.BiometricManager;
import androidx.biometric.BiometricPrompt;
import androidx.fragment.app.FragmentActivity;

import org.jetbrains.annotations.NotNull;

import java.util.concurrent.Executor;

public class BioMetricAuthentication {
    public static void showAuthenticationDialog(@NotNull FragmentActivity activity,
                                                BiometricAuthenticationListener listener) {
        Executor executor = AppExecutors.getInstance().mainThread();
        BiometricPrompt biometricPrompt = new BiometricPrompt(activity,
                executor, new BiometricPrompt.AuthenticationCallback() {
            @Override
            public void onAuthenticationError(int errorCode,
                                              @NonNull CharSequence errString) {
                super.onAuthenticationError(errorCode, errString);
                if (!errString.equals("Cancel")) {
                    listener.onError((String) errString);
                }
            }

            @Override
            public void onAuthenticationSucceeded(
                    @NonNull BiometricPrompt.AuthenticationResult result) {
                super.onAuthenticationSucceeded(result);
                listener.onSuccess();
            }

            @Override
            public void onAuthenticationFailed() {
                super.onAuthenticationFailed();
            }
        });
        BiometricPrompt.PromptInfo promptInfo = new BiometricPrompt.PromptInfo.Builder()
                .setTitle("Verify your biometrics")
                .setNegativeButtonText("Cancel")
                .build();
        biometricPrompt.authenticate(promptInfo);
    }

    public static boolean canAuth(Context context) {
        BiometricManager biometricManager = BiometricManager.from(context);
        boolean message = false;
        switch (biometricManager.canAuthenticate(BiometricManager.Authenticators.BIOMETRIC_STRONG)) {
            case BiometricManager.BIOMETRIC_SUCCESS:
                message = true;
                break;
            case BiometricManager.BIOMETRIC_ERROR_HW_UNAVAILABLE:
            case BiometricManager.BIOMETRIC_ERROR_NONE_ENROLLED:
            case BiometricManager.BIOMETRIC_ERROR_NO_HARDWARE:
            case BiometricManager.BIOMETRIC_ERROR_SECURITY_UPDATE_REQUIRED:
            case BiometricManager.BIOMETRIC_ERROR_UNSUPPORTED:
            case BiometricManager.BIOMETRIC_STATUS_UNKNOWN:
                break;
        }
        return message;
    }

    public static String checkBiometrics(Context context) {
        BiometricManager biometricManager = BiometricManager.from(context);
        String message = null;
        switch (biometricManager.canAuthenticate(BiometricManager.Authenticators.BIOMETRIC_STRONG)) {
            case BiometricManager.BIOMETRIC_SUCCESS:
                message = "Success";
                break;
            case BiometricManager.BIOMETRIC_ERROR_HW_UNAVAILABLE:
            case BiometricManager.BIOMETRIC_ERROR_NO_HARDWARE:
            case BiometricManager.BIOMETRIC_ERROR_SECURITY_UPDATE_REQUIRED:
                message = "Biometric hardware unavailable";
                break;
            case BiometricManager.BIOMETRIC_ERROR_NONE_ENROLLED:
                message = "No biometric credential is enrolled";
                break;
            case BiometricManager.BIOMETRIC_ERROR_UNSUPPORTED:
                message = "Biometric authentication unsupported";
                break;
            case BiometricManager.BIOMETRIC_STATUS_UNKNOWN:
                message = "Unknown";
                break;
        }
        return message;
    }

    public interface BiometricAuthenticationListener {
        void onSuccess();
        void onError(String error);
    }
}
