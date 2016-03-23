----
ffs.sh - generate basic java project skeleton with rapidoid, junit and a fucking makfile

-----

jack@foo $ ffs.sh example
mkdir: created directory ‘example’
mkdir: created directory ‘example/src’
mkdir: created directory ‘example/src/main’
mkdir: created directory ‘example/src/main/java’
mkdir: created directory ‘example/src/main/java/org’
mkdir: created directory ‘example/src/main/java/org/example’
mkdir: created directory ‘example/src/main/resources’
mkdir: created directory ‘example/src/test’
mkdir: created directory ‘example/src/test/java’
mkdir: created directory ‘example/src/test/java/org’
mkdir: created directory ‘example/src/test/java/org/example’
mkdir: created directory ‘example/src/test/resources’
creating example/pom.xml
creating example/src/main/java/org/example/Main.java
creating example/Makefile
jack@foo $ cd example && make
mvn package && java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 -cp target/dependency/*:target/example-app-0.1-SNAPSHOT.jar example.Main port=8080 address=127.0.0.1 cpus=2 workers=4 nodelay
... bla bla bla ...
Listening for transport dt_socket at address: 5005
INFO | server | org.rapidoid.net.impl.AbstractLoop | Starting event loop | name=server
INFO | server | org.rapidoid.net.impl.RapidoidServerLoop | Initializing server | port=8080 | accept=non-blocking
INFO | server | org.rapidoid.net.impl.RapidoidServerLoop | Opening port to listen | port=8080
INFO | server | org.rapidoid.net.impl.RapidoidServerLoop | Opened server socket | address=/0.0.0.0:8080
INFO | server | org.rapidoid.net.impl.RapidoidServerLoop | Registering accept selector
INFO | server | org.rapidoid.net.impl.RapidoidServerLoop | Waiting for connections...
INFO | server1 | org.rapidoid.insight.AbstractInsightful | Creating object | kind=pool | name=buffers | creatorThread=server1 | class=SynchronizedArrayPool
INFO | server1 | org.rapidoid.insight.AbstractInsightful | Creating object | kind=pool | name=connections | creatorThread=server1 | class=SynchronizedArrayPool
INFO | server1 | org.rapidoid.net.impl.AbstractLoop | Starting event loop | name=server1
INFO | server2 | org.rapidoid.insight.AbstractInsightful | Creating object | kind=pool | name=buffers | creatorThread=server2 | class=SynchronizedArrayPool
INFO | server2 | org.rapidoid.insight.AbstractInsightful | Creating object | kind=pool | name=connections | creatorThread=server2 | class=SynchronizedArrayPool
INFO | server2 | org.rapidoid.net.impl.AbstractLoop | Starting event loop | name=server2
INFO | server3 | org.rapidoid.insight.AbstractInsightful | Creating object | kind=pool | name=buffers | creatorThread=server3 | class=SynchronizedArrayPool
INFO | server3 | org.rapidoid.insight.AbstractInsightful | Creating object | kind=pool | name=connections | creatorThread=server3 | class=SynchronizedArrayPool
INFO | server3 | org.rapidoid.net.impl.AbstractLoop | Starting event loop | name=server3
INFO | server4 | org.rapidoid.insight.AbstractInsightful | Creating object | kind=pool | name=buffers | creatorThread=server4 | class=SynchronizedArrayPool
INFO | server4 | org.rapidoid.insight.AbstractInsightful | Creating object | kind=pool | name=connections | creatorThread=server4 | class=SynchronizedArrayPool
INFO | server4 | org.rapidoid.net.impl.AbstractLoop | Starting event loop | name=server4


----

TODO:

accept arguments with dependencies, and automatically write the pom.xml
file based on something like:

curl -s 'http://search.maven.org/solrsearch/select?q=rapidoid&rows=1&wt=json' | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["response"]["docs"][0]'
