package com.example.kimoi.extractors
import app.cash.quickjs.QuickJs

/**
 * Helper class to deobfuscate JavaScript strings with synchrony.
 */
object Deobfuscator {
    fun deobfuscateScript(source: String): String? {
        val originalScript = javaClass.getResource("/assets/$SCRIPT_NAME")
            ?.readText() ?: return null

        // Sadly needed until QuickJS properly supports module imports:
        // Regex for finding one and two in "export{one as com.example.kimoi.extractors.Deobfuscator,two as Transformer};"
        val regex = """export\{(.*) as com.example.kimoi.extractors.Deobfuscator,(.*) as Transformer\};""".toRegex()
        val synchronyScript = regex.find(originalScript)?.let { match ->
            val (deob, trans) = match.destructured
            val replacement = "const com.example.kimoi.extractors.Deobfuscator = $deob, Transformer = $trans;"
            originalScript.replace(match.value, replacement)
        } ?: return null

        return QuickJs.create().use { engine ->
            engine.evaluate("globalThis.console = { log: () => {}, warn: () => {}, error: () => {}, trace: () => {} };")
            engine.evaluate(synchronyScript)

            engine.set("source", TestInterface::class.java, object : TestInterface { override fun getValue() = source })
            engine.evaluate("new com.example.kimoi.extractors.Deobfuscator().deobfuscateSource(source.getValue())") as? String
        }
    }

    @Suppress("unused")
    private interface TestInterface {
        fun getValue(): String
    }
}

// Update this when the script is updated!
private const val SCRIPT_NAME = "synchrony-v2.4.2.1.js"
