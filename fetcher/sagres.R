host <- Sys.getenv("MYSQL_HOST")
user <- Sys.getenv("MYSQL_USER")
database <- Sys.getenv("MYSQL_DB")
port <- Sys.getenv("MYSQL_PORT")
password <- Sys.getenv("MYSQL_PASSWORD")

sagres <- DBI::dbConnect(RMySQL::MySQL(),
                      dbname = database, 
                      host = host, 
                      port = as.numeric(port),
                      user = user,
                      password = password)

set_names = DBI::dbGetQuery(sagres, "SET NAMES 'utf8'") 

tipo_obra <- DBI::dbGetQuery(sagres, "SELECT * FROM Tipo_Obra;")

readr::write_csv(tipo_obra, "./data/tipo_obras.csv")
