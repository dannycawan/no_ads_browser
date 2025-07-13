package com.noads.browser

import android.content.Context
import android.graphics.Color
import android.view.LayoutInflater
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.NativeAdFactory

class NativeAdFactoryExample(private val context: Context) : NativeAdFactory {
    override fun createNativeAd(nativeAd: NativeAd, customOptions: MutableMap<String, Any>?): NativeAdView {
        val view = LayoutInflater.from(context).inflate(R.layout.list_tile, null) as NativeAdView

        view.headlineView = view.findViewById<TextView>(R.id.ad_headline).apply {
            text = nativeAd.headline
            setTextColor(Color.BLACK)
        }

        view.setNativeAd(nativeAd)
        return view
    }
}
