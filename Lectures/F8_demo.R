
# demo baserat på artiklen nedan och exempel från dok för stringr:
# "stringr: modern, consistent string processing" av Hadley Wickham
# https://journal.r-project.org/archive/2010-2/RJournal_2010-2_Wickham.pdf



library(stringr)

#----------------------------------------------------------------------------
#----------------------------------------------------------------------------
# from doc:
#----------------------------------------------------------------------------
#----------------------------------------------------------------------------


# str_c

str_c("a","b","c")
paste("a","b","c")
str_c("a","b","c",sep = "--")

str_c(c("a","b","c"),c("d","e","f"),sep = "--")


a<-str_c("a","b","c",sep = "\n")
a
cat(a)
print(a)

# str_length
letters
my_letters <- str_c(letters, collapse = "")
str_length(my_letters)
str_length(letters)

# str_sub
str_sub(string = my_letters, start = 3, end = 6)
my_letters
str_sub(string = my_letters, start = 3, end = 6) <- " hej! "
my_letters

# str_split
str_split(string = c("hej, hur är det?"), pattern = "[:space:]")
str_split(string = c("hej, hur är det?"), pattern = ",")

b<-c("hej, hur är det?","saidjf aslfk w ajfd asdj")
x<-str_split(string = b,pattern = "[:space:]")
x[[1]][1]

# str_trim

str_trim(string = c("   hej!", "    abc  ","test   "),side = "left")
str_trim(string = c("   hej!", "    abc  ","test   "),side = "right")
str_trim(string = c("   hej!", "    abc  ","test   "),side = "both")


# str_pad
str_pad(string = "HEJ!",width = 10,side ="left")

str_pad(string = "HEJ!",width = 10,side ="both")


#----------------------------------------------------------------------------
#----------------------------------------------------------------------------

# pattern matching-funktioner:
?regex

my_letters
str_detect(string = my_letters, pattern = "ab")
str_detect(string = my_letters, pattern = "cd")

str_locate(string = my_letters, pattern = "hi")


x <- "[a-z]{3} "
x <- "(^| )[a-z]{3} "
str_locate_all(string ="hud hej hejhej",pattern = x)


# str_replace

str_replace(string =" hej hejhej",pattern = x, replacement = "X")


# str_extract_all

y<-" hej"

str_extract
str_extract_all


#----------------------------------------------------------------------------
#----------------------------------------------------------------------------

# str_extract {stringr}
shopping_list <- c("apples x4", "bag of flour", "bag of sugar", "milk x2")
str_extract(shopping_list, "\\d")
str_extract(shopping_list, "[a-z]+")
str_extract(shopping_list, "[a-z]{1,4}")
str_extract(shopping_list, "\\b[a-z]{1,4}\\b")

# Extract all matches
str_extract_all(shopping_list, "[a-z]+")
str_extract_all(shopping_list, "\\b[a-z]+\\b")
str_extract_all(shopping_list, "\\d")

# Simplify results into character matrix
str_extract_all(shopping_list, "\\b[a-z]+\\b", simplify = TRUE)
str_extract_all(shopping_list, "\\d", simplify = TRUE)




# from article:

strings <- c(" 219 733 8965", "329-293-8753 ", "banana", "595 794 7569",
             "387 287 6718", "apple", "233.398.9187  ", "482 952 3315", "239 923 8115",
             "842 566 4692", "Work: 579-499-7527", "$1000", "Home: 543.355.3679")

strings
phone <- "([2-9][0-9]{2})[- .]([0-9]{3})[- .]([0-9]{4})"
phone
# Which strings contain phone numbers?
str_detect(strings, phone)
strings[str_detect(strings, phone)]
# Where in the string is the phone number located?
loc <- str_locate(strings, phone)
loc
# Extract just the phone numbers
str_sub(strings, loc[, "start"], loc[, "end"])
# Or more conveniently:
str_extract(strings, phone)
# Pull out the three components of the match
str_match(strings, phone)
# Anonymise the data
str_replace(strings, phone, "XXX-XXX-XXXX")




#----------------------------------------------------------------------------
#----------------------------------------------------------------------------
# Tidy R
# Taget från: https://blog.rstudio.org/2014/07/22/introducing-tidyr/
#----------------------------------------------------------------------------
#----------------------------------------------------------------------------

library(tidyr)
library(dplyr)

# Multiple observations per row
messy <- data.frame(
  name = c("Wilbur", "Petunia", "Gregory"),
  a = c(67, 80, 64),
  b = c(56, 90, 50)
)

tidy <- gather(data = messy, key = drug, value = heartrate, a:b)
tidy

# Make multiple observations per row again
spread(tidy, key = drug, value = heartrate)

# Multiple variables in same columns
set.seed(10)
messy <- data.frame(
  id = 1:4,
  trt = sample(rep(c('control', 'treatment'), each = 2)),
  work.T1 = runif(4),
  home.T1 = runif(4),
  work.T2 = runif(4),
  home.T2 = runif(4)
)

tidier <- gather(data = messy, key = key, value = time, -id, -trt)
# Can use stringr or...
tidy <- separate(tidier, key, into = c("location", "time"), sep = "\\.") 




#----------------------------------------------------------------------------
#----------------------------------------------------------------------------
# dplyr
# Taget från: https://blog.rstudio.org/2014/07/22/introducing-tidyr/
#----------------------------------------------------------------------------
#----------------------------------------------------------------------------

install.packages("nycflights13")
library(dplyr)
library(nycflights13)

data(flights)
class(flights)

# Select
select(.data = flights, day, year, dep_delay)

# Filter
filter(flights, day == 1 & dep_delay > 60)

# Arrange
arrange(flights, desc(dep_delay))
system.time(
arrange(flights, dep_delay)
)

system.time(
flights[order(flights$dep_delay, decreasing = TRUE),]
)

# Mutate
flights <- 
  mutate(flights,
         gain = arr_delay - dep_delay,
         speed = distance / air_time * 60)
select(flights, gain, speed)

# Summarise
summarise(flights,
          delay = mean(dep_delay, na.rm = TRUE))

# Group by
daily <- group_by(flights, year, month, day)
per_day   <- summarise(daily, flights = n(), delay = mean(dep_delay, na.rm = TRUE))

# Join
# There are different joins for different purposes, see ?join
flights2 <- left_join(flights, per_day)
select(flights2, dep_delay, delay)

