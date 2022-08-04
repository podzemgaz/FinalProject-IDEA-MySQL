package ua.nure.your_last_name.SummaryTask4.web.command;

import ua.nure.your_last_name.SummaryTask4.db.DBManager;
import ua.nure.your_last_name.SummaryTask4.exception.AppException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class TestCommand extends Command {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException, AppException {
        DBManager dbManager = DBManager.getInstance();
        return null;
    }
}
