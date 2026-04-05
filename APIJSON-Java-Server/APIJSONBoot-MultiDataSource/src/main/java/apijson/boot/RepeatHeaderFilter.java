/*Copyright ©2025 APIJSON(https://github.com/APIJSON)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.*/

package apijson.boot;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletRequestWrapper;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

/**请求头去重，解决 header 和 x-header 都传时请求解析报错
 * @author Lemon
 */
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
