package ua.nure.your_last_name.SummaryTask4.web;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import ua.nure.your_last_name.SummaryTask4.Path;
import ua.nure.your_last_name.SummaryTask4.exception.AppException;
import ua.nure.your_last_name.SummaryTask4.web.command.Command;
import ua.nure.your_last_name.SummaryTask4.web.command.CommandContainer;

/**
 * Main servlet controller.
 * 
 * @author D.Kolesnikov
 * 
 */
public class Controller extends HttpServlet {
	
	private static final long serialVersionUID = 2423353715955164816L;

	private static final Logger LOG = Logger.getLogger(Controller.class);

	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		process(request, response);
	}

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		process(request, response);
	}

	/**
	 * Main method of this controller.
	 */
	private void process(HttpServletRequest request,
			HttpServletResponse response) throws IOException, ServletException {
		
		LOG.debug("Controller starts");

		// extract command name from the request
		String commandName = (String)request.getSession().getAttribute("command");
		LOG.trace("Request parameter: command --> " + commandName);

		// obtain command object by its name
		Command command = CommandContainer.get(commandName);
		LOG.trace("Obtained command --> " + command);

		// execute command and get forward address
		String forward = Path.PAGE_ERROR_PAGE;
		try {
			forward = command.execute(request, response);
		} catch (AppException ex) {
			request.setAttribute("errorMessage", ex.getMessage());
		}
		LOG.trace("Forward address --> " + forward);

		LOG.debug("Controller finished, now go to forward address --> " + forward);

		// go to forward
		StackTraceElement[] stEls = Thread.currentThread().getStackTrace();
		String methName = stEls[2].getMethodName();
		LOG.debug("method name: " + methName);
		if ("doPost".equals(methName)) {
			String path = getServletContext().getContextPath();
			LOG.debug("context path: " + path);
			forward = path + forward;
			response.sendRedirect(forward);
		} else if ("doGet".equals(methName)) {
			request.getRequestDispatcher(forward).forward(request, response);
		}

	}

}