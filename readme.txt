Проект (JEE WEB project) для IntelliJ IDEA Ultimate Edition.
Содержит пример частично решенной задачи финального проекта.

*********************************************************************

1. Запустить сервер MySQL.

2. Зайти в административную консоль и выполнить команду

	source ABSOLUTE_PATH_TO_SCRIPT;

где ABSOLUTE_PATH_TO_SCRIPT - абсолютный путь к файлу:

	sql/dbcreate-mysql.sql

3. Создать пользователя с именем testuser, паролем testpass и дать ему все права на базу данных st4db:

	grant all privileges on st4db.* to testuser@'%' identified by 'testpass';	
	
(выполнить в административной консоли MySQL)

4. Открыть проект в IntelliJ IDEA.

5. Сконфигурировать в IDEA Apache Tomcat.
