package top.haoshenqi.holiday;

import org.apache.catalina.core.ApplicationContext;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.scheduling.annotation.EnableScheduling;

import java.util.Arrays;

/**
 * @author haosh
 */
@SpringBootApplication
@EnableScheduling
@ServletComponentScan
@MapperScan(basePackages="top.haoshenqi.holiday.dao.mybatis")
public class HolidayApplication {

    public static void main(String[] args) {
        ConfigurableApplicationContext context = SpringApplication.run(HolidayApplication.class, args);
        String[] activeProfiles = context.getEnvironment().getActiveProfiles();
        if (activeProfiles==null||activeProfiles.length==0){
            System.out.println("no activeProfiles");
        }else {
            Arrays.stream(activeProfiles).forEach(profiles-> System.out.println(profiles));
        }
    }

}
