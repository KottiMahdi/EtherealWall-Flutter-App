package com.etherealwall.ethereal_wall

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.RenderMode
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import android.content.Context

class MainActivity : FlutterActivity() {
    override fun getRenderMode(): RenderMode = RenderMode.texture

    override fun provideFlutterEngine(context: Context): FlutterEngine? {
        val engineId = "ethereal_wall_engine"
        val cachedEngine = FlutterEngineCache.getInstance().get(engineId)
        if (cachedEngine != null) {
            return cachedEngine
        }
        val engine = super.provideFlutterEngine(context)
        if (engine != null) {
            FlutterEngineCache.getInstance().put(engineId, engine)
        }
        return engine
    }
}
