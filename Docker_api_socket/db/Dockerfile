FROM mysql:8.0

ENV MYSQL_USER=test
ENV MYSQL_PASSWORD=test1234
ENV MYSQL_ROOT_PASSWORD=test1234
ENV MYSQL_DATABASE=test_db

COPY init/* /docker-entrypoint-initdb.d/

CMD ["mysqld", "--default-authentication-plugin=mysql_native_password"]