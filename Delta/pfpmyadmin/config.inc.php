
phpmyadmin:
  image: phpmyadmin/phpmyadmin
  environment:
    PMA_HOST: db
    MYSQL_ROOT_PASSWORD: root
  ports:
    - "8080:80"
