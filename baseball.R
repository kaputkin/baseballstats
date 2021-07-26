install.packages('Lahman')
library(Lahman)

colnames(People)

data(People)
subset(People, nameLast=="Jackson" & nameFirst=="Joe")


people1950 <- subset(People, birthYear > 1950)
birthcity <- as.data.frame(table(people1950$birthCity, people1950$birthState, people1950$birthCountry))
birthcity <- subset(birthcity, Freq > 0)

colnames(birthcity) <- c("city", "state", "country", "freq")



addr <- paste(city, state, sep = "%2C")

### Geocoding Function ###
geocode <- function (city, state){
  # NOMINATIM SEARCH API URL
  src_url <- "https://nominatim.openstreetmap.org/search?q="
  
  # CREATE A FULL ADDRESS
  addr <- paste(city, state, sep = "%2C")
  
  # CREATE A SEARCH URL BASED ON NOMINATIM API TO RETURN GEOJSON
  requests <- paste0(src_url, query, "&format=geojson")
  
  # ITERATE OVER THE URLS AND MAKE REQUEST TO THE SEARCH API
  for (i in 1:length(requests)) {
    
    # QUERY THE API TRANSFORM RESPONSE FROM JSON TO R LIST
    response <- read_html(requests[i]) %>%
      html_node("p") %>%
      html_text() %>%
      fromJSON()
    
    # FROM THE RESPONSE EXTRACT LATITUDE AND LONGITUDE COORDINATES
    lon <- response$features$geometry$coordinates[[1]][1]
    lat <- response$features$geometry$coordinates[[1]][2]
    
    # CREATE A COORDINATES DATAFRAME
    if(i == 1) {
      loc <- tibble(name = name[i], 
                    address = str_replace_all(addr[i], "%2C", ","),
                    latitude = lat, longitude = lon)
    }else{
      df <- tibble(name = name[i], 
                   address = str_replace_all(addr[i], "%2C", ","),
                   latitude = lat, longitude = lon)
      loc <- bind_rows(loc, df)
    }
  }
  return(loc)
}

#####
#####

df <- geocode(
              city = birthcity$city, 
              state = birthcity$state)
s