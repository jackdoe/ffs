#!/bin/sh

function pexit {
	if [ $1 -ne 0 ]; then echo failed to write ; exit 1 ; fi
	return 0
}

name=$1
if [ -z "$name" ]; then echo "usage: $0 projectname"; exit 1 ; fi

mkdir -vp $name/src/main/java/$name $name/src/main/resources $name/src/test/java/$name $name/src/test/resources $name/project

pexit $? && echo creating $name/pom.xml && cat > $name/pom.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>$name</groupId>
  <artifactId>$name-app</artifactId>
  <packaging>jar</packaging>
  <description>$name</description>
  <version>0.1-SNAPSHOT</version>

  <properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
    <dropwizard.version>0.9.2</dropwizard.version>
    <maven.compiler.source>1.8</maven.compiler.source>
    <maven.compiler.target>1.8</maven.compiler.target>
    <maven.compiler.testSource>1.8</maven.compiler.testSource>
    <maven.compiler.testTarget>1.8</maven.compiler.testTarget>
  </properties>

  <dependencies>
    <dependency>
      <groupId>io.dropwizard</groupId>
      <artifactId>dropwizard-core</artifactId>
      <version>\${dropwizard.version}</version>
    </dependency>
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>4.12</version>
      <scope>test</scope>
    </dependency>
    <dependency>
      <groupId>io.dropwizard</groupId>
      <artifactId>dropwizard-testing</artifactId>
      <version>\${dropwizard.version}</version>
      <scope>test</scope>
    </dependency>

  </dependencies>

  <build>
    <plugins>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-shade-plugin</artifactId>
        <version>2.3</version>
        <configuration>
          <createDependencyReducedPom>true</createDependencyReducedPom>
          <filters>
            <filter>
              <artifact>*:*</artifact>
              <excludes>
                <exclude>META-INF/*.SF</exclude>
                <exclude>META-INF/*.DSA</exclude>
                <exclude>META-INF/*.RSA</exclude>
              </excludes>
            </filter>
          </filters>
        </configuration>
        <executions>
          <execution>
            <phase>package</phase>
            <goals>
              <goal>shade</goal>
            </goals>
            <configuration>
              <transformers>
                <transformer implementation="org.apache.maven.plugins.shade.resource.ServicesResourceTransformer"/>
                <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                  <mainClass>$name.MainApplication</mainClass>
                </transformer>
              </transformers>
            </configuration>
          </execution>
        </executions>
      </plugin>
    </plugins>
  </build>
</project>

EOF

pexit $? && echo creating $name/src/main/java/$name/MainApplication.java && cat > $name/src/main/java/$name/MainApplication.java <<EOF
package $name;
import io.dropwizard.setup.Environment;
import io.dropwizard.Application;
import io.dropwizard.setup.Bootstrap;
public class MainApplication extends Application<MainConfiguration> {
    public static void main(String[] args) throws Exception {
        new MainApplication().run(args);
    }

    @Override
    public String getName() {
        return "$name";
    }

    @Override
    public void initialize(Bootstrap<MainConfiguration> bootstrap) {
    }

    @Override
    public void run(MainConfiguration configuration, Environment environment) {
        final MainResource resource = new MainResource();

        final MainHealthCheck healthCheck = new MainHealthCheck();
        environment.healthChecks().register("main", healthCheck);

        environment.jersey().register(resource);
    }
}
EOF
pexit $? && echo creating $name/src/main/java/$name/MainConfiguration.java && cat > $name/src/main/java/$name/MainConfiguration.java <<EOF
package $name;

import io.dropwizard.Configuration;

public class MainConfiguration extends Configuration {
}

EOF
pexit $? && echo creating $name/src/main/java/$name/MainResource.java && cat > $name/src/main/java/$name/MainResource.java <<EOF
package $name;

import com.google.common.base.Optional;
import com.codahale.metrics.annotation.Timed;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import java.util.concurrent.atomic.AtomicLong;

// Saying
import com.fasterxml.jackson.annotation.JsonProperty;

@Path("/hello-world")
@Produces(MediaType.APPLICATION_JSON)
public class MainResource {
    private final AtomicLong globalCounter;

    public MainResource() {
        this.globalCounter = new AtomicLong();
    }

    public static class Saying {
        private long number;

        private String content;
        public Saying() {
            // empty for Jackson deserialization
        }
        public Saying(long number, String content) {
            this.number = number;
            this.content = content;
        }

        @JsonProperty
        public long getNumber() {
            return number;
        }
        @JsonProperty
        public String getContent() {
            return content;
        }
    }

    @GET
    @Timed
    public Saying sayHello(@QueryParam("name") Optional<String> name) {
        return new Saying(globalCounter.incrementAndGet(), name.or("__no_name__"));
    }
}
EOF

pexit $? && echo creating $name/src/main/java/$name/MainHealthCheck.java && cat > $name/src/main/java/$name/MainHealthCheck.java <<EOF
package $name;

import com.codahale.metrics.health.HealthCheck;

public class MainHealthCheck extends HealthCheck {
    @Override
    protected Result check() throws Exception {
        return Result.healthy();
    }
}
EOF
pexit $? && echo creating $name/src/test/java/$name/MainTest.java && cat > $name/src/test/java/$name/MainTest.java <<EOF
package $name;
import org.junit.*;
import static org.junit.Assert.assertEquals;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import io.dropwizard.testing.junit.DropwizardAppRule;
import java.util.Optional;

public class MainTest {
    private Client client;
    @ClassRule
    public static final DropwizardAppRule<MainConfiguration> RULE = new DropwizardAppRule<>(MainApplication.class);

    @Before
    public void setUp() throws Exception {
        client = ClientBuilder.newClient();
    }

    @After
    public void tearDown() throws Exception {
        client.close();
    }

    @Test
    public void testHelloWorld() throws Exception {
        final Optional<String> name = Optional.of("zzz");
        final MainResource.Saying saying = client.target("http://localhost:" + RULE.getLocalPort() + "/hello-world")
                .queryParam("name", name.get())
                .request()
                .get(MainResource.Saying.class);
        assertEquals(saying.getContent(),name.get());
    }
}
EOF
pexit $?
