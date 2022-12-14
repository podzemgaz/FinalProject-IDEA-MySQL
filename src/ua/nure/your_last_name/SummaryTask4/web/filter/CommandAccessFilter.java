package ua.nure.your_last_name.SummaryTask4.web.filter;

import java.io.IOException;
import java.util.*;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

import ua.nure.your_last_name.SummaryTask4.Path;
import ua.nure.your_last_name.SummaryTask4.db.Role;

/**
 * Security filter. Disabled by default. Uncomment Security filter
 * section in web.xml to enable.
 * 
 * @author D.Kolesnikov
 * 
 */
public class CommandAccessFilter implements Filter {
	
	private static final Logger LOG = Logger.getLogger(CommandAccessFilter.class);

	// commands access	
	private final Map<Role, List<String>> accessMap = new HashMap<>();
	private List<String> commons = new ArrayList<>();
	private List<String> outOfControl = new ArrayList<>();
	
	public void destroy() {
		LOG.debug("Filter destruction starts");
		// do nothing
		LOG.debug("Filter destruction finished");
	}

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		LOG.debug("Filter starts");
		
		if (accessAllowed(request)) {
			LOG.debug("Filter finished");
			chain.doFilter(request, response);
		} else {
			String errorMessage = "You do not have permission to access the requested resource";
			
			request.setAttribute("errorMessage", errorMessage);
			LOG.trace("Set the request attribute: errorMessage --> " + errorMessage);
			
			request.getRequestDispatcher(Path.PAGE_ERROR_PAGE)
					.forward(request, response);
		}
	}
	
	private boolean accessAllowed(ServletRequest request) {
			HttpServletRequest httpRequest = (HttpServletRequest) request;

			HttpSession session = httpRequest.getSession();
			String command = request.getParameter("command");
			LOG.debug("command in request: " + command);
			if (command != null) {
				LOG.debug("setting attribute `command` to session: " + command);
				session.setAttribute("command" ,command);
			}

		String commandName = (String)((HttpServletRequest) request).getSession().getAttribute("command");
		LOG.trace("command in filter: " + commandName);
		if (commandName == null || commandName.isEmpty()) {
			return false;
		}
		
		if (outOfControl.contains(commandName)) {
			return true;
		}
		
		Role userRole = (Role)session.getAttribute("userRole");
		LOG.trace("userRole in filter: " + userRole);
		if (userRole == null) {
			LOG.debug("null role");
			return false;
		}
		
		return accessMap.get(userRole).contains(commandName)
				|| commons.contains(commandName);
	}

	public void init(FilterConfig fConfig) {
		LOG.debug("Filter initialization starts");
		
		// roles
		accessMap.put(Role.ADMIN, asList(fConfig.getInitParameter("admin")));
		accessMap.put(Role.CLIENT, asList(fConfig.getInitParameter("client")));
		LOG.trace("Access map --> " + accessMap);

		// commons
		commons = asList(fConfig.getInitParameter("common"));
		LOG.trace("Common commands --> " + commons);

		// out of control
		outOfControl = asList(fConfig.getInitParameter("out-of-control"));
		LOG.trace("Out of control commands --> " + outOfControl);
		
		LOG.debug("Filter initialization finished");
	}
	
	/**
	 * Extracts parameter values from string.
	 * 
	 * @param str
	 *            parameter values string.
	 * @return list of parameter values.
	 */
	private List<String> asList(String str) {
		List<String> list = new ArrayList<>();
		StringTokenizer st = new StringTokenizer(str);
		while (st.hasMoreTokens()) {
			list.add(st.nextToken());
		}
		return list;		
	}
	
}