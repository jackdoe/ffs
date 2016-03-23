#!/bin/sh

function pexit {
	if [ $1 -ne 0 ]; then echo failed to write ; exit 1 ; fi
	return 0
}

name=$1

mkdir -vp $name/src/main/java/org/$name $name/src/main/resources $name/src/test/java/org/$name $name/src/test/resources
pexit $? && echo creating $name/pom.xml && cat > $name/pom.xml <<EOF
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>$name</groupId>
  <artifactId>$name-app</artifactId>
  <packaging>jar</packaging>
  <description>$name</description>
  <version>0.1-SNAPSHOT</version>

  <dependencies>
    <dependency>
      <groupId>org.rapidoid</groupId>
      <artifactId>rapidoid-http-fast</artifactId>
      <version>5.0.12</version>
    </dependency>
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>4.12</version>
      <scope>test</scope>
    </dependency>
  </dependencies>

  <properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <maven.compiler.source>1.8</maven.compiler.source>
    <maven.compiler.target>1.8</maven.compiler.target>
    <maven.compiler.testSource>1.8</maven.compiler.testSource>
    <maven.compiler.testTarget>1.8</maven.compiler.testTarget>
  </properties>

  <build>
    <plugins>
            <plugin>
                <artifactId>maven-dependency-plugin</artifactId>
                    <executions>
                        <execution>
                            <phase>process-sources</phase>
                            <goals>
                                <goal>copy-dependencies</goal>
                            </goals>
                            <configuration>
                                <outputDirectory>${targetdirectory}</outputDirectory>
                            </configuration>
                        </execution>
                    </executions>
            </plugin>
    </plugins>
  </build>
</project>
EOF

pexit $? && echo creating $name/src/main/java/org/$name/Main.java && cat > $name/src/main/java/org/$name/Main.java <<EOF
package $name;
import org.rapidoid.data.*;
import org.rapidoid.http.fast.*;
import org.rapidoid.config.*;
public class Main {
    public static void main(String[] args) {
        Conf.args(args);
        On.get("/size").json("msg", msg -> msg.length());
    }
}
EOF

pexit $? && echo creating $name/Makefile && cat > $name/Makefile <<EOF
all:
	 mvn package && java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 -cp target/dependency/*:target/$name-app-0.1-SNAPSHOT.jar $name.Main port=8080 address=127.0.0.1 cpus=2 workers=4 nodelay
EOF
pexit $?
