package apijson.boot;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletRequestWrapper;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
public class RepeatHeaderFilter extends OncePerRequestFilter {

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {

        HttpServletRequestWrapper wrapper = new HttpServletRequestWrapper(request) {
            @Override
            public String getHeader(String name) {
                if (name != null && ! name.toLowerCase().startsWith("x-")) {
                    String xVal = request.getHeader("x-" + name.toLowerCase());
                    if (xVal != null && ! xVal.isEmpty()) {
                        return xVal;
                    }
                }

//                if (name != null && name.toLowerCase().startsWith("x-")) {
//                    String xVal = request.getHeader(name);
//                    if (xVal == null || xVal.isEmpty()) {
//                        return request.getHeader(name.substring(2).toLowerCase());
//                    }
//                }

                return super.getHeader(name);
            }
        };

        filterChain.doFilter(wrapper, response);
    }
}
