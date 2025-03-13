package com.example.backend.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

import java.util.List;

@Configuration
public class CorsConfig {

    @Bean
    public CorsFilter corsFilter() {
        CorsConfiguration corsConfig = new CorsConfiguration();
        
        // ✅ Allow requests from your frontend domain
        corsConfig.setAllowedOrigins(List.of("http://localhost:3000")); 
        
        // ✅ Allow HTTP methods
        corsConfig.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        
        // ✅ Allow specific headers
        corsConfig.setAllowedHeaders(List.of("Content-Type"));

        // ✅ Allow credentials (cookies, authorization headers)
        corsConfig.setAllowCredentials(true);

        // ✅ Apply to all endpoints
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", corsConfig);

        return new CorsFilter(source);
    }
}
