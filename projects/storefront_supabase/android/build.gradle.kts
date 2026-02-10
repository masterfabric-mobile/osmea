import com.android.build.gradle.BaseExtension

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Ensure all Android subprojects (including Flutter plugins like app_links) have compileSdkVersion
subprojects {
    afterEvaluate {
        extensions.findByType(BaseExtension::class.java)?.apply {
            compileSdkVersion(36)
            compileOptions {
                sourceCompatibility = org.gradle.api.JavaVersion.VERSION_17
                targetCompatibility = org.gradle.api.JavaVersion.VERSION_17
            }
        }
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
