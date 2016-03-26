ffs.sh - generate basic java project skeleton with finatra

in other words: this is ragecoded project skeleton generator.
(turns out the main reason I was using go, was because it is too anoying to start new java projects)

* creates {name}/src/main/java/{name}
* creates {name}/src/main/resources
* creates {name}/src/test/java/{name}
* creates {name}/src/test/resources
* creates {name}/build.sbt { with finatra }
* creates {name}/project/plugins.sbt { with sbt-revolver }
* creates {name}/src/main/java/{name}/Main.java { starts finatra }
* creates {name}/src/main/java/{name}/MainServer.java { sets up controller and basic response}

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
creating example/build.sbt
creating example/src/main/java/example/Main.java
creating example/src/main/java/example/MainServer.java
jack@foo $
jack@foo $ cd example
jack@foo $ sbt run
[info] Set current project to example (in build file:example/)
[info] Updating {file:example/}example...
[info] Resolving jline#jline;2.12.1 ...
[info] Done updating.
[info] Compiling 2 Java sources to example/target/classes...
[info] Running example.Main 
Mar 24, 2016 3:51:43 PM com.twitter.finagle.http.HttpMuxer$$anonfun$4 apply
INFO: HttpMuxer[/admin/metrics.json] = com.twitter.finagle.stats.MetricsExporter(<function1>)
Mar 24, 2016 3:51:43 PM com.twitter.finagle.http.HttpMuxer$$anonfun$4 apply
INFO: HttpMuxer[/admin/per_host_metrics.json] = com.twitter.finagle.stats.HostMetricsExporter(<function1>)
15:51:43.083 [run-main-0] INFO  example.MainServer - Process started
I 0324 14:51:43.227 THREAD21:  => com.twitter.server.handler.AdminRedirectHandler
I 0324 14:51:43.228 THREAD21: /admin => com.twitter.server.handler.SummaryHandler
I 0324 14:51:43.229 THREAD21: /admin/server_info => com.twitter.finagle.Filter$$anon$1
I 0324 14:51:43.233 THREAD21: /admin/lint => com.twitter.server.handler.LintHandler
I 0324 14:51:43.233 THREAD21: /admin/lint.json => com.twitter.server.handler.LintHandler
I 0324 14:51:43.233 THREAD21: /admin/threads => com.twitter.server.handler.ThreadsHandler
I 0324 14:51:43.234 THREAD21: /admin/threads.json => com.twitter.server.handler.ThreadsH
----

TODO:

accept arguments with dependencies, and automatically write into build.sbt
file based on something like:

curl -s 'http://search.maven.org/solrsearch/select?q=rapidoid&rows=1&wt=json' | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["response"]["docs"][0]'

----
PS: tried it out for couple of microservices already, and it kicks ass!
