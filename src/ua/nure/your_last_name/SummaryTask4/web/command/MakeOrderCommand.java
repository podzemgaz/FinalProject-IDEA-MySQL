package ua.nure.your_last_name.SummaryTask4.web.command;

import org.apache.log4j.Logger;
import ua.nure.your_last_name.SummaryTask4.exception.AppException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class MakeOrderCommand extends Command {
    private static final long serialVersionUID = 8031784744689994154L;

    private static final Logger LOG =  Logger.getLogger(MakeOrderCommand.class);

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException, AppException {
        return null;
    }
}
