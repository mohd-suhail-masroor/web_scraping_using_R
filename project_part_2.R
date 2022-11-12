# Creating a link to the website

link = 'https://www.imdb.com/search/title/?title_type=movie&genres=sci-fi&sort=boxoffice_gross_us,desc&start=1&explore=title_type,genres&ref_=adv_nxt'

page  = read_html(link)


# Extracting values using css notations and storing them as vectors

# title

title <- page %>% 
         html_nodes('.lister-item-header a') %>% 
         html_text()

head(title)

# year

year <- page %>% 
        html_nodes('.text-muted.unbold') %>% 
        html_text()

head(year)

# rating

rating <- page %>% 
          html_nodes('.ratings-imdb-rating strong') %>% 
          html_text()

head(rating)

# description

description <- page %>% 
               html_nodes('.ratings-bar+ .text-muted') %>% 
               html_text()

head(description)

# Movie Links

movie_links<- page %>% 
              html_nodes('.lister-item-header a') %>% 
              html_attr('href') %>% 
              paste('https://www.imdb.com/', . ,sep = '')

head(movie_links)


#  constructor function 

# function to extract the links of the cast and crew pages 

get_cast_links = function(movie_links){

  movie_page <- read_html(movie_links)
  
  movie_cast_links <- movie_page %>% 
    html_nodes('.ipc-metadata-list-item__icon-link') %>% 
    html_attr('href') %>% 
    paste('https://www.imdb.com/', . ,sep = '')
  
   return(movie_cast_links[2])

}  


cast_links <- sapply(movie_links,FUN = get_cast_links ,USE.NAMES = FALSE) 

# function to extract the list of cast members

get_cast = function(cast_links){
  movie_cast_page = read_html(cast_links)
  
  movie_cast <- movie_cast_page %>% 
                html_nodes('.primary_photo+ td a') %>% 
                html_text()
  
  return(movie_cast)
}

cast_list <- sapply(cast_links,FUN = get_cast ,USE.NAMES = FALSE) 

#converting the list to a data frame

cast <- as.data.frame(do.call(rbind,cast_list)) %>%
  unite('cast',V1:ncol(.),sep = ',')

View(cast)

# Creating data frame using the extracted vectors

movies <- data.frame(title,description,year,rating,cast)



# removing brackets from the year vector
movies<-
movies %>% 
  mutate(year,year = str_replace_all(string = year,pattern = '[()]',
                                     replacement = ''))



write.csv(movies,'movies_with_cast.csv')

