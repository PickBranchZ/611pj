Hi, this is my 611 Data Science Project. More to come.
=========================


To run this code, just build the docker container like this:

```
docker build . -t 611-longfeiz
```

And then start an RStudio server like this:

```
docker run -e PASSWORD=d13579 -v ${pwd}:/home/rstudio -p 8787:8787 -w /home/rstudio --rm 611-longfeiz
```
*Use ${pwd} in powershell

And visit http://localhost:8787 in your browser. Log in with user
`rstudio` and password `d13579`.



