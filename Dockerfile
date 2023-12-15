FROM rocker/verse 
WORKDIR .
COPY . .

RUN apt-get update && apt-get install -y texlive-latex-base texlive-fonts-recommended texlive-fonts-extra \
    && apt-get install -y lmodern texlive-xetex

RUN R -e "install.packages('corrplot')"
RUN R -e "install.packages('caTools')"
RUN R -e "install.packages('ResourceSelection')"
RUN R -e "install.packages('caret')"
RUN R -e "install.packages('rpart')"
RUN R -e "install.packages('rpart.plot')"
