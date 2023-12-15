# 611 Data Science Project of Iowa Liquor Sale -longfeiz
Last Revision Date: 12/14/2023

## Background
According to the surveillance report from the National Institute on Alcohol Abuse and Alcoholism, alcoholic beverages sales increased while the most sales of food and other drinks decreased during the pandemic of COVID-19. Hence, we are particularly interested in the economical impacts due to the pandemic. Through investigation on alcohol sales in Iowa, we try to figure out some unrevealed influences of the pandemic.

## Data Source
The dataset for this analysis is the “Iowa Liquor Sales” data publicly available from [the state of Iowa](https://data.iowa.gov/Sales-Distribution/Iowa-Liquor-Sales/m3tr-qhgy/explore/query). For our analysis, sales data from Oct. 2017 to Oct. 2021 was selected, such as store, brand, sales volume, and sales price, considering data duplication, completion, etc. The raw data is not uploaded to github due to its large size, but you can get access to raw files at [my dropbox](https://www.dropbox.com/scl/fo/doac28hw4yqbx1q00fpp6/h?rlkey=7aslm36x9ycgh2o9zrbsynukf&dl=0) and a number of pre-processed data files are available in the git repository for further analysis. Makefile will only based on pre-processed data included in the repository.



=========================
To run this code, you can locate to the root path and build the docker container like this:

```
docker build . -t 611-longfeiz
```

And then start an RStudio server like this:

```
docker run --rm -e USERID=$(id -u) -e GROUPID=$(id -g) -e PASSWORD=d13579 -v $(pwd):/home/rstudio -p 8787:8787 -it 611-longfeiz
```

And visit http://localhost:8787 in your browser. Log in with user
`rstudio` and password `d13579`.



