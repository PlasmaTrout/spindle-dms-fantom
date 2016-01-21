using build

class Build : BuildPod
{
    new make()
    {
        podName = "spindle"
        summary = "Primary spindle server and application."
        depends = ["sys 1.0.67", "util 1.0.67",
                    "wisp 1.0.67", "web 1.0.67", "fandoc 1.0.67",
                    "xml 1.0.67"]
        srcDirs = [`fan/`, `test/`]
    }
}
