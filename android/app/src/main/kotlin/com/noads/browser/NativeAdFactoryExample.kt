package com.noads.browser

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class NativeAdFactoryExample(private val context: Context) : GoogleMobileAdsPlugin.NativeAdFactory {
    override fun createNativeAd(nativeAd: NativeAd, customOptions: Map<String, Any>?): NativeAdView {
        val adView = LayoutInflater.from(context).inflate(R.layout.list_tile, null) as NativeAdView

        adView.headlineView = adView.findViewById<TextView>(R.id.ad_headline).apply {
            text = nativeAd.headline
        }

        adView.bodyView = adView.findViewById<TextView>(R.id.ad_body).apply {
            text = nativeAd.body
        }

        adView.iconView = adView.findViewById<ImageView>(R.id.ad_app_icon).apply {
            setImageDrawable(nativeAd.icon?.drawable)
            visibility = View.VISIBLE
        }

        adView.setNativeAd(nativeAd)
        return adView
    }
}
