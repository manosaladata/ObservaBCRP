library(tm)
library(pdftools)
library(wordcloud2)

file_location = "C:/Users/Jhon/Downloads/Documents/MMM_2022_2025.pdf"

#cargar el PDF
txt = pdf_text(file_location )
cat(txt[5:8])

#Creando corpus
txt_corpus = Corpus(VectorSource(txt))

#Limpiando corpus
txt_corpus = tm_map(txt_corpus, tolower)
txt_corpus = tm_map(txt_corpus, removePunctuation)
txt_corpus = tm_map(txt_corpus, stripWhitespace)
txt_corpus = tm_map(txt_corpus, removeNumbers)
#Eliminando stop
head(stopwords())
txt_corpus = tm_map(txt_corpus, removeWords, stopwords("en"))
txt_corpus = tm_map(txt_corpus, removeWords, stopwords("spanish"))

#Viendo el contenido de Corpus
txt_corpus$content

#Creando doc matrix
dtm = DocumentTermMatrix(txt_corpus)
dtm = as.matrix(dtm)
dtm = t(dtm)

#Contando el numero de ocurrencias
number_occurances = rowSums(dtm)
number_occurances = sort(number_occurances, decreasing = TRUE)


install.packages("wordcloud")
library(wordcloud)
wordcloud(head(names(number_occurances), 40), head(number_occurances, 40), scale = c(2,1), colors = brewer.pal(name = "Dark2", n = 8))






dtm[1:10, ] %>%
  ggplot(aes(palabra, frec)) +
  geom_bar(stat = "identity", color = "black", fill = "#87CEFA") +
  geom_text(aes(hjust = 1.3, label = frec)) + 
  coord_flip() + 
  labs(title = "Diez palabras m??s frecuentes en Niebla",  x = "Palabras", y = "N??mero de usos")


