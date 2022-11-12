# Creating a link to the website

link = 'https://www.imdb.com/search/title/?title_type=movie&genres=sci-fi&sort=boxoffice_gross_us,desc&start=1&explore=title_type,genres&ref_=adv_nxt'


# calling out the html page by the link

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


# Creating data frame using the extracted vectors

movies <- data_frame(title,description,year,rating)



# removing brackets from the year vector
movies<-
movies %>% 
  mutate(year,year = str_replace_all(string = year,pattern = '[()]',
                                     replacement = ''))

