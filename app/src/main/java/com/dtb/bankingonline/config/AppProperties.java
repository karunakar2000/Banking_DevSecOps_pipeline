package com.dtb.bankingonline.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Component
@ConfigurationProperties(prefix = "app.bank")
public class AppProperties {

    /**
     * Logical name of the bank, e.g. "DTB Bank"
     */
    private String name;

    /**
     * Environment label shown in health endpoint, e.g. "dev", "uat", "prod"
     */
    private String environment;

    /**
     * Region / location label, optional
     */
    private String region;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEnvironment() {
        return environment;
    }

    public void setEnvironment(String environment) {
        this.environment = environment;
    }

    public String getRegion() {
        return region;
    }

    public void setRegion(String region) {
        this.region = region;
    }
}

