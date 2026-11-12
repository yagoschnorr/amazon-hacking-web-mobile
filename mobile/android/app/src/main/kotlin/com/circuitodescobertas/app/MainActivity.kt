package com.circuitodescobertas.app

import android.content.Intent
import android.net.Uri
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Abre a tela do app nas configurações do Android, onde o visitante
        // libera a câmera depois de ter negado a permissão.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "circuito_descobertas/configuracoes")
            .setMethodCallHandler { chamada, resultado ->
                if (chamada.method == "abrirConfiguracoesDoApp") {
                    val intent = Intent(
                        Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
                        Uri.fromParts("package", packageName, null),
                    )
                    startActivity(intent)
                    resultado.success(null)
                } else {
                    resultado.notImplemented()
                }
            }
    }
}
