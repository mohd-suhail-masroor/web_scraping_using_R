# function to fetch the links to the cast and crew pages

get_cast_links = function(movie_links){
  
  movie_page <- read_html(movie_links)
  
  movie_cast_links <- movie_page %>% 
    html_nodes('.ipc-metadata-list-item__icon-link') %>% html_attr('href') %>% 
    paste('https://www.imdb.com/', . ,sep = '')
  
  return(movie_cast_links[2])
  
}  

# Function to fetch the list of cast members

get_cast = function(cast_links){
  movie_cast_page = read_html(cast_links)
  
  movie_cast <- movie_cast_page %>% html_nodes('.primary_photo+ td a') %>% 
    html_text()
  
  return(movie_cast)
}

# empty data frame declaration

movies<- data.frame()

# for loop to differentiate between different pages

for (number in seq(from = 1, to = 101 , by = 50)){
  
  # creating connection to the website 
  
  link = paste0('https://www.imdb.com/search/title/?title_type=movie&genres=sci-fi&sort=boxoffice_gross_us,desc&start=',
               number,'&explore=title_type,genres&ref_=adv_nxt')
  
  page = read_html(link)
  
  # extracting data from the website
  
  title <- page %>% html_nodes('.lister-item-header a') %>% html_text()
  year <- page %>% html_nodes('.text-muted.unbold') %>% html_text()
  rating <- page %>% html_nodes('.ratings-imdb-rating strong') %>% html_text()
  description <- page %>% html_nodes('.ratings-bar+ .text-muted') %>% html_text()
  
  movie_links<- page %>% html_nodes('.lister-item-header a') %>% 
    html_attr('href') %>% paste('https://www.imdb.com/', . ,sep = '')
  
  #generating cast_links using get_cast_links function
  
  cast_links <- sapply(movie_links,FUN = get_cast_links ,USE.NAMES = FALSE) 
  
  #generating cast list using get_cast function
  
  cast_list <- sapply(cast_links,FUN = get_cast ,USE.NAMES = FALSE) 
  
  #converting cast_list into a data frame
  
  cast <- as.data.frame(do.call(rbind,cast_list)) %>% unite('cast',V1:ncol(.),sep = ',')
  
  #binding the data extracted with the previously generated data
  
  movies <- rbind(movies, data.frame(title,description,year,rating,cast,stringsAsFactors = FALSE)) 
  
  # printing the number to notice from which page the data is being pulled
  
  print(number)
}

# removing brackets from the year column

movies<-
  movies %>% 
  mutate(year,year = str_replace_all(string = year,pattern = '[()]',
                                     replacement = ''))


