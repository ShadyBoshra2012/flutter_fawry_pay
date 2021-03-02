/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

package com.shadyboshra2012.flutter_fawry_pay;

import android.content.Context;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup.LayoutParams;
import android.widget.Button;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.emeint.android.fawryplugin.views.cutomviews.*;

import java.lang.reflect.Field;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

// Import fawryplugin

class NativeFawryButton implements PlatformView {
    @NonNull
    private final FawryButton fawryButton;

    NativeFawryButton(@NonNull Context context, int id, @Nullable Map<String, Object> creationParams) {
        fawryButton = new FawryButton(context);
        fawryButton.setLayoutParams(new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT));
    }

    @NonNull
    @Override
    public View getView() {
        return fawryButton;
    }

    @Override
    public void dispose() {
    }
}
