allprojects {
    repositories {
        google()
        mavenCentral()
        // Caf Repository
        maven { url = uri("https://repo.combateafraude.com/android/release") }
        
        // iProov Repository (required for Face Liveness)
        maven { url = uri("https://raw.githubusercontent.com/iProov/android/master/maven/") }
        
        // FingerPrintJS Repository
        maven { setUrl("https://maven.fpregistry.io/releases") }
        
        // JitPack
        maven { setUrl("https://jitpack.io") }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
