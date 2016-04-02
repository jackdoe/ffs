ffs.sh - generate basic java project skeleton with dropwizard

in other words: this is ragecoded project skeleton generator.
(turns out the main reason I was using go, was because it is too anoying to start new java projects)

* creates {name}/src/main/java/{name}
* creates {name}/src/main/resources
* creates {name}/src/test/java/{name}
* creates {name}/src/test/resources
* creates {name}/pom.xml  { with dropwizard }
* creates {name}/src/main/java/{name}/MainApplication.java { main class }
* creates {name}/src/main/java/{name}/MainConfiguration.java
* creates {name}/src/main/java/{name}/MainResource.java
* creates {name}/src/main/java/{name}/MainHealthCheck.java

* creates {name}/src/test/java/{name}/MainTest.java

-----
jack@foo $ ffs.sh example
mkdir: created directory ‘example’
mkdir: created directory ‘example/src’
mkdir: created directory ‘example/src/main’
mkdir: created directory ‘example/src/main/java’
mkdir: created directory ‘example/src/main/java/example’
mkdir: created directory ‘example/src/main/resources’
mkdir: created directory ‘example/src/test’
mkdir: created directory ‘example/src/test/java’
mkdir: created directory ‘example/src/test/java/example’
mkdir: created directory ‘example/src/test/resources’
mkdir: created directory ‘example/project’
creating example/pom.xml
creating example/src/main/java/example/MainApplication.java
creating example/src/main/java/example/MainConfiguration.java
creating example/src/main/java/example/MainResource.java
creating example/src/main/java/example/MainHealthCheck.java
creating example/src/test/java/example/MainTest.java

jack@foo $
jack@foo $ cd example
jack@foo example/ $ mvn package

... [ bla bla bla ] ...
[INFO] Replacing original artifact with shaded artifact.
[INFO] Replacing /home/jack/work/test2/example/target/example-app-0.1-SNAPSHOT.jar with /home/jack/work/test2/example/target/example-app-0.1-SNAPSHOT-shaded.jar
[INFO] Dependency-reduced POM written at: /home/jack/work/test2/example/dependency-reduced-pom.xml
[INFO] Dependency-reduced POM written at: /home/jack/work/test2/example/dependency-reduced-pom.xml
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 14.835 s
[INFO] Finished at: 2016-04-02T10:55:42+02:00
[INFO] Final Memory: 53M/240M
jack@foo example/ $ java -jar /home/jack/work/test2/example/target/example-app-0.1-SNAPSHOT.jar server
INFO  [2016-04-02 08:56:07,809] org.eclipse.jetty.util.log: Logging initialized @2202ms
INFO  [2016-04-02 08:56:07,946] io.dropwizard.server.ServerFactory: Starting example
INFO  [2016-04-02 08:56:07,965] io.dropwizard.server.DefaultServerFactory: Registering jersey handler with root path prefix: /
INFO  [2016-04-02 08:56:07,993] io.dropwizard.server.DefaultServerFactory: Registering admin handler with root path prefix: /
INFO  [2016-04-02 08:56:08,055] org.eclipse.jetty.setuid.SetUIDListener: Opened application@4bd1f8dd{HTTP/1.1}{0.0.0.0:8080}
INFO  [2016-04-02 08:56:08,056] org.eclipse.jetty.setuid.SetUIDListener: Opened admin@7096b474{HTTP/1.1}{0.0.0.0:8081}
INFO  [2016-04-02 08:56:08,060] org.eclipse.jetty.server.Server: jetty-9.2.z-SNAPSHOT
INFO  [2016-04-02 08:56:09,173] io.dropwizard.jersey.DropwizardResourceConfig: The following paths were found for the configured resources:

    GET     /hello-world (example.MainResource)

INFO  [2016-04-02 08:56:09,175] org.eclipse.jetty.server.handler.ContextHandler: Started i.d.j.MutableServletContextHandler@5d1e09bc{/,null,AVAILABLE}
INFO  [2016-04-02 08:56:09,197] io.dropwizard.setup.AdminEnvironment: tasks = 

    POST    /tasks/log-level (io.dropwizard.servlets.tasks.LogConfigurationTask)
    POST    /tasks/gc (io.dropwizard.servlets.tasks.GarbageCollectionTask)

INFO  [2016-04-02 08:56:09,205] org.eclipse.jetty.server.handler.ContextHandler: Started i.d.j.MutableServletContextHandler@3e83c18{/,null,AVAILABLE}
INFO  [2016-04-02 08:56:09,216] org.eclipse.jetty.server.ServerConnector: Started application@4bd1f8dd{HTTP/1.1}{0.0.0.0:8080}
INFO  [2016-04-02 08:56:09,217] org.eclipse.jetty.server.ServerConnector: Started admin@7096b474{HTTP/1.1}{0.0.0.0:8081}
INFO  [2016-04-02 08:56:09,217] org.eclipse.jetty.server.Server: Started @3612ms

----

TODO:

accept arguments with dependencies, and automatically write into pom.xml
file based on something like:

curl -s 'http://search.maven.org/solrsearch/select?q=rapidoid&rows=1&wt=json' | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["response"]["docs"][0]'
