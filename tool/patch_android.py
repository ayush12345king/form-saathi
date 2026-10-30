"""Small fixes to the Android files that `flutter create` generates in CI.

- Turns on core library desugaring (needed by flutter_local_notifications).
- Signs release builds with the upload key when android/key.properties
  exists (created in CI from GitHub secrets); otherwise uses the debug key.
Works for both build.gradle.kts (Kotlin) and build.gradle (Groovy).
"""
import pathlib
import sys

app = pathlib.Path("android/app")
kts = app / "build.gradle.kts"
groovy = app / "build.gradle"
path = kts if kts.exists() else groovy
src = path.read_text()

if "CoreLibraryDesugaring" in src or "coreLibraryDesugaring" in src:
    print("already patched")
    sys.exit(0)

SIGNING_KTS = """    signingConfigs {
        create("release") {
            val keyFile = rootProject.file("key.properties")
            if (keyFile.exists()) {
                val p = Properties()
                p.load(FileInputStream(keyFile))
                keyAlias = p.getProperty("keyAlias")
                keyPassword = p.getProperty("keyPassword")
                storeFile = file(p.getProperty("storeFile"))
                storePassword = p.getProperty("storePassword")
            }
        }
    }

    buildTypes {"""

if path == kts:
    src = "import java.io.FileInputStream\nimport java.util.Properties\n\n" + src
    src = src.replace("compileOptions {", "compileOptions {\n        isCoreLibraryDesugaringEnabled = true", 1)
    src = src.replace("    buildTypes {", SIGNING_KTS, 1)
    src = src.replace(
        'signingConfig = signingConfigs.getByName("debug")',
        'signingConfig = if (rootProject.file("key.properties").exists()) signingConfigs.getByName("release") else signingConfigs.getByName("debug")',
        1,
    )
    src += '\ndependencies {\n    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")\n}\n'
else:
    src = src.replace("compileOptions {", "compileOptions {\n        coreLibraryDesugaringEnabled true", 1)
    src += "\ndependencies {\n    coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.1.4'\n}\n"

if "esugaringEnabled" not in src:
    sys.exit("could not find compileOptions in " + str(path))
path.write_text(src)
print("patched", path)
