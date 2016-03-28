#!/bin/sh

function pexit {
	if [ $1 -ne 0 ]; then echo failed to write ; exit 1 ; fi
	return 0
}

name=$1
if [ -z "$name" ]; then echo "usage: $0 projectname"; exit 1 ; fi

mkdir -vp $name/src/main/java/$name $name/src/main/resources $name/src/test/java/$name $name/src/test/resources $name/project
pexit $? && echo creating $name/build.sbt && cat > $name/build.sbt <<EOF
name := "$name"
organization := "$name"
version := "0.1"
scalaVersion := "2.11.8"
parallelExecution in ThisBuild := false
publishMavenStyle := true
crossPaths := false
autoScalaLibrary := false

javacOptions ++= Seq(
  "-source", "1.8",
  "-target", "1.8",
  "-Xlint:unchecked"
)

val projectMainClass = "$name.Main"

mainClass in (Compile, run) := Some(projectMainClass)
mainClass in (Compile, packageBin) := Some(projectMainClass)


lazy val versions = new {
  val finatra = "2.1.5"
  val guice = "4.0"
  val logback = "1.0.13"
}

resolvers ++= Seq(
  Resolver.sonatypeRepo("releases"),
  "Twitter Maven" at "https://maven.twttr.com"
)
Revolver.enableDebugging(port = 5005, suspend = false)
libraryDependencies ++= Seq(
  "com.twitter.finatra" %% "finatra-http" % versions.finatra,
  "com.twitter.finatra" %% "finatra-httpclient" % versions.finatra,
  "ch.qos.logback" % "logback-classic" % versions.logback,

  "com.twitter.finatra" %% "finatra-http" % versions.finatra % "test",
  "com.twitter.finatra" %% "finatra-jackson" % versions.finatra % "test",
  "com.twitter.inject" %% "inject-server" % versions.finatra % "test",
  "com.twitter.inject" %% "inject-app" % versions.finatra % "test",
  "com.twitter.inject" %% "inject-core" % versions.finatra % "test",
  "com.twitter.inject" %% "inject-modules" % versions.finatra % "test",
  "com.google.inject.extensions" % "guice-testlib" % versions.guice % "test",

  "com.twitter.finatra" %% "finatra-http" % versions.finatra % "test" classifier "tests",
  "com.twitter.finatra" %% "finatra-jackson" % versions.finatra % "test" classifier "tests",
  "com.twitter.inject" %% "inject-server" % versions.finatra % "test" classifier "tests",
  "com.twitter.inject" %% "inject-app" % versions.finatra % "test" classifier "tests",
  "com.twitter.inject" %% "inject-core" % versions.finatra % "test" classifier "tests",
  "com.twitter.inject" %% "inject-modules" % versions.finatra % "test" classifier "tests",

  "org.mockito" % "mockito-core" % "1.9.5" % "test",
  "org.scalatest" %% "scalatest" % "2.2.3" % "test",
  "org.specs2" %% "specs2" % "2.3.12" % "test",
  "com.novocode" % "junit-interface" % "0.11" % Test)
EOF

pexit $? && echo creating $name/project/plugins.sbt && cat > $name/project/plugins.sbt <<EOF
addSbtPlugin("io.spray" % "sbt-revolver" % "0.8.0")
addSbtPlugin("com.eed3si9n" % "sbt-assembly" % "0.14.2")
EOF

pexit $? && echo creating $name/assembly.sbt && cat > $name/assembly.sbt <<EOF
assemblyMergeStrategy in assembly := {
  case PathList("META-INF", "MANIFEST.MF") => MergeStrategy.discard
  case x => MergeStrategy.last
}
EOF

pexit $? && echo creating $name/src/main/java/$name/Main.java && cat > $name/src/main/java/$name/Main.java <<EOF
package $name;
public class Main {
    public static void main(String[] args) {
        new MainServer().main(args);
    }
}
EOF

pexit $? && echo creating $name/src/main/java/$name/MainServer.java && cat > $name/src/main/java/$name/MainServer.java <<EOF
package $name;
import com.twitter.finatra.http.JavaHttpServer;
import com.twitter.finatra.http.filters.CommonFilters;
import com.twitter.finatra.http.routing.HttpRouter;
import com.twitter.finatra.http.JavaController;

public class MainServer extends JavaHttpServer {
    public static class MainController extends JavaController {
        public class GoodbyeResponse {
            public final String name;
            public final String message;
            public final Integer code;

            public GoodbyeResponse(String name, String message, Integer code) {
                this.name = name;
                this.message = message;
                this.code = code;
            }
        }

        public void configureRoutes() {
            get("/goodbye", request ->
                    new GoodbyeResponse("guest", "cya", 123));
        }
    }


    @Override
    public void configureHttp(HttpRouter httpRouter) {
        httpRouter
            .filter(CommonFilters.class)
            .add(MainController.class);
    }
}
EOF

pexit $? && echo creating $name/src/test/java/$name/MainTest.java && cat > $name/src/test/java/$name/MainTest.java <<EOF
package $name;
import org.junit.*;
import static org.junit.Assert.assertEquals;

import org.junit.Assert;
import org.junit.Test;

import com.twitter.finagle.http.Request;
import com.twitter.finagle.http.Response;
import com.twitter.finagle.http.Status;
import com.twitter.finatra.http.test.EmbeddedHttpServer;
import static com.twitter.finatra.httpclient.RequestBuilder.*;
public class MainTest {
    private EmbeddedHttpServer server = new EmbeddedHttpServer(new MainServer());

    @Test
    public void testGoodbyeEndpoint() {
        Request request = get("/goodbye");
        Response response = server.httpRequest(request);
        assertEquals(Status.Ok(), response.status());
        assertEquals("{\"name\":\"guest\",\"message\":\"cya\",\"code\":123}", response.contentString());
    }
}

EOF
pexit $?
