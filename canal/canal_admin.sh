docker run -it --name canal-admin  \
-e spring.datasource.address=101.43.76.117:3307 \
-e spring.datasource.database=canal_manager \
-e spring.datasource.username=canal \
-e spring.datasource.password=canal \
-p 8089:8089 canal/canal-admin:latest