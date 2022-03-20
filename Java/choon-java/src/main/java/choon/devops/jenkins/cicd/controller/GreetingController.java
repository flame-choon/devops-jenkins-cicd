package choon.devops.jenkins.cicd.controller;

import choon.devops.jenkins.cicd.service.Greeting;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.concurrent.atomic.AtomicLong;

@RestController
public class GreetingController {

    private static final String template = "Hello, %s";
    private final AtomicLong counter = new AtomicLong();

    @GetMapping("/greeting")
    public Greeting greeting(@RequestParam(value = "name", defaultValue = "World")String name){

        int target = -5;
        int num = 3;

        target =- num;
        target =+ num;

        return new Greeting(counter.incrementAndGet(), String.format(template, name));
    }
}
